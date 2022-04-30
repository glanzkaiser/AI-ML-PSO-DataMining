unit UApriori;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, DBTables, ComCtrls, IBDatabase,
  IBCustomDataSet, IBQuery, ExtCtrls;

type
  TForm1 = class(TForm)
    Query: TQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    EdtMinTransaksi: TEdit;
    EdtMinConfidence: TEdit;
    BitBtn1: TBitBtn;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    Memo1: TMemo;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel1: TBevel;
    Label3: TLabel;
    EdtTotalTransaksi: TEdit;
    Query1: TQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  C : integer;

implementation

uses DateUtils;

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var i,j,k,l,temp,total_transaksi, min_transaksi : integer;
min_confidence : real;
keluar : boolean ;
antecedent, konklusi  : string;
begin
  min_transaksi := StrToInt(EdtMinTransaksi.text);
  min_confidence := StrToFloat(EdtMinConfidence.Text);
  Memo1.Clear;
  with Query do
  begin
    Close;
    SQL.Text :=
      ' SELECT count(OrderId) '+
      ' FROM Orders ';
    Open;

    EdtTotalTransaksi.Text := Fields[0].AsString;
    total_transaksi := Fields[0].AsInteger;


    //==========mengambil item yang memenuhi syarat (C1)=========//
    C := 1;

    Close;
    SQL.Text := 'DROP TABLE C1';
    try
        ExecSQL;
    except
    end;

    Close;
    SQL.Text :=
          ' CREATE TABLE C1 ( '+
          ' ITEM1 INTEGER, '+
          ' JML INTEGER)';
    try
      ExecSQL;
    except
    end;

    Close;
    SQL.Text :=
      ' INSERT INTO C1 '+
      ' SELECT ProductId, count(OrderId)  '+
      ' FROM [Order Details] '+
      ' GROUP BY Productid '+
      ' HAVING count(OrderId) >= ' +
        IntToStr(min_transaksi) +
      ' ORDER BY ProductId';
    ExecSQL;

    //===========end of mengambil item yang memenuhi syarat (C1)==============//

    //===============mengambil item yang memenuhi syarat (C2 dst)=============//

    while not keluar do
    begin
      inc(C);

      Close;
      SQL.Text := 'DROP TABLE C' + IntToStr(C);
      try
        ExecSQL;
      except
      end;

      //buat tabel
      Close;
      SQL.Text := ' CREATE TABLE C' + IntToStr(C) + ' ( ';
      for i := 1 to C do
        SQL.Add(' ITEM' + IntToStr(i) + ' INTEGER, ');
      SQL.Add(' JML INTEGER)');
         try
        ExecSQL;
      except
      end;

      //isi tabel
      Close;
      SQL.Text := 'INSERT INTO C'+ IntToStr(C) +
        ' SELECT DISTINCT ';

      for i := 1 to C-1 do
        SQL.Add (' P.ITEM' + IntToStr(i) +', ');

      SQL.Add(' Q.ITEM' + IntToStr(C-1) +', '+
        ' (SELECT COUNT(O.ORDERID) '+
        ' FROM ORDERS O '+
	      ' WHERE (SELECT COUNT (*) FROM [ORDER DETAILS] D '+
		    ' WHERE D.PRODUCTID IN (');

      for i := 1 to C-1 do
        SQL.Add (' P.ITEM' + IntToStr(i) +', ');

      SQL.Add(' Q.ITEM' + IntToStr(C-1) +') '+
        ' AND D.ORDERID= O.ORDERID) >= '+ IntToStr(C) + ') '+
        ' FROM C'+ IntToStr(C-1) + ' P, C'+ IntToStr(C-1) + ' Q '+
        ' WHERE Q.ITEM'+ IntToStr(C-1) + ' > P.ITEM' + IntToStr(C-1) );

      for i := 2 to C-1 do
        SQL.Add(' AND P.ITEM' + IntToStr(i) + ' > P.ITEM' + IntToStr(i-1) );

      SQL.Add(' ORDER BY ');

      for i := 1 to C-1 do
        SQL.Add (' P.ITEM' + IntToStr(i) +', ');

      SQL.Add(' Q.ITEM' + IntToStr(C-1));
      try
        ExecSQL;
      except
      end;
      //hapus isi tabel yg tidak memenuhi syarat
      Close;
      SQL.Text := ' DELETE FROM C'+ IntToStr(C) +
        ' WHERE JML <= '+
        FloatToStr(min_transaksi);

      try
        ExecSQL;
      except
      end;

      //cek isi tabel
      Close;
      SQL.Text := ' SELECT * FROM C'+ IntToStr(C) ;
      Open;

      if IsEmpty then keluar := true;
    end; //end of while not keluar do

    //===========end of mengambil item yang memenuhi syarat (C2 dst)==========//

    //===========itung confidence ===================//
    for i := 2 to C-1 do
    begin
      Close;
      SQL.Text := 'SELECT * FROM C' + IntToStr(i) + ' ORDER BY JML DESC';
      Open;
      while not eof do
      begin
        temp := 0;
        for j := i downto 1 do
        begin
          Query1.Close;
          Query1.SQL.Text := ' SELECT JML FROM C' + IntToStr(i-1) + ' WHERE ';
          for k := 1 to i-1 do
          begin
            Query1.SQL.Text := Query1.SQL.Text + ' item' + IntToStr(k) + ' = ' ;
            if temp = k then
            begin
              Query1.SQL.Text := Query1.SQL.Text + Fields[temp].AsString + ' and ';
              temp := temp + 2
            end else
            begin
              Query1.SQL.Text := Query1.SQL.Text + Fields[temp].AsString + ' and ';
              temp := temp + 1
            end
          end;
          Query1.SQL.Text := copy(Query1.SQL.Text,1, length(Query1.SQL.Text)-7);
          Query1.Open;

          //jika nilai confidence minimum terpenuhi
          if FieldByName('jml').AsInteger*100/
            Query1.FieldByName('jml').AsInteger >= min_confidence then
          begin
            antecedent := 'JIKA membeli ';
            for k := 1 to i do
            begin
              if k = j then
                konklusi := ' MAKA akan membeli '+ Fields[k-1].AsString +
                  ' dengan SUPPORT '+
                  FormatFloat('0.00', FieldByName('jml').AsInteger/
                    total_transaksi*100) + ' %' +
                  ' dan CONFIDENCE '+
                  FormatFloat('0.00',FieldByName('jml').AsInteger * 100 /
                  Query1.FieldByName('jml').AsInteger) + ' %'
              else if ((j = 1) and (k>2)) or ((j>1) and (k>1)) then
                antecedent := antecedent + ', ' + Fields[k-1].AsString
              else antecedent := antecedent + Fields[k-1].AsString;
            end;
            Memo1.Lines.Add(antecedent + konklusi);
          end;
        end; //end of for j := 1 to i do
        Next;
      end; //end of while not eof
    end;
  end; //end of with query do
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  C := 0;
  Memo1.Clear;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

end.
