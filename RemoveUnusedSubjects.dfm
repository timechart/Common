object FrmRemoveUnusedSubjects: TFrmRemoveUnusedSubjects
  Left = 0
  Top = 0
  HelpContext = 469
  Caption = 'Remove Unused Subjects'
  ClientHeight = 536
  ClientWidth = 448
  Color = clBtnFace
  Constraints.MinHeight = 160
  Constraints.MinWidth = 365
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lsvUnusedSubjects: TListView
    Left = 0
    Top = 41
    Width = 448
    Height = 397
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Code'
        Width = 110
      end
      item
        Caption = 'Name'
        Width = 310
      end>
    ReadOnly = True
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = SetupRemoveButton
    ExplicitHeight = 375
  end
  object pnlControls: TPanel
    Left = 0
    Top = 0
    Width = 448
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblPrompt: TLabel
      Left = 29
      Top = 8
      Width = 357
      Height = 26
      AutoSize = False
      Caption = 
        'To Keep any subject click on the checkbox next to the code to un' +
        'select it. Click Remove button to remove all the subjects.'
      WordWrap = True
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 438
    Width = 448
    Height = 98
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 416
    DesignSize = (
      448
      98)
    object lblUnusedSubjectCount: TLabel
      Left = 170
      Top = 72
      Width = 50
      Height = 13
      AutoSize = False
      Caption = 'Unused Subjects'
    end
    object lblUsedSubjectCount: TLabel
      Left = 170
      Top = 56
      Width = 50
      Height = 13
      AutoSize = False
      Caption = 'Used Subjects'
    end
    object lblTotalSubjectCount: TLabel
      Left = 170
      Top = 39
      Width = 50
      Height = 13
      AutoSize = False
      Caption = 'Subject Count'
    end
    object lblTotalSubjectCountCap: TLabel
      Left = 15
      Top = 39
      Width = 150
      Height = 13
      AutoSize = False
      Caption = 'Subjects Total:'
    end
    object lblUsedSubjectCountCap: TLabel
      Left = 15
      Top = 56
      Width = 150
      Height = 13
      AutoSize = False
      Caption = 'Subjects Used by the System:'
    end
    object lblUnusedSubjectCountCap: TLabel
      Left = 15
      Top = 72
      Width = 150
      Height = 13
      AutoSize = False
      Caption = 'Subjects ready to remove:'
    end
    object btnRemove: TButton
      Left = 283
      Top = 65
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Remove'
      ModalResult = 1
      TabOrder = 0
      OnClick = RemoveUnusedSubjects
    end
    object btnCancel: TButton
      Left = 364
      Top = 65
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object rgpSelectSubjects: TRadioGroup
      Left = 15
      Top = 0
      Width = 149
      Height = 35
      Caption = 'Select'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'All'
        'None')
      TabOrder = 2
      OnClick = SetSelectedSubjects
    end
  end
end
