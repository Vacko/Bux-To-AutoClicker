unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, ExtCtrls, ComCtrls, StdCtrls, inifiles, idhttp, CommCtrl,
  registry;

type
  TForm5 = class(TForm)
    XPManifest1: TXPManifest;
    Checking_Version: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    Label6: TLabel;
    status: TLabel;
    Label7: TLabel;
    timeleft: TLabel;
    Label8: TLabel;
    countlinks: TLabel;
    Server: TComboBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Label5: TLabel;
    username: TEdit;
    password: TEdit;
    code: TEdit;
    logon: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    logoff: TButton;
    GroupBox2: TGroupBox;
    statss: TButton;
    work: TListView;
    start: TButton;
    Button1: TButton;
    TrayIcon: TTrayIcon;
    source: TRichEdit;
    re_error: TTimer;
    ndown: TTimer;
    source2: TRichEdit;
    TabSheet2: TTabSheet;
    Bevel1: TBevel;
    Update_Version: TTimer;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    Label15: TLabel;
    Label18: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label17: TLabel;
    Label20: TLabel;
    update_progress: TProgressBar;
    GroupBox4: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    version_history: TMemo;
    Label14: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    GroupBox5: TGroupBox;
    Label23: TLabel;
    start_autorun: TCheckBox;
    Label24: TLabel;
    start_trayicon: TCheckBox;
    Label25: TLabel;
    start_login: TCheckBox;
    Label26: TLabel;
    start_start: TCheckBox;
    Label27: TLabel;
    start_exit: TCheckBox;
    OnStartW: TTimer;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    proxy_on: TRadioButton;
    proxy_off: TRadioButton;
    GroupBox8: TGroupBox;
    proxy_server: TEdit;
    proxy_port: TEdit;
    Checking_TimeLeft: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Checking_VersionTimer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure logonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ServerChange(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure logoffClick(Sender: TObject);
    procedure startClick(Sender: TObject);
    procedure re_errorTimer(Sender: TObject);
    procedure ndownTimer(Sender: TObject);
    procedure statssClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Update_VersionTimer(Sender: TObject);
    procedure OnStartWTimer(Sender: TObject);
    procedure Checking_TimeLeftTimer(Sender: TObject);
    procedure start_exitClick(Sender: TObject);
    procedure proxy_onClick(Sender: TObject);
    procedure proxy_offClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  iniFile : Tinifile;

  Logged_in : Boolean;
  seconds_left : integer;

implementation

uses
 updating,
 functions_program, functions_updating, functions_buxto,
 settings_program,
 stats;

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
 Hide;
end;

procedure TForm5.Checking_TimeLeftTimer(Sender: TObject);
var
 i : integer;
 done : Boolean;
begin
 Done := True;

 if work.Items.Count-1 > -1 then
  begin
    for i := 0 to work.Items.Count-1 do
      if (work.Items.Item[i].SubItems.Strings[0] = 'False') then
        Done := False;
  end;

 if Done then 
  Close;
end;

procedure TForm5.Checking_VersionTimer(Sender: TObject);
begin
 Checking_Version.Enabled := False;

 PageControl1.TabIndex := 1;
 DownloadNewVersion := TDownloadNewVersion.Create(false);
end;

procedure TForm5.FormCreate(Sender: TObject);
var
 i : integer;
 us, ps : integer;
 run,
 ic,
 lg,
 st,
 ex : integer;
 prx : integer;
begin
 Form5.Caption := Pname + ' v.' + Pversion + ' - ' + Pby;
 Middle(Form5);

  for i := Low(Servers_Names) to High(Servers_Names) do
    Server.Items.Add(Servers_Names[i]);
    Server.ItemIndex := 0;

 if FileExists(ChangeFileExt(Application.ExeName,'.ini')) then
  begin
   iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
     us  := iniFile.ReadInteger('Settings', 'Us', 0);
     ps  := iniFile.ReadInteger('Settings', 'Ps', 0);
     run := iniFile.ReadInteger('On_Start', 'Run', 0);
     ic  := iniFile.ReadInteger('On_Start', 'Tray', 0);
     lg  := iniFile.ReadInteger('On_Start', 'Log', 0);
     st  := iniFile.ReadInteger('On_Start', 'Start', 0);
     ex  := iniFile.ReadInteger('On_Start', 'Exit', 0);
     prx := iniFile.ReadInteger('Proxy', 'Off', 1);
    if prx = 0 then
      begin
       proxy_server.Text := iniFile.ReadString('Proxy', 'server', 'Error reading');
       proxy_port.Text := iniFile.ReadString('Proxy', 'port', 'Error reading');
       proxy_on.Checked := True;
       proxy_off.Checked := False;
      end;
     if prx = 1 then
      begin
       proxy_on.Checked := False;
       proxy_off.Checked := True;
      end;

    if us = 1 then
     begin
      CheckBox1.Checked := True;
      username.Text     := iniFile.ReadString('Settings', 'Username', 'Error reading');
     end;
    if ps = 1 then
     begin
      CheckBox2.Checked := True;
      password.Text     := DeCrypt(iniFile.ReadString('Settings', 'Password', 'Error reading'));
     end;

    if run = 1 then
      start_autorun.Checked := True;
    if ic = 1 then
      start_trayicon.Checked := True;
    if lg = 1 then
      start_login.Checked := True;
    if st = 1 then
      start_start.Checked := True;
    if ex = 1 then
      start_exit.Checked := True;
      
   IniFile.Free;
  end;


//Panel Updates
  Label10.Caption :=  Pversion;
  Label18.Caption := '                           ';
  Status.Caption := 'None                                                            ';
  countlinks.Caption := '0  ';
  version_history.Clear;
  version_history.Lines.Insert(0, '*New: Log On to Bux.To by Web Page');
  version_history.Lines.Insert(0, '*New: Auto Clicking to Links');
  version_history.Lines.Insert(0, '*New: Clear Cookies');
  version_history.Lines.Insert(0, Pname + ' 1.0');
  version_history.Lines.Insert(0, '');
  version_history.Lines.Insert(0, '*New: More Users');
  version_history.Lines.Insert(0, '*Improved: Program Design');
  version_history.Lines.Insert(0, '*Improved: Faster Clicking to Links');
  version_history.Lines.Insert(0, Pname + ' 2.0');
  version_history.Lines.Insert(0, '');
  version_history.Lines.Insert(0, '*New: Code to Rewrite');
  version_history.Lines.Insert(0, '*New: Updating New Version');
  version_history.Lines.Insert(0, '*New: User Stats');
  version_history.Lines.Insert(0, '*New: Tray Icon');
  version_history.Lines.Insert(0, '*New: TimeLeft');
  version_history.Lines.Insert(0, '*New: Save(Login & Password)');
  version_history.Lines.Insert(0, '*Improved: Log On to Bux.To');
  version_history.Lines.Insert(0, Pname + ' 3.0');
  version_history.Lines.Insert(0, '');
  version_history.Lines.Insert(0, '*New: Program Engine');   
  version_history.Lines.Insert(0, '*Improved: User Stats');
  version_history.Lines.Insert(0, '*Improved: Program Design');
  version_history.Lines.Insert(0, '*Fixed: Code to Rewrite');  
  version_history.Lines.Insert(0, Pname + ' 3.1');
  version_history.Lines.Insert(0, '');
  version_history.Lines.Insert(0, '*New: Settings');     
  version_history.Lines.Insert(0, '*Improved: TimeLeft');
  version_history.Lines.Insert(0, '*Improved: Updating New Version');
  version_history.Lines.Insert(0, '*Improved: No Code to ReWrite(Only Login & Password)');
  version_history.Lines.Insert(0, Pname + ' 3.2');
  version_history.Lines.Insert(0, '');
  version_history.Lines.Insert(0, '*New: Proxy Settings');   
  version_history.Lines.Insert(0, '*Improved: No Freezes in Log On (Thread)');
  version_history.Lines.Insert(0, '*Improved: No Freezes in Clicking Links (Thread)');
  version_history.Lines.Insert(0, Pname + ' 3.3');
  SendMessage(update_progress.Handle, PBM_SETBARCOLOR, 0, clBlack);

// CreateImage;
 Logged_in := False; 
end;

procedure TForm5.FormDestroy(Sender: TObject);
begin
if (CheckBox1.Checked) or (CheckBox2.Checked) or
   (start_autorun.Checked) or (start_trayicon.Checked) or
   (start_login.Checked) or (start_start.Checked) or
   (start_exit.Checked) or (proxy_off.Checked) or
   (proxy_on.Checked) then
 begin
   iniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));

     if proxy_off.Checked then iniFile.WriteInteger('Proxy', 'Off', 1)
                          else iniFile.WriteInteger('Proxy', 'Off', 0);
     if proxy_on.Checked then
      begin
       iniFile.WriteString('Proxy', 'server', proxy_server.Text);
       iniFile.WriteString('Proxy', 'port', proxy_port.Text);
      // iniFile.WriteString('Proxy', 'username', proxy_username.Text);
      // iniFile.WriteString('Proxy', 'password', proxy_password.Text);
      end;

     if start_autorun.Checked  then iniFile.WriteInteger('On_Start', 'Run', 1)
                               else iniFile.WriteInteger('On_Start', 'Run', 0);
     if start_trayicon.Checked then iniFile.WriteInteger('On_Start', 'Tray', 1)
                               else iniFile.WriteInteger('On_Start', 'Tray', 0);
     if start_login.Checked    then iniFile.WriteInteger('On_Start', 'Log', 1)
                               else iniFile.WriteInteger('On_Start', 'Log', 0);
     if start_start.Checked    then iniFile.WriteInteger('On_Start', 'Start', 1)
                               else iniFile.WriteInteger('On_Start', 'Start', 0);
     if start_exit.Checked     then iniFile.WriteInteger('On_Start', 'Exit', 1)
                               else iniFile.WriteInteger('On_Start', 'Exit', 0);

    if start_autorun.Checked then
     begin
       with TRegistry.Create do
        begin
         RootKey := HKEY_LOCAL_MACHINE;
         if OpenKey(Key1, False) then
           begin
             WriteString(application.Title, application.ExeName);
             CloseKey;
           end;
        end;
     end;

    if start_autorun.Checked = false then
     begin
       with TRegistry.Create do
        begin
         RootKey := HKEY_LOCAL_MACHINE;
         if OpenKey(Key1, False) then
           begin
             DeleteValue(application.Title);
             CloseKey;
           end;
        end;
     end;

    if CheckBox1.Checked then
     begin
      iniFile.WriteString('Settings', 'Username', username.Text);
      iniFile.WriteInteger('Settings', 'Us', 1);
     end else
      iniFile.WriteInteger('Settings', 'Us', 0);
    if CheckBox2.Checked then
     begin
      iniFile.WriteString('Settings', 'Password', Encrypt(password.Text));
      iniFile.WriteInteger('Settings', 'Ps', 1);
     end else
      iniFile.WriteInteger('Settings', 'Ps', 0);
   IniFile.Free;
 end;
