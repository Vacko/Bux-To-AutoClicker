unit functions_buxto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, ExtCtrls, ComCtrls, StdCtrls, inifiles, idhttp, PNGZLIB,
  PNGImage;

type
  TLogInThread = class(TThread) count:Integer;
    protected
    procedure Execute; override;
  end;
  TCheckingThread = class(TThread) count:Integer;
    protected
    procedure Execute; override;
  end;


var
 GetImg : Tidhttp;
 number   : string;
 v      : integer;

 LogInThread : TLogInThread;
 CheckingThread : TCheckingThread;

  Procedure CreateImage;
  procedure TransPNGtoJPG(filename : String);
  function Bux_to_logged : boolean;
  procedure SearchLinks(Word : string);
  Procedure Add(link : string);
  Procedure StartChecking;
  procedure GetBux_to_Stats;
  function Getmoney : string;

implementation

uses
 updating, main,
 functions_program, functions_updating,
 settings_program,
 stats;

procedure TransPNGtoJPG(filename : String);
var
   lPNG: TPNGImage;
   lExt: string;
   lStreamLoaded: boolean;
   lStream: TmemoryStream;
begin
 lExt := ExtractFileExt(filename);
   if (lExt = '.png') then
     begin
      lStreamLoaded := true;
      lStream := TMemoryStream.Create;
      try
       lStream.LoadFromFile(filename);
       lStream.Seek(0, soFromBeginning);
       lPNG := TPNGImage.Create;
       try
        lPNG.LoadFromStream(lStream);
        lStream.Free;
        lStreamLoaded := false;
        Form5.Image1.Picture.Bitmap.PixelFormat := lPNG.PixelFormat;
        Form5.Image1.Picture.Bitmap.Height := lPNG.Height;
        Form5.Image1.Picture.Bitmap.Width := lPNG.Width;
        if lPNG.PixelFormat = pf8Bit then Form5.Image1.Picture.Bitmap.Palette := lPNG.Palette;
        Form5.Image1.Canvas.Draw(0,0,lPNG);
        Form5.Image1.Picture.Bitmap.PaletteModified := true;
       finally
        lPNG.Free;
       end;
      finally
       if lStreamLoaded then lStream.Free;
      end;
     end;
 DeleteFile(filename);
end;

Procedure CreateImage;
var
 i : integer;
 F : TFileStream;
begin
 
 Form5.Image1.Visible := True;
 Form5.Label5.Visible := True;
 Form5.Label4.Visible := True;
 Form5.code.Visible := True;

         GetImg := Tidhttp.Create(nil);
         GetImg.AllowCookies:=true;
         GetImg.Request.ContentType := 'application/x-www-form-urlencoded';
         GetImg.Request.Connection:='Keep-Alive';
         GetImg.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)';
         GetImg.HandleRedirects := True;
         GetImg.RedirectMaximum := 15;
 //        h.ProxyParams.ProxyServer := '80.237.232.194';
 //        h.ProxyParams.ProxyPort := 8080;


   for i := Low(Servers_Names) to High(Servers_Names) do
     begin
        if Servers_Names[i] = 'Bux.to' then
          begin
             F := TFileStream.Create(Servers_UImag[i] , fmCreate);
              try
                GetImg.Get(Servers_Image[i] , F);
              finally
                F.Free;
              end;
             TransPNGtoJPG(Servers_UImag[i]);
          end;
      end;

end;

function Bux_to_logged : boolean;
begin
 if not (Pos(but_to_image, Form5.source.Lines.Text) = 0) then
 begin
  Form5.status.Caption := but_to_image;
//  CreateImage;
  result := False;
 end;
 if not (Pos(bux_to_logpa, Form5.source.Lines.Text) = 0) then
  begin
