unit uAMGTimeSlot;

interface

uses
  uAMGItem;

type
  //Time Slot objects
  TAMGTimeSlot = class(TAMGItem)
  private
    FSlotName: string;
    FAllotment: Double;
    FTSStart: TDateTime;
    FTSEnd: TDateTime;
    FDayGroupID: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property SlotName: string read FSlotName write FSlotName;
    property Allotment: Double read FAllotment write FAllotment;
    property TSStart: TDateTime read FTSStart write FTSStart;
    property TSEnd: TDateTime read FTSEnd write FTSEnd;
    property DayGroupID: Integer read FDayGroupID write FDayGroupID;
  end;

  TAMGTimeSlots = class(TAMGItemList)
  public
    function Refresh: Boolean; override;
    function RefreshFromFile: Boolean; override;
    function Save: Boolean; override;
    function SaveToFile: Boolean;
  end;

  //Time Slot objects
  TAMGAllotmentUnit = class(TAMGItem)
  private
    FAllotmentDesc: string;
    FAllotmentName: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Refresh: Boolean; override;
    function Save: Boolean; override;
    property AllotmentName: string read FAllotmentName write FAllotmentName;
    property AllotmentDesc: string read FAllotmentDesc write FAllotmentDesc;
  end;

var
  TimeSlots: TAMGTimeSlots;
  AllotmentUnit: TAMGAllotmentUnit;

implementation

uses
  uAMGDBCoord, SysUtils;

{ TAMGTimeSlot }

constructor TAMGTimeSlot.Create;
begin
  inherited;
  FTableName := 'TimeSlot';
  FPKName := 'TimeSlotID';
end;

destructor TAMGTimeSlot.Destroy;
begin
  inherited;
end;

function TAMGTimeSlot.Refresh: Boolean;
begin
  inherited Refresh;
end;

function TAMGTimeSlot.Save: Boolean;
begin
  inherited Save;
  if DBCoord.AlreadyExists(FtableName, 'TimeSlotName', FSlotName)  then
  begin
    DBCoord.qryMain.SQL.Text := Format('update TimeSlot set TimeSlotName = %s, TimeSlotCode = %s, TimeSlotAllotment = %f, StartTime = %f, EndTime = %f, DayGroupID = %d where TimeSlotID = %d',
                                       [QuotedStr(FSlotName),
                                        QuotedStr(Code),
                                        FAllotment,
                                        FTSStart,
                                        FTSEnd,
                                        DayGroupID,
                                        ID]);
  end
  else
  begin
    ID := DBCoord.GetNextID(FTableName, FPKName);
    DBCoord.qryMain.SQL.Text := Format('insert into TimeSlot(TimeSlotID, TimeSlotName, TimeSlotCode, TimeSlotAllotment, StartTime, EndTime, DayGroupID) values(%d, %s, %s, %f, %f, %f, %d)',
                                       [ID,
                                        QuotedStr(FSlotName),
                                        QuotedStr(Code),
                                        FAllotment,
                                        FTSStart,
                                        FTSEnd,
                                        DayGroupID]);
  end;
  DBCoord.qryMain.ExecSQL;
  Result := True;
end;

{ TAMGTimeSlots }

function TAMGTimeSlots.Refresh: Boolean;
begin
  inherited Refresh;
end;

function TAMGTimeSlots.RefreshFromFile: Boolean;
begin
  inherited RefreshFromFile;
end;

function TAMGTimeSlots.Save: Boolean;
var
  i: Integer;
begin
  inherited Save;
  for i := 0 to Self.Count - 1 do
    TAMGTimeSlot(Self.Items[i]).Save;
  AllotmentUnit.Save;
  Result := True;
end;

function TAMGTimeSlots.SaveToFile: Boolean;
begin
  //ToDo
end;

{ TAMGAllotmentUnit }

constructor TAMGAllotmentUnit.Create;
begin
  inherited;
  //code
end;

destructor TAMGAllotmentUnit.Destroy;
begin
  //code
  inherited;
end;

function TAMGAllotmentUnit.Refresh: Boolean;
begin
  //code
end;

function TAMGAllotmentUnit.Save: Boolean;
begin
  inherited Save;
  DBCoord.qryMain.SQL.Text := Format('update Allotment set AllotmentID = %d, AllotmentName = %s, AllotmentDescription = %s',
                                     [ID,
                                      QuotedStr(FAllotmentName),
                                      QuotedStr(FAllotmentDesc)]);
  DBCoord.qryMain.ExecSQL;
  Result := True;
end;

end.
