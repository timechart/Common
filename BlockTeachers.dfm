object FrmBlockTeachers: TFrmBlockTeachers
  Left = 0
  Top = 0
  HelpContext = 466
  Caption = 'Block Teachers'
  ClientHeight = 678
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = popBlockTeachers
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBlockteachersButtons: TPanel
    Left = 0
    Top = 640
    Width = 447
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      447
      38)
    object lblTeachersAllocated: TLabel
      Left = 24
      Top = 16
      Width = 127
      Height = 13
      Caption = 'No teachers are allocated.'
    end
    object btnBlockTeachersClose: TBitBtn
      Left = 363
      Top = 7
      Width = 75
      Height = 25
      Hint = 'Exit from dialogue'
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'C&lose'
      Default = True
      ModalResult = 2
      TabOrder = 0
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000C0DCC000F0CA
        A600000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030404040406
        0303030303040404040303030303FFFFFFFF030303030303FFFFFFFF03030303
        FAFAFA0403030303030302FA040303030303F8F80303FF0303030303F8F803FF
        030303030302FA0406030303030302FA0403030303030303F803FF0303030303
        03F803FF030303030302FA02040303030306FA060603030303030303F80303FF
        03030303F803FF03030303030303FAFA040603030602FA040303030303030303
        03F803FF030303F80303FF0303030303030306FAFA04040602FA040603030303
        0303030303F80303FFFFF80303FF03030303030303030302FAFA020202040603
        03030303030303030303F80303030303FF030303030303030303030306FAFAFA
        020206040603030303030303030303F803030303FFF8FFFF0303030304040404
        0606FAFA040306FA04030303030303F8FFFFFFF8F80303FF03F803FF03030303
        06FAFA020406FA02040306FA04030303030303F8F80303FFF80303FF03F803FF
        03030303030306FA0204FAFA040402FA040303030303030303F80303FF0303FF
        FFF803FF0303030303030303FA02FAFA02FAFA0403030303030303030303F803
        030303030303FF030303030303030303030202FAFAFA04030303030303030303
        030303F80303030303FF0303030303030303030303030202FA04030303030303
        0303030303030303F8030303FF0303030303030303030303030404FA04030303
        03030303030303030303030303F803FF0303030303030303030303030306FA02
        04030303030303030303030303030303F80303FF030303030303030303030303
        0306FAFA04030303030303030303030303030303F80303FF0303030303030303
        03030303030306060603030303030303030303030303030303F8F8F803030303
        0303}
      NumGlyphs = 2
    end
  end
  object trvBlockTeachers: TTreeView
    Left = 0
    Top = 0
    Width = 447
    Height = 640
    Align = alClient
    Indent = 19
    PopupMenu = popBlockTeachers
    ReadOnly = True
    RightClickSelect = True
    TabOrder = 1
  end
  object popBlockTeachers: TPopupMenu
    Left = 320
    Top = 640
    object popBlockTeachersPrint: TMenuItem
      Caption = 'Print...'
      ImageIndex = 1
      ShortCut = 16464
      OnClick = PrintReport
    end
    object popBlockTeachersPrintPreview: TMenuItem
      Caption = 'Print Preview...'
      ImageIndex = 0
      ShortCut = 16465
      OnClick = PrintPreviewReport
    end
    object popBlockTeachersCopy: TMenuItem
      Caption = '&Copy'
      ShortCut = 16451
      OnClick = CopyBlockTeachersToClipboard
    end
  end
  object pipBlockTeachers: TppJITPipeline
    InitialIndex = 0
    RecordCount = 99999999
    UserName = 'pipBlockTeachers'
    OnGetFieldValue = PopulateFieldData
    Left = 256
    Top = 640
    object ppJITBlockName: TppField
      FieldAlias = 'BlockName'
      FieldName = 'fldBlockName'
      FieldLength = 10
      DisplayWidth = 10
      Position = 0
    end
    object ppJITSubjectName: TppField
      FieldAlias = 'SubjectName'
      FieldName = 'fldSubjectName'
      FieldLength = 100
      DisplayWidth = 10
      Position = 1
    end
    object ppJITNoOfStudents: TppField
      FieldAlias = 'NoOfStudents'
      FieldName = 'fldNoOfStudents'
      FieldLength = 10
      DisplayWidth = 10
      Position = 2
    end
    object ppJITTeacherName: TppField
      FieldAlias = 'TeacherName'
      FieldName = 'fldTeacherName'
      FieldLength = 100
      DisplayWidth = 10
      Position = 3
    end
  end
  object repBlockTeachers: TppReport
    AutoStop = False
    DataPipeline = pipBlockTeachers
    NoDataBehaviors = [ndMessageDialog, ndBlankPage]
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.PaperName = 'Letter'
    PrinterSetup.PrinterName = 'Default'
    PrinterSetup.SaveDeviceSettings = False
    PrinterSetup.mmMarginBottom = 6350
    PrinterSetup.mmMarginLeft = 6350
    PrinterSetup.mmMarginRight = 6350
    PrinterSetup.mmMarginTop = 6350
    PrinterSetup.mmPaperHeight = 279401
    PrinterSetup.mmPaperWidth = 215900
    PrinterSetup.PaperSize = 1
    AllowPrintToFile = True
    DeviceType = 'Screen'
    EmailSettings.ReportFormat = 'PDF'
    LanguageID = 'Default'
    OutlineSettings.CreateNode = True
    OutlineSettings.CreatePageNodes = True
    OutlineSettings.Enabled = True
    OutlineSettings.Visible = True
    PDFSettings.EmbedFontOptions = []
    PDFSettings.EncryptSettings.AllowCopy = True
    PDFSettings.EncryptSettings.AllowInteract = True
    PDFSettings.EncryptSettings.AllowModify = True
    PDFSettings.EncryptSettings.AllowPrint = True
    PDFSettings.EncryptSettings.Enabled = False
    PDFSettings.FontEncoding = feAnsi
    PDFSettings.OpenPDFFile = True
    PDFSettings.Subject = 'Block Teachers'
    PDFSettings.Title = 'Block Teachers'
    PreviewFormSettings.WindowState = wsMaximized
    RTFSettings.DefaultFont.Charset = DEFAULT_CHARSET
    RTFSettings.DefaultFont.Color = clWindowText
    RTFSettings.DefaultFont.Height = -13
    RTFSettings.DefaultFont.Name = 'Arial'
    RTFSettings.DefaultFont.Style = []
    TextSearchSettings.DefaultString = '<FindText>'
    TextSearchSettings.Enabled = True
    Left = 288
    Top = 640
    Version = '12.04'
    mmColumnWidth = 0
    DataPipelineName = 'pipBlockTeachers'
    object ppHeaderBand1: TppHeaderBand
      mmBottomOffset = 0
      mmHeight = 45773
      mmPrintPosition = 0
      object lblSchoolName: TppLabel
        UserName = 'lblSchoolName'
        HyperlinkColor = clBlue
        AutoSize = False
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'AMIG SYSTEMS Secondary School'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 16
        Font.Style = []
        TextAlignment = taCentered
        Transparent = True
        WordWrap = True
        mmHeight = 8996
        mmLeft = 5556
        mmTop = 6879
        mmWidth = 190236
        BandType = 0
      end
      object ppLabel2: TppLabel
        UserName = 'Label2'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'Block'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4064
        mmLeft = 8202
        mmTop = 39952
        mmWidth = 10795
        BandType = 0
      end
      object ppLabel3: TppLabel
        UserName = 'Label3'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'Subject'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4064
        mmLeft = 39423
        mmTop = 39952
        mmWidth = 15113
        BandType = 0
      end
      object ppLabel4: TppLabel
        UserName = 'Label4'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'Teacher'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4064
        mmLeft = 143140
        mmTop = 39952
        mmWidth = 15113
        BandType = 0
      end
      object ppLine1: TppLine
        UserName = 'Line1'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Weight = 0.750000000000000000
        mmHeight = 265
        mmLeft = 5556
        mmTop = 45508
        mmWidth = 189972
        BandType = 0
      end
      object ppLabel1: TppLabel
        UserName = 'Label1'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'No. of Students'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4064
        mmLeft = 100542
        mmTop = 39952
        mmWidth = 32385
        BandType = 0
      end
      object ppSystemVariable1: TppSystemVariable
        UserName = 'SystemVariable1'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        VarType = vtDateTime
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 3937
        mmLeft = 148029
        mmTop = 32015
        mmWidth = 47498
        BandType = 0
      end
      object ppLabel5: TppLabel
        UserName = 'Label5'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'Block Teachers'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 16
        Font.Style = []
        Transparent = True
        mmHeight = 6223
        mmLeft = 82286
        mmTop = 16933
        mmWidth = 46228
        BandType = 0
      end
      object imgSchoolLogo: TppImage
        UserName = 'imgSchoolLogo'
        AlignHorizontal = ahCenter
        AlignVertical = avCenter
        MaintainAspectRatio = False
        Stretch = True
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        mmHeight = 15081
        mmLeft = 6879
        mmTop = 16140
        mmWidth = 34396
        BandType = 0
      end
      object ppLine2: TppLine
        UserName = 'Line2'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Weight = 0.750000000000000000
        mmHeight = 265
        mmLeft = 5556
        mmTop = 38629
        mmWidth = 189971
        BandType = 0
      end
      object ppShape1: TppShape
        UserName = 'Shape1'
        Gradient.EndColor = clWhite
        Gradient.StartColor = clWhite
        Gradient.Style = gsNone
        mmHeight = 6615
        mmLeft = 195263
        mmTop = 38894
        mmWidth = 264
        BandType = 0
      end
      object ppShape2: TppShape
        UserName = 'Shape2'
        Gradient.EndColor = clWhite
        Gradient.StartColor = clWhite
        Gradient.Style = gsNone
        mmHeight = 6615
        mmLeft = 5556
        mmTop = 38894
        mmWidth = 265
        BandType = 0
      end
      object lblBlockFile: TppLabel
        UserName = 'lblBlockFile'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'Block File'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 3937
        mmLeft = 6085
        mmTop = 32015
        mmWidth = 21590
        BandType = 0
      end
    end
    object ppDetailBand1: TppDetailBand
      Background1.Brush.Style = bsClear
      Background1.Gradient.EndColor = clWhite
      Background1.Gradient.StartColor = clWhite
      Background1.Gradient.Style = gsNone
      Background2.Brush.Style = bsClear
      Background2.Gradient.EndColor = clWhite
      Background2.Gradient.StartColor = clWhite
      Background2.Gradient.Style = gsNone
      mmBottomOffset = 0
      mmHeight = 5556
      mmPrintPosition = 0
      object ppDBText1: TppDBText
        UserName = 'DBText1'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'fldBlockName'
        DataPipeline = pipBlockTeachers
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'pipBlockTeachers'
        mmHeight = 3937
        mmLeft = 8202
        mmTop = 794
        mmWidth = 18256
        BandType = 4
      end
      object ppDBText2: TppDBText
        UserName = 'DBText2'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'fldSubjectName'
        DataPipeline = pipBlockTeachers
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clFuchsia
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'pipBlockTeachers'
        mmHeight = 3937
        mmLeft = 27781
        mmTop = 794
        mmWidth = 75671
        BandType = 4
      end
      object ppDBText3: TppDBText
        UserName = 'DBText3'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'fldNoOfStudents'
        DataPipeline = pipBlockTeachers
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'pipBlockTeachers'
        mmHeight = 3937
        mmLeft = 109009
        mmTop = 794
        mmWidth = 16669
        BandType = 4
      end
      object ppDBText4: TppDBText
        UserName = 'DBText4'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'fldTeacherName'
        DataPipeline = pipBlockTeachers
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'pipBlockTeachers'
        mmHeight = 3937
        mmLeft = 129646
        mmTop = 794
        mmWidth = 64558
        BandType = 4
      end
      object ppLine3: TppLine
        UserName = 'Line3'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Weight = 0.750000000000000000
        mmHeight = 265
        mmLeft = 5555
        mmTop = 5291
        mmWidth = 189971
        BandType = 4
      end
      object ppShape3: TppShape
        UserName = 'Shape3'
        Gradient.EndColor = clWhite
        Gradient.StartColor = clWhite
        Gradient.Style = gsNone
        mmHeight = 5292
        mmLeft = 195263
        mmTop = 0
        mmWidth = 265
        BandType = 4
      end
      object ppShape4: TppShape
        UserName = 'Shape4'
        Gradient.EndColor = clWhite
        Gradient.StartColor = clWhite
        Gradient.Style = gsNone
        mmHeight = 5291
        mmLeft = 5556
        mmTop = 0
        mmWidth = 265
        BandType = 4
      end
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 13229
      mmPrintPosition = 0
    end
    object ppParameterList1: TppParameterList
    end
  end
end
