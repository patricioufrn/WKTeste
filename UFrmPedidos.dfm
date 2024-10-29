object FrmPedidos: TFrmPedidos
  Left = 0
  Top = 0
  Caption = 'FrmPedidos'
  ClientHeight = 640
  ClientWidth = 1030
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 8
    Width = 1025
    Height = 81
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 40
      Height = 15
      Caption = 'Cliente:'
    end
    object Label2: TLabel
      Left = 24
      Top = 46
      Width = 40
      Height = 15
      Caption = 'Cidade:'
    end
    object Label3: TLabel
      Left = 945
      Top = 45
      Width = 17
      Height = 15
      Caption = 'UF:'
    end
    object EditCodigoCliente: TEdit
      Left = 70
      Top = 13
      Width = 116
      Height = 23
      TabOrder = 0
      OnKeyPress = EditCodigoClienteKeyPress
    end
    object EditNomeCliente: TEdit
      Left = 231
      Top = 13
      Width = 779
      Height = 23
      TabStop = False
      ReadOnly = True
      TabOrder = 2
    end
    object BtnBuscarCliente: TButton
      Left = 192
      Top = 12
      Width = 33
      Height = 25
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = BtnBuscarClienteClick
    end
    object EditCidade: TEdit
      Left = 70
      Top = 43
      Width = 869
      Height = 23
      TabStop = False
      ReadOnly = True
      TabOrder = 3
    end
    object EditUF: TEdit
      Left = 968
      Top = 42
      Width = 42
      Height = 23
      ReadOnly = True
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 95
    Width = 809
    Height = 90
    TabOrder = 1
    object Label4: TLabel
      Left = 24
      Top = 24
      Width = 46
      Height = 15
      Caption = 'Produto:'
    end
    object Label5: TLabel
      Left = 24
      Top = 56
      Width = 65
      Height = 15
      Caption = 'Quantidade:'
    end
    object Label6: TLabel
      Left = 209
      Top = 56
      Width = 78
      Height = 15
      Caption = 'Pre'#231'o Unit'#225'rio:'
    end
    object EditCodigoProduto: TEdit
      Left = 95
      Top = 21
      Width = 91
      Height = 23
      TabOrder = 0
      OnKeyPress = EditCodigoProdutoKeyPress
    end
    object EditQuantidade: TEdit
      Left = 95
      Top = 50
      Width = 91
      Height = 23
      TabOrder = 1
    end
    object EditDescricaoProduto: TEdit
      Left = 192
      Top = 21
      Width = 601
      Height = 23
      TabStop = False
      ReadOnly = True
      TabOrder = 3
    end
    object EditValorUnitario: TEdit
      Left = 293
      Top = 50
      Width = 132
      Height = 23
      TabOrder = 2
    end
    object BtnAdicionarProduto: TButton
      Left = 454
      Top = 49
      Width = 75
      Height = 25
      Caption = 'Adicionar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = BtnAdicionarProdutoClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 191
    Width = 1025
    Height = 410
    TabOrder = 2
    object GridProdutos: TStringGrid
      Left = 8
      Top = 8
      Width = 1008
      Height = 393
      FixedCols = 0
      ScrollBars = ssVertical
      TabOrder = 0
      ColWidths = (
        100
        585
        75
        103
        115)
    end
  end
  object Panel4: TPanel
    Left = 815
    Top = 95
    Width = 210
    Height = 90
    TabOrder = 3
    object Label7: TLabel
      Left = 8
      Top = 8
      Width = 193
      Height = 33
      Alignment = taCenter
      AutoSize = False
      Caption = 'Total do Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LabelTotalPedido: TLabel
      Left = 8
      Top = 39
      Width = 193
      Height = 33
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -23
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object BtnGravarPedido: TButton
    Left = 416
    Top = 607
    Width = 160
    Height = 25
    Caption = 'Salvar Pedido'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = BtnGravarPedidoClick
  end
  object BtnCancelarPedido: TButton
    Left = 862
    Top = 607
    Width = 160
    Height = 25
    Caption = 'Cancelar um Pedido...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = BtnCancelarPedidoClick
  end
  object BtnCarregarPedido: TButton
    Left = 8
    Top = 607
    Width = 160
    Height = 25
    Caption = '&Carregar um Pedido...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = BtnCarregarPedidoClick
  end
end
