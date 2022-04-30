unit UUtama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrmUtama = class(TForm)
    BtnTraining: TBitBtn;
    BtnTesting: TBitBtn;
    BtnAturan: TBitBtn;
    BtnKeluar: TBitBtn;
    procedure BtnTrainingClick(Sender: TObject);
    procedure BtnTestingClick(Sender: TObject);
    procedure BtnAturanClick(Sender: TObject);
    procedure BtnKeluarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUtama: TFrmUtama;

implementation

uses UTraining, UTesting, UAturan;

{$R *.dfm}

procedure TFrmUtama.BtnTrainingClick(Sender: TObject);
begin
  FrmTraining.Show;
end;

procedure TFrmUtama.BtnTestingClick(Sender: TObject);
begin
  FrmTesting.Show;
end;

procedure TFrmUtama.BtnAturanClick(Sender: TObject);
begin
  FrmAtruran.show;
end;

procedure TFrmUtama.BtnKeluarClick(Sender: TObject);
begin
  close;
end;

end.
