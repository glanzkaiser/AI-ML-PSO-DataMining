object FrmSettingAtribut: TFrmSettingAtribut
  Left = 280
  Top = 237
  Width = 453
  Height = 362
  Caption = 'SETING ATRIBUT'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlBawah: TPanel
    Left = 0
    Top = 276
    Width = 445
    Height = 59
    Align = alBottom
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clOlive
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 66
      Height = 13
      Caption = 'Atribut Tujuan'
    end
    object CmbTujuan: TComboBox
      Left = 8
      Top = 24
      Width = 184
      Height = 21
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 0
      OnChange = CmbTujuanChange
    end
    object BtnTutup: TBitBtn
      Left = 200
      Top = 20
      Width = 240
      Height = 25
      Caption = 'Tutup'
      ModalResult = 2
      TabOrder = 1
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
  object PnlTengah: TPanel
    Left = 0
    Top = 97
    Width = 445
    Height = 179
    Align = alClient
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clOlive
    TabOrder = 0
    object LVAtribut: TListView
      Left = 5
      Top = 5
      Width = 435
      Height = 169
      Align = alClient
      Color = clInfoBk
      Columns = <
        item
          Caption = 'Atribut'
          Width = 120
        end
        item
          Caption = 'Aktif'
          Width = 48
        end
        item
          AutoSize = True
          Caption = 'Penjelasan'
        end>
      Ctl3D = False
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = LVAtributClick
    end
  end
  object PnlInput: TPanel
    Left = 0
    Top = 0
    Width = 445
    Height = 97
    Align = alTop
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clOlive
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object Label4: TLabel
      Left = 8
      Top = 8
      Width = 30
      Height = 13
      Caption = 'Atribut'
    end
    object Label1: TLabel
      Left = 200
      Top = 8
      Width = 52
      Height = 13
      Caption = 'Penjelasan'
    end
    object EdtAtribut: TEdit
      Left = 8
      Top = 28
      Width = 184
      Height = 19
      Color = clInfoBk
      Enabled = False
      MaxLength = 15
      TabOrder = 0
      OnKeyPress = EdtAtributKeyPress
    end
    object BtnSimpan: TBitBtn
      Left = 8
      Top = 56
      Width = 88
      Height = 25
      Caption = '&Simpan'
      TabOrder = 3
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
    object EdtPenjelasan: TEdit
      Left = 200
      Top = 28
      Width = 177
      Height = 19
      Color = clInfoBk
      Enabled = False
      MaxLength = 15
      TabOrder = 1
      OnKeyPress = EdtPenjelasanKeyPress
    end
    object CbAktif: TCheckBox
      Left = 384
      Top = 32
      Width = 49
      Height = 17
      Caption = '&Aktif'
      Color = clOlive
      ParentColor = False
      TabOrder = 2
      OnKeyPress = CbAktifKeyPress
    end
  end
end
