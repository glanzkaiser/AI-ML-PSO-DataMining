object Form1: TForm1
  Left = 246
  Top = 171
  Width = 574
  Height = 406
  BorderWidth = 1
  Caption = 'ASSOSIATION RULE - APRIORI'
  Color = 8421440
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial Black'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 564
    Height = 97
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Color = 8421440
    TabOrder = 0
    object Bevel3: TBevel
      Left = 176
      Top = 16
      Width = 185
      Height = 57
    end
    object Bevel2: TBevel
      Left = 8
      Top = 16
      Width = 161
      Height = 57
    end
    object Label1: TLabel
      Left = 24
      Top = 24
      Width = 117
      Height = 15
      Caption = 'Minimum Transaksi'
    end
    object Label2: TLabel
      Left = 184
      Top = 24
      Width = 147
      Height = 15
      Caption = 'Minimum Confidence (%)'
    end
    object Bevel1: TBevel
      Left = 368
      Top = 16
      Width = 145
      Height = 57
    end
    object Label3: TLabel
      Left = 377
      Top = 18
      Width = 106
      Height = 15
      Caption = 'Jumlah Transaksi'
    end
    object EdtMinTransaksi: TEdit
      Left = 24
      Top = 40
      Width = 137
      Height = 21
      Color = 14085316
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      Text = '5'
    end
    object EdtMinConfidence: TEdit
      Left = 184
      Top = 40
      Width = 169
      Height = 21
      Color = 14085316
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      Text = '10'
    end
    object EdtTotalTransaksi: TEdit
      Left = 377
      Top = 36
      Width = 121
      Height = 21
      Color = 14085316
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 97
    Width = 564
    Height = 41
    Align = alTop
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Color = 8421440
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 16
      Top = 8
      Width = 249
      Height = 25
      Caption = 'Proses'
      TabOrder = 0
      OnClick = BitBtn1Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 138
    Width = 564
    Height = 190
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvLowered
    BorderWidth = 4
    Caption = 'Panel1'
    Color = 8421440
    TabOrder = 2
    object Memo1: TMemo
      Left = 6
      Top = 6
      Width = 552
      Height = 178
      Align = alClient
      Color = 14085316
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentCtl3D = False
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 328
    Width = 564
    Height = 49
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvLowered
    Color = 8421440
    TabOrder = 3
    DesignSize = (
      564
      49)
    object BitBtn2: TBitBtn
      Left = 358
      Top = 8
      Width = 193
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Tutup'
      TabOrder = 0
      OnClick = BitBtn2Click
    end
  end
  object Query: TQuery
    DatabaseName = 'Northwind'
    SQL.Strings = (
      'select OrderId, count(ProductId) from [Order Details]'
      'group by orderid')
    Left = 432
    Top = 216
  end
  object Query1: TQuery
    DatabaseName = 'Northwind'
    SQL.Strings = (
      'select OrderId, count(ProductId) from [Order Details]'
      'group by orderid')
    Left = 464
    Top = 216
  end
end
