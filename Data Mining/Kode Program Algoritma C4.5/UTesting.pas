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
    LVAtribut: TListView;
    BtnNext: TBitBtn;
    Label2: TLabel;
    BtnTutup: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BtnNextClick(Sender: TObject);
    procedure BtnTutupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure Cari_Nilai(id_node : integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTesting: TFrmTesting;
  id_node : integer;
  Nilai_Combo, Tampil_Combo : TStringList;

implementation

uses UDM, DB, IBQuery;

{$R *.dfm}

procedure TFrmTesting.Cari_Nilai(id_node : integer);
begin
  with DM.Q1 do
  begin
    Nilai_Combo.Clear;
    Tampil_Combo.Clear;
    CmbNilai.Items.Clear;
    Close;
    SQL.Text := 'SELECT Nilai from Tree where induk = :id ';
    ParamByName('id').AsInteger := id_node;
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
end;

procedure TFrmTesting.FormShow(Sender: TObject);
begin
  Nilai_Combo := TStringList.create;
  Tampil_Combo := TStringList.create;
  BtnNext.Caption := '&Mulai';
  EdtAtribut.Text := '';
  CmbNilai.Items.Clear;
  BtnNext.SetFocus;
end;

procedure TFrmTesting.BtnNextClick(Sender: TObject);
var daftar : TListItem;
begin
  if BtnNext.Caption = '&Mulai' then
  begin
    LVAtribut.Items.Clear;
    with DM.Q1 do
    begin
      //cari induk
      Close;
      SQL.Text := 'select id_node, node from tree where induk is null';
      Open;

      EdtAtribut.Text := Fields[1].AsString;
      id_node := Fields[0].AsInteger;
      Cari_Nilai(id_node);
      BtnNext.Enabled := true;
      LblHasil.Caption := '';
      BtnNext.Caption := '&Selanjutnya'
    end;
  end else
  begin
    with DM.Q1, daftar do
    begin
      daftar := LVAtribut.Items.Add;
      Caption := EdtAtribut.Text;
      SubItems.Add(CmbNilai.Items[CmbNilai.Itemindex]);
      close;
      SQL.Text := 'select id_node, node, is_atribut '+
        ' from tree '+
        ' where induk  = :induk '+
        ' and nilai = :nilai '+
        ' ORDER BY ID_NODE ';
      ParamByName('induk').AsInteger := id_node;
      ParamByName('nilai').AsString := Nilai_Combo[CmbNilai.itemindex];
      Open;
      if Fields[2].AsString = 'Y' then
      begin
        EdtAtribut.Text := Fields[1].AsString;
        id_node := Fields[0].AsInteger;
        Cari_Nilai(id_node);
      end else
      begin
        EdtAtribut.Text := '';
        CmbNilai.Items.Clear;
        CmbNilai.Text := '';
        LblHasil.Caption := Fields[1].AsString;
        BtnNext.Caption := '&Mulai';
      end;
    end;
  end;
end;

procedure TFrmTesting.BtnTutupClick(Sender: TObject);
begin
  close;
end;

procedure TFrmTesting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Nilai_Combo.Free;
  Tampil_Combo.Free;
end;

end.
