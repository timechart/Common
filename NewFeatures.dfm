object FrmNewFeatures: TFrmNewFeatures
  Left = 0
  Top = 0
  Caption = 'New Features'
  ClientHeight = 416
  ClientWidth = 607
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
    607
    416)
  PixelsPerInch = 96
  TextHeight = 13
  object lblContinueUpdate: TLabel
    Left = 150
    Top = 387
    Width = 168
    Height = 13
    Cursor = crHandPoint
    Anchors = [akBottom]
    Caption = 'Continue updating Time Chart'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = CloseAndContinue
    ExplicitLeft = 164
    ExplicitTop = 275
  end
  object lblNoThanks: TLabel
    Left = 360
    Top = 387
    Width = 58
    Height = 13
    Cursor = crHandPoint
    Anchors = [akBottom]
    Caption = 'No Thanks'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = CloseAndIgnore
    ExplicitLeft = 383
    ExplicitTop = 275
  end
  object memRM: TMemo
    Left = 16
    Top = 16
    Width = 574
    Height = 359
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitWidth = 610
    ExplicitHeight = 247
  end
end
