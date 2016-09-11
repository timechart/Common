unit CreateHealthCondition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrmAddHealthCondition = class(TForm)
    btnAddHealthCondition: TBitBtn;
    btnClose: TBitBtn;
    lblHealthConditionName: TLabel;
    lblHealthConditionDescription: TLabel;
    lblHealthConditionWebLink: TLabel;
    edtHealthConditionName: TEdit;
    lblWhereToFindInfo: TLabel;
    memHealthConditionDescription: TMemo;
    edtHealthConditionWebLink: TEdit;
    lblBetterHealthURL: TLabel;
    procedure LinkToWebPage(Sender: TObject);
    procedure AddHealthCondition(Sender: TObject);
  private
    function ValidateData: Boolean;
  end;

var
  FrmAddHealthCondition: TFrmAddHealthCondition;

implementation

uses
  ShellAPI, uAMGHealthCondition, uAMGConst;

{$R *.dfm}

procedure TFrmAddHealthCondition.AddHealthCondition(Sender: TObject);
var
  lHealthCondition: TAMGHealthCondition;
begin
  if ValidateData then
  begin
    lHealthCondition := TAMGHealthCondition.Create;
    lHealthCondition.ConditionName := Trim(edtHealthConditionName.Text);
    lHealthCondition.ConditionDescription := Trim(memHealthConditionDescription.Text);
    lHealthCondition.ConditionWebURL := Trim(edtHealthConditionWebLink.Text);
    lHealthCondition.IsUserAdded := True;
    lHealthCondition.Code := lHealthCondition.GetHealthConditionCode;
    if HealthConditions.IndexOf(lHealthCondition.Code) = -1 then
    begin
      HealthConditions.Add(lHealthCondition);
      HealthConditions.SaveToFile;
      Self.ModalResult := mrOK;
    end
    else
    begin
      MessageDlg('Health Condition ' + lHealthCondition.ConditionName + ' already exists.', mtInformation, [mbOK], 0);
      Self.ModalResult := mrNone;
      FreeAndNil(lHealthCondition);
    end;
  end
  else
  begin
    Self.ModalResult := mrNone;
  end;
end;

procedure TFrmAddHealthCondition.LinkToWebPage(Sender: TObject);
begin
  ShellExecute(Handle, nil, PChar(lblBetterHealthURL.Caption), nil, nil, SW_SHOWNORMAL);
  Application.ProcessMessages;
end;

function TFrmAddHealthCondition.ValidateData: Boolean;
begin
  Result := True;
  if Trim(edtHealthConditionName.Text) = '' then
  begin
    MessageDlg(AMG_CONDITION_NAME_NOT_PROVIDED, mtError, [mbOK], 0);
    Result := False;
  end;
  if Pos('WWW.', UpperCase(edtHealthConditionWebLink.Text)) = 0 then
  begin
    MessageDlg(AMG_INVALID_WEB_LINK, mtError, [mbOK], 0);
    Result := False;
  end
end;

end.
