object FrmSchoolLogo: TFrmSchoolLogo
  Left = 0
  Top = 0
  Caption = 'School Logo'
  ClientHeight = 206
  ClientWidth = 292
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
    292
    206)
  PixelsPerInch = 96
  TextHeight = 13
  object imgLogo: TImage
    Left = 75
    Top = 23
    Width = 150
    Height = 58
    Stretch = True
  end
  object lblPrompt: TLabel
    Left = 63
    Top = 129
    Width = 173
    Height = 26
    Alignment = taCenter
    Caption = 'jpg or gif image of size 150 X 60 pxl is the best match.'
    WordWrap = True
  end
  object btnOK: TBitBtn
    Left = 126
    Top = 173
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = SaveSchoolLogo
    ExplicitLeft = 100
    ExplicitTop = 153
  end
  object btnClose: TBitBtn
    Left = 208
    Top = 173
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'C&lose'
    Default = True
    ModalResult = 2
    TabOrder = 1
    ExplicitLeft = 182
    ExplicitTop = 153
  end
  object btnAssignImage: TButton
    Left = 110
    Top = 93
    Width = 80
    Height = 21
    Caption = 'Assign &Image'
    TabOrder = 2
    OnClick = AssignImage
  end
  object OpenDialog: TOpenDialog
    Filter = 'Bitmap(*.bmp)|*.bmp|jpg image(*.jpg)|*.jpg'
    Left = 16
  end
end
