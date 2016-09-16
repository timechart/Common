unit CopyTT;

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, TabNotBk, Dialogs, ComCtrls, TimeChartGlobals;

type
   TFrmCopyTT = class(TForm)
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblSubjects: TLabel;
    Edit2: TEdit;
    edtTimeSlot: TEdit;
    btnClose: TBitBtn;
    CopyBtn: TBitBtn;
    ClearBtn: TBitBtn;
    ComboBox1: TComboBox;
    lblTeachers: TLabel;
    lblRooms: TLabel;
    ComboBox2: TComboBox;
    Style1: TTabbedNotebook;
    Label20: TLabel;
    Label17: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    AutoBtn: TButton;
    OverWriteBox: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox3: TComboBox;
    edtBlockNo: TEdit;
    MatchBtn: TButton;
    CopyScope: TRadioGroup;
    Label15: TLabel;
    Label16: TLabel;
    GroupBox2: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    Label21: TLabel;
    Label22: TLabel;
    ResetBtn: TBitBtn;
    WarnBox: TCheckBox;
    pnlCaptions: TPanel;
    lblSingles: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RefreshSelection(Sender: TObject);
    procedure edtTimeSlotKeyPress(Sender: TObject; var Key: Char);
    procedure OverWriteBoxClick(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure edtTimeSlotChange(Sender: TObject);
    Procedure PeriodCheckClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure AutoBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure MatchBtnClick(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure edtBlockNoChange(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure WarnBoxClick(Sender: TObject);
    procedure RefreshHint(Sender: TObject);
  private
    abSingle: Integer;
    abDouble: Integer;
    abTriple: Integer;
    abPeriod: Integer;
    Ebox: Integer;
    Aorder: array[0..nmbrDays] of Smallint;
    Adone: array[0..nmbrDays] of Bool;
    CopyRect: TRect;
    CopyOp: Integer;
    Optype: string;
    CopyStop: Bool;
    Nblock,l1,l2:  integer;
    tegroup, sugroup, rogroup:  tplevelsub;
    ptab:    tpPeriodData;
    Ntegroup,Nsugroup,Nrogroup:  integer;
    CanCopy, FirstStart: Bool;
    periodCheckBox:  array[1..nmbrPeriods] of TCheckBox;
    bd, bp, by, bl:  integer;
    Nentries,Navail,Nselect,NentrySelect: integer;
    CheckPer:       tpFclash;
    AutoPer:   tpFclash;
    Mblock,Myear:  integer;
    fd, fp, fy, fl:       integer;
    td, tp, ty, tl:       integer;
    Bflag,Fflag,Dflag:    bool;
    procedure SetButtons;
    procedure SetAutoBtn;
    procedure Restore;
    procedure DoSelect(d,p: integer);
    procedure AutoTriples(var Tneed: Integer);
    procedure AutoDoubles(var Dneed: Integer);
    procedure AutoSingles(var Sneed: integer);
    procedure CopyBlock;
    procedure SetCopyBtn;
    procedure SetResetBtn;
    procedure SetClearBtn;
    procedure SetMatchBtn;
    procedure ShowCopy;
    procedure CheckUnit;
    procedure CheckBox;
    Procedure DoUnit;
    procedure SortAuto(pCount: Integer; pAtemp: array of Integer);
  end;

var
  FrmCopyTT: TFrmCopyTT;

implementation

{$R *.DFM}
uses
  tcommon,ttable,tcommon2, DlgCommon;

procedure TFRmCopyTT.SetCopyBtn;
begin
 if CanCopy and (Nselect>0) then
   CopyBtn.Enabled:=true
 else
   CopyBtn.Enabled:=False;
end;

procedure TFRmCopyTT.SetResetBtn;
begin
 if CanCopy and ((Nselect>0) or (NentrySelect>0)) then
    ResetBtn.Enabled:=true
  else
    ResetBtn.Enabled:=False;
end;

procedure TFRmCopyTT.SetClearBtn;
begin
  if CanCopy and (NentrySelect>0) then
    ClearBtn.Enabled := True
  else
    ClearBtn.Enabled := False;
end;

procedure TFrmCopyTT.SetAutoBtn;
begin
  if CanCopy and (Navail>0) and ((abSingle+abDouble+abTriple)>0) then
    AutoBtn.Enabled := True
  else
    AutoBtn.Enabled := False;
end;

procedure TFrmCopyTT.SetMatchBtn;
begin
  if CanCopy and (Navail>0) and (Myear>0) and (Mblock>0) and (Mblock<=30) and (Myear<>by) then
    MatchBtn.Enabled:=true
  else
    MatchBtn.Enabled:=False;
end;

procedure TFrmCopyTT.SetButtons;
begin
  if FirstStart then exit;
  SetCopyBtn;
  SetResetBtn;
  SetClearBtn;
  SetAutoBtn;
  SetMatchBtn;
end;

procedure TFrmCopyTT.ShowCopy;
var
 d,p,y,l: Integer;
 empty, Found: bool;
 IntPoint: tpIntPoint;
 allthere,te,ro: Integer;
 s,i: Integer;
begin
 Nentries:=0; Navail:=0; Nselect:=0; NentrySelect:=0;
 image1.canvas.fillrect(CopyRect);
 if CanCopy=false then exit;
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   begin
    CheckPer[d,p]:=0;
    empty:=true;
    for l:=l1 to l2 do
     if FNT(d,p,by,l,0)^>0 then
      begin
       empty:=false;
       break;
      end;
    allthere:=0;
    if Nsugroup>0 then
      for s:=1 to Nsugroup do
       for l:=l1 to l2 do
        if FNT(d,p,by,l,0)^=Sugroup[s] then
         begin
          inc(allthere); break;
         end;
    found:=false;
    for y:=0 to yr do
     begin
      for l:=1 to level[y] do
      begin
       if (y=by) and (l>=l1) and (l<=l2) then continue;
       Intpoint:=FNT(d,p,y,l,2); te:=Intpoint^;
       inc(Intpoint); ro:=Intpoint^;
       if (ro=0) and (te=0) then continue;
       if (te>0) and (Ntegroup>0) then
        for i:=1 to Ntegroup do
         if te=tegroup[i] then
          begin
           found:=true; break;
          end;
       if (ro>0) and (Nrogroup>0) and not(found) then
        for i:=1 to Nrogroup do
         if ro=Rogroup[i] then
          begin
           found:=true; break;
          end;
      end; {l}
      if found then break;
     end; {y}
    if (allthere=Nsugroup) and (Nsugroup>0) then CheckPer[d,p]:=1;
    if (empty or abOverwrite) and not(found) and (CheckPer[d,p]<>1) then
    begin
      CheckPer[d,p]:=2;
      inc(Navail);
      image1.canvas.font.color:=clBlack;
      image1.canvas.font.style:= (image1.canvas.font.style-[fsUnderline]);
      image1.canvas.textout(ptab[p], 7+15*d,inttostr(p+1));
    end;
    if (allthere=Nsugroup) and (Nsugroup>0) then
    begin
      CheckPer[d,p]:=1;
      inc(Nentries);
      image1.canvas.font.color:=clRed;
      image1.canvas.font.style:= (image1.canvas.font.style+[fsUnderline]);
      image1.canvas.textout(ptab[p], 7+15*d,inttostr(p+1));
      image1.canvas.font.style:= (image1.canvas.font.style-[fsUnderline]);
    end;
   end; {p}
end;

procedure TFrmCopyTT.Restore;
var
  IntPoint:      tpIntPoint;
  s:             string;
  l,i:             integer;
  su,te,ro:      integer;
  lLongestLength: Integer;
begin
 Ntegroup:=0; Nsugroup:=0; Nrogroup:=0;
 l1:=0; l2:=0; Cancopy:=False; Nblock:=0;
 lLongestLength := GetLongestLength;
 if (bl>0) and (bl<=level[by]) and (bp>=0) and (bp<=Tlimit[bd]) then
  begin      { ^- check on valid position}
   Case Ebox of
    0: begin
        l1:=bl; l2:=bl;
       end;
    1: GetBlockLevels(bd,bp,by,bl,l1,l2);
    2: begin
        l1:=1; l2:=level[by];
       end;
   end;
   if (l1>0) then
    for l:=l1 to l2 do
     begin
      Intpoint:=FNT(bd,bp,by,l,0);
      su:=Intpoint^;
      if (su>0) and (su<=LabelBase) then
       begin
        inc(Nsugroup); Sugroup[Nsugroup]:=su;
       end;
      inc(Intpoint); te:=Intpoint^;
      if (te>0) then
       begin
        inc(Ntegroup); tegroup[Ntegroup]:=te;
       end;
      inc(Intpoint); ro:=Intpoint^;
      if (ro>0) then
       begin
        inc(Nrogroup); Rogroup[Nrogroup]:=ro;
       end;
      i:=FNgetBlockNumber(bd,bp,by,l);
      if Nblock=0 then Nblock:=i;
     end;
  end; {if valid pos}
  Combobox2.text:=day[bd];
  Combobox1.text:=yearname[by];
  if (bp>=0) and (bp<Tlimit[bd]) then edtTimeSlot.Text := IntToStr(bp+1);
  if (bl>0) and (bl<=level[by]) then edit2.text:=inttostr(bl);
  s:='';
  if (Nsugroup=0) and (Ntegroup=0) and (Nrogroup=0) then
   s:='No codes at this position' else CanCopy:=True;
  if Nsugroup>0 then
  begin
    for i:=1 to Nsugroup do
      s := s + Trim(subcode[Sugroup[i]])+' ' + GetSpacesToAlign(Trim(subcode[Sugroup[i]]), lLongestLength);
    end
  else if (l1=0) and (l2=0) then s:='No block number at this position';
  lblSubjects.Caption := s; s:='';
  if Ntegroup>0 then
   for i:=1 to Ntegroup do
     s := s + Trim(tecode[tegroup[i],0])+' ' + GetSpacesToAlign(Trim(TeCode[tegroup[i],0]), lLongestLength);
  lblTeachers.Caption := s;
  if (bl<1) or (bl>level[by]) then
   begin
    lblTeachers.Caption := 'Enter level in range 1-'+inttostr(level[by]);
    edit2.Setfocus; Edit2.SelectAll;
   end;
  s:='';
  if Nrogroup>0 then
   for i:=1 to Nrogroup do
     s:= s + Trim(tecode[Rogroup[i],1]) + ' ' + GetSpacesToAlign(Trim(TeCode[Rogroup[i],1]), lLongestLength);
  lblRooms.Caption := s;
  if (bp<0) or (bp>=Tlimit[bd]) then
   begin
    lblRooms.Caption := 'Enter time slot in range 1-'+inttostr(Tlimit[bd]);
    if edtTimeSlot.Visible and edtTimeSlot.Enabled then
    begin
      edtTimeSlot.Setfocus;
    end;
    edtTimeSlot.SelectAll;

   end;
  label14.Caption:=inttostr(Nblock);
  if Nblock > 0 then
  begin
    s := IntToStr(Nblock);
    Mblock := Nblock;
  end
  else
  begin
    s := '';
  end;
  edtBlockNo.Text := s;
  showCopy;
  label16.Caption:=inttostr(Nentries);
  label18.Caption:=inttostr(Navail);
  label20.Caption:=inttostr(Nselect);
  label22.Caption:=inttostr(NentrySelect);
  SetButtons;
end;

Procedure TFrmCopyTT.PeriodCheckClick(Sender: TObject);
var
 i: Integer;
begin
 i:=activecontrol.tag;
 if PeriodCheckBox[i].checked then
  abPeriod:=abPeriod or (1 shl i)
 else
  abPeriod:=abPeriod and not(1 shl i);
end;

procedure TFrmCopyTT.FormCreate(Sender: TObject);
var
 i,temp: integer;
 s:      string;
begin
 FirstStart := True;
 if box=bxBlock then CopyScope.ItemIndex:=1
  else if box=bxYrTime then CopyScope.ItemIndex:=2
   else CopyScope.ItemIndex:=0;
 Ebox:=CopyScope.ItemIndex;
 WarnBox.checked:=Bool(Warn);
 label3.caption:='&'+Yeartitle;
 lblSubjects.Font.Color := FontColorPair[cpSub,1];
 lblTeachers.Font.Color := FontColorPair[cpTeach,1];
 lblRooms.Font.Color := FontColorPair[cpRoom,1];
 ComboBox1.Maxlength:=szYearname;
 ComboBox1.DropDownCount:=nmbrYears;
 ComboBox3.DropDownCount:=nmbrYears;
 ptab[0]:=0;
 combobox2.clear; ComboBox2.DropDownCount:=nmbrDays;
 for i:=0 to (days-1) do
  begin
   combobox2.items.add(day[i]);
   image1.Canvas.TextOut(2, 7+15*i,'  ' + day[i]+':     ');
   temp:=image1.canvas.textwidth(day[i]);
   if temp>ptab[0] then ptab[0]:=temp;
  end;
 ptab[0]:=ptab[0]+2+image1.canvas.textwidth(':      ');
 for i:=1 to periods do
  ptab[i]:=ptab[i-1]+image1.canvas.textwidth(inttostr(i)+' ');
 copyrect.left:=ptab[0]-1; copyrect.right:=image1.width;
 copyrect.top:=0; copyrect.bottom:=3+15*days;
 combobox1.clear; combobox3.clear;
 Combobox1.Hint:='Select '+Yeartitle+' of timetable';
 Combobox3.Hint:='Select '+Yeartitle+' to match blocks to';
 for i:=0 to yr do
  begin
   combobox1.items.add(yearname[i]);
   combobox3.items.add(yearname[i]);
  end;
 edit3.text:=inttostr(abSingle);
 edit4.text:=inttostr(abDouble);
 edit5.text:=inttostr(abTriple);
 overWritebox.checked:=abOverwrite;
 for i:=1 to Periods do
  begin
   periodCheckBox[i]:=tCheckBox.create(application);
   periodCheckBox[i].parent:=GroupBox2;
   periodCheckBox[i].caption:=inttostr(i);
   periodCheckBox[i].checked:=bool(abPeriod and (1 shl i));
   periodCheckBox[i].width:=35;
   periodCheckBox[i].height:=17;
   periodCheckBox[i].left:=11 + ((i-1) div 5)*51;
   periodCheckBox[i].top:=19+((i-1) mod 5)*20;
   periodCheckBox[i].OnClick:=PeriodCheckClick;
   periodCheckBox[i].tag:=i;
   periodCheckBox[i].hint:='Check if a multiple can start in this time slot';
   periodCheckBox[i].showhint:=true;
  end;
 by:=ny; bl:=nl; bd:=nd; bp:=np;
 s:=''; Myear:=-1;
 if by<yr then
  begin
   s:=yearname[yr];
   Myear:=yr;
  end;
 combobox3.text:=s;
 edtBlockNo.Text := '';
 fillchar(CheckPer,sizeof(CheckPer),chr(0));
 fillchar(AutoPer,sizeof(AutoPer),chr(0));
 fillchar(Sugroup,sizeof(Sugroup),chr(0));
 fillchar(tegroup,sizeof(tegroup),chr(0));
 fillchar(Rogroup,sizeof(Rogroup),chr(0));
 lblSubjects.Hint := lblSubjects.Caption;
 lblTeachers.Hint := lblTeachers.Caption;
 lblRooms.Hint := lblRooms.Caption;
 lblSingles.Refresh;
end;

procedure TFrmCopyTT.FormActivate(Sender: TObject);
begin
  FirstStart := True;
  Restore;
  FirstStart := False;
  SetButtons;
end;

procedure TFrmCopyTT.RefreshSelection(Sender: TObject);
begin
 if FirstStart then exit;
   if Ebox<>CopyScope.ItemIndex then
   begin
     Ebox := CopyScope.ItemIndex;
     Restore;
   end;
end;

procedure TFrmCopyTT.edtTimeSlotKeyPress(Sender: TObject; var Key: Char);
begin
  allowNumericInputOnly(key);
end;

procedure TFrmCopyTT.OverWriteBoxClick(Sender: TObject);
begin
  if FirstStart then exit;
  abOverwrite := OverWritebox.Checked;
  Restore;
end;

procedure TFrmCopyTT.Edit3Change(Sender: TObject);
var
  s: string;
begin
  s := Trim(edit3.text);
  abSingle := StrToIntDef(s,0);
  if firstStart then exit;
  SetAutoBtn;
end;

procedure TFrmCopyTT.Edit4Change(Sender: TObject);
var
 s: string;
begin
 s:=trim(edit4.text);
 abDouble:=strtointdef(s,0);
 if firstStart then exit;
 SetAutoBtn;
end;

procedure TFrmCopyTT.Edit5Change(Sender: TObject);
var
 s: string;
begin
 s:=trim(edit5.text);
 abTriple:=strtointdef(s,0);
 if firstStart then exit;
 SetAutoBtn;
end;

procedure TFrmCopyTT.ComboBox1Change(Sender: TObject);
var
 found,oldyear:  integer;
begin
 if FirstStart then exit;
 oldyear:=by;
 found:=findYear(ComboBox1.text);
 if found>=0 then by:=found;
 if oldyear<>by then restore;
end;

procedure TFrmCopyTT.Edit2Change(Sender: TObject);
var
 s:  string;
 lev,oldlevel:  integer;
begin
 if FirstStart then exit;
 oldlevel:=bl;
 s:=trim(edit2.text);
 lev:=strtointdef(s,0);
 bl:=lev;
 if (oldlevel<>bl) and (Ebox<>2) then restore;
end;

procedure TFrmCopyTT.ComboBox2Change(Sender: TObject);
var
 found,oldday:  integer;
begin
 oldday:=0;
 if FirstStart then exit;
 found:=findDay(ComboBox2.text);
 if found>=0 then bd:=found;
 if bd<>oldday then restore;
end;

procedure TFrmCopyTT.edtTimeSlotChange(Sender: TObject);
var
 s:  string;
 p,oldperiod:  integer;
begin
 if FirstStart then exit;
 oldperiod:=bp;
 s := Trim(edtTimeSlot.Text);
 p:=strtointdef(s,0);
 bp:=p-1;
 if bp<>oldperiod then restore;
end;

procedure TFrmCopyTT.DoSelect(d,p: integer);
var
 i:      integer;
 Srect:  Trect;
begin
 if CanCopy=false then exit;
 Srect.left:=ptab[p]-1; Srect.right:= ptab[p+1]-2;
 Srect.top:= 3+15*d; Srect.bottom:=Srect.top+15;
 i:=CheckPer[d,p];
 if i=1 then
  begin
   image1.canvas.font.color:=clNavy;
   image1.canvas.font.style:= (image1.canvas.font.style+[fsUnderline]);
   image1.canvas.textout(ptab[p], 7+15*d,inttostr(p+1));
  end;
 invertrect(image1.canvas.handle,Srect);
 if i=-1 then
 begin
   image1.canvas.font.color:=clRed;
   image1.canvas.font.style:=  (image1.canvas.font.style+[fsUnderline]);
   image1.canvas.textout(ptab[p], 7+15*d,inttostr(p+1));
 end;
 image1.Refresh;
 case i of
   1: inc(NentrySelect);
  -1: dec(NentrySelect);
   2: inc(Nselect);
  -2: dec(Nselect);
 end;
 CheckPer[d,p]:=-i;
 label20.Caption:=inttostr(Nselect);
 label22.Caption:=inttostr(NentrySelect);
 SetButtons;
end;

procedure TFrmCopyTT.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
 d,p,i:  integer;
begin
 if (x<(ptab[0]-1)) or (x>ptab[periods]) or (y>(3+15*days)) then exit;
 d:= (y-3) div 15;
 p:=0;
 for i:=0 to periods-1 do
  if x>(ptab[i]-1) then p:=i;
 if p<0 then p:=0; if p>=periods then p:=periods-1;
 if d<0 then d:=0; if d>=days then d:=days-1;
 if CheckPer[d,p]=0 then exit; {not relevant}
 DoSelect(d,p);
end;

procedure TFrmCopyTT.RefreshHint(Sender: TObject);
begin
   (Sender as TLabel).Hint := (Sender as TLabel).Caption;
end;

procedure TFrmCopyTT.SortAuto(pCount: Integer; pAtemp: array of Integer);
var
 i,j,a,b,min,same,end1:  integer;
begin
 if pCount < 2 then exit;
 for i:=1 to pCount-1 do
  begin
   min:= pAtemp[Aorder[i]];
   for j:=i+1 to pCount do
    begin
     a := pAtemp[Aorder[j]];
     if a<min then
      begin
       min:=a;
       swapint(Aorder[i],Aorder[j]);
      end;
    end; {j}
  end; {i}
 for i:=1 to pCount-1 do
  begin
   same := pAtemp[Aorder[i]];
   end1:=i;
   for j:=i+1 to pCount do
    begin
     if pAtemp[Aorder[j]]=same then end1:=j else break;
    end; {j}
   if end1>i then
    begin
     a:=i-1; b:=1+end1-i;
     for j:= i to end1 do swapint(Aorder[j],Aorder[1+a+random(b)]);
    end;
  end; {i}
end;

procedure TFrmCopyTT.AutoTriples(var Tneed: integer);
var
 d,p,tp,triplecount,count,i: integer;
 Atriple: array[0..nmbrdays] of integer;
 cycle,j1,a,apos,begin1,got:  integer;
label
 TripleCycle;
begin
 for d:=0 to days-1 do
  begin
   Atriple[d]:=0;
   triplecount:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     AutoPer[d,p]:=0;
     if CheckPer[d,p]=2 then
      begin
       if triplecount>0 then inc(triplecount)
        else if (abperiod and (1 shl (p+1)))<>0 then triplecount:=1;
       if triplecount=3 then
        begin
         inc(Atriple[d]);
         AutoPer[d,p-2]:=3;
         triplecount:=0;
        end; {triplecount=3}
      end {CheckPer[d,p]=2}
     else
      triplecount:=0;
    end; {p}
  end; {d}
 count:=0;
 for d:=0 to days-1 do
  if Atriple[d]>0 then
   begin
    inc(count);
    Aorder[count]:=d;
   end;
 if count=0 then exit;
 SortAuto(count,Atriple);
 j1:=0; if abTriple<count then j1:=count-abTriple;
 for i:=1 to abTriple do
  begin
   cycle:=0;
  TripleCycle:
   inc(j1); inc(cycle);
   if j1>count then j1:=1;
   d:=Aorder[j1];
   if (cycle<=count) and (Atriple[d]=0) then goto TripleCycle;
   if cycle>count then break;
   a:=Atriple[d]; apos:=1; if a>1 then apos:=1+random(a);
   begin1:=-1; got:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     if AutoPer[d,p]=3 then
      begin
       inc(got);
       if (got=apos) then begin1:=p else continue;
      end;
    end; {p}
   if begin1=-1 then goto TripleCycle;
   for tp:=begin1 to begin1+2 do
    begin
     DoSelect(d,tp);
     AutoPer[d,tp]:=0;
    end;
   if Atriple[d]>0 then dec(Atriple[d]);
   if Tneed>0 then dec(Tneed);
   Adone[d]:=true;
  end; {i}
end;

procedure TFrmCopyTT.AutoDoubles(var Dneed: integer);
var
 d,p,tp,doublecount,count,i: integer;
 Adouble: array[0..nmbrdays] of integer;
 firstcycle,cycle,j1,a,apos,begin1,got:  integer;
label
 DoubleCycle;
begin
 for d:=0 to days-1 do
  begin
   Adouble[d]:=0;
   doublecount:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     AutoPer[d,p]:=0;
     if CheckPer[d,p]=2 then
      begin
       if doublecount>0 then
        begin
         inc(Adouble[d]);
         AutoPer[d,p-1]:=2;
         doublecount:=0;
        end
        else if (abperiod and (1 shl (p+1)))<>0 then doublecount:=1;
      end {CheckPer[d,p]=2}
     else
      doublecount:=0;
    end; {p}
  end; {d}
 count:=0;
 for d:=0 to days-1 do
  if Adouble[d]>0 then
   begin
    inc(count);
    Aorder[count]:=d;
   end;
 if count=0 then exit;
 SortAuto(count,Adouble);
 firstcycle:=0;
 j1:=0; if abDouble<count then j1:=count-abDouble;
 for i:=1 to abDouble do
  begin
   cycle:=0;
  DoubleCycle:
   inc(j1); inc(firstcycle);
   if j1>count then j1:=1;
   if firstcycle>count then inc(cycle);
   d:=Aorder[j1];
   if (cycle<=count) and (Adouble[d]=0) then goto DoubleCycle;
   if cycle>count then break;
   a:=Adouble[d]; apos:=1; if a>1 then apos:=1+random(a);
   begin1:=-1; got:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     if AutoPer[d,p]=2 then
      begin
       inc(got);
       if (got=apos) then begin1:=p else continue;
      end;
    end; {p}
   if begin1=-1 then goto DoubleCycle;
   for tp:=begin1 to begin1+1 do
    begin
     DoSelect(d,tp);
     AutoPer[d,tp]:=0;
    end;
   if Adouble[d]>0 then dec(Adouble[d]);
   if Dneed>0 then dec(Dneed);
   Adone[d]:=true;
  end; {i}
end;

procedure TFrmCopyTT.AutoSingles(var Sneed: integer);
var
 d,p,count,i: integer;
 lastperiod:     bool;
 Asingle: array[0..nmbrdays] of integer;
 firstcycle,cycle,j1,a,apos,begin1,got:  integer;
label
 SingleCycle;
begin
 for d:=0 to days-1 do
  begin
   Asingle[d]:=0;
   for p:=0 to Tlimit[d]-1 do
    begin
     AutoPer[d,p]:=0;
     if CheckPer[d,p]=2 then
      begin
       inc(Asingle[d]);
       AutoPer[d,p]:=1;
      end
    end; {p}
  end; {d}
 count:=0;
 for d:=0 to days-1 do
  if Asingle[d]>0 then
   begin
    inc(count);
    Aorder[count]:=d;
   end;
 if count=0 then exit;
 SortAuto(count,Asingle);
 lastperiod:=false;
 firstcycle:=0;
 j1:=0; if abSingle<count then j1:=count-abSingle;
 for i:=1 to abSingle do
  begin
   cycle:=0;
  SingleCycle:
   inc(j1); inc(firstcycle);
   if j1>count then j1:=1;
   if firstcycle>count then inc(cycle);
   d:=Aorder[j1];
   if (cycle<=count) and (Asingle[d]=0) then goto SingleCycle;
   if (firstcycle<=count) and Adone[d] then goto SingleCycle;
   if cycle>count then break;
   a:=Asingle[d]; apos:=1; if a>1 then apos:=1+random(a);
   begin1:=-1; got:=0;
   for p:=0 to Tlimit[d]-1 do
    if AutoPer[d,p]=1 then
      begin
       inc(got);
       if (got=apos) then begin1:=p;
      end;
   if lastperiod and (begin1=Tlimit[d]-1) and (Asingle[d]>1) then
    begin
     a:=Asingle[d]; apos:=1+random(a-1);
     begin1:=-1; got:=0;
     for p:=0 to Tlimit[d]-1 do
      if AutoPer[d,p]=1 then
        begin
         inc(got);
         if got=apos then begin1:=p;
        end;
    end;
   if begin1=-1 then goto SingleCycle;
   if begin1=Tlimit[d]-1 then lastperiod:=true;
   DoSelect(d,begin1);
   AutoPer[d,begin1]:=0;
   if Asingle[d]>0 then dec(Asingle[d]);
   if Sneed>0 then dec(Sneed);
   Adone[d]:=true;
  end; {i}
end;

procedure TFrmCopyTT.AutoBtnClick(Sender: TObject);
var
 Sneed,Dneed,Tneed,TotNeed,i:  integer;
 msg: string;
begin
 TotNeed:=abTriple*3+abDouble*2+abSingle;
 Sneed:=abSingle; Dneed:=abDouble; Tneed:=abTriple;
 if TotNeed=0 then exit;
 restore; {set selection back to 0}
 for i:=0 to days do Adone[i]:=false;
 if abTriple>0 then AutoTriples(Tneed);
 if abDouble>0 then AutoDoubles(Dneed);
 if abSingle>0 then AutoSingles(Sneed);
 msg:='';
 if Sneed>0 then msg:='Singles set: '+inttostr(abSingle-Sneed)+'/'+
  inttostr(abSingle);
 if Dneed>0 then
  begin
   if msg>'' then msg:=msg+chr(13)+chr(10);
   msg:=msg+'Doubles set: '+inttostr(abDouble-Dneed)+'/'+
  inttostr(abDouble);
  end;
 if Tneed>0 then
  begin
   if msg>'' then msg:=msg+chr(13)+chr(10);
   msg:=msg+'Triples set: '+inttostr(abTriple-Tneed)+'/'+
  inttostr(abTriple);
  end;
 if msg>'' then messagedlg(msg,mtInformation,[mbOK],0);
end;

procedure TFrmCopyTT.Checkunit;
var
 Sbyte1, Sbyte2: byte;
 Double1, Fix1:  bool;
 Nblock1: byte;
begin
 Sbyte1:=FNTByte(fd,fp,fy,fl,6)^;
 Sbyte2:=FNTByte(td,tp,ty,tl,6)^;
 Double1:=((sByte1 and 1)=1); Fix1:=((sByte1 and 4)=4);
 Nblock1:=FNgetBlockNumber(fd,fp,fy,fl);
 if copyop<>3 then
  begin
   if Fix1 then
    begin
     Fflag:=true;
     exit;
    end;
   if (Nblock1>0) and (Ebox=0) then Bflag:=True;
   if Double1 then Dflag:=true;
  end;
 if Copyop=0 then exit;
 Double1:=((sByte2 and 1)=1); Fix1:=((sByte2 and 4)=4);
 Nblock1:=FNgetBlockNumber(td,tp,ty,tl);
 if Fix1 then Fflag:=true;
 if (Nblock1>0) and (Ebox=0) then Bflag:=True;
 if Double1 then Dflag:=true;
end;

procedure TFrmCopyTT.CheckBox;
var
 msg,location: string;
begin
 CopyStop:=false;
 if Copyop=3 then location:='on '+day[td]+': '+inttostr(tp+1)
  else location:='on '+day[fd]+': '+inttostr(fp+1);
 if Fflag then
  begin
   msg:='One or more entries '+location+' are fixed - can''t '+optype;
   messagedlg(msg,mtWarning,[mbOK],0);
   CopyStop:=true;
   exit;
  end;
 if warn then exit;
 if Bflag then
  begin
   msg:='Entry in cell '+location+' is part of a block';
   msg:=msg+chr(13)+chr(10)+Optype+' anyway?';
   if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then CopyStop:=true;
   if CopyStop then exit;
  end;
 if Dflag then
  begin
   msg:='Entry '+location+' is part of a double';
   msg:=msg+chr(13)+chr(10)+Optype+' anyway?';
   if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then CopyStop:=true;
  end;
end;

Procedure TFrmCopyTT.DoUnit;
var
 A,B,C:  tpIntPoint;
 Lplace,Lplace1:   integer;

 procedure ClearLabel;
 begin
  Lplace:=A^; if Lplace<=LabelBase then exit;
  Lplace:=Lplace-LabelBase;
  TcLabel[Lplace]:='';
  if Lplace=Lnum then dec(Lnum);
  if Lnum<0 then Lnum:=0;
 end;

 procedure NewLabel;
 begin
  Lplace1:=B^; if Lplace1<=LabelBase then exit;
  Lplace1:=Lplace1-LabelBase;
  Lplace:=FindLabel; if Lplace=0 then exit;
  B^:=Lplace+LabelBase;
  TcLabel[Lplace]:=TcLabel[Lplace1];
 end;

begin
 if(Copyop=0) and (fp<Tlimit[fd]) then  {clear}
  begin
   A:=FNT(fd,fp,fy,fl,0);
   ClearLabel; A^:=0;
   inc(A); A^:=0; inc(A); A^:=0; inc(A); A^:=0;
  end;
 if (CopyOp>0) and ((Ebox=1) or (Ebox=2)) then
  if (fp>=Tlimit[fd]) OR (tp>=Tlimit[td]) then exit;
 if (CopyOp=1) or (CopyOp=3) then
  begin
   A:=FNT(td,tp,ty,tl,0);
   ClearLabel;
  end;
 if (CopyOp=3) then {copy}
  begin
  C:=FNT(fd,fp,fy,fl,0); B:=FNT(td,tp,ty,tl,0); B^:=C^; NewLabel;
  inc(B); inc(C); B^:=C^;
  inc(B); inc(C); B^:=C^;
  inc(B); inc(C); B^:=C^;
  end;
 if Copyop>0 then Fclash[td,tp]:=1;
 Fclash[fd,fp]:=1;
end;

procedure TFrmCopyTT.CopyBlock;
var
 xxfl: integer;
begin
 Bflag:=false; Fflag:=False; Dflag:=False;
 fy:=by; ty:=by;
 for xxfl:=l1 to l2 do
  begin
   fl:=xxfl;
   tl:=fl; ty:=fy;
   CheckUnit;
  end;
 CheckBox;
 if CopyStop then exit;
 for xxfl:=l1 to l2 do
  begin
   fl:=xxfl;
   tl:=fl; ty:=fy;
   DoUnit;
  end;
end;

procedure TFrmCopyTT.CopyBtnClick(Sender: TObject);
var
 xxtd,xxtp: integer;
begin
  Copyop:=3; Optype:='Copy'; fd:=bd; fp:=bp;
  for xxtd := 0 to days-1 do
    for xxtp:=0 to Tlimit[xxtd]-1 do
    begin
      td:=xxtd; tp:=xxtp;
      if CheckPer[td,tp]=-2 then
        Copyblock;
    end;
  Restore;
  ttclash;
  UpdateTimetableWins;
  SaveTimeFlag:=True;
end;

procedure TFrmCopyTT.MatchBtnClick(Sender: TObject);
var
 d,p,l:   integer;
 found:   bool;
begin
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   if CheckPer[d,p]<0 then DoSelect(d,p);
 for d:=0 to days-1 do
  for p:=0 to Tlimit[d]-1 do
   begin
    if CheckPer[d,p]<>2 then continue;
    found:=false;
    for l:=1 to level[Myear] do
     begin
      if Mblock=FNgetBlockNumber(d,p,Myear,l) then found:=true;
     end;
    if found then DoSelect(d,p);
   end;
 if Nselect=0 then messagedlg('No matches found',mtInformation,[mbOK],0);
end;

procedure TFrmCopyTT.ComboBox3Change(Sender: TObject);
begin
 Myear:=findYear(ComboBox3.text);
 if Myear>0 then ComboBox3.text:=yearname[Myear];
 if firstStart then exit;
 SetMatchBtn;
end;

procedure TFrmCopyTT.edtBlockNoChange(Sender: TObject);
var
 s:  string;
begin
 s := Trim(edtBlockNo.Text);
 Mblock:=strtointdef(s,0);
 if firstStart then exit;
 SetMatchBtn;
end;

procedure TFrmCopyTT.ClearBtnClick(Sender: TObject);
var
 msg:  string;
 xxfd,xxfp: integer;
begin
 CopyOp:=0; Optype:='Clear';
 if (Nentries=NentrySelect) and (Nentries>0) then
  begin
   msg:='This will clear ALL entries of your selection'+chr(13)+chr(10)+
         'Continue with Clear?';
   if messagedlg(msg,mtWarning,[mbyes,mbno],0)<>mrYes then exit;
  end;
 for xxfd:=0 to days-1 do
  for xxfp:=0 to Tlimit[xxfd]-1 do
  begin
   fd:=xxfd; fp:=xxfp;
   if CheckPer[fd,fp]=-1 then copyblock;
  end;
 restore;
 ttclash;
 UpdateTimetableWins;
 SaveTimeFlag:=True;
end;

procedure TFrmCopyTT.ResetBtnClick(Sender: TObject);
begin
  Restore;
end;

procedure TFrmCopyTT.WarnBoxClick(Sender: TObject);
begin
  Warn := WarnBox.Checked;
end;

end.
