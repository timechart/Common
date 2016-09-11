unit uAMGComment;

interface

uses
  uAMGItem, Classes;

type
  //Comment objects
  TAMGComment = class(TAMGItem)
  private
    FDescription: string;
    FShortcut: string;
  public
    property Shortcut: string read FShortcut write FShortcut;
    property Description: string read FDescription write FDescription;
  end;

  TAMGComments = class(TAMGItemList)
  public
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
  end;

  //Subject Comment objects
  TAMGSubjectComment = class(TAMGItem)
  private
    FStudentCode: string;
    FSubjectCode: string;
    FCommentText: string;
    FCommentCount: Integer;
  public
    property StudentCode: string read FStudentCode write FStudentCode;
    property SubjectCode: string read FSubjectCode write FSubjectCode;
    property CommentText: string read FCommentText write FCommentText;
    property CommentCount: Integer read FCommentCount write FCommentCount;
  end;

  TAMGSubjectComments = class(TAMGItemList)
  public
    function RefreshFromFile: Boolean; override;
    function SaveToFile: Boolean;
  end;

var
  Comments: TAMGComments;
  SubjectComments: TAMGSubjectComments;

implementation

uses
  DCPrijndael, DCPSha1, uAMGConst, SysUtils, uAMGGlobal, uAMGCommon;

{ TAMGComments }

function TAMGComments.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lComment: TAMGComment;
begin
  inherited RefreshFromFile;
  Result := False;
  Self.Clear;
  if FileExists(AMG_COMMENT_FILE) then
  begin
    lTempList := TStringList.Create;
    Cipher := TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(AMG_COMMENT_FILE);
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lComment := TAMGComment.Create;
        lComment.Code := GetSubStr(lTempList.Strings[i], 1, AMG_PIPE);
        lComment.FDescription := GetSubStr(lTempList.Strings[i], 2, AMG_PIPE);
        lComment.FShortcut := GetSubStr(lTempList.Strings[i], 3, AMG_PIPE);
        Self.Add(lComment);
      end;
    finally
      if Assigned(lTempList) then
        FreeAndNil(lTempList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end;
  Result := True;
end;

function TAMGComments.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lComment: TAMGComment;
  lDir: string;
begin
  lTempList := TStringList.Create;
  Cipher := TDCP_Rijndael.Create(nil);
  lDir := GetCurrentDir;
  try
    ChDir(DataDir);
    for i := 0 to Self.Count -1 do
    begin
      lComment := TAMGComment(Self.Items[i]);
      lTempList.Add(lComment.Code + AMG_PIPE + lComment.FDescription + AMG_PIPE + lComment.FShortcut);
    end;
    //encrypt
    Cipher.InitStr(KeyStrRt, TDCP_sha1);
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(AMG_COMMENT_FILE);
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
    SetCurrentDir(lDir);
  end;
end;

{ TAMGSubjectComments }

function TAMGSubjectComments.RefreshFromFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lSubjectComment: TAMGSubjectComment;
begin
  inherited RefreshFromFile;
  Result := False;
  Self.Clear;
  if FileExists(RWFile + '.SBC') then
  begin
    lTempList := TStringList.Create;
    Cipher := TDCP_Rijndael.Create(nil);
    try
      lTempList.LoadFromFile(RWFile + '.SBC');
      //decrypt string
      Cipher.InitStr(KeyStrRt,TDCP_sha1);
      lTempList.Text := Cipher.DecryptString(lTempList.Text);
      Cipher.Burn;
      //retrieve strings
      for i := 0 to lTempList.Count - 1 do
      begin
        lSubjectComment := TAMGSubjectComment.Create;
        lSubjectComment.FStudentCode := GetSubStr(lTempList.Strings[i], 1, AMG_PIPE);
        lSubjectComment.FSubjectCode := GetSubStr(lTempList.Strings[i], 2, AMG_PIPE);
        lSubjectComment.FCommentText := GetSubStr(lTempList.Strings[i], 3, AMG_PIPE);
        lSubjectComment.FCommentCount := StrToInt(GetSubStr(lTempList.Strings[i], 4, AMG_PIPE));
        Self.Add(lSubjectComment);
      end;
    finally
      if Assigned(lTempList) then
        FreeAndNil(lTempList);
      if Assigned(Cipher) then
        FreeAndNil(Cipher);
    end;
  end;
  Result := True;
end;

function TAMGSubjectComments.SaveToFile: Boolean;
var
  lTempList: TStringList;
  Cipher: TDCP_Rijndael;
  i: Integer;
  lSubjectComment: TAMGSubjectComment;
begin
  lTempList := TStringList.Create;
  Cipher := TDCP_Rijndael.Create(nil);
  try
    ChDir(DataDir);
    for i := 0 to Self.Count -1 do
    begin
      lSubjectComment := TAMGSubjectComment(Self.Items[i]);
      lTempList.Add(lSubjectComment.FStudentCode + AMG_PIPE + lSubjectComment.FSubjectCode + AMG_PIPE + lSubjectComment.FCommentText + IntToStr(lSubjectComment.FCommentCount));
    end;
    //encrypt
    Cipher.InitStr(KeyStrRt, TDCP_sha1);
    lTempList.Text := Cipher.EncryptString(lTempList.Text);
    Cipher.Burn;
    lTempList.SaveToFile(RWFile + '.SBC');
  finally
    if Assigned(Cipher) then
      FreeAndNil(Cipher);
    if Assigned(lTempList) then
      FreeAndNil(lTempList);
  end;
end;

end.
