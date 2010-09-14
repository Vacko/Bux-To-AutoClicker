unit updating;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, ComCtrls, StdCtrls, CommCtrl, ExtActns;

type
  TForm1 = class(TForm)
    update_progress: TProgressBar;
    XPManifest1: TXPManifest;
    Label1: TLabel;
    procedure URL_OnDownloadProgress
        (Sender: TDownLoadURL;
         Progress, ProgressMax: Cardinal;
         StatusCode: TURLDownloadStatus;
         StatusText: String; var Cancel: Boolean);
    procedure URL_AfterDownload(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
 functions_program, functions_updating,
 settings_program;

{$R *.dfm}

procedure TForm1.URL_AfterDownload;
begin
//Progressbar position
 Form1.update_progress.Position := Form1.update_progress.Max;
//if downloading will be complete (no errors) show message
 Application.MessageBox(PChar('Downloading Complete.. Run New Version'),PChar(Pname + ' - Update Complete'), MB_OK  + MB_ICONINFORMATION);
//Exit Program
 ExitProcess(0);
end;

procedure TForm1.URL_OnDownloadProgress;
begin
 update_progress.Min := 0;
 update_progress.Max := ProgressMax;
 update_progress.Position:= Progress;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Form1.Caption := Pname + ' - Updating v.' + Pversion + ' - ' + Pby;
 SendMessage(update_progress.Handle, PBM_SETBARCOLOR, 0, clBlack);
 Middle(Form1);
end;

end.

