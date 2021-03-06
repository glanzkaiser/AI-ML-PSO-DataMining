unit USettingAtribut;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, Buttons, ComCtrls;

type
  TFrmSettingAtribut = class(TForm)
    PnlBawah: TPanel;
    PnlTengah: TPanel;
    PnlInput: TPanel;
    Label4: TLabel;
    EdtAtribut: TEdit;
    LVAtribut: TListView;
    Label2: TLabel;
    CmbTujuan: TComboBox;
    BtnSimpan: TBitBtn;
    BtnTutup: TBitBtn;
    EdtPenjelasan: TEdit;
    Label1: TLabel;
    CbAktif: TCheckBox;
    procedure BtnSimpanClick(Sender: TObject);
    procedure EdtAtributKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure EdtPenjelasanKeyPress(Sender: TObject; var Key: Char);
    procedure LVAtributClick(Sender: TObject);
    procedure BtnTutupClick(Sender: TObject);
    procedure CbAktifKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure CmbTujuanChange(Sender: TObject);
  private
    procedure tampil;
  public
    { Public declarations }
  end;

var
  FrmSettingAtribut: TFrmSettingAtribut;
  is_update : boolean;
  namavar : TStringList;
implementation

uses UDM, IBQuery, DB;

{$R *.dfm}

procedure TFrmSettingAtribut.Tampil;
var Daftar : TListItem;
begin
  LVAtribut.Clear;
  namavar.Clear;
  CmbTujuan.Clear;
  with DM.Q1, Daftar do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from d_atribut ');
    Open;

    while not Eof do
    begin
      if FieldByName('is_aktif').AsString = 'Y' then
        namavar.Add(FieldByName('nama_atribut').AsString);

      Daftar := LVAtribut.Items.Add;
      CAption := FieldByName('nama_atribut').AsString;
      SubItems.Add(FieldByName('is_aktif').AsString);
      SubItems.Add(FieldByName('ket').AsString);
      Next;
    end;
  end;
  BtnSimpan.Enabled := false;
  EdtAtribut.Text := '';
  EdtPenjelasan.Text := '';
  CbAktif.Checked := true;
  is_update := false;
  CmbTujuan.Items.Assign(namavar);
  if CmbTujuan.Items.Count > 0 then
  //cari var tujuan
  with DM.Q1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(
      'select nama_atribut '+
      ' from d_atribut '+
      ' where is_hasil = ''Y'' and is_aktif = ''Y''');
    Open;
    if IsEmpty and (CmbTujuan.Items.Count > 0) then
    begin
      CmbTujuan.ItemIndex := 0;
      CmbTujuan.OnChange(self);
    end else
      CmbTujuan.ItemIndex := CmbTujuan.Items.IndexOf(Fields[0].AsString);
  end;
  CbAktif.SetFocus;
end;

procedure TFrmSettingAtribut.BtnSimpanClick(Sender: TObject);
  var i : integer;
  is_salah : boolean;
begin
  if EdtAtribut.Text = '' then
  begin
    MessageDlg('Beri nama atributnya!', mtInformation, [mbOK],0);
    CbAktif.SetFocus;
    Exit;
  end;
  with DM.Q1 do
  begin
      SQL.Text :=
        ' update d_atribut set '+
        ' is_aktif = :is_aktif '+
        ' where nama_atribut = :namalama ';
      ParamByName('namalama').AsString := LVAtribut.Selected.Caption;
    if CbAktif.Checked = true then ParamByName('is_aktif').AsString := 'Y'
    else ParamByName('is_aktif').AsString := 'T';
    try
      ExecSQL;
    except
    end;

    try
      IF DM.IBT.Active = False THEN
        DM.IBT.Active := True;
      DM.IBT.Commit;
    except
    end;
  end;
  //buat tabel kasus
  tampil;
end;

procedure TFrmSettingAtribut.EdtAtributKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then CbAktif.SetFocus
  else if (EdtAtribut.Text = '') and not (key in [#65 ..#90, #97 ..#122]) then
  begin
    MessageDlg('Karakter yang diinputkan tidak diijinkan '+
      ' sebagai karakter pertama nama atribut', mtInformation, [MBOK],0);
    key := char(0);
  end else if not
    (key in [#48..#57, #65 ..#90, #95, #97 ..#122, chr(VK_BACK)]) then
  begin
    MessageDlg('Karakter yang diinputkan tidak diijinkan dalam nama atribut',
      mtInformation, [mbOK], 0);
    key := char(0);
  end;
end;

procedure TFrmSettingAtribut.FormShow(Sender: TObject);
begin
  namavar := TStringList.create;
  tampil;
end;

procedure TFrmSettingAtribut.EdtPenjelasanKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then CbAktif.SetFocus
end;

procedure TFrmSettingAtribut.LVAtributClick(Sender: TObject);
begin
  if LVAtribut.SelCount = 0 then exit;
  EdtAtribut.Text := LVAtribut.Selected.Caption;
  EdtPenjelasan.Text := LVAtribut.Selected.SubItems[1];
  if LVAtribut.Selected.SubItems[0] = 'Y' then CbAktif.Checked := true
  else CbAktif.Checked := false;
  is_update := true;
  BtnSimpan.Enabled := true;
  CbAktif.SetFocus;
end;

procedure TFrmSettingAtribut.BtnTutupClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmSettingAtribut.CbAktifKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then BtnSimpan.SetFocus
end;

procedure TFrmSettingAtribut.FormDestroy(Sender: TObject);
begin
  namavar.Free;
end;

procedure TFrmSettingAtribut.CmbTujuanChange(Sender: TObject);
begin
  with DM.Q1 do
  begin
    //buat non hasil semua
    close;
    SQL.Text := 'update d_atribut set is_hasil = ''T''';
    ExecSQL;

    //pilih atribut hasil
    close;
    SQL.Text := 'update d_atribut set is_hasil = ''Y'''+
      ' where nama_atribut = :nama ';
    ParamByName('nama').AsString := CmbTujuan.Text;
    ExecSQL;
    IF DM.IBT.Active = False THEN
      DM.IBT.Active := True;
    DM.IBT.CommitRetaining;

  end;
end;

end.
