unit UUtama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrmUtama = class(TForm)
    BitBtn2: TBitBtn;
    BitBtn4: TBitBtn;
    BtnAtribut: TBitBtn;
    BtnNilaiAtribut: TBitBtn;
    BitBtn1: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BtnAtributClick(Sender: TObject);
    procedure BtnNilaiAtributClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUtama: TFrmUtama;

implementation

uses UTesting, USettingAtribut, UNilaiVariabel, UKasus, UInputKasus;

{$R *.dfm}

procedure TFrmUtama.BitBtn2Click(Sender: TObject);
begin
  FrmTesting.Show;
end;

procedure TFrmUtama.BitBtn4Click(Sender: TObject);
begin
  close;
end;

procedure TFrmUtama.BtnAtributClick(Sender: TObject);
begin
  FrmSettingAtribut.Show;
end;

procedure TFrmUtama.BtnNilaiAtributClick(Sender: TObject);
begin
  FrmNilaiAtribut.Show;
end;


procedure TFrmUtama.BitBtn1Click(Sender: TObject);
begin
  FrmKasus.Show;
end;

end.
