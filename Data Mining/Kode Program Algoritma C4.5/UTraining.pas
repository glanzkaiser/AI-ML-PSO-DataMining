unit UTraining;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DB, IBCustomDataSet, IBQuery, IBDatabase, Menus,
  ComCtrls, Buttons, ExtCtrls, math;

type
  TFrmTraining = class(TForm)
    Panel1: TPanel;
    BtnAtribut: TBitBtn;
    BtnKasus: TBitBtn;
    BtnProses: TBitBtn;
    BtnKeluar: TBitBtn;
    Tree: TTreeView;
    procedure SettingAtribut1Click(Sender: TObject);
    procedure Data1Click(Sender: TObject);
    procedure BtnAtributClick(Sender: TObject);
    procedure BtnKasusClick(Sender: TObject);
    procedure BtnProsesClick(Sender: TObject);
    procedure BtnKeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTraining: TFrmTraining;

implementation

uses USettingAtribut, UInputKasus, UDM;

{$R *.dfm}

procedure TFrmTraining.SettingAtribut1Click(Sender: TObject);
begin
  FrmSettingAtribut.Show;
end;

procedure TFrmTraining.Data1Click(Sender: TObject);
begin
  FrmKasus.Show;
end;

procedure TFrmTraining.BtnAtributClick(Sender: TObject);
begin
  FrmSettingAtribut.Show;
end;

procedure TFrmTraining.BtnKasusClick(Sender: TObject);
begin
  FrmKasus.Show;
end;

procedure TFrmTraining.BtnProsesClick(Sender: TObject);
var
  Induk : TTreeNode;
  Entropy: real;
  Jml_Hasil, v_sub_jml_kasus, v_jml_kasus, jml_node : integer;
  Hasil, tampil, id_node, Atribut_Terpakai,
    Nilai_Atribut_terpakai, NoCabang : TStringList;
  Level : Integer;
  atribut_hasil : string;
  QTemp, QTemp1 : TIBQuery;


procedure Buat_Node;
var i, j : integer;
  Gain, Sub_Entropy : real;
  str, terpilih : string;
  Ketemu : Boolean;

