object FrmTeacherLoadOnWS: TFrmTeacherLoadOnWS
  Left = 0
  Top = 0
  Caption = 'Teacher Load on Work Sheet'
  ClientHeight = 123
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pipTeacherLoadOnWS: TppJITPipeline
    InitialIndex = 0
    RecordCount = 99999999
    UserName = 'pipTeacherLoadOnWS'
    OnGetFieldValue = PopulateFieldData
    Left = 112
    Top = 48
    object ppJITTeacherName: TppField
      FieldAlias = 'TeacherName'
      FieldName = 'fldTeacherName'
      FieldLength = 100
      DisplayWidth = 10
      Position = 0
    end
    object ppJITNoOfStudents: TppField
      FieldAlias = 'TeacherLoad'
      FieldName = 'fldTeacherLoad'
      FieldLength = 10
      DisplayWidth = 10
      Position = 1
    end
    object ppJITSubjectName: TppField
      FieldAlias = 'SubjectList'
      FieldName = 'fldSubjectList'
      FieldLength = 100
      DisplayWidth = 10
      Position = 2
    end
  end
  object repTeacherLoadOnWS: TppReport
    AutoStop = False
    DataPipeline = pipTeacherLoadOnWS
    NoDataBehaviors = [ndMessageDialog, ndBlankPage]
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Teacher Load on Worksheet'
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
    EmailSettings.Enabled = True
    EmailSettings.FileName = 'TeacherLoadOnWS'
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
    PDFSettings.Subject = 'Teacher Load on Worksheet'
    PDFSettings.Title = 'Teacher Load on Worksheet'
    PreviewFormSettings.WindowState = wsMaximized
    RTFSettings.DefaultFont.Charset = DEFAULT_CHARSET
    RTFSettings.DefaultFont.Color = clWindowText
    RTFSettings.DefaultFont.Height = -13
    RTFSettings.DefaultFont.Name = 'Arial'
    RTFSettings.DefaultFont.Style = []
    TextSearchSettings.DefaultString = '<FindText>'
    TextSearchSettings.Enabled = True
    Left = 144
    Top = 48
    Version = '12.04'
    mmColumnWidth = 0
    DataPipelineName = 'pipTeacherLoadOnWS'
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
      object ppLabel3: TppLabel
        UserName = 'Label3'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'Subjects'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4064
        mmLeft = 112977
        mmTop = 39952
        mmWidth = 17272
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
        mmLeft = 10583
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
        Caption = 'Load'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4064
        mmLeft = 70644
        mmTop = 39952
        mmWidth = 8636
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
        Caption = 'Teacher Load on Worksheet'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 16
        Font.Style = []
        Transparent = True
        mmHeight = 6223
        mmLeft = 66146
        mmTop = 16933
        mmWidth = 82550
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
        Visible = False
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
        Visible = False
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
        Visible = False
        mmHeight = 6615
        mmLeft = 5556
        mmTop = 38894
        mmWidth = 265
        BandType = 0
      end
      object lblTeachTotal: TppLabel
        UserName = 'lblTeachTotal'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Caption = 'lblTeachTotal'
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = [fsBold]
        Transparent = True
        mmHeight = 4064
        mmLeft = 7408
        mmTop = 33073
        mmWidth = 28067
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
      PrintHeight = phDynamic
      mmBottomOffset = 0
      mmHeight = 7144
      mmPrintPosition = 0
      object ppDBText3: TppDBText
        UserName = 'DBText3'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        DataField = 'fldTeacherLoad'
        DataPipeline = pipTeacherLoadOnWS
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'pipTeacherLoadOnWS'
        mmHeight = 3937
        mmLeft = 70644
        mmTop = 2381
        mmWidth = 9260
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
        DataPipeline = pipTeacherLoadOnWS
        Ellipsis = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        DataPipelineName = 'pipTeacherLoadOnWS'
        mmHeight = 3937
        mmLeft = 7144
        mmTop = 2381
        mmWidth = 62177
        BandType = 4
      end
      object ppLine3: TppLine
        UserName = 'Line3'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Visible = False
        Weight = 0.750000000000000000
        mmHeight = 265
        mmLeft = 5555
        mmTop = 6879
        mmWidth = 189971
        BandType = 4
      end
      object ppShape3: TppShape
        UserName = 'Shape3'
        Gradient.EndColor = clWhite
        Gradient.StartColor = clWhite
        Gradient.Style = gsNone
        Visible = False
        mmHeight = 5292
        mmLeft = 195263
        mmTop = 1588
        mmWidth = 265
        BandType = 4
      end
      object ppShape4: TppShape
        UserName = 'Shape4'
        Gradient.EndColor = clWhite
        Gradient.StartColor = clWhite
        Gradient.Style = gsNone
        Visible = False
        mmHeight = 5291
        mmLeft = 5556
        mmTop = 1588
        mmWidth = 265
        BandType = 4
      end
      object memTeacherSubjects: TppDBMemo
        UserName = 'memTeacherSubjects'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        CharWrap = False
        DataField = 'fldSubjectList'
        DataPipeline = pipTeacherLoadOnWS
        Font.Charset = ANSI_CHARSET
        Font.Color = clFuchsia
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        Stretch = True
        Transparent = True
        DataPipelineName = 'pipTeacherLoadOnWS'
        mmHeight = 4233
        mmLeft = 82550
        mmTop = 2381
        mmWidth = 111654
        BandType = 4
        mmBottomOffset = 0
        mmOverFlowOffset = 0
        mmStopPosition = 0
        mmMinHeight = 0
        mmLeading = 0
      end
      object ppLine4: TppLine
        UserName = 'Line4'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Visible = False
        Weight = 0.750000000000000000
        mmHeight = 265
        mmLeft = 5556
        mmTop = 0
        mmWidth = 189971
        BandType = 4
      end
    end
    object ppFooterBand1: TppFooterBand
      mmBottomOffset = 0
      mmHeight = 10583
      mmPrintPosition = 0
      object ppLine5: TppLine
        UserName = 'Line5'
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        Weight = 0.750000000000000000
        mmHeight = 265
        mmLeft = 5556
        mmTop = 529
        mmWidth = 189971
        BandType = 8
      end
      object ppSystemVariable2: TppSystemVariable
        UserName = 'SystemVariable2'
        HyperlinkColor = clBlue
        Border.BorderPositions = []
        Border.Color = clBlack
        Border.Style = psSolid
        Border.Visible = False
        VarType = vtPageNoDesc
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Name = 'Courier SWA'
        Font.Size = 10
        Font.Style = []
        Transparent = True
        mmHeight = 3937
        mmLeft = 95250
        mmTop = 2910
        mmWidth = 12954
        BandType = 8
      end
    end
    object ppParameterList1: TppParameterList
    end
  end
end
