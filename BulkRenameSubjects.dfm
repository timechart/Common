object FrmBulkRenameSubjects: TFrmBulkRenameSubjects
  Left = 549
  Top = 309
  Hint = 
    'Generic Find and Replace tool to rename one or more subject code' +
    's.'
  HelpContext = 464
  Caption = 'Bulk Rename Subjects'
  ClientHeight = 479
  ClientWidth = 790
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblBulkRenameMsg: TLabel
    Left = 15
    Top = 64
    Width = 3
    Height = 13
    WordWrap = True
  end
  object pnlControls: TPanel
    Left = 0
    Top = 0
    Width = 790
    Height = 77
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblFind: TLabel
      Left = 15
      Top = 25
      Width = 20
      Height = 13
      Caption = 'Find'
    end
    object lblReplaceWith: TLabel
      Left = 171
      Top = 25
      Width = 61
      Height = 13
      Caption = 'Replace with'
    end
    object lblShowMeTheList: TLabel
      Left = 380
      Top = 25
      Width = 167
      Height = 13
      Cursor = crHandPoint
      Caption = 'Show me the list after replacement'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = DisplayListAfterReplacement
    end
    object edtFindText: TEdit
      Left = 41
      Top = 22
      Width = 121
      Height = 21
      Hint = 'Creteria to frind subjects.'
      CharCase = ecUpperCase
      TabOrder = 0
      OnChange = PrepareSave
    end
    object edtReplaceText: TEdit
      Left = 235
      Top = 22
      Width = 121
      Height = 21
      Hint = 'Text to replace the find crteria.'
      CharCase = ecUpperCase
      TabOrder = 1
      OnChange = PrepareSave
      OnKeyPress = SupressSpaceChar
    end
    object chkNames: TCheckBox
      Left = 15
      Top = 57
      Width = 122
      Height = 17
      Hint = 
        'Select if you want to change the name according to find and repl' +
        'acement criteria.'
      Alignment = taLeftJustify
      Caption = 'Rename Names too'
      TabOrder = 2
      OnClick = RefreshSubjectList
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 77
    Width = 790
    Height = 361
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object lsvBulkRenameSubjects: TListView
      Left = 4
      Top = 4
      Width = 782
      Height = 353
      Align = alClient
      Checkboxes = True
      Columns = <
        item
          Caption = 'Old Code'
          Width = 85
        end
        item
          Caption = 'New Code'
          Width = 85
        end
        item
          Caption = 'Name'
          Width = 160
        end
        item
          Caption = 'Report Sub. Code'
          Width = 102
        end
        item
          Caption = 'Report Sub. Name'
          Width = 160
        end
        item
          Caption = 'Comment'
          Width = 200
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnChanging = DisableCheck
      OnClick = RefreshSave
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 438
    Width = 790
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      790
      41)
    object btnBulkRenameOK: TBitBtn
      Left = 625
      Top = 11
      Width = 75
      Height = 25
      Hint = 'Save the new subjects.'
      Anchors = [akRight, akBottom]
      Caption = '&Save'
      Enabled = False
      TabOrder = 0
      OnClick = DoBulkRenameSubjects
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
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
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303FF030303030303030303
        03030303030303040403030303030303030303030303030303F8F8FF03030303
        03030303030303030303040202040303030303030303030303030303F80303F8
        FF030303030303030303030303040202020204030303030303030303030303F8
        03030303F8FF0303030303030303030304020202020202040303030303030303
        0303F8030303030303F8FF030303030303030304020202FA0202020204030303
        0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
        040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
        03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
        FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
        0303030303030303030303FA0202020403030303030303030303030303F8FF03
        03F8FF03030303030303030303030303FA020202040303030303030303030303
        0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
        03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
        030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
        0202040303030303030303030303030303F8FF03F8FF03030303030303030303
        03030303FA0202030303030303030303030303030303F8FFF803030303030303
        030303030303030303FA0303030303030303030303030303030303F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      NumGlyphs = 2
    end
    object btnBulkRenameCancel: TBitBtn
      Left = 707
      Top = 11
      Width = 75
      Height = 25
      Hint = 'Exit from dialogue'
      Anchors = [akRight, akBottom]
      Caption = 'C&lose'
      ModalResult = 2
      TabOrder = 1
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
    object rgpSelectSubjects: TRadioGroup
      Left = 32
      Top = -1
      Width = 137
      Height = 35
      Hint = 'Select or deselect all subjects in the list.'
      Caption = 'Select'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'All'
        'None')
      TabOrder = 2
      OnClick = SetSelectedSubjects
    end
    object rgpReplaceCreate: TRadioGroup
      Left = 180
      Top = -1
      Width = 424
      Height = 35
      Hint = 
        'Choose to replace existing subjects or keep them and create the ' +
        'new matches.'
      Caption = 'Replace/Create'
      Columns = 2
      Enabled = False
      ItemIndex = 0
      Items.Strings = (
        'Replace existing subjects'
        'Create new subjects and Keep existing')
      TabOrder = 3
    end
  end
end
