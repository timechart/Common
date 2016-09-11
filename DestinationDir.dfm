object FrmDestinationFile: TFrmDestinationFile
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FrmDestinationFile'
  ClientHeight = 112
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    488
    112)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDestination: TLabel
    Left = 15
    Top = 32
    Width = 54
    Height = 13
    Caption = 'Destination'
  end
  object btnOK: TButton
    Left = 327
    Top = 81
    Width = 72
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = SaveFileName
    ExplicitLeft = 478
    ExplicitTop = 267
  end
  object btnCancel: TButton
    Left = 408
    Top = 81
    Width = 72
    Height = 24
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Cancel'
    Default = True
    ModalResult = 2
    TabOrder = 1
    ExplicitLeft = 559
    ExplicitTop = 267
  end
  object edtDestination: TEdit
    Left = 75
    Top = 29
    Width = 343
    Height = 21
    TabOrder = 2
  end
  object btnSelectDir: TButton
    Left = 424
    Top = 29
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = SelectTargetDirectory
  end
end
