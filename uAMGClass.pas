unit uAMGClass;

interface

uses
  uAMGItem;

type
  TAMGClass = class(TAMGItem)
  private
    FClassName: string;
    FClassDescription: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property ClassName: string read FClassName write FClassName;
    property ClassDescription: string read FClassDescription write FClassDescription;
  end;

  TAMGClasses = class(TAMGItemList)
  private
    FCodeLength: Integer;
    procedure SetCodeLength(const Value: Integer);
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function Save: Boolean; override;
    function SaveToFile: Boolean;
    property CodeLength: Integer read FCodeLength write SetCodeLength;
  end;

var
  TCClasses: TAMGClasses;

implementation

uses
  SysUtils, uAMGDBCoord, uAMGConst;

{ TAMGClass }

constructor TAMGClass.Create;
begin
  inherited;
  FTableName := 'Class';
  FPKName := 'ClassID';
end;

destructor TAMGClass.Destroy;
begin
  //code
  inherited;
end;

function TAMGClass.Refresh: Boolean;
begin
  //code
end;

function TAMGClass.Save: Boolean;
begin
  inherited Save;
  if ClassName = '' then
    ClassName := AMG_CLASS_ROOM + ' ' + Code;

  if DBCoord.AlreadyExists(FtableName, 'ClassCode', Code)  then
  begin
    DBCoord.qryMain.SQL.Text := Format('update Class set ClassName = %s, ClassDescription = %s where ClassCode = %s', [QuotedStr(FClassName), QuotedStr(FClassDescription), QuotedStr(Code)]);
  end
  else
  begin
    ID := DBCoord.GetNextID(FTableName, FPKName);
    DBCoord.qryMain.SQL.Text := Format('insert into Class (ClassID, ClassCode, ClassName, ClassDescription) values(%d, %s, %s, %s)', [ID, QuotedStr(Code), QuotedStr(FClassName), QuotedStr(FClassDescription)]);
  end;
  DBCoord.qryMain.ExecSQL;
  Result := True;
end;

{ TAMGClasses }

function TAMGClasses.Refresh: Boolean;
begin
  //code
end;

function TAMGClasses.RefreshFromFile: Boolean;
begin
  //code
end;

function TAMGClasses.Save: Boolean;
var
  i: Integer;
begin
  inherited Save;
  for i := 0 to Self.Count - 1 do
    TAMGClass(Self.Items[i]).Save;
  Result := True;
end;

function TAMGClasses.SaveToFile: Boolean;
begin
  //code
end;

procedure TAMGClasses.SetCodeLength(const Value: Integer);
begin
  DBCoord.qrySub.SQL.Text := Format('update Code set CodeLength = %d where CodeName = ''Class''', [Value]);
  try
    DBCoord.qrySub.ExecSQL;
  finally
    DBCoord.qrySub.Close;
  end;
  FCodeLength := Value;
end;

end.
