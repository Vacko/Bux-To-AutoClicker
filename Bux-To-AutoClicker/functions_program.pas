unit functions_program;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

  procedure Middle(form : Tform);
  function Decrypt(Retezec : string): string;
  function Encrypt(Retezec : string): string;

implementation


procedure Middle(form : Tform);
begin
  form.Left := trunc(screen.Width / 2 - form.Width / 2);
  form.top := trunc(screen.height / 2 - form.Height / 2);
end;

function Encrypt(Retezec : string): string;
var
  i  : integer;
  pp : string;
begin
  pp := '';
  for i := 1 to length(Retezec) do
    if length(Retezec[i]) > 0 then
    if i mod 2 = 0 then
      pp := pp + chr(ord(Retezec[i]) + 18)
    else
      pp := pp + chr(ord(Retezec[i]) - 6);

  result :=  pp;
end;

function Decrypt(Retezec : string): string;
var
  i  : integer;
  pp : string;
begin
  pp := '';
   for i := 1 to length(Retezec) do
    if i mod 2 = 0 then
      pp := pp + chr(ord(Retezec[i])- 18)
    else
      pp := pp + chr(ord(Retezec[i])+ 6);

  result := pp;
end;

end.