//   CreateImage;
   Form5.status.Caption := bux_to_logpa2;
   result := False;
  end;
 if not (Pos(bux_login_in, Form5.source.Lines.Text) = 0) then
  begin
   Form5.logon.Enabled := false;
   Form5.server.Enabled := False;
   Form5.Image1.Enabled := False;

   Form5.logoff.Enabled := True;
   Form5.statss.Enabled  := True;
   Form5.start.Enabled  := True;

   Form5.status.Caption := bux_login_in + ' ' + Form5.Username.Text;
   result := True;
  end;
end;

procedure SearchLinks(Word : string);
var
 X, ToEnd    : integer;
 link, lend  : string;
 i           : integer;
begin
for i := Low(Servers_Names) to High(Servers_Names) do
 if Trim(Form5.Server.Text) = Servers_Names[i] then
  begin
    try
     Form5.source.Lines.Text := GetImg.Get(Servers_Links[i] + 'surf.php');
    except on E: Exception do
    end;
  end;


  with Form5.source do
   begin
     X := 0;
     ToEnd := length(Text);
     X := FindText(Word, X, ToEnd, []);

   while X <> -1 do
     begin
       SetFocus;         //view.php?ad=1000 t
       SelStart := X;
       SelLength := length(Word)+ 1;
       lend := copy(Text, X + 1, SelLength + 20);
       link := copy(lend, 1 , (Pos(' ', lend)-1));
       Add(link);

       X := FindText(Word, X + SelLength, ToEnd, []);
     end;
    if form5.start_exit.Checked then
     form5.Checking_TimeLeft.Enabled := True;

    seconds_left := Trunc(form5.work.Items.Count-1 + 1)*31;
    form5.countlinks.Caption := IntToStr(form5.Work.Items.Count-1 + 1);

   if (form5.Work.Items.Count-1 = -1) then Add(bux_Cmessage)
                                      else StartChecking;
   end;

  if form5.start_trayicon.Checked then
   form5.Hide;
end;


Procedure Add(link : string);
var
 NextItem: TlistItem;
begin
 NextItem := form5.Work.Items.Add;
if link = bux_Cmessage then
 begin
  NextItem.Caption:= bux_Cmessage;
  NextItem.SubItems.Add('');
  NextItem.SubItems.Add('');
 end else
  begin
   NextItem.Caption:= link;
   NextItem.SubItems.Add('False');
   NextItem.SubItems.Add('31');
  end;
end;


Procedure StartChecking;
var
 i, c : integer;
 co : string;
begin
for i := Low(Servers_Names) to High(Servers_Names) do
 if Trim(Form5.Server.Text) = Servers_Names[i] then
   begin
     for v := 0 to Form5.Work.Items.Count-1 do
      begin
       if (Form5.Work.Items[v].SubItems.Strings[1] = '31')  and (not (Form5.Work.Items[v].SubItems.Strings[0] = 'Work is Complete')) then
         begin
            number := Trim(Form5.Work.Items[v].Caption);
            number := Copy(number, 13, Length(number) - 12);
            Form5.source.Lines.Text := GetImg.Get(Servers_Links[i] + 'view.php?ad=' + number);

            Application.ProcessMessages;

            Form5.ndown.Enabled := True;
            exit;
         end;
      end;

 for v := 0 to Form5.Work.Items.Count-1 do
  begin
   if (Form5.Work.Items[v].SubItems.Strings[0] = 'Error') then
    Form5.re_error.Enabled := True;
  end;
end;
end;

function Getmoney : string;
var
 i   : integer;
 sou : string;
begin
 for i := Low(Servers_Names) to High(Servers_Names) do
  if Trim(main.Form5.Server.Text) = Servers_Names[i] then
   begin
     if Servers_Names[i] = 'Bux.to' then
      begin
        main.Form5.source2.Lines.Text := GetImg.Get(Servers_Links[i] + 'stats.php');

        sou := Copy(main.Form5.source2.Text, Pos('Website Visits', main.Form5.source2.Text), length(main.Form5.source2.Text));

        sou := Copy(sou, Pos('of Referrals', sou), length(sou));
        sou := Copy(sou, Pos('Website Visits', sou), length(sou));
        sou := Copy(sou, Pos('Account Balance', sou), length(sou));
        sou := Trim(Copy(sou, Pos('<strong>', sou) + 8, length(sou)));

        result := '$ ' + Trim(Copy(sou, Pos('.', sou) - 6, Pos(' ', sou) + 1));
      end;
   end;
