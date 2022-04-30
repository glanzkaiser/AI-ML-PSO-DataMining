object FrmNilaiAtribut: TFrmNilaiAtribut
  Left = 186
  Top = 137
  Width = 745
  Height = 567
  Caption = 'Seting Nilai Atribut'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlInput: TPanel
    Left = 0
    Top = 0
    Width = 737
    Height = 57
    Align = alTop
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clOlive
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 8
      Width = 38
      Height = 13
      Caption = '&Atribut'
    end
    object CmbAtribut: TComboBox
      Left = 8
      Top = 24
      Width = 169
      Height = 21
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnChange = CmbAtributChange
    end
  end
  object PnlTengah: TPanel
    Left = 0
    Top = 57
    Width = 737
    Height = 424
    Align = alClient
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clOlive
    TabOrder = 1
    object PnlPerbandingan: TPanel
      Left = 201
      Top = 5
      Width = 531
      Height = 414
      Align = alClient
      BevelOuter = bvLowered
      Color = clOlive
      TabOrder = 0
      object SGPerbandingan: TStringGrid
        Left = 1
        Top = 33
        Width = 529
        Height = 336
        Align = alClient
        Ctl3D = False
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        ParentCtl3D = False
        TabOrder = 0
        ColWidths = (
          64
          64
          53
          64
          64)
        RowHeights = (
          24
          24
          24
          24
          24)
      end
      object Panel4: TPanel
        Left = 1
        Top = 369
        Width = 529
        Height = 44
        Align = alBottom
        BevelOuter = bvLowered
        BorderWidth = 4
        Color = clOlive
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        object BtnSimpan: TBitBtn
          Left = 432
          Top = 10
          Width = 88
          Height = 25
          Caption = '&Simpan'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = BtnSimpanClick
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
            000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
            00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
            F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
            0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
            FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
            FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
            0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
            00333377737FFFFF773333303300000003333337337777777333}
          NumGlyphs = 2
        end
      end
      object Panel1: TPanel
        Left = 1
        Top = 1
        Width = 529
        Height = 32
        Align = alTop
        BevelOuter = bvLowered
        BorderWidth = 4
        Caption = 'PERBANDINGAN NILAI ATRIBUT'
        Color = clOlive
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 2
      end
    end
    object PnlNilai: TPanel
      Left = 5
      Top = 5
      Width = 172
      Height = 414
      Align = alLeft
      BevelOuter = bvLowered
      Color = clOlive
      TabOrder = 1
      object SGNilaiAtribut: TStringGrid
        Left = 1
        Top = 89
        Width = 170
        Height = 324
        Align = alClient
        ColCount = 1
        Ctl3D = False
        FixedCols = 0
        ParentCtl3D = False
        TabOrder = 0
        ColWidths = (
          64)
      end
      object Panel6: TPanel
        Left = 1
        Top = 1
        Width = 170
        Height = 88
        Align = alTop
        BevelOuter = bvLowered
        BorderWidth = 4
        Color = clOlive
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 67
          Height = 13
          Caption = '&Nilai Atribut'
        end
        object EdtNilai: TEdit
          Left = 8
          Top = 28
          Width = 152
          Height = 19
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          MaxLength = 30
          ParentFont = False
          TabOrder = 0
          OnKeyPress = EdtNilaiKeyPress
        end
        object BtnOk: TBitBtn
          Left = 8
          Top = 52
          Width = 152
          Height = 22
          Caption = 'OK'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = BtnOkClick
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            33333333FF33333333FF333993333333300033377F3333333777333993333333
            300033F77FFF3333377739999993333333333777777F3333333F399999933333
            33003777777333333377333993333333330033377F3333333377333993333333
            3333333773333333333F333333333333330033333333F33333773333333C3333
            330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
            993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
            333333333337733333FF3333333C333330003333333733333777333333333333
            3000333333333333377733333333333333333333333333333333}
          NumGlyphs = 2
        end
      end
    end
    object Panel2: TPanel
      Left = 177
      Top = 5
      Width = 24
      Height = 414
      Align = alLeft
      BevelOuter = bvLowered
      Color = clOlive
      TabOrder = 2
    end
  end
  object PnlBawah: TPanel
    Left = 0
    Top = 481
    Width = 737
    Height = 59
    Align = alBottom
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clOlive
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object BtnTutup: TBitBtn
      Left = 488
      Top = 28
      Width = 240
      Height = 25
      Caption = 'Tutup'
      ModalResult = 2
      TabOrder = 0
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
end
