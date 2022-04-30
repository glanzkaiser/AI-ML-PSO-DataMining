object FrmTesting: TFrmTesting
  Left = 300
  Top = 184
  Width = 552
  Height = 274
  Caption = 'Testing'
  Color = clOlive
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 544
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    Color = clOlive
    TabOrder = 0
    object EdtAtribut: TEdit
      Left = 8
      Top = 12
      Width = 121
      Height = 19
      Color = clInfoBk
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      TabOrder = 0
    end
    object CmbNilai: TComboBox
      Left = 136
      Top = 12
      Width = 201
      Height = 21
      Color = clInfoBk
      Ctl3D = False
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 1
    end
    object BtnNext: TBitBtn
      Left = 344
      Top = 8
      Width = 107
      Height = 25
      Caption = '&Selanjutnya'
      TabOrder = 2
      OnClick = BtnNextClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object BtnTutup: TBitBtn
      Left = 456
      Top = 8
      Width = 80
      Height = 25
      Caption = 'Tutup'
      TabOrder = 3
      OnClick = BtnTutupClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        03333377777777777F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F3333333F7F333301111111B10333337F333333737F33330111111111
        0333337F333333337F333301111111110333337F33FFFFF37F3333011EEEEE11
        0333337F377777F37F3333011EEEEE110333337F37FFF7F37F3333011EEEEE11
        0333337F377777337F333301111111110333337F333333337F33330111111111
        0333337FFFFFFFFF7F3333000000000003333377777777777333}
      NumGlyphs = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 206
    Width = 544
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    Color = clOlive
    TabOrder = 1
    object LblHasil: TLabel
      Left = 48
      Top = 16
      Width = 46
      Height = 13
      Caption = 'LblHasil'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 16
      Width = 37
      Height = 13
      Caption = 'Hasil :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 544
    Height = 165
    Align = alClient
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clOlive
    TabOrder = 2
    object LVAtribut: TListView
      Left = 5
      Top = 5
      Width = 534
      Height = 155
      Align = alClient
      Color = clInfoBk
      Columns = <
        item
          Caption = 'Atribut'
          Width = 120
        end
        item
          AutoSize = True
          Caption = 'Nilai Atribut'
        end>
      Ctl3D = False
      GridLines = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
end
