object FrmLoadProgress: TFrmLoadProgress
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FrmLoadProgress'
  ClientHeight = 89
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlLoadProgress: TPanel
    Left = 0
    Top = 0
    Width = 440
    Height = 89
    Align = alClient
    TabOrder = 0
    object lblTitle: TLabel
      Left = 0
      Top = 14
      Width = 440
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Parent Teacher Interview'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblProgressMsg: TLabel
      Left = 0
      Top = 66
      Width = 440
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'lblProgressMsg'
    end
    object prbProgress: TProgressBar
      Left = 20
      Top = 44
      Width = 400
      Height = 17
      Smooth = True
      Step = 1
      TabOrder = 0
    end
  end
end
