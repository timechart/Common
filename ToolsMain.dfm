object FrmToolsMain: TFrmToolsMain
  Left = 0
  Top = 0
  Caption = 'AMIG Tools'
  ClientHeight = 304
  ClientWidth = 643
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object memMain: TMemo
    Left = 0
    Top = 0
    Width = 643
    Height = 304
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object MainMenu: TMainMenu
    Left = 544
    Top = 24
    object mnuFile: TMenuItem
      Caption = '&File'
    end
    object mnuTools: TMenuItem
      Caption = '&Tools'
      object mniToolsDecryptFile: TMenuItem
        Caption = '&Decrypt File'
        OnClick = DecryptDataFile
      end
      object mniToolsEncryptFile: TMenuItem
        Caption = '&Encrypt File'
        OnClick = EncryptDataFile
      end
    end
  end
  object OpenDialog: TOpenDialog
    Left = 512
    Top = 24
  end
end
