object FrmTimetableStatistics: TFrmTimetableStatistics
  Left = 0
  Top = 0
  Caption = 'Timetable Statistics'
  ClientHeight = 445
  ClientWidth = 717
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grdTTStatistics: TStringGrid
    Left = 0
    Top = 0
    Width = 717
    Height = 404
    Align = alClient
    ColCount = 7
    DefaultRowHeight = 16
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 0
    OnDrawCell = AlignText
    OnMouseUp = SortList
    ExplicitLeft = 24
    ExplicitTop = 24
    ExplicitWidth = 553
    ExplicitHeight = 233
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 404
    Width = 717
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 128
    ExplicitTop = 296
    ExplicitWidth = 185
    DesignSize = (
      717
      41)
    object btnClose: TBitBtn
      Left = 634
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 619
    end
  end
end