end;

procedure TForm5.FormHide(Sender: TObject);
begin
 TrayIcon.Visible := True;
 TrayIcon.Hint := Pname + ' v.' + Pversion + ' - ' + Pby;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
 TrayIcon.Visible := False;
end;

procedure TForm5.Image1Click(Sender: TObject);
begin
// CreateImage;
end;

procedure TForm5.logoffClick(Sender: TObject);
var
 i : integer;
begin
 logon.Enabled := True;
 logoff.Enabled := False;
 statss.Enabled := False;
 start.Enabled := False;
 server.Enabled := True;
 Form5.Image1.Enabled := True;

 work.Items.Clear;

  for i := Low(Servers_Names) to High(Servers_Names) do
   if Trim(Server.Text) = Servers_Names[i] then
     GetImg.Get(Servers_Links[i] + 'logout.php');

 Status.Caption := 'None                                                          ';
 Logged_in := False;
 
 GetImg.Free;
end;

procedure TForm5.logonClick(Sender: TObject);
begin
 LogInThread := TLogInThread.Create(false);
end;

procedure TForm5.ndownTimer(Sender: TObject);
var
 i : integer;
begin
 Work.Items[v].SubItems.Strings[1] := IntToStr(StrToInt(Work.Items[v].SubItems.Strings[1]) - 1);

   seconds_left := seconds_left - 1;
 if ((seconds_left div 60) div 60) < 1 then
  timeleft.Caption :=  IntToStr((seconds_left div 60) div 60) + ' h ' + IntToStr(seconds_left div 60) + ' m ' + IntToStr(seconds_left mod 60) + ' s';
 if ((seconds_left div 60) div 60) > 0 then
  timeleft.Caption :=  IntToStr((seconds_left div 60) div 60) + ' h ' + IntToStr((seconds_left div 60) mod 60) + ' m ' + IntToStr((seconds_left mod 60) mod 60) + ' s';

