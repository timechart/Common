unit uAMGDBCoord;

interface

uses
  ADODB;

type
  TDBCoord = class(TObject)
  private
    FqryMain: TADOQuery;
    FqrySub: TADOQuery;
  public
    constructor Create;
    function GetNextID(const pTableName, pFieldName: string): Integer;
    function AlreadyExists(const pTableName, pFieldName, pValue: string): Boolean;
    property qryMain: TADOQuery read FqryMain write FqryMain;
    property qrySub: TADOQuery read FqrySub write FqrySub;
  end;

var
  DBCoord: TDBCoord;

implementation

{$IFDEF TC6NET}
uses
  dmTC;
{$ENDIF}

{ TDBCoord }

function TDBCoord.AlreadyExists(const pTableName, pFieldName, pValue: string): Boolean;
begin
  Result := False;
  qrySub.SQL.Text := 'select * from ' + pTableName  + ' where ' + pFieldName + ' = ''' + pValue + '''';
  qrySub.Open;
  Result := qrySub.RecordCount > 0;
  qrySub.Close;
end;

constructor TDBCoord.Create;
begin
end;

function TDBCoord.GetNextID(const pTableName, pFieldName: string): Integer;
begin
{$IFDEF TC}
  Result := -1;
  DM.qrySub.SQL.Text := 'select top 1 ' + pFieldName + ' as NextID from ' + pTableName + ' order by ' + pFieldName + ' desc';
  DM.qrySub.Open;
  if DM.qrySub.RecordCount > 0 then
    Result := DM.qrySub.FieldByName('NextID').AsInteger + 1
 else
    Result := 1;
{$ENDIF}
end;

end.