begin
  try
  with TIBQuery.Create(self) do
  begin
    Name := 'IQ'+ IntToStr(Level);
    Database := DM.DB;
    Transaction := DM.IBT;
  end;
  except
  end;

  with FindComponent('IQ'+ IntToStr(Level)) as TIBQuery do
  begin
    //cari entropy
    Entropy := 0;

    //cari jumlah kasus
    Close;
    SQL.Text := 'select count (*) from kasus where 1=1 ';
    for j := 0 to level-1 do
          SQL.Add(' and '+ Atribut_terpakai[j] + ' = :p' + IntToStr(j));
    for j := 0 to level-1 do
      ParamByName('p'+IntToStr(j)).AsString := Nilai_Atribut_terpakai[j];
    Open;

    v_jml_kasus := Fields[0].AsInteger;

    for i := 0 to Jml_Hasil-1 do
    begin
      Close;
      SQL.Text := 'select count(*) from kasus where '+
         atribut_hasil + ' = :hasil';
      for j := 0 to level - 1 do
          SQL.Add(' and '+ Atribut_Terpakai[j] + ' = :p' + IntToStr(j));
      for j := 0 to level - 1 do
        ParamByName('p' + IntToStr(j)).AsString := Nilai_Atribut_terpakai[j];


      ParamByName('hasil').AsString := tampil[i];
      Open;
      if (Fields[0].AsInteger <> 0) and (v_jml_kasus <>0 )then
      Entropy := Entropy +
          (- Fields[0].AsInteger/v_jml_kasus *
            log2 (Fields[0].AsInteger/v_jml_kasus));
    end;

    //hapus tabel kerja
    Close;
    SQL.Text := ' DROP TABLE KERJA'+ IntToStr(Level);
    try
      ExecSQL;
    except
    end;

    //hapus tabel subkerja
    Close;
    SQL.Text := ' DROP TABLE SUB_KERJA'+ IntToStr(Level);
    try
      ExecSQL;
    except
    end;

    DM.IBT.CommitRetaining;

    //buat tabel kerja
    Close;
    SQL.Text := ' CREATE TABLE KERJA'+ IntToStr(Level) + ' ('+
        ' NAMA_ATRIBUT VARCHAR (30), '+
        ' GAIN NUMERIC(15,2))';
    ExecSQL;

    DM.IBT.CommitRetaining;

    //buat tabel sub_kerja
    Close;
    SQL.Text := ' CREATE TABLE SUB_KERJA'+ IntToStr(Level) + ' ('+
        ' NAMA_ATRIBUT VARCHAR(30), '+
        ' NILAI VARCHAR(255), '+
        ' ENTROPY NUMERIC(15,2), ';
    for i := 0 to Jml_Hasil-1 do
      SQL.Add(Hasil[i] + ' VARCHAR(30), ');
    SQL.Add(' JML_KASUS INTEGER)');
    ExecSQL;

    DM.IBT.CommitRetaining;

    //cari atribut dari daftar_atribut
    Close;
    SQL.Text := 'select nama_atribut '+
      ' from d_atribut '+
      ' where Is_Hasil = ''T'' and Is_Aktif = ''Y''';
    if level <> 0 then
    begin
      SQL.add(' AND nama_atribut not in (');
      for i := 0 to level-2 do
        SQL.Add(':p' + IntToStr(i) + ', ');
      SQL.Add(':p' + IntToStr(level-1) +')');
      for i := 0 to level-1 do
        ParamByName('p' + IntToStr(i)).AsString := Atribut_Terpakai[i];
    end;
    Application.ProcessMessages;
    Open;
  end;

  while not (FindComponent('IQ'+ IntToStr(Level)) as TIBQuery).eof do
  begin
    Gain := Entropy;

    try
    with TIBQuery.Create(self) do
    begin
      Name := 'IQ'+ IntToStr(Level+1);
      Database := DM.DB;
      Transaction := DM.IBT;
    end;
    except
    end;

    //cari macam isi dari masing-masing atribut
    (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).Close;
    (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).SQL.Text :=
      'SELECT DISTINCT ' +
        (FindComponent('IQ'+ IntToStr(Level)) as TIBQuery).Fields[0].AsString +
        ' FROM kasus ';
    (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).Open;
    Application.ProcessMessages;

    //cari jumlah data dari masing-masing nilai
    while not (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).eof do
    begin
      try
      with TIBQuery.Create(self) do
      begin
        Name := 'IQ'+ IntToStr(Level+2);
        Database := DM.DB;
        Transaction := DM.IBT;
      end;
      except
      end;

      //jumlah dari atribut dengan suatu nilai : JUMLAH CERAH
      (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).Close;
      (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).SQL.Text :=
          'SELECT COUNT(*) FROM kasus '+
          ' WHERE ' + (FindComponent('IQ'+ IntToStr(Level)) as TIBQuery).
          Fields[0].AsString + ' = :p';

      (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
        ParamByName('p').AsString :=
        (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).Fields[0].AsString;
      for i := 0 to level -1 do
        (FindComponent('IQ'+ IntToStr(level+2)) as TIBQuery).SQL.Add(' and '+
          Atribut_Terpakai[i] + ' = :p' + IntToStr(i));

      for i := 0 to level -1 do
        (FindComponent('IQ'+ IntToStr(level+2)) as TIBQuery).
          ParamByName('p' + IntToStr(i)).AsString := Nilai_Atribut_terpakai[i];

      (FindComponent('IQ'+ IntToStr(level+2)) as TIBQuery).Open;
      Application.ProcessMessages;

      v_sub_jml_kasus :=
        (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
          Fields[0].AsInteger;
      if v_sub_jml_kasus > 0 then
      begin
        str := '';
        Sub_Entropy := 0;

        for i := 0 to Jml_Hasil-1 do
        begin
          //jumlah data dari isi atribut untuk suatu nilai hasil
          //eks (jumlah cerah dengan kep ya)
          (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).Close;
          (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).SQL.Text :=
            'SELECT COUNT(*) FROM kasus '+
            ' WHERE ' + (FindComponent('IQ'+ IntToStr(Level)) as TIBQuery).
              Fields[0].AsString + ' = :p' +
            ' AND '+ atribut_hasil + ' = '''+ tampil[i] + '''';
          (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
            ParamByName('p').AsString :=
            (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).
              Fields[0].AsString;
          for j := 0 to level -1 do
            (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).SQL.Add(
              ' and '+ Atribut_Terpakai[j] + ' = :p' + IntToStr(j));
          for j := 0 to level -1 do
            (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
              ParamByName('p'+IntToStr(j)).AsString :=
                Nilai_Atribut_terpakai[j];

          (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).Open;

          if (v_sub_jml_kasus <> 0) and
            ((FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
              Fields[0].AsInteger <> 0)then
          Sub_Entropy := Sub_Entropy -
              (((FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
                Fields[0].AsInteger/v_sub_jml_kasus) *
              log2 ((FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
                Fields[0].AsInteger/v_sub_jml_kasus));
          str := str + (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
            Fields[0].AsString + ', ';
        end; //end for i := 0 to jml_hasil-1

        //hitung gain
        if (v_sub_jml_kasus <> 0) and (v_jml_kasus <> 0) then
          Gain := Gain - (v_sub_jml_kasus/v_jml_kasus) * Sub_Entropy;

        //simpan dalam tabel sub_kerja
        (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).Close;
        (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).SQL.Text :=
          'INSERT INTO SUB_KERJA' + IntToStr(Level) +
            ' VALUES (:atribut, :nilai, :entropy, '+ str +
              IntToStr(v_sub_jml_kasus) + ')';
        (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
          ParamByName('atribut').AsString :=
            (FindComponent('IQ'+ IntToStr(Level)) as TIBQuery).
              Fields[0].AsString;
        (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
          ParamByName('nilai').AsString :=
            (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).
              Fields[0].AsString;
        (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).
          ParamByName('entropy').AsFloat := Sub_Entropy;
        try
          (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).ExecSQL;
          DM.IBT.CommitRetaining;
        except
        end;
      end;
      (FindComponent('IQ'+ IntToStr(Level+2)) as TIBQuery).Free;
      (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).next;
    end; //end while not end of
    //simpan ke tabel kerja

    (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).Close;
    (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).SQL.Text :=
      'INSERT INTO KERJA' + IntToStr(Level) +
          ' VALUES (:atribut, :gain)';
    (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).
      ParamByName('atribut').AsString :=
          (FindComponent('IQ'+ IntToStr(Level)) as TIBQuery).Fields[0].AsString;
    (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).
      ParamByName('gain').AsFloat := Gain;
    try
      (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).ExecSQL;
      DM.IBT.CommitRetaining;
    except
    end;
    (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).Free;
    (FindComponent('IQ'+ IntToStr(Level)) as TIBQuery).Next;
  end; //end while FindComponent('IQ'+ IntToStr(Level)) as TIBQuery.eof
  //cari atribut terpilih
  QTemp := FindComponent('IQ'+ IntToStr(Level)) as TIBQuery;
  with QTemp do
  begin
    Close;
    SQL.Text := ' SELECT NAMA_ATRIBUT FROM KERJA'+
        IntToStr(Level) + ' WHERE GAIN IN (SELECT MAX(GAIN) FROM KERJA'+
        IntToStr(Level)+ ')';
    Open;
    id_node.Add(IntToStr(jml_node+1));
    if not IsEmpty then
    begin
      terpilih := Fields[0].asstring;
      atribut_terpakai.Add(terpilih);
      if Level = 0 then
      begin
        //isi table tree
        Induk := Tree.Items.Add(Nil, Atribut_Terpakai[level] + '?');

        Close;
        SQL.Text := 'insert into tree (id_node, node) values (:id, :node)';
        ParamByName('id').AsInteger := jml_node + 1;
        ParamByName('node').AsString := Atribut_Terpakai[level];
        ExecSQL;
        DM.IBT.CommitRetaining;
        inc(jml_node);

      end else
      begin
        Tree.Items.AddChild(Induk,Nilai_Atribut_Terpakai[level-1] + ' : ' +
          Atribut_terpakai[level]+ '?');
        Induk := Induk.Item[strtoint(nocabang[level-1])];
        Close;
        SQL.Text := 'insert into tree (id_node, node, nilai, induk) '+
          ' values (:id, :node, :nilai, :induk)';
        ParamByName('id').AsInteger := jml_node + 1;
        ParamByName('node').AsString := Atribut_Terpakai[level];
        ParamByName('nilai').AsString := Nilai_Atribut_terpakai[level-1];
        ParamByName('induk').AsString := id_node[level-1];
        ExecSQL;
        DM.IBT.CommitRetaining;
        Inc(jml_node);
      end;

      //nyari nilai atribut terpilih
      Close;
      SQL.Text := ' SELECT * FROM SUB_KERJA' + IntToStr(Level) +
          ' WHERE NAMA_ATRIBUT = :atribut ';
      ParamByName('atribut').AsString := Atribut_Terpakai[level];
      Open;

      if not IsEmpty then Nilai_Atribut_terpakai.Add('');
    NoCabang.Add('-1');

      while not Eof do
      begin
        //cek apakah sudah ketemu jawabnya
        Nilai_Atribut_terpakai[level]:=
          FieldByName('nilai').AsString;
        NoCabang[Level] := IntToStr(StrToInt(NoCabang[level]) + 1);
        Ketemu := false;
        i := 0;
        while (i <= Jml_Hasil-1) and not Ketemu do
        begin
          if (QTemp.FieldByName('jml_kasus').AsInteger =
              QTemp.FieldByName(Hasil[i]).AsInteger) then
          begin

            Tree.Items.AddChild(Induk,Nilai_Atribut_Terpakai[level] + ' : ' +
              tampil[i]);
            //sudah ketemu klas-nya

              DM.Q1.Close;
              DM.Q1.SQL.Text := 'insert into tree '+
              ' (id_node, node, nilai, induk, is_atribut) '+
              ' values (:id, :node, :nilai, :induk, :is_atribut)';
              DM.Q1.ParamByName('id').AsInteger := jml_node + 1;
              DM.Q1.ParamByName('node').AsString := tampil[i];
              DM.Q1.ParamByName('nilai').AsString :=
                Nilai_Atribut_Terpakai[level];
              DM.Q1.ParamByName('induk').AsString := id_node[level];
              DM.Q1.ParamByName('is_atribut').AsString := 'T';
              DM.Q1.ExecSQL;
              DM.IBT.CommitRetaining;
              Inc(jml_node);

            ketemu := true;
          end;
          inc(i);
        end;
        inc(level);
        if Ketemu = false then
        begin
          Buat_Node;
        end;
        Dec(Level);

        if Level <= 0 then exit
        else begin
          try
            QTemp.Next;
          Except
          end;
        end;
      end;
    end else
    begin
      NoCabang.Add('0');
      Tree.Items.AddChild(Induk,Nilai_Atribut_Terpakai[level-1] +
        ' : Tidak terklasifikasi');
      Induk := Induk.Item[strtoint(nocabang[level-1])];
      //tidak terklasifikasi
      DM.Q1.Close;
      DM.Q1.SQL.Text := 'insert into tree '+
        ' (id_node, node, nilai, induk, is_atribut) '+
        ' values (:id, :node, :nilai, :induk, :is_atribut)';
      DM.Q1.ParamByName('id').AsInteger := jml_node + 1;
      DM.Q1.ParamByName('node').AsString := 'tidak terklasifikasi';
      DM.Q1.ParamByName('nilai').AsString := Nilai_Atribut_Terpakai[level-1];
      DM.Q1.ParamByName('induk').AsString := id_node[level-1];
      DM.Q1.ParamByName('is_atribut').AsString := 'T';
      DM.Q1.ExecSQL;
      DM.IBT.CommitRetaining;
      Inc(jml_node);
      Nilai_Atribut_terpakai.Add('');
      atribut_terpakai.Add('');

    end;
  end;

  while level > 0 do
  begin
    Nilai_Atribut_Terpakai.Delete(Level);
    Atribut_Terpakai.Delete(Level);
    NoCabang[Level-1] := IntToStr(StrToInt(NoCabang[level-1]) + 1);
    NoCabang.Delete(Level);
    Induk := Induk.Parent;
    //cek apakah masih ada cabang yang belum selesai
    id_node.Delete(Level);

    QTemp1 := (FindComponent('IQ'+ IntToStr(Level)) as TIBQuery);
    QTemp1.Close;
    QTemp1.SQL.Text := ' select distinct '+  Atribut_Terpakai[level-1] +
      ' from kasus '+
      ' where ' + Atribut_Terpakai[level-1] + ' not in ( '+
      ' select nilai from tree where induk = ''' + id_node[level-1] + ''')';
    QTemp1.Open;

    while not QTemp1.eof do
    begin

      Nilai_Atribut_terpakai[Level-1] := QTemp1.Fields[0].AsString;

      //cek apakah sudah jadi satu klasifikasi
      try
        with TIBQuery.Create(self) do
        begin
          Name := 'IQ'+ IntToStr(Level+1);
          Database := DM.DB;
          Transaction := DM.IBT;
        end;
      except
      end;

      QTemp := (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery);
      QTemp.Close;
      QTemp.SQL.Text := ' select jml_kasus';
      for i := 0 to Jml_Hasil-1 do
          QTemp.SQL.Text := QTemp.SQL.Text + ', ' + Hasil[i];
      QTemp.SQL.Text := QTemp.SQL.Text + ' from sub_kerja'+ IntToStr(Level-1) +
        ' where nama_atribut = ''' +
        Atribut_Terpakai[level-1] + ''' and Nilai = :p';
      QTemp.ParamByName('p').AsString := Nilai_Atribut_terpakai [level-1];
      QTemp.Open;

      ketemu := false;
      if not QTemp.IsEmpty then
      begin
         for i := 0 to Jml_Hasil-1 do
          begin
            if QTemp.FieldByName(Hasil[i]).AsInteger =
              QTemp.FieldByName('jml_kasus').AsInteger then
            begin
              Tree.Items.AddChild(Induk,Nilai_Atribut_Terpakai[level-1] +
                ' : ' + tampil[i]);
              DM.Q1.Close;
              DM.Q1.SQL.Text := 'insert into tree '+
                ' (id_node, node, nilai, induk, is_atribut) '+
                ' values (:id, :node, :nilai, :induk, :is_atribut)';
              DM.Q1.ParamByName('id').AsInteger := jml_node + 1;
              DM.Q1.ParamByName('node').AsString := tampil[i];
              DM.Q1.ParamByName('nilai').AsString :=
                Nilai_Atribut_Terpakai[level-1];
              DM.Q1.ParamByName('induk').AsString := id_node[level-1];
              DM.Q1.ParamByName('is_atribut').AsString := 'T';
              DM.Q1.ExecSQL;
              DM.IBT.CommitRetaining;
              Inc(jml_node);
              Ketemu := true;
            end;
          end;
         if (Ketemu = false) then
          begin
            (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).Free;
            QTemp1.Free;
            Buat_Node;
            Exit;
          end;
      end;
      (FindComponent('IQ'+ IntToStr(Level+1)) as TIBQuery).Free;
      QTemp1.Next;
    end;
    QTemp1.free;
    dec(level);
  end;
end;

begin
  if DM.IBT.Active = false then DM.IBT.Active := true;
  with DM.Q1, Tree.Items do
  begin
    //bersihkan tree
    Tree.Items.Clear;

    //hapus tabel tree
    Close;
    SQL.Text := 'delete from tree';
    ExecSQL;
    DM.IBT.CommitRetaining;


    //cari jenis jawaban
    Close;
    SQL.Text := 'select nama_atribut from d_atribut '+
      ' where  Is_Hasil = ''Y'' and is_Aktif = ''Y''';
    Open;

    atribut_hasil := Fields[0].AsString;

    Close;
    SQL.Text := 'select distinct '+ atribut_hasil +
      ' FROM kasus';
    Open;

    //atribut yang sedang aktif
    Atribut_Terpakai := TStringList.Create;
    id_node := TStringList.Create;
    Nilai_Atribut_terpakai := TStringList.Create;
    NoCabang := TStringList.Create;

    //untuk menyimpan jenis klasifikasi pada variabel hasil
    Hasil := TStringList.Create;
    tampil := TStringList.Create;
    Jml_Hasil := 0;
    while not Eof do
    begin
      Hasil.Add('result_'+ IntToStr(RecNo));
      tampil.Add(Fields[0].AsString);
      Inc(Jml_Hasil);
      Next;
    end;

    Level := 0;
    Jml_node := 0;

    Buat_Node;
    Hasil.Free;
    tampil.Free;
    Atribut_Terpakai.Free;
    id_node.Free;
    Nilai_Atribut_terpakai.Free;
    showmessage('selesai');
  end;  //end with Q1 --> atribut
end;

procedure TFrmTraining.BtnKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTraining.FormShow(Sender: TObject);
begin
  IF DM.DB.Connected = FALSE THEN DM.DB.Connected := TRUE;
  IF DM.IBT.Active = False THEN
    DM.IBT.Active := True;
  Tree.Items.Clear;

end;

end.
