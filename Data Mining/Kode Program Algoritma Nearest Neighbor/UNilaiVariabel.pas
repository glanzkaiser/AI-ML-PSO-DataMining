unit UNilaiVariabel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls;

type
  TFrmNilaiAtribut = class(TForm)
    PnlInput: TPanel;
    Label4: TLabel;
    PnlTengah: TPanel;
    PnlBawah: TPanel;
    BtnTutup: TBitBtn;
    CmbAtribut: TComboBox;
    PnlPerbandingan: TPanel;
    SGPerbandingan: TStringGrid;
    Panel4: TPanel;
    PnlNilai: TPanel;
    SGNilaiAtribut: TStringGrid;
    Panel6: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    EdtNilai: TEdit;
    BtnOk: TBitBtn;
    BtnSimpan: TBitBtn;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure CmbAtributChange(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnSimpanClick(Sender: TObject);
    procedure BtnTutupClick(Sender: TObject);
    procedure EdtNilaiKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmNilaiAtribut: TFrmNilaiAtribut;

implementation

uses UDM, DB, IBQuery;

{$R *.dfm}

procedure TFrmNilaiAtribut.FormShow(Sender: TObject);
begin
  SGNilaiAtribut.Cells[0,0] := 'N I L A I';
  SGNilaiAtribut.RowCount := 2;
  SGNilaiAtribut.Cells[0,1] := '';

  SGNilaiAtribut.ColWidths[0] := PnlNilai.Width;
  //menampilkan daftar variabel
  with DM.Q1 do
  begin
    Close;
    SQL.Clear;
    SQL.Add(
      ' select nama_atribut '+
      ' from d_atribut '+
      ' where is_hasil = ''T'' and is_aktif = ''Y''');
    Open;

    CmbAtribut.Clear;
    while not eof do
    begin
      CmbAtribut.Items.Add(Fields[0].AsString);
      Next;
    end;
  end;
  if CmbAtribut.Items.Count > 0 then
  begin
    CmbAtribut.ItemIndex := 0 ;
    CmbAtribut.OnChange(self);
  end else ShowMessage('Belum ada variabel yang diinputkan');

end;

procedure TFrmNilaiAtribut.CmbAtributChange(Sender: TObject);
var nobaris, nokolom : integer;
begin
  //ambil dari tabel nilai_atribut --> masukkan ke nilai
  with DM.Q1 do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT NILAI FROM NILAI_ATRIBUT '+
      ' WHERE NAMA_ATRIBUT = :nama ';
    ParamByName('nama').AsString := CmbAtribut.Text;
    Open;
    Last;
    SGNilaiAtribut.RowCount := RecordCount + 1;
    SGPerbandingan.RowCount := RecordCount + 1;
    SGPerbandingan.ColCount := RecordCount + 1;
    SGPerbandingan.ColWidths[0] := 160;

    if recordcount > 0 then
    begin
      SGNilaiAtribut.FixedRows := 1;
      SGPerbandingan.FixedCols := 1;
      SGPerbandingan.FixedRows := 1;
    end;

    First;
    nobaris := 1;
    while not Eof do
    begin
      SGPerbandingan.ColWidths[nobaris] := 20 + length(Fields[0].AsString) * 6;
      SGNilaiAtribut.Cells[0, nobaris] := Fields[0].AsString;
      SGPerbandingan.Cells[0, nobaris] := Fields[0].AsString;
      SGPerbandingan.Cells[nobaris, 0] := Fields[0].AsString;
      //ambil dari tabel perbandingan --> masukkan ke perbandingan
      nokolom := 1;

      with DM.Q2 do
      begin
        Close;
        SQL.Clear;
        SQL.Text := 'SELECT Bobot '+
          ' from perbandingan '+
          ' where nama_atribut = :nama'+
          ' and nilai_Kasus_lama = :lama ';
        ParamByName('nama').AsString := CmbAtribut.Text;
        ParamByName('lama').AsString := DM.Q1.Fields[0].AsString;
        Open;

        while not eof do
        begin
          SGPerbandingan.Cells[nokolom, nobaris] := Fields[0].AsString;
          inc(nokolom);
          Next;
        end;
      end;
      Inc(nobaris);
      Next;
    end;
  end;

end;

procedure TFrmNilaiAtribut.BtnOkClick(Sender: TObject);
begin
  with DM.Q1 do
  begin
    //masukkan ke tabel nilai
    Close;
    SQL.Clear;
    SQL.Text := ' INSERT INTO NILAI_ATRIBUT VALUES (:nama, :nilai)';
    ParamByName('nama').AsString := CmbAtribut.Text;
    ParamByName('nilai').AsString := EdtNilai.Text;
    try
      ExecSQL;
    except
      MessageDlg('Nilai variabel sudah ada dalam database', mtInformation, [mbOK],0);
      exit;
    end;

    //ambil dari nilai
    Close;
    SQL.Clear;
    SQL.Text := ' SELECT Nilai FROM NILAI_ATRIBUT WHERE NAMA_ATRIBUT =  :nama';
    ParamByName('nama').AsString := CmbAtribut.Text;
    Open;

    while not eof do
    begin
      with DM.Q2 do
      begin
        //masukkan ke tabel perbandingan
        Close;
        SQL.Clear;
        SQL.Text := ' INSERT INTO PERBANDINGAN '+
        ' (NAMA_ATRIBUT, NILAI_KASUS_LAMA, NILAI_KASUS_BARU) '+
        ' VALUES (:nama, :lama, :baru)';
        ParamByName('nama').AsString := CmbAtribut.Text;
        ParamByName('lama').AsString := DM.Q1.Fields[0].AsString;
        ParamByName('baru').AsString := EdtNilai.Text;
        try
          ExecSQL;
        except
        end;

        if EdtNilai.Text <> DM.Q1.Fields[0].AsString then
        begin
          Close;
          SQL.Clear;
          SQL.Text := ' INSERT INTO PERBANDINGAN '+
            ' (NAMA_ATRIBUT, NILAI_KASUS_LAMA, NILAI_KASUS_BARU) '+
            ' VALUES (:nama, :lama, :baru)';
          ParamByName('nama').AsString := CmbAtribut.Text;
          ParamByName('lama').AsString := EdtNilai.Text;
          ParamByName('baru').AsString := DM.Q1.Fields[0].AsString;
          try
            ExecSQL;
          except
          end;
        end;
      end;
      Next;
    end;
    DM.IBT.CommitRetaining;
  end;
  CmbAtribut.OnChange(Self);
  EdtNilai.Text := '';
  EdtNilai.SetFocus;
end;

procedure TFrmNilaiAtribut.BtnSimpanClick(Sender: TObject);
var i, j : integer;
begin
  //simpan bobot perbandingan
  with DM.Q1, SGPerbandingan do
  begin
    for i := 1 to ColCount-1 do
      for j := 1 to RowCount-1 do
        if Cells[i,j] <> '' then
        begin
          Close;
          SQL.Text := ' update perbandingan set bobot = :bobot'+
          ' where nama_atribut = :nama '+
          ' and nilai_kasus_lama = :lama '+
          ' and nilai_kasus_baru = :baru ';
          ParamByName('nama').AsString := CmbAtribut.Text;
          ParamByName('lama').AsString := Cells[0,j];
          ParamByName('baru').AsString := Cells[i,0];
          ParamByName('bobot').AsFloat := StrToFloat(Cells[i,j]);
          ExecSQL;
        end;
  end;
  dm.IBT.CommitRetaining;
end;

procedure TFrmNilaiAtribut.BtnTutupClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmNilaiAtribut.EdtNilaiKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then BtnOk.Click;
end;

end.
