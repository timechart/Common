unit uAMGHouse;

interface

uses
  uAMGItem;

type
  //House objects
  TAMGHouse = class(TAMGItem)
  private
    FHouseDescription: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property HouseDescription: string read FHouseDescription write FHouseDescription;
  end;

  TAMGHouses = class(TAMGItemList)
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
  Houses: TAMGHouses;

implementation

uses
  uAMGDBCoord, SysUtils;

{ TAMGHouse }

constructor TAMGHouse.Create;
begin
  inherited;
  FTableName := 'House';
  FPKName := 'HouseID';
end;

destructor TAMGHouse.Destroy;
begin

  inherited;
end;

function TAMGHouse.Refresh: Boolean;
begin
  inherited Refresh;
end;

function TAMGHouse.Save: Boolean;
begin
  inherited Save;
  if FHouseDescription = '' then
    FHouseDescription := Code;

  if not DBCoord.AlreadyExists(FtableName, 'HouseCode', Code)  then
  begin
    ID := DBCoord.GetNextID(FTableName, FPKName);
    DBCoord.qryMain.SQL.Text := Format('insert into House (HouseID, HouseCode, HouseDescription) values(%d, %s, %s)', [ID, QuotedStr(Code), QuotedStr(HouseDescription)]);
  end;
  DBCoord.qryMain.ExecSQL;
  Result := True;
end;

{ TAMGHouses }

function TAMGHouses.Refresh: Boolean;
begin
  inherited Refresh;
end;

function TAMGHouses.RefreshFromFile: Boolean;
begin
  inherited RefreshFromFile;
end;

function TAMGHouses.Save: Boolean;
var
  i: Integer;
begin
  inherited Save;
  for i := 0 to Self.Count - 1 do
    TAMGHouse(Self.Items[i]).Save;
  Result := True;
end;

function TAMGHouses.SaveToFile: Boolean;
begin
  //ToDo
end;

procedure TAMGHouses.SetCodeLength(const Value: Integer);
begin
  DBCoord.qrySub.SQL.Text := Format('update Code set CodeLength = %d where CodeName = ''House''', [Value]);
  try
    DBCoord.qrySub.ExecSQL;
  finally
    DBCoord.qrySub.Close;
  end;
  FCodeLength := Value;
end;

end.
