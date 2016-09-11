unit NewFeatures;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmNewFeatures = class(TForm)
    memRM: TMemo;
    lblContinueUpdate: TLabel;
    lblNoThanks: TLabel;
    procedure FormShow(Sender: TObject);
    procedure CloseAndIgnore(Sender: TObject);
    procedure CloseAndContinue(Sender: TObject);
  private
    FRMFile: string;
  public
    property RMFile: string read FRMFile write FRMFile;
  end;

var
  FrmNewFeatures: TFrmNewFeatures;

implementation

{$R *.dfm}

procedure TFrmNewFeatures.CloseAndContinue(Sender: TObject);
begin
  Close;
  ModalResult := mrOK;
end;

procedure TFrmNewFeatures.CloseAndIgnore(Sender: TObject);
begin
  Close;
end;

procedure TFrmNewFeatures.FormShow(Sender: TObject);
begin
  memRM.Lines.LoadFromFile(FRMFile);
end;

end.
