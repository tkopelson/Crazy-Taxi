object Form1: TForm1
  Left = 480
  Top = 132
  Width = 1008
  Height = 831
  Caption = 'Juego - Final PCI - Kopelson'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Menu: TImage
    Left = 272
    Top = 168
    Width = 105
    Height = 105
  end
  object Jugar: TLabel
    Left = 288
    Top = 472
    Width = 3
    Height = 13
    OnClick = JugarClick
  end
  object Opciones: TLabel
    Left = 328
    Top = 560
    Width = 3
    Height = 13
    OnClick = OpcionesClick
  end
  object Salir: TLabel
    Left = 336
    Top = 616
    Width = 3
    Height = 13
    Transparent = True
    OnClick = SalirClick
  end
  object Image1: TImage
    Left = 664
    Top = 264
    Width = 105
    Height = 105
  end
  object Auto: TImage
    Left = 496
    Top = 592
    Width = 105
    Height = 105
  end
  object ApagarMusica: TLabel
    Left = 152
    Top = 368
    Width = 3
    Height = 13
    OnClick = ApagarMusicaClick
  end
  object Highscores: TLabel
    Left = 160
    Top = 424
    Width = 3
    Height = 13
    OnClick = HighscoresClick
  end
  object Creditos: TLabel
    Left = 216
    Top = 600
    Width = 3
    Height = 13
    OnClick = CreditosClick
  end
  object AtrasOpcionesAMenu: TLabel
    Left = 136
    Top = 328
    Width = 3
    Height = 13
    OnClick = AtrasOpcionesAMenuClick
  end
  object AtrasCreditosAOpciones: TLabel
    Left = 176
    Top = 464
    Width = 3
    Height = 13
    OnClick = AtrasCreditosAOpcionesClick
  end
  object ScoreBar: TImage
    Left = 144
    Top = 336
    Width = 105
    Height = 105
  end
  object Score: TLabel
    Left = 176
    Top = 112
    Width = 37
    Height = 13
    Caption = 'SCORE'
  end
  object Nube: TImage
    Left = 320
    Top = 504
    Width = 105
    Height = 105
  end
  object Objeto: TImage
    Left = 552
    Top = 416
    Width = 105
    Height = 105
  end
  object AtrasHighscoresAOpciones: TLabel
    Left = 360
    Top = 336
    Width = 3
    Height = 13
    OnClick = AtrasHighscoresAOpcionesClick
  end
  object ScoreAltoActual: TLabel
    Left = 112
    Top = 536
    Width = 3
    Height = 13
  end
  object wmp: TWindowsMediaPlayer
    Left = 408
    Top = 32
    Width = 245
    Height = 240
    TabOrder = 0
    ControlData = {
      000300000800000000000500000000000000F03F030000000000050000000000
      0000000008000200000000000300010000000B00FFFF0300000000000B00FFFF
      08000200000000000300320000000B00000008000A000000660075006C006C00
      00000B0000000B0000000B00FFFF0B00FFFF0B00000008000200000000000800
      020000000000080002000000000008000200000000000B00000052190000CE18
      0000}
  end
  object EscribirNombre: TEdit
    Left = 312
    Top = 392
    Width = 457
    Height = 21
    TabOrder = 1
    Text = 'Ingrese su nombre de la forma XXXXX (5 caracteres m'#225'x)'
  end
  object GuardarScore: TButton
    Left = 456
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Guardar Score'
    TabOrder = 2
    OnClick = GuardarScoreClick
  end
  object wmp2: TWindowsMediaPlayer
    Left = 392
    Top = 320
    Width = 49
    Height = 49
    TabOrder = 3
    ControlData = {
      000300000800000000000500000000000000F03F030000000000050000000000
      0000000008000200000000000300010000000B00FFFF0300000000000B00FFFF
      08000200000000000300320000000B00000008000A000000660075006C006C00
      00000B0000000B0000000B00FFFF0B00FFFF0B00000008000200000000000800
      020000000000080002000000000008000200000000000B00000052190000CE18
      0000}
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 464
    Top = 360
  end
end
