unit stats;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel2: TBevel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel3: TBevel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
 updating,
 functions_program, functions_updating, functions_buxto,
 settings_program;

{$R *.dfm}

procedure TForm2.FormActivate(Sender: TObject);
begin
 GetBux_to_Stats;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 form2.Caption := Pname + ' v.' + Pversion + ' - ' + Pby + ' - Stats';
 Middle(Form2);
end;

procedure TForm2.FormShow(Sender: TObject);
begin
 label3.Caption := '0';
 label6.Caption := '0';
 label8.Caption := '0';
 label11.Caption := '0';
end;

end.

