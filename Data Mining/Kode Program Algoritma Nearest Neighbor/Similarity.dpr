program Similarity;

uses
  Forms,
  USettingAtribut in 'USettingAtribut.pas' {FrmSettingAtribut},
  UDM in 'UDM.pas' {DM: TDataModule},
  UInputKasus in 'UInputKasus.pas' {FrmKasus},
  UUtama in 'UUtama.pas' {FrmUtama},
  UTesting in 'UTesting.pas' {FrmTesting},
  UNilaiVariabel in 'UNilaiVariabel.pas' {FrmNilaiAtribut};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmUtama, FrmUtama);
  Application.CreateForm(TFrmSettingAtribut, FrmSettingAtribut);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmKasus, FrmKasus);
  Application.CreateForm(TFrmTesting, FrmTesting);
  Application.CreateForm(TFrmNilaiAtribut, FrmNilaiAtribut);
  Application.Run;
end.
