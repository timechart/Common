unit uAMGItem;

interface

uses
  Contnrs, uAMGDBCoord;

type
  TAMGItem = class
  private
    FLastUpdatedDate: TDateTime;
    FCode: string;
    FID: Integer;
  protected
    FTableName: string;
    FPKName: string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Refresh: Boolean; virtual;
    function Save: Boolean; virtual;
    property ID: Integer read FID write FID;
    property Code: string read FCode write FCode;
    property LastUpdatedDate: TDateTime read FLastUpdatedDate write FLastUpdatedDate;
  end;

  TAMGItemList = class(TObjectList)
  private
    FSMSFileName: string;
    FDataFileName: string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Refresh: Boolean; virtual;
    function RefreshFromFile: Boolean; virtual;
    function ImportFromSMSFile: Boolean; virtual;
    function Save: Boolean; virtual;
    function IndexOf(const pCode: string): Integer;
    function GetIndexByID(const pID: Integer): Integer;

    property SMSFileName: string read FSMSFileName write FSMSFileName;
    property DataFileName: string read FDataFileName write FDataFileName;
  end;

implementation

uses
  SysUtils;

{ TAMGItem }

constructor TAMGItem.Create;
begin
  ID := -1;
end;

destructor TAMGItem.Destroy;
begin
  //Keep
end;

function TAMGItem.Refresh: Boolean;
begin
  Result := False;
end;

function TAMGItem.Save: Boolean;
begin
  Result := False;
end;

{ TAMGItemList }

constructor TAMGItemList.Create;
begin
  //Keep
end;

destructor TAMGItemList.Destroy;
begin
  //Keep
end;

function TAMGItemList.GetIndexByID(const pID: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if TAMGItem(Self.Items[i]).ID = pID then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGItemList.IndexOf(const pCode: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if UpperCase(TAMGItem(Self.Items[i]).Code) = UpperCase(Trim(pCode)) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGItemList.ImportFromSMSFile: Boolean;
begin
  Result := False;
end;

function TAMGItemList.Refresh: Boolean;
begin
  Result := False;
end;

function TAMGItemList.RefreshFromFile: Boolean;
begin
  Result := False;
end;

function TAMGItemList.Save: Boolean;
begin
  Result := False;
end;

end.
