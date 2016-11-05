unit SearchBlocks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, XML.DISPLAY;

type
  TFrmSearchBlocks = class(TForm)
    btnFind: TBitBtn;
    btnClose: TBitBtn;
    lblFindCriterion: TLabel;
    edtFindCriterion: TEdit;
    procedure DoFindNext(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetupCursor(Sender: TObject);
  private
    FNextBlock: Integer;
    FNextLevel: Integer;
  end;

var
  FrmSearchBlocks: TFrmSearchBlocks;

implementation

uses
  TimeChartGlobals, Block1;

{$R *.dfm}

procedure TFrmSearchBlocks.DoFindNext(Sender: TObject);
var
  lBlkIdx: Integer;
  lLvlIdx: Integer;
  lSub: Integer;
  lFound: Boolean;
begin
  lFound := False;
  for lBlkIdx := FNextBlock to XML_DISPLAY.blocknum do
  begin
    for lLvlIdx := FNextLevel to Sheet[lBlkIdx, 0] do
    begin
      lSub := Sheet[lBlkIdx, lLvlIdx];
      if Pos(UpperCase(edtFindCriterion.Text), UpperCase(SubCode[lSub])) > 0 then
      begin
        Blockwin.StringGrid1.Col := lBlkIdx -1;
        Blockwin.StringGrid1.Row := lLvlIdx;
        FNextBlock := lBlkIdx;
        FNextLevel := lLvlIdx + 1;
        lFound := True;
        Break;
      end;
    end;
    if lLvlIdx >= Sheet[lBlkIdx, 0] then
    begin
      Inc(FNextBlock);  //We reached the end of the Block now go next
      FNextLevel := 1;
    end;

    if lFound then
    begin
      Exit;
    end;
  end;
  MessageDlg('Time Chart has finished searching the blocks.', mtInformation, [mbOK], 0);
  btnFind.Enabled := False;
end;

procedure TFrmSearchBlocks.FormCreate(Sender: TObject);
begin
  SetupCursor(Self);
end;

procedure TFrmSearchBlocks.SetupCursor(Sender: TObject);
begin
  FNextBlock := 1;
  FNextLevel := 1;
  btnFind.Enabled := True;
end;

end.