// timeleft.Caption                  := IntToStr(StrToInt(timeleft.Caption) - 1);

 if Work.Items[v].SubItems.Strings[1] = '0' then
  begin
   ndown.Enabled := False;
   ndown.Tag := 0;
    for i := Low(Servers_Names) to High(Servers_Names) do
     if Trim(Server.Text) = Servers_Names[i] then
      begin
         if Servers_Names[i] = 'Bux.to' then
           begin
             source.Lines.Text := GetImg.Get(Servers_Links[i] + 'success.php?ad=' + Trim(number) + '&verify=1');

             if not (Pos('ok.gif', source.Lines.Text) = 0) then
              Work.Items[v].SubItems.Strings[0] := 'True';
             if not (Pos('error.gif', source.Lines.Text) = 0) then
              Work.Items[v].SubItems.Strings[0] := 'Error';
             if not (Pos('error1.gif', source.Lines.Text) = 0) then
              Work.Items[v].SubItems.Strings[0] := 'Error';
           end;

         StartChecking;
     end;
  end;
end;

procedure TForm5.re_errorTimer(Sender: TObject);
begin
 re_error.Enabled := False;
 StartChecking;
end;

procedure TForm5.ServerChange(Sender: TObject);
begin
// CreateImage;
end;

procedure TForm5.startClick(Sender: TObject);
begin
 CheckingThread := TCheckingThread.Create(false);
