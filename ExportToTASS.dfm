object FrmExportTASS: TFrmExportTASS
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Export Data to TASS'
  ClientHeight = 147
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  DesignSize = (
    397
    147)
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrompt: TLabel
    Left = 33
    Top = 50
    Width = 338
    Height = 33
    AutoSize = False
    Caption = 'Promp'
    WordWrap = True
  end
  object btnExport: TButton
    Left = 233
    Top = 114
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'E&xport'
    TabOrder = 0
    OnClick = btnExportClick
  end
  object btnCancel: TButton
    Left = 314
    Top = 114
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 1
  end
  object chkExcludeNonTtabledChoices: TCheckBox
    Left = 33
    Top = 24
    Width = 225
    Height = 17
    Caption = 'Exclude non-timetabled student choices'
    TabOrder = 2
    OnClick = RefreshPrompt
  end
end
