object FrmKasus: TFrmKasus
  Left = 291
  Top = 173
  Width = 696
  Height = 480
  Caption = 'KASUS'
  Color = clBtnFace
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
    Width = 688
    Height = 412
    Align = alClient
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clOlive
    TabOrder = 0
    object DBGKasus: TDBGrid
      Left = 5
      Top = 5
      Width = 678
      Height = 377
      Align = alClient
      Color = clInfoBk
      Ctl3D = False
      DataSource = DM.DS
      ParentCtl3D = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          Visible = True
        end
        item
          Expanded = False
          Visible = True
        end
        item
          Expanded = False
          Visible = True
        end
        item
          Expanded = False
          Visible = True
        end>
    end
    object DBNavigator: TDBNavigator
      Left = 5
      Top = 382
      Width = 678
      Height = 25
      DataSource = DM.DS
      Align = alBottom
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 412
    Width = 688
    Height = 41
    Align = alBottom
    BevelOuter = bvLowered
    BorderWidth = 4
    Color = clOlive
    TabOrder = 1
    object BtnTutup: TBitBtn
      Left = 432
      Top = 8
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
