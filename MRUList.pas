unit MRUList;

interface

uses
  Classes;

type
  TMRUList = class(TObject)
  private
    FItems: TStringList;
    FMaxItems: Cardinal;
    procedure SetMaxItems(const Value: Cardinal);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddItem(const pItem: string);
    function RemoveItem(const pItem: string): Boolean;
    function RefreshFromFile: Boolean;
    function SaveToFile: Boolean;

    property Items: TStringList read FItems write FItems;
    property MaxItems: Cardinal read FMaxItems write SetMaxItems default 5;
  end;

var
  FMRU: TMRUList;

implementation

uses
  uAMGConst, DCPrijndael, DCPSha1, SysUtils, uAMGCommon;

{ TMRUList }

procedure TMRUList.AddItem(const pItem: string);
begin
  if pItem <> '' then
  begin
    FItems.BeginUpdate;
    try
      if FItems.IndexOf(pItem) > -1 then
        FItems.Delete(FItems.IndexOf(pItem));
      FItems.Insert(0, pItem);

      while FItems.Count > MaxItems do
        FItems.Delete(MaxItems);
    finally
      FItems.EndUpdate;
      Self.SaveToFile;
    end;
  end;
end;

constructor TMRUList.Create;
begin
  inherited;
  FItems := TStringList.Create;
  FMaxItems := 5;
end;

destructor TMRUList.Destroy;
begin
  FItems.Free;
  inherited;
end;

function TMRUList.RefreshFromFile: Boolean;
var
  i: Integer;
  lTempStr: string;
  Cipher: TDCP_Rijndael;
  lDirList: TStringList;
begin
  Result := False;
  Self.FItems.Clear;
  if FileExists(AMG_DATADIR_LIST) then
  begin
    lDirList := TStringList.Create;
    Cipher:= TDCP_Rijndael.Create(nil);
    try
      lDirList.LoadFromFile(AMG_DATADIR_LIST);
      //decrypt string
      Cipher.InitStr(KeyStrRt, TDCP_sha1);   // initialize the cipher with a hash of the passphrase
      lDirList.Text := Cipher.DecryptString(lDirList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lDirList.Count - 1 do
      begin
        lTempStr := GetSubStr(lDirList.Strings[i], 1);
        Self.FItems.Add(lTempStr);
      end;
    finally
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
      if Assigned(lDirList) then
        FreeAndNil(lDirList);
    end;
    Result := True;
  end; // if
end;

function TMRUList.RemoveItem(const pItem: string): Boolean;
begin
  if FItems.IndexOf(pItem) > -1 then
  begin
    FItems.Delete(FItems.IndexOf(pItem));
    Result := True;
  end
  else
    Result := False;
end;

function TMRUList.SaveToFile: Boolean;
var
  lDirList: TStringList;
  i: Integer;
  Cipher: TDCP_Rijndael;
begin
  if Self.FItems.Count > 0 then
  begin
    lDirList := TStringList.Create;
    try
      Cipher := TDCP_Rijndael.Create(nil);
      try
        for i := 0 to Self.FItems.Count - 1 do
          lDirList.Add(Self.FItems.Strings[i]);

        {encrypt}
        Cipher.InitStr(KeyStrRt, TDCP_sha1);
        lDirList.Text := Cipher.EncryptString(lDirList.Text);
        Cipher.Burn;
        lDirList.SaveToFile(AMG_DATADIR_LIST);
      finally
        FreeAndNil(Cipher);
      end;
    finally
      FreeAndNil(lDirList);
    end;
    Result := True;
  end;
end;

procedure TMRUList.SetMaxItems(const Value: Cardinal);
begin
  if Value <> FMaxItems then
  begin
    if Value < 1 then
      FMaxItems := 1
    else
      if Value > MaxInt then
        FMaxItems := MaxInt - 1
      else
      begin
        FMaxItems := Value;
        FItems.BeginUpdate;
        try
          while FItems.Count > MaxItems do
            FItems.Delete(FItems.Count - 1);
        finally
          FItems.EndUpdate;
        end;
      end;
  end;
end;

end.
