unit functions_updating;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, ComCtrls, StdCtrls, CommCtrl, ExtActns, Updating, idhttp,
  httpget;

const
 UPDATE_WEB  = 'http://www.vacko.ic.cz/';
 UPDATE_PATH = 'updates/buxto/';
 UPDATE_VERS = 'update.txt';
 UPDATE_FILE = 'download.txt';
 UPDATE_NAME = 'Buxto_v34.exe';

type
  THttpGetNewVerison = Class(TObject)
   procedure ProgrameOnProgress(Sender: TObject; TotalSize, Readed: Integer);
   Procedure ProgrameOnDoneFile(Sender: TObject; FileName: String; FileSize: Integer);
   Procedure ProgrameOnError(Sender: TObject);
  end;
  
   TDownloadNewVersion = class(TThread) count:Integer;
    protected
    procedure Execute; override;
  end; 

var
 DownloadNewVersion : TDownloadNewVersion;
 HttpGetNewVerison : THttpGetNewVerison;
 update_http : Tidhttp;

  function Updating_GetDLLink : String;
  function Updating_GetVersion : String;
  Procedure HttpGetNewPrograme(const URL: String; const FileName : String);

implementation

uses
 main;

function Updating_GetVersion : String;
begin
 update_http := Tidhttp.Create(nil);
  try
   result := update_http.Get(UPDATE_WEB + UPDATE_PATH + UPDATE_VERS);
  except on E: Exception do
    result :=  'Error Connection';
  end;

 update_http.Free;
end;

function Updating_GetDLLink : String;
begin
 update_http := Tidhttp.Create(nil);
  try
   result := update_http.Get(UPDATE_WEB + UPDATE_PATH + UPDATE_FILE);
  except on E: Exception do
    result :=  'Error Connection';
  end;
 update_http.Free;  
end;


procedure THttpGetNewVerison.ProgrameOnProgress(Sender: TObject; TotalSize, Readed: Integer);
begin
//Progressbar Min
 Form5.update_progress.Min := 0;
//Progressbar Max
 Form5.update_progress.Max := TotalSize;
//Progressbar position
 Form5.update_progress.Position := Readed;

 Form5.Label19.Caption := IntToStr(Round(Readed / 1024)) + ' Kb';
 Form5.Label20.Caption := IntToStr(Round(TotalSize / 1024)) + ' Kb';
end;

Procedure THttpGetNewVerison.ProgrameOnError(Sender: TObject);
begin
 Form5.update_progress.Position := Form5.update_progress.Max;
 Application.MessageBox(PChar('Error Downloading.. Please Restart Program '),PChar('Update Error'), MB_OK  + MB_ICONINFORMATION);
end;

Procedure THttpGetNewVerison.ProgrameOnDoneFile(Sender: TObject; FileName: String; FileSize: Integer);
begin
//Progressbar position
 Form5.update_progress.Position := Form5.update_progress.Max;
//if downloading will be complete (no errors) show message
 Application.MessageBox(PChar('Downloading Complete.. Run New Version '),PChar('Update Complete'), MB_OK  + MB_ICONINFORMATION);
//Exit Program
 ExitProcess(0);
end;

Procedure HttpGetNewPrograme(const URL: String; const FileName : String);
var
 update_new_version : Thttpget;
begin
  Form5.Label18.Caption := UPDATE_NAME;
  Form5.update_progress.Position := 0;

  if FileExists(FileName) then
     DeleteFile(FileName);

   update_new_version := Thttpget.Create(nil);
   update_new_version.OnProgress := HttpGetNewVerison.ProgrameOnProgress;
   update_new_version.OnDoneFile := HttpGetNewVerison.ProgrameOnDoneFile;
   update_new_version.OnError := HttpGetNewVerison.ProgrameOnError;
   try
    update_new_version.url := URL;
    update_new_version.FileName := FileName;
    update_new_version.GetFile;
   except
      update_new_version.Free;
    end;
end;

Procedure TDownloadNewVersion.Execute;
begin
 HttpGetNewPrograme(Updating_GetDLLink, UPDATE_NAME);
end;

end.