// SearchLinks('view.php?ad=');
end;

procedure TForm5.start_exitClick(Sender: TObject);
begin
 if start_exit.Checked then
    if work.Items.Count-1 > -1 then Checking_TimeLeft.Enabled := True
                               else Checking_TimeLeft.Enabled := False;
end;

procedure TForm5.statssClick(Sender: TObject);
begin
 stats.Form2.Show;
end;

procedure TForm5.OnStartWTimer(Sender: TObject);
begin
  OnStartW.Enabled := False;

  if start_login.Checked then
   Logon.Click;
end;

procedure TForm5.proxy_offClick(Sender: TObject);
begin
 if proxy_off.Checked then GroupBox8.Enabled := False;
end;

procedure TForm5.proxy_onClick(Sender: TObject);
begin
 if proxy_on.Checked then GroupBox8.Enabled := True;
end;

procedure TForm5.TrayIconClick(Sender: TObject);
begin
 if Form5.Visible then hide
                  else show;
end;

procedure TForm5.Update_VersionTimer(Sender: TObject);
begin
 Update_Version.Enabled := False;

 Label12.Caption :=  Trim(Updating_GetVersion);

 if (Pversion <> Trim(Label12.Caption)) and (Trim(Label12.Caption) <> 'Error Connection') then
  Checking_Version.Enabled := True;
end;

end.



