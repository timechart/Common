unit LoadProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TFrmLoadProgress = class(TForm)
    pnlLoadProgress: TPanel;
    lblTitle: TLabel;
    prbProgress: TProgressBar;
    lblProgressMsg: TLabel;
    procedure FormShow(Sender: TObject);
  private
    FTitle: string;
  public
    procedure UpdateProgress(const pProgressBy: Integer; const pMsg: string; const pDelay: Integer = 0);
    property Title: string read FTitle write FTitle;
  end;

var
  FrmLoadProgress: TFrmLoadProgress;

implementation

{$R *.dfm}

{ TFrmLoadProgress }

procedure TFrmLoadProgress.FormShow(Sender: TObject);
begin
  lblTitle.Caption := FTitle;
  lblProgressMsg.Caption := '';
end;

procedure TFrmLoadProgress.UpdateProgress(const pProgressBy: Integer; const pMsg: string; const pDelay: Integer);
begin
  lblProgressMsg.Caption := pMsg;
  prbProgress.Position := prbProgress.Position + pProgressBy;
  Application.ProcessMessages;
  if pDelay > 0 then
    Sleep(pDelay);
end;

end.
