unit UDM;

interface

uses
  SysUtils, Classes, IBDatabase, DB, IBCustomDataSet, IBQuery, IBTable;

type
  TDM = class(TDataModule)
    DB: TIBDatabase;
    Q1: TIBQuery;
    IBT: TIBTransaction;
    Q2: TIBQuery;
    DS: TDataSource;
    IBTable1: TIBTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

end.
