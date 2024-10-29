unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    BtnGerarPedido: TButton;
    procedure BtnGerarPedidoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;


implementation

uses uFrmPedidos;

{$R *.dfm}

procedure TFrmPrincipal.BtnGerarPedidoClick(Sender: TObject);
var
  FrmPedidos: TFrmPedidos; // Substitua pelo nome real da classe do formulário de pedidos
begin
  FrmPedidos := TFrmPedidos.Create(Self);
  try
    FrmPedidos.ShowModal;
  finally
    FrmPedidos.Free;
  end;
end;

end.
