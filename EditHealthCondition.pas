unit EditHealthCondition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, uAMGHealthCondition;

type
  TFrmEditHealthCondition = class(TForm)
    cboStudentHealthCondition: TComboBox;
    lblHealthCondition: TLabel;
    lblNote: TLabel;
    memStudentHealthNote: TMemo;
    btnSelectStudentHealthCondition: TBitBtn;
    btnCancel: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure UpdateStudentHealthCondition(Sender: TObject);
  private
    FHealthCondition: TAMGHealthCondition;
    FHealthNote: string;
    function RefreshHealthConditions: Boolean;
  public
    property HealthCondition: TAMGHealthCondition read FHealthCondition write FHealthCondition;
    property HealthNote: string read FHealthNote write FHealthNote;
  end;

var
  FrmEditHealthCondition: TFrmEditHealthCondition;

implementation

{$R *.dfm}

{ TForm1 }

procedure TFrmEditHealthCondition.FormShow(Sender: TObject);
begin
  RefreshHealthConditions;
end;

function TFrmEditHealthCondition.RefreshHealthConditions: Boolean;
var
  i: Integer;
begin
  for i := 0 to HealthConditions.Count -1 do
  begin
    cboStudentHealthCondition.AddItem(TAMGHealthCondition(HealthConditions.Items[i]).ConditionName, TAMGHealthCondition(HealthConditions.Items[i]));
  end;
  cboStudentHealthCondition.ItemIndex := 0;
end;

procedure TFrmEditHealthCondition.UpdateStudentHealthCondition(Sender: TObject);
begin
  FHealthCondition := TAMGHealthCondition.Create;
  FHealthCondition.Assign(TAMGHealthCondition(cboStudentHealthCondition.Items.Objects[cboStudentHealthCondition.ItemIndex]));
  FHealthNote := memStudentHealthNote.Text;
end;

end.