end;

procedure GetBux_to_Stats;
var
 i : integer;
 sou : string;
begin
 for i := Low(Servers_names) to High(Servers_Names) do
  if Trim(main.Form5.Server.Text) = Servers_Names[i] then
   main.Form5.source2.Lines.Text := GetImg.Get(Servers_Links[i] + 'stats.php');

  sou := Copy(main.Form5.source2.Text, Pos('Website Visits', main.Form5.source2.Text), length(main.Form5.source2.Text));
  Form2.Label3.Caption := Trim(Copy(sou, Pos('<strong>', sou) + 8, Pos('</', sou) -2));

  sou := Copy(sou, Pos('of Referrals', sou), length(sou));
  sou := Trim(Copy(sou, Pos('<strong>', sou) + 8, Length(sou)));
  Form2.Label6.Caption := Trim(Copy(sou, 1, Pos('</', sou) -1));

  sou := Copy(sou, Pos('Website Visits', sou), length(sou));
  Form2.Label8.Caption := Trim(Copy(sou, Pos('<strong>', sou) + 8, Pos('<', sou) +6));

  sou := Copy(sou, Pos('Account Balance', sou), length(sou));
  sou := Trim(Copy(sou, Pos('<strong>', sou) + 8, length(sou)));

  Form2.Label11.Caption := Getmoney;
end;


Procedure TLogInThread.Execute;
var
 Params : TStringStream;
 i      : integer;
begin
 GetImg := Tidhttp.Create(nil);
 GetImg.AllowCookies:=true;
 GetImg.Request.ContentType := 'application/x-www-form-urlencoded';
 GetImg.Request.Connection:='Keep-Alive';
 GetImg.Request.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)';
 GetImg.HandleRedirects := True;
  if Form5.proxy_on.Checked then
   begin
    GetImg.ProxyParams.ProxyServer := Trim(Form5.proxy_server.Text);
    GetImg.ProxyParams.ProxyPort := StrToIntDef(Trim(Form5.proxy_port.Text), 80);
 //   GetImg.ProxyParams.ProxyUsername := Form5.proxy_username.Text;
 //   GetImg.ProxyParams.ProxyPassword := Form5.proxy_password.Text;
   end;
 GetImg.RedirectMaximum := 15;


for i := Low(Servers_Names) to High(Servers_Names) do
 if Trim(Form5.Server.Text) = Servers_Names[i] then
  begin
   Params := TStringStream.create('');
   Params.SIZE := 0;

     if Servers_Names[i] = 'Bux.to' then
      begin
       Params.WriteString('COOKIEusername=' + Trim(Form5.username.Text) + '&');
       Params.WriteString('COOKIEpass=' + Trim(Form5.password.Text) + '&');
       Params.WriteString('verify=' + Trim(Form5.code.Text) + '&');
       Params.WriteString('loginsubmit=Login');
      end;
    try
      Form5.source.Lines.Text := GetImg.Post(Trim(Servers_Links[i] + 'login.php'), Params);
    except on E: Exception do
       //CreateImage;
       Form5.status.Caption := 'Error Connection to ' + Form5.Server.Text;
     end;
     if Servers_Names[i] = 'Bux.to' then
      if Bux_to_logged then
        Logged_in := True;
     if (Form5.start_start.Checked) and (Logged_in) then
       Form5.start.Click;
    end;

   Params.Free;
end;

procedure TCheckingThread.Execute;
begin
  SearchLinks('view.php?ad=');
end;



end.
