unit uAMGCalendar;

interface

uses
  Classes, Contnrs;

type

  TAMGSADays = class;

  TAMGCalendar = class(TObject)
  private
    FDays: TAMGSADays;
    FSAYear: Integer;
  public
    constructor Create;
    destructor Destroy;
    function ValidDayNumber(y, m, d: Integer): Boolean;
    procedure SetTypeOfDay(const pDate: TDateTime; const pType: Integer);

    property SAYear: Integer read FSAYear write FSAYear;
    property Days: TAMGSADays read FDays write FDays;
  end;

  TAMGSADay = class
  private
    FSAMonthDay: Integer;
    FSAMonth: Integer;
    FDayType: Integer;
    FSACalYear: Integer;
  public
    property SAMonthDay: Integer read FSAMonthDay write FSAMonthDay;
    property SAMonth: Integer read FSAMonth write FSAMonth;
    property SACalYear: Integer read FSACalYear write FSACalYear;
    property DayType: Integer read FDayType write FDayType;
  end;

  TAMGSADays = class(TObjectList)
  public
    function GetDayType(const pDate: TDateTime): Integer;
    function GetDayTypeDescription(const pDate: TDateTime): string;
    function GetDayIndex(const pDate: TDateTime): Integer;
    function RefreshFromFile: Boolean;
    function SaveToFile: Boolean;
  end;

var
  saDaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  Calendar: TAMGCalendar;

implementation

uses
  SysUtils, DateUtils, DCPrijndael, DCPSha1, uAMGConst, uAMGCommon;

{ TAMGCalendar }

constructor TAMGCalendar.Create;
var
  m,d: smallint;
  PanelDate: TDateTime;
  lDay: TAMGSADay;
begin
  FDays := TAMGSADays.Create;
  SAYear := YearOf(Now);
  for m:=1 to 12 do
    for d:=1 to 31 do
    begin
      //   if d>saDaysInMonth(m) then continue;
      if ValidDayNumber(SAYear, m, d) then
      begin
        PanelDate := EncodeDate(SAYear, m, d);
        lDay := TAMGSADay.Create;
        lDay.FSACalYear := SAYear;
        lDay.SAMonth := m;
        lDay.SAMonthDay := d;
        case DayOfWeek(PanelDate) of
          1,7: lDay.DayType := 3;  //mark weekends as holidays initially
          else lDay.DayType := 1;
        end;
        Days.Add(lDay);
      end;
    end;
end;

destructor TAMGCalendar.Destroy;
begin
  if Assigned(FDays) then
    FreeAndNil(FDays);
end;

procedure TAMGCalendar.SetTypeOfDay(const pDate: TDateTime; const pType: Integer);
var
  i: Integer;
  lDay: TAMGSADay;
begin
  for i := 0 to Self.FDays.Count - 1 do
  begin
    lDay := TAMGSADay(Self.FDays.Items[i]);
    if (lDay.FSAMonthDay = DayOf(pDate)) and (lDay.FSAMonth = MonthOf(pDate)) and (lDay.FSACalYear = YearOf(pDate)) then
    begin
      lDay.FDayType := pType;
    end;
  end;
  Self.Days.SaveToFile;
end;

function TAMGCalendar.ValidDayNumber(y, m, d: Integer): Boolean;
var
  lIsOk: Boolean;
begin
  lIsOk := False;
  if d <= saDaysInMonth[m] then
    lIsOk := true;
  if (IsLeapYear(y) and (m=2) and (d=29)) then
    lIsOk := True;
  Result := lIsOk;
end;


{ TAMGSADays }

function TAMGSADays.GetDayIndex(const pDate: TDateTime): Integer;
var
  i: Integer;
  lDay: TAMGSADay;
begin
  for i := 0 to Self.Count -1 do
  begin
    lDay := TAMGSADay(Self.Items[i]);
    if (lDay.FSAMonthDay = DayOf(pDate)) and (lDay.FSAMonth = MonthOf(pDate)) and (lDay.FSACalYear = YearOf(pDate)) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TAMGSADays.GetDayType(const pDate: TDateTime): Integer;
var
  i: Integer;
  lDay: TAMGSADay;
begin
  for i := 0 to Self.Count -1 do
  begin
    lDay := TAMGSADay(Self.Items[i]);
    if (lDay.FSAMonthDay = DayOf(pDate)) and (lDay.FSAMonth = MonthOf(pDate)) and (lDay.FSACalYear = YearOf(pDate)) then
    begin
      Result := lDay.FDayType;
      Break;
    end;
  end;
end;

function TAMGSADays.GetDayTypeDescription(const pDate: TDateTime): string;
var
  i: Integer;
  lDayType: Integer;
  lDay: TAMGSADay;
begin
  Result := '';
  lDayType := Self.GetDayType(pDate);

  case lDayType of
    1: Result := 'Normal School Day';
    2: Result := 'School Holiday';
    3: Result := 'Public Holiday';
    4: Result := 'Excursion';
    5: Result := 'Curriculum Day';
    6: Result := 'Student-Free Day';
  end;
end;

function TAMGSADays.RefreshFromFile: Boolean;
var
  lList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lID: string;
  lYear: Integer;
  lMonth: Integer;
  lDay: Integer;
  lDateTime: TDatetime;
  lDayIndex: Integer;
begin
  Result := False;
  if FileExists(AMIG_ATTEND_CAL_FILE) then
  begin
    lList := TStringList.Create;
    Cipher := TDCP_Rijndael.Create(nil);
    try
      lList.LoadFromFile(AMIG_ATTEND_CAL_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt, TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lList.Text := Cipher.DecryptString(lList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lList.Count - 1 do
      begin
        lYear := StrToInt(Trim(GetSubStr(lList.Strings[i], 1)));
        lMonth := StrToInt(Trim(GetSubStr(lList.Strings[i], 2)));
        lDay := StrToInt(Trim(GetSubStr(lList.Strings[i], 3)));

            lDateTime := EncodeDateTime(lYear, lMonth, lDay, 0, 0, 0, 0);
        lDayIndex := Self.GetDayIndex(lDateTime);
        TAMGSADay(Self.Items[lDayIndex]).FDayType := StrToInt(Trim(GetSubStr(lList.Strings[i], 4)));
      end;
    finally
      if Assigned(lList) then
        FreeAndNil(lList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
      Result := True;
    end;
  end;
end;

function TAMGSADays.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lSADay: TAMGSADay;
begin
  lTempList := TStringList.Create;
  Cipher:= TDCP_Rijndael.Create(nil);
  try
    for i := 0 to Self.Count -1 do
    begin
      lSADay := TAMGSADay(Self.Items[i]);
      lTempList.Add(IntToStr(lSADay.FSACalYear) + ',' +
                    IntToStr(lSADay.FSAMonth) + ',' +
                    IntToStr(lSADay.FSAMonthDay) + ',' +
                    IntToStr(lSADay.FDayType));
    end;
    {encrypt}
    Cipher.InitStr(KeyStrRt, TDCP_sha1);         // initialize the cipher with a hash of the passphrase
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMIG_ATTEND_CAL_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

end.
