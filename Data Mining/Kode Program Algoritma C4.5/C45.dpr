program C45;

uses
  Forms,
  UTraining in 'UTraining.pas' {FrmTraining},
  USettingAtribut in 'USettingAtribut.pas' {FrmSettingAtribut},
  UDM in 'UDM.pas' {DM: TDataModule},
  UInputKasus in 'UInputKasus.pas' {FrmKasus},
  UUtama in 'UUtama.pas' {FrmUtama},
  UTesting in 'UTesting.pas' {FrmTesting},
  UAturan in 'UAturan.pas' {FrmAtruran};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmUtama, FrmUtama);
  Application.CreateForm(TFrmTraining, FrmTraining);
  Application.CreateForm(TFrmSettingAtribut, FrmSettingAtribut);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmKasus, FrmKasus);
  Application.CreateForm(TFrmTesting, FrmTesting);
  Application.CreateForm(TFrmAtruran, FrmAtruran);
  Application.Run;
end.
