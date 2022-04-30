unit UAturan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, comobj, StdCtrls, Buttons, ExtCtrls;

type
  TFrmAtruran = class(TForm)
    Panel1: TPanel;
    LVAturan: TListView;
    Panel2: TPanel;
    BitBtn4: TBitBtn;
    BtnProses: TBitBtn;
    BtnFile: TBitBtn;
    procedure BitBtn4Click(Sender: TObject);
    procedure BtnProsesClick(Sender: TObject);
    procedure BtnFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmAtruran: TFrmAtruran;

implementation

uses UDM, IBQuery, DB;

{$R *.dfm}

procedure TFrmAtruran.BitBtn4Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmAtruran.BtnProsesClick(Sender: TObject);
var noaturan, level : integer;
  daftar : TListItem;
  QTemp : TIBQuery;
procedure Tampil (id_node : integer; nilai : string);
begin
  inc (level);
  try
    with TIBQuery.Create(self) do
    begin
      Name := 'TIQ'+ IntToStr(Level);
      Database := DM.DB;
      Transaction := DM.IBT;
    end;
  except
  end;

  QTemp := FindComponent('TIQ'+ IntToStr(Level)) as TIBQuery;
  with daftar do
  begin
    QTemp.Close;
    QTemp.SQL.Text := 'SELECT node, induk, nilai '+
      ' FROM TREE '+
      ' WHERE ID_NODE = :id '+
      ' ORDER BY ID_NODE';
    QTemp.ParamByName('id').AsInteger := id_node;
    QTemp.Open;

    if QTemp.Fields[1].AsString = '' then
    begin
      daftar := LVAturan.Items.Add;
      Caption := IntToStr(noaturan);
      if UpperCase(QTemp.Fields[0].AsString) = 'NEM' then
      begin
        if nilai = '1' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '0 - 5')
        else if nilai = '2' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '5 - 6')
        else if nilai = '3' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '6 - 7')
        else if nilai = '4' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '7 - 8')
        else if nilai = '5' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '8 - 9')
        else if nilai = '6' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '9 - 10')
        else SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + nilai);
      end else if UpperCase(QTemp.Fields[0].AsString) = 'NILAI' then
      begin
        if nilai = '1' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '0 - 50')
        else if nilai = '2' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '50 - 60')
        else if nilai = '3' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '60 - 70')
        else if nilai = '4' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '70 - 80')
        else if nilai = '5' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '80 - 90')
        else if nilai = '6' then
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + '90 - 100')
        else
          SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + nilai);
      end else
        SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + nilai);

      (FindComponent('TIQ'+ IntToStr(Level)) as TIBQuery).Free;
      Exit;
    end;

    Tampil(QTemp.Fields[1].AsInteger, QTemp.Fields[2].AsString);
    dec (level);
    QTemp := FindComponent('TIQ'+ IntToStr(Level)) as TIBQuery;


    daftar := LVAturan.Items.Add;
    Caption := '';

      if UpperCase(QTemp.Fields[0].AsString) = 'NEM' then
      begin
        if nilai = '1' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '0 - 5')
        else if nilai = '2' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '5 - 6')
        else if nilai = '3' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '6 - 7')
        else if nilai = '4' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '7 - 8')
        else if nilai = '5' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '8 - 9')
        else if nilai = '6' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '9 - 10')
        else SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + nilai);
      end else if UpperCase(QTemp.Fields[0].AsString) = 'NILAI' then
      begin
        if nilai = '1' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '0 - 50')
        else if nilai = '2' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '50 - 60')
        else if nilai = '3' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '60 - 70')
        else if nilai = '4' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '70 - 80')
        else if nilai = '5' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '80 - 90')
        else if nilai = '6' then
          SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + '90 - 100')
        else SubItems.Add('JIKA ' + QTemp.Fields[0].AsString + ' = ' + nilai);
      end else  SubItems.Add('DAN ' + QTemp.Fields[0].AsString + ' = ' + nilai);

    (FindComponent('TIQ'+ IntToStr(Level)) as TIBQuery).Free;
  end;
end;

begin
  LVAturan.Items.Clear;
  noaturan := 1;
  //cari induk
  with DM.Q1, daftar do
  begin
    Close;
    SQL.Text := 'SELECT ID_NODE, NODE, INDUK, nilai '+
      ' FROM TREE '+
      ' WHERE IS_ATRIBUT = ''T''' +
      ' ORDER BY ID_NODE';
    Open;

    while not Eof do
    begin
      //tampilkan dalam listview
      daftar := LVAturan.Items.Add;
      Caption:= '';
      SubItems.Add('');
      level := 0;
      if Fields[2].AsString <> '' then
        Tampil(Fields[2].AsInteger, Fields[3].AsString);
      daftar := LVAturan.Items.Add;
      Caption := '';
      SubItems.Add('MAKA ' + Fields[1].AsString);
      Application.ProcessMessages;
      Inc(noaturan);
      Next;
    end;
  end;
end;

procedure TFrmAtruran.BtnFileClick(Sender: TObject);
var
    XlApp, XlBook, XlSheet : variant;
    StartRow, StartCol, i, j : integer;
begin
  StartRow:=2;
  StartCol:=1;
  try

    //*****Buka Excel Baru***************************************
    try
      XlApp:=CreateOleObject('Excel.Application');
      XlBook:=XlApp.WorkBooks.Add(ExtractFilePath(Application.ExeName)+
        '\Data.xlt');
      XlSheet:=XlApp.WorkBooks[1].Sheets[1];
      XlApp.Visible:=true;
    except
      XlApp.Quit;
      ShowMessage('Error saat membuka OLE dengan Excel 97. '+
        ' Apakah file template gaji ada?');
    end;//end punya try

    //*****Nulis ke Excel***************************************

    XlSheet.Cells[StartRow,StartCol]   := 'DAFTAR ATURAN';
      for i := 0 to LVAturan.Items.Count - 1 do
      begin
        XlSheet.Cells[StartRow+4+i,StartCol] :=
          '''' + LVAturan.Items[i].Caption;
        for j := 0 to LVAturan.Columns.Count - 2 do
          XlSheet.Cells[StartRow+4+i,StartCol+1+j] :=
            '''' + LVAturan.Items[i].SubItems.Strings[j];
      end;//
    //*****Selesai Nulis Ke Excel
  except
    MessageDlg('Operasi gagal', mtError, [mbOK],0);
  end;

end;

end.
