object FrmHealthCondition: TFrmHealthCondition
  Left = 0
  Top = 0
  HelpContext = 467
  BorderStyle = bsDialog
  Caption = 'Health Conditions'
  ClientHeight = 424
  ClientWidth = 606
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
  object pnlHealthCondition: TPanel
    Left = 0
    Top = 0
    Width = 606
    Height = 424
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      606
      424)
    object pgcHealthCond: TPageControl
      Left = 1
      Top = 1
      Width = 604
      Height = 422
      ActivePage = tabStudent
      Align = alClient
      TabOrder = 0
      OnChange = RefreshPeerSupportGroup
      object tabStudent: TTabSheet
        Caption = 'Student'
        DesignSize = (
          596
          394)
        object lblStudent: TLabel
          Left = 15
          Top = 12
          Width = 38
          Height = 13
          Caption = 'Student'
        end
        object lblNoteToAssist: TLabel
          Left = 15
          Top = 124
          Width = 71
          Height = 13
          Caption = 'Notes to assist'
        end
        object lblAllConditions: TLabel
          Left = 15
          Top = 40
          Width = 64
          Height = 13
          Caption = 'All Conditions'
        end
        object lblKeySupportPerson: TLabel
          Left = 15
          Top = 270
          Width = 59
          Height = 26
          Caption = 'Key Support Person'
          WordWrap = True
        end
        object lblEmergencyContact: TLabel
          Left = 15
          Top = 304
          Width = 94
          Height = 13
          Caption = 'Emergency Contact'
        end
        object lblOtherRelevanInfo: TLabel
          Left = 15
          Top = 327
          Width = 77
          Height = 26
          Caption = 'Other Relevant Information'
          WordWrap = True
        end
        object Label1: TLabel
          Left = 314
          Top = 304
          Width = 78
          Height = 13
          Caption = 'Contact Number'
        end
        object btnSaveStudentHealth: TBitBtn
          Left = 431
          Top = 364
          Width = 75
          Height = 25
          Hint = 'Save changes to student health conditions'
          Anchors = [akRight, akBottom]
          Caption = '&Save'
          TabOrder = 9
          OnClick = SaveStudentHealthConditions
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
        object cboStudent: TComboBox
          Left = 112
          Top = 9
          Width = 269
          Height = 21
          Hint = 'Select a student'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          OnClick = RefreshStudentHealthConditions
        end
        object memStudentHealthNote: TMemo
          Left = 112
          Top = 123
          Width = 458
          Height = 119
          Hint = 'Note to assist student when needed.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          MaxLength = 500
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 3
        end
        object lsvStudentHealthCond: TListView
          Left = 112
          Top = 36
          Width = 458
          Height = 81
          Hint = 'List of student health conditions.'
          Columns = <
            item
              Caption = 'Health Condition'
              Width = 280
            end
            item
              Caption = 'Peer Support Group'
              Width = 130
            end>
          ReadOnly = True
          RowSelect = True
          PopupMenu = popHealthCond
          TabOrder = 2
          ViewStyle = vsReport
          OnChange = RefreshNote
          OnDblClick = DisplayMoreDetails
        end
        object btnAddCondition: TButton
          Left = 387
          Top = 9
          Width = 100
          Height = 21
          Hint = 'Add health condition to student'
          Caption = '&Add Condition'
          TabOrder = 1
          OnClick = AddHealthConditionToStudent
        end
        object chkHealthSupportPlan: TCheckBox
          Left = 15
          Top = 246
          Width = 111
          Height = 17
          Hint = 'Select if student has health support plan.'
          Alignment = taLeftJustify
          Caption = 'Health Support Plan'
          TabOrder = 4
        end
        object edtKeySupportPerson: TEdit
          Left = 112
          Top = 270
          Width = 167
          Height = 21
          Hint = 'Name of the key support person.'
          MaxLength = 50
          TabOrder = 5
        end
        object edtOtherRelevanInfo: TEdit
          Left = 112
          Top = 332
          Width = 458
          Height = 21
          Hint = 
            'Any relevant data to the student or their condition that might b' +
            'e useful.'
          MaxLength = 500
          TabOrder = 8
        end
        object edtEmergencyContact: TEdit
          Left = 112
          Top = 301
          Width = 167
          Height = 21
          Hint = 'Name of the contact person such as parent.'
          MaxLength = 50
          TabOrder = 6
        end
        object edtEmergencyContactNo: TEdit
          Left = 403
          Top = 301
          Width = 167
          Height = 21
          Hint = 'Phone number of the contact person.'
          MaxLength = 20
          TabOrder = 7
        end
      end
      object tabHealthCond: TTabSheet
        Caption = 'Health Condition'
        ImageIndex = 1
        object lblHealthCondName: TLabel
          Left = 15
          Top = 13
          Width = 27
          Height = 13
          Caption = 'Name'
        end
        object lblHealthDescription: TLabel
          Left = 15
          Top = 36
          Width = 53
          Height = 13
          Caption = 'Description'
        end
        object lblConditionWebLink: TLabel
          Left = 15
          Top = 342
          Width = 77
          Height = 13
          Caption = 'Read more here'
        end
        object lblConditionWebURL: TLabel
          Left = 112
          Top = 342
          Width = 466
          Height = 13
          Cursor = crHandPoint
          Hint = 'Web link to the Health condition.'
          AutoSize = False
          Caption = 'lblConditionWebURL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          OnClick = LinkToWebPage
        end
        object memHealthDescription: TMemo
          Left = 112
          Top = 36
          Width = 458
          Height = 301
          Hint = 'Health condition description'
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object cboHealthCondName: TComboBox
          Left = 112
          Top = 9
          Width = 269
          Height = 21
          Hint = 'Select a health condition.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          OnChange = RefreshHealthConditionDetails
        end
        object btnCreateHealthCondtion: TButton
          Left = 387
          Top = 9
          Width = 100
          Height = 21
          Hint = 'Create new health condition.'
          Caption = '&Create Condtion'
          TabOrder = 2
          OnClick = DisplayCreateHealthCondition
        end
      end
      object tabPeerSupportGroup: TTabSheet
        Caption = 'Peer Support Group'
        ImageIndex = 2
        object lblPeerSupportGroups: TLabel
          Left = 15
          Top = 24
          Width = 112
          Height = 13
          Caption = 'Peer Support Group for'
        end
        object cboPeerSupportGroups: TComboBox
          Left = 131
          Top = 21
          Width = 250
          Height = 21
          Hint = 'Select a Peer Support Group.'
          ItemHeight = 13
          TabOrder = 0
          OnClick = RefreshStudentsInPeerSupportGroup
        end
        object lsvPeerSupportGroup: TListView
          Left = 15
          Top = 48
          Width = 555
          Height = 301
          Columns = <
            item
              Caption = 'Student'
              Width = 150
            end
            item
              Caption = 'ID'
              Width = 60
            end
            item
              Caption = 'Sex'
              Width = 37
            end
            item
              Caption = 'Year'
              Width = 60
            end
            item
              Caption = 'Roll Class'
              Width = 60
            end
            item
              Caption = 'Home Room'
              Width = 90
            end
            item
              Caption = 'Teacher'
              Width = 160
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 1
          ViewStyle = vsReport
        end
      end
    end
    object btnCancel: TBitBtn
      Left = 519
      Top = 390
      Width = 75
      Height = 25
      Hint = 'Exit from dialogue.'
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'C&lose'
      Default = True
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
  end
  object popHealthCond: TPopupMenu
    OnPopup = SetupMenu
    Left = 520
    Top = 112
    object popHealthCondMoreDetails: TMenuItem
      Caption = 'More Details'
      OnClick = DisplayMoreDetails
    end
    object PopHealtCondRemove: TMenuItem
      Caption = 'Remove'
      OnClick = RemoveStudentHealthCondition
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object popHCAddtoPeerSupportGroup: TMenuItem
      Caption = 'Add to Peer Support Group'
      OnClick = AddToPeerSupportGroup
    end
    object popHCRemovefromPeersupportGrooup: TMenuItem
      Caption = 'Remove from Peer support Group '
      OnClick = RemoveFromPeerSupportGroup
    end
  end
end
