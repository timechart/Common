object FrmCASES21ImportOptions: TFrmCASES21ImportOptions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CASES21 (Maze) Import Options'
  ClientHeight = 229
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    272
    229)
  PixelsPerInch = 96
  TextHeight = 13
  object lblPrompot: TLabel
    Left = 15
    Top = 16
    Width = 191
    Height = 13
    Caption = 'Include the following data in the import:'
  end
  object lblPrompt: TLabel
    Left = 15
    Top = 148
    Width = 249
    Height = 28
    AutoSize = False
    Caption = 
      'Note: Make sure the lengths of the codes are long enough to acco' +
      'mmodate the new codes.'
    WordWrap = True
  end
  object btnImport: TButton
    Left = 112
    Top = 194
    Width = 72
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Import'
    ModalResult = 1
    TabOrder = 0
    OnClick = SetupImportOptions
    ExplicitTop = 166
  end
  object lblCancel: TButton
    Left = 191
    Top = 194
    Width = 72
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    ExplicitTop = 166
  end
  object chkStudentData: TCheckBox
    Left = 55
    Top = 42
    Width = 80
    Height = 17
    BiDiMode = bdRightToLeft
    Caption = 'Student'
    Checked = True
    ParentBiDiMode = False
    State = cbChecked
    TabOrder = 2
  end
  object chkTeacherData: TCheckBox
    Left = 55
    Top = 69
    Width = 80
    Height = 17
    BiDiMode = bdRightToLeft
    Caption = 'Teacher'
    Checked = True
    ParentBiDiMode = False
    State = cbChecked
    TabOrder = 3
  end
  object chkStubjectData: TCheckBox
    Left = 55
    Top = 96
    Width = 80
    Height = 17
    BiDiMode = bdRightToLeft
    Caption = 'Subject'
    Checked = True
    ParentBiDiMode = False
    State = cbChecked
    TabOrder = 4
  end
  object chkRoomData: TCheckBox
    Left = 55
    Top = 123
    Width = 80
    Height = 17
    BiDiMode = bdRightToLeft
    Caption = 'Room'
    Checked = True
    ParentBiDiMode = False
    State = cbChecked
    TabOrder = 5
  end
end
