unit UTesting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons;

type
  TFrmTesting = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    EdtAtribut: TEdit;
    CmbNilai: TComboBox;
    LblHasil: TLabel;
    BtnNext: TBitBtn;
    Label2: TLabel;
    BitBtn4: TBitBtn;
    Panel4: TPanel;
    LVAtribut: TListView;
    Panel5: TPanel;
    LVHasil: TListView;
    procedure FormShow(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure Cari_Nilai(atribut : string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTesting: TFrmTesting;
  jml_var, no_var : integer;
  atribut, bobot_atribut,  Nilai_Combo, Tampil_Combo : TStringList;
  total_bobot : real;

implementation

uses UDM, DB, IBQuery;

{$R *.dfm}

procedure TFrmTesting.Cari_Nilai(atribut : string);
begin
  with DM.Q1 do
  begin
    Nilai_Combo.Clear;
    Tampil_Combo.Clear;
    CmbNilai.Items.Clear;
    Close;
    SQL.Text := 'SELECT Nilai from nilai_atribut '+
      ' where nama_atribut = :nama ';
    ParamByName('nama').AsString := EdtAtribut.Text;
    Open;

    while not DM.Q1.eof do
    begin
      Nilai_Combo.Add(Fields[0].AsString);
      if UpperCase(EdtAtribut.Text) = 'NEM' then
      begin
        if Fields[0].AsString = '1' then Tampil_Combo.Add('0-5')
        else if Fields[0].AsString = '2' then Tampil_Combo.Add('5-6')
        else if Fields[0].AsString = '3' then Tampil_Combo.Add('6-7')
        else if Fields[0].AsString = '4' then Tampil_Combo.Add('7-8')
        else if Fields[0].AsString = '5' then Tampil_Combo.Add('8-9')
        else if Fields[0].AsString = '6' then Tampil_Combo.Add('9-10')
        else Tampil_Combo.Add(Fields[0].AsString);
      end else if UpperCase(EdtAtribut.Text) = 'NILAI' then
      begin
        if Fields[0].AsString = '1' then Tampil_Combo.Add('0-50')
        else if Fields[0].AsString = '2' then Tampil_Combo.Add('50-60')
        else if Fields[0].AsString = '3' then Tampil_Combo.Add('60-70')
        else if Fields[0].AsString = '4' then Tampil_Combo.Add('70-80')
        else if Fields[0].AsString = '5' then Tampil_Combo.Add('80-90')
        else if Fields[0].AsString = '6' then Tampil_Combo.Add('90-100')
        else Tampil_Combo.Add(Fields[0].AsString);
      end else Tampil_Combo.Add(Fields[0].AsString);
      DM.Q1.Next;
    end;
    CmbNilai.Items.Assign(Tampil_Combo);
    CmbNilai.ItemIndex := 0;
  end;
  CmbNilai.SetFocus;
end;

procedure TFrmTesting.FormShow(Sender: TObject);
begin
  Nilai_Combo := TStringList.create;
  Tampil_Combo := TStringList.create;
  atribut := TStringList.create;
  bobot_atribut := TStringList.create;
  BtnNext.Caption := 'Mulai';
  BtnNext.Click;
end;

procedure TFrmTesting.BtnNextClick(Sender: TObject);
var daftar : TListItem;
i : integer;
kedekatan : real;

begin
  if BtnNext.Caption = 'Mulai' then
  begin
    LblHasil.Caption := '';
    with DM.Q1 do
    begin
      //cari daftar variable
        Close;
        SQL.Text := 'select nama_atribut, bobot '+
         ' from d_atribut '+
          ' where is_hasil = ''T'' and is_aktif = ''Y''';
        Open;
      jml_var := 0;
      while  not eof do
      begin
        atribut.Add(Fields[0].AsString);
        bobot_atribut.Add(Fields[1].AsString);
        Inc(jml_var);
        Next;
      end;
    end;
    total_bobot := 0;
    for i := 0 to jml_var-1 do
      total_bobot := total_bobot + StrToFloat(bobot_atribut[i]);

    no_var := 0;
    EdtAtribut.Text := atribut[no_var];
    LVAtribut.Clear;
    LVHasil.Clear;
    BtnNext.Caption := 'Selanjutnya';
    Cari_Nilai(EdtAtribut.Text);
    exit;
  end;
  if BtnNext.Caption = 'Reset' then
  begin
    BtnNext.Caption:= 'Mulai';
    LVAtribut.Clear;
    LVHasil.Clear;;
    LblHasil.Caption := '';
    EdtAtribut.Text := '';
    CmbNilai.Clear;
    exit;
  end;
  Inc(no_var);
  //masukkan ke lv
  with DM.Q1, daftar do
  begin
    daftar := LVAtribut.Items.Add;
    Caption := EdtAtribut.Text;  
    SubItems.Add(CmbNilai.Items[CmbNilai.Itemindex]);  
    SubItems.Add(Nilai_Combo[CmbNilai.Itemindex]);  
    Application.ProcessMessages;  
    if no_var < jml_var then  
    begin  
      EdtAtribut.Text := atribut[no_var];  
      Cari_Nilai(EdtAtribut.Text);  
    end else  
    begin  
      BtnNext.Enabled := false;  
      //ambil semua kasus  
      Close;  
      SQL.Text := ' select * from kasus ';
      open;  

      while not eof do  
      begin  
        //hitung kedekatan  
        LblHasil.Caption := FieldByname('id_kasus').AsString;  
        Application.ProcessMessages;  
        with DM.Q2 do  
        begin  
          kedekatan := 0;  
          for i := 0 to jml_var-1 do  
          begin  
            Close;  
            SQL.Text := ' select bobot '+  
              ' from perbandingan  '+  
              ' where nama_atribut = :nama '+  
              ' and nilai_kasus_lama = :lama '+  
              ' and nilai_kasus_baru = :baru ';  
            ParamByName('nama').AsString := atribut[i];  
            ParamByName('lama').AsString := DM.Q1.Fieldbyname(atribut[i]).AsString;  
            ParamByName('baru').AsString := LVAtribut.Items[i].SubItems[1];
            Open;  

            kedekatan := kedekatan + Fields[0].AsFloat * StrToFloat(bobot_atribut[i]);  
          end;  
          kedekatan := kedekatan / total_bobot;

          //simpan kedekatan  
          Close;  
          SQL.Text := 'update kasus set kedekatan = :kedekatan '+  
            ' where id_kasus = :id ';  
          ParamByName('kedekatan').AsFloat := kedekatan;  
          ParamByName('id').AsInteger := DM.Q1.FieldbyName('id_kasus').AsInteger;  
          ExecSQL;  

        end;  
        Next;  
      end;  
      //tampilkan kedekatan terkecil dan hasilnya  
      DM.IBT.CommitRetaining;  
      Close;  
      SQL.Text := 'select * from kasus '+  
            ' where kedekatan = (select max(kedekatan) from kasus) ';  
      Open;  

      for i := 0 to jml_var-1 do  
      begin  
        daftar := LVHasil.Items.Add;  
        Caption := atribut[i];  
        if UpperCase(atribut[i]) = 'NEM' then  
        begin  
          if FieldByName(atribut[i]).AsString = '1' then SubItems.Add('0-5')  
          else if FieldByName(atribut[i]).AsString = '2' then SubItems.Add('5-6')  
          else if FieldByName(atribut[i]).AsString = '3' then SubItems.Add('6-7')  
          else if FieldByName(atribut[i]).AsString = '4' then SubItems.Add('7-8')  
          else if FieldByName(atribut[i]).AsString = '5' then SubItems.Add('8-9')  
          else if FieldByName(atribut[i]).AsString = '6' then SubItems.Add('9-10')  
          else SubItems.Add(FieldByName(atribut[i]).AsString);  
        end else if UpperCase(atribut[i]) = 'NILAI' then  
        begin  
          if FieldByName(atribut[i]).AsString = '1' then SubItems.Add('0-50')  
          else if FieldByName(atribut[i]).AsString = '2' then SubItems.Add('50-60')  
          else if FieldByName(atribut[i]).AsString = '3' then SubItems.Add('60-70')  
          else if FieldByName(atribut[i]).AsString = '4' then SubItems.Add('70-80')  
          else if FieldByName(atribut[i]).AsString = '5' then SubItems.Add('80-90')  
          else if FieldByName(atribut[i]).AsString = '6' then SubItems.Add('90-100')  
          else SubItems.Add(FieldByName(atribut[i]).AsString);  
        end else SubItems.Add(FieldByName(atribut[i]).AsString);  
      end;  
      LblHasil.Caption := Fieldbyname('registrasi').AsString +  
        ' (' + FormatFloat('0.00', fieldByName('kedekatan').asfloat) +  
        ') - kasus no : ' + fieldByName('id_kasus').AsString;  
      BtnNext.Caption := 'Reset';
      BtnNext.Enabled := true;  
    end;
  end;
end;

procedure TFrmTesting.BitBtn4Click(Sender: TObject);
begin
  close;
end;

procedure TFrmTesting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Nilai_Combo.Free;
  Tampil_Combo.Free;
  atribut.Free;
  bobot_atribut.free;
end;

end.
