object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Wk Pedidos'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object BtnGerarPedido: TButton
    Left = 32
    Top = 24
    Width = 161
    Height = 25
    Caption = 'Criar Pedido'
    TabOrder = 0
    OnClick = BtnGerarPedidoClick
  end
end
