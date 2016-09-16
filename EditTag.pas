unit EditTag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TFrmEditTag = class(TForm)
    btnEditTagSave: TBitBtn;
    btnEdiTTagClose: TBitBtn;
    lblTagCode: TLabel;
    lblTagName: TLabel;
    lblTagOrder: TLabel;
    edtTagName: TEdit;
    edtTagOrder: TEdit;
    chkTagUsed: TCheckBox;
    updTagCode: TUpDown;
    cboTagCode: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure RefreshTagDetails(Sender: TObject);
    procedure GoNextPrevious(Sender: TObject; Button: TUDBtnType);
    procedure SaveTagName(Sender: TObject);
  private
    FSelectedTag: Integer;
    FIsChanged: Boolean;
    procedure LoadTags;
  public
    property SelectedTag: Integer read FSelectedTag write FSelectedTag;
    property IsChanged: Boolean read FIsChanged write FIsChanged;
  end;

var
  FrmEditTag: TFrmEditTag;

implementation

uses
  TimeChartGlobals, uAMGStudent;

{$R *.dfm}

procedure TFrmEditTag.FormShow(Sender: TObject);
begin
  edtTagName.MaxLength := szTagname;
  updTagCode.Increment := 1;
  LoadTags;
  cboTagCode.ItemIndex := SelectedTag -1;
  RefreshTagDetails(Self);
  edtTagName.Color := clRelevantControlOnDlg
end;

procedure TFrmEditTag.GoNextPrevious(Sender: TObject; Button: TUDBtnType);
begin
  cboTagCode.ItemIndex := updTagCode.Position;
  RefreshTagDetails(Self);
end;

procedure TFrmEditTag.LoadTags;
var
  i: Integer;
  lTag: TAMGTag;
begin
  for i := 0 to Tags.Count - 1 do
  begin
    lTag := TAMGTag(Tags.Items[i]);
    cboTagCode.AddItem(lTag.Code, lTag);
  end;
end;

procedure TFrmEditTag.RefreshTagDetails(Sender: TObject);
var
  lTag: TAMGTag;
begin
  if cboTagCode.ItemIndex >= 0 then
  begin
    lTag := TAMGTag(cboTagCode.Items.Objects[cboTagCode.ItemIndex]);
    edtTagName.Text := lTag.TagName;
    chkTagUsed.Checked := lTag.IsUsed;
    edtTagOrder.Text := IntToStr(lTag.TagOrder);
  end
  else
  begin
    edtTagName.Text := '';
    chkTagUsed.Checked := False;
    edtTagOrder.Text := '';
  end;
end;

procedure TFrmEditTag.SaveTagName(Sender: TObject);
var
  lTag: TAMGTag;
begin
  lTag := TAMGTag(cboTagCode.Items.Objects[cboTagCode.ItemIndex]);
  lTag.TagName := Trim(edtTagName.Text);
  TagName[cboTagCode.ItemIndex + 1] := lTag.TagName;
  FIsChanged := True;
end;

end.
