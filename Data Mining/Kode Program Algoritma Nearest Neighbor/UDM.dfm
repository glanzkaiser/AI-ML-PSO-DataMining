object DM: TDM
  OldCreateOrder = False
  Left = 208
  Top = 200
  Height = 187
  Width = 215
  object DB: TIBDatabase
    DatabaseName = 'SIMILARITY.GDB'
    Params.Strings = (
      'user_name=SYSDBA'
      'password=masterkey')
    LoginPrompt = False
    DefaultTransaction = IBT
    IdleTimer = 0
    SQLDialect = 1
    TraceFlags = []
    Left = 96
    Top = 24
  end
  object Q1: TIBQuery
    Database = DB
    Transaction = IBT
    BufferChunks = 1000
    CachedUpdates = False
    Left = 40
    Top = 24
  end
  object IBT: TIBTransaction
    Active = False
    DefaultDatabase = DB
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saNone
    Left = 144
    Top = 24
  end
  object Q2: TIBQuery
    Database = DB
    Transaction = IBT
    BufferChunks = 1000
    CachedUpdates = False
    Left = 80
    Top = 72
  end
  object DS: TDataSource
    Left = 32
    Top = 80
  end
  object IBTable1: TIBTable
    Database = DB
    Transaction = IBT
    BufferChunks = 1000
    CachedUpdates = False
    Left = 136
    Top = 80
  end
end
