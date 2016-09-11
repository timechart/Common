object FrmCASES21ExportDataView: TFrmCASES21ExportDataView
  Left = 0
  Top = 0
  Caption = 'CASES21 (Maze)  Export Data View'
  ClientHeight = 525
  ClientWidth = 639
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
  object lblQuiltLabel: TLabel
    Left = 0
    Top = 0
    Width = 639
    Height = 17
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Quilt data'
  end
  object lblSubjectSelectionLabel: TLabel
    Left = 0
    Top = 273
    Width = 639
    Height = 13
    Align = alTop
    Alignment = taCenter
    Caption = 'Subject selections data'
    ExplicitWidth = 111
  end
  object grdQuilt: TNiceGrid
    Left = 0
    Top = 17
    Width = 639
    Height = 256
    Cursor = 101
    ColCount = 6
    RowCount = 0
    HeaderColor = clScrollBar
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    FitToWidth = True
    ReadOnly = True
    Columns = <
      item
        Title = 'Subject Code'
        Width = 91
        VertAlign = vaTop
        ReadOnly = True
      end
      item
        Title = 'Class Number'
        Width = 99
        HorzAlign = haCenter
        VertAlign = vaTop
        ReadOnly = True
      end
      item
        Title = 'Teacher Code'
        Width = 100
        VertAlign = vaTop
        ReadOnly = True
      end
      item
        Title = 'Room Code'
        Width = 102
        VertAlign = vaTop
        ReadOnly = True
      end
      item
        Title = 'Period Number'
        Width = 103
        HorzAlign = haCenter
        VertAlign = vaTop
        ReadOnly = True
      end
      item
        Title = 'Day Number'
        Width = 105
        HorzAlign = haCenter
        VertAlign = vaTop
      end>
    GutterKind = gkNumber
    GutterWidth = 35
    GutterFont.Charset = DEFAULT_CHARSET
    GutterFont.Color = clWindowText
    GutterFont.Height = -11
    GutterFont.Name = 'Tahoma'
    GutterFont.Style = []
    ShowFooter = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Align = alTop
    TabOrder = 0
  end
  object grdSubjectSelections: TNiceGrid
    Left = 0
    Top = 286
    Width = 639
    Height = 239
    Cursor = 101
    ColCount = 3
    RowCount = 0
    HeaderColor = clScrollBar
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'Tahoma'
    FooterFont.Style = []
    ReadOnly = True
    Columns = <
      item
        Title = 'Student ID'
        Width = 120
        ReadOnly = True
      end
      item
        Title = 'Subject Code'
        Width = 120
        ReadOnly = True
      end
      item
        Title = 'Class Number'
        Width = 120
        HorzAlign = haCenter
        ReadOnly = True
      end>
    GutterKind = gkNumber
    GutterWidth = 35
    GutterFont.Charset = DEFAULT_CHARSET
    GutterFont.Color = clWindowText
    GutterFont.Height = -11
    GutterFont.Name = 'Tahoma'
    GutterFont.Style = []
    ShowFooter = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Align = alClient
    TabOrder = 1
  end
end
