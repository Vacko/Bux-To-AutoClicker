object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Updating '
  ClientHeight = 53
  ClientWidth = 442
  Color = clBtnHighlight
  Font.Charset = EASTEUROPE_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Sylfaen'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 192
    Top = 4
    Width = 59
    Height = 14
    Caption = 'Updating : '
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -10
    Font.Name = 'Sylfaen'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object update_progress: TProgressBar
    Left = 8
    Top = 24
    Width = 426
    Height = 9
    Smooth = True
    TabOrder = 0
  end
  object XPManifest1: TXPManifest
  end
end
