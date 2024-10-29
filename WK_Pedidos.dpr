program WK_Pedidos;

uses
  Vcl.Forms,
  uFrmPrincipal in 'uFrmPrincipal.pas' {FrmPrincipal},
  UFrmPedidos in 'UFrmPedidos.pas' {FrmPedidos},
  uDMConexao in 'DataModule\uDMConexao.pas' {DMConexao: TDataModule},
  uCliente in 'Models\uCliente.pas',
  uPedido in 'Models\uPedido.pas',
  uPedidoProduto in 'Models\uPedidoProduto.pas',
  uProduto in 'Models\uProduto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmPedidos, FrmPedidos);
  Application.CreateForm(TDMConexao, DMConexao);
  Application.Run;
end.
