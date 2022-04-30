unit UInputKasus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, Grids, DBGrids, StdCtrls, Buttons, DBCtrls;

type
  TFrmKasus = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    DBGKasus: TDBGrid;
    BtnTutup: TBitBtn;
    DBNavigator1: TDBNavigator;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnTutupClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmKasus: TFrmKasus;

implementation

uses UDM, IBQuery;

{$R *.dfm}

procedure TFrmKasus.FormShow(Sender: TObject);
var i : integer;
begin

  DBGKasus.Columns.Clear;
  DM.IBTable1.TableName := 'Kasus';
  DM.IBTable1.Active := false;
  DM.IBTable1.Active := true;
  DM.DS.DataSet :=  DM.IBTable1;
  DBGKasus.DataSource :=  DM.DS;
  //ambil jumlah atribut aktif
  DBGKasus.Columns.Add;
  DBGKasus.Columns[0].FieldName := 'Id_Kasus';
  DBGKasus.Columns[0].Width := 80;
  with DM.Q1 do
  begin
    Close;
    SQL.Text := 'SELECT NAMA_ATRIBUT FROM D_ATRIBUT WHERE IS_AKTIF = ''Y''';
    Open;

    i := 1;
    if IsEmpty then
    begin
      Close;
      SQL.Text := 'DELETE FROM kasus';
      ExecSQL;
    end;

    while not Eof do
    begin
      DBGKasus.Columns.Add;
      DBGKasus.Columns[i].FieldName := Fields[0].AsString;
      DBGKasus.Columns[i].Width := 120;
      Next;
      inc(i);
    end;
  end;
end;

procedure TFrmKasus.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IF DM.IBT.Active = False THEN
    DM.IBT.Active := True;
  DM.IBT.Commit;

end;

procedure TFrmKasus.BtnTutupClick(Sender: TObject);
begin
  Close;
end;

end.
