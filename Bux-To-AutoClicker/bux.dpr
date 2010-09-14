program bux;

uses
  Forms,
  main in 'main.pas' {Form5},
  functions_program in 'functions_program.pas',
  settings_program in 'settings_program.pas',
  functions_updating in 'functions_updating.pas',
  PNGZLIB in 'Png\PNGZLIB.pas',
  PNGImage in 'Png\PNGImage.pas',
  functions_buxto in 'functions_buxto.pas',
  stats in 'stats.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
