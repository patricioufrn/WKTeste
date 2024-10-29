unit uPedidoProduto;

interface

uses
  FireDAC.Comp.Client, System.SysUtils;

type
  TPedidoProduto = class
  private
    FAutoincrem: Integer;
    FNumeroPedido: Integer;
    FCodigoProduto: Integer;
    FQuantidade: Integer;
    FValorUnitario: Currency;
    FValorTotal: Currency;
    FConexao: TFDConnection;
  public
    constructor Create(AConexao: TFDConnection);
    procedure LoadFromDatabase(AAutoincrem: Integer; ANumeroPedido: Integer);
    procedure SaveToDatabase(ANumeroPedido: Integer);
    procedure DeleteFromDatabase;

    property Autoincrem: Integer read FAutoincrem write FAutoincrem;
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
  end;

implementation

{ TPedidoProduto }

constructor TPedidoProduto.Create(AConexao: TFDConnection);
begin
  FConexao := AConexao;
end;

procedure TPedidoProduto.LoadFromDatabase(AAutoincrem: Integer; ANumeroPedido: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'SELECT * FROM PedidosProdutos WHERE Autoincrem = :Autoincrem';
    Query.ParamByName('Autoincrem').AsInteger := AAutoincrem;
    Query.Open;

    if not Query.IsEmpty then
    begin
      FAutoincrem := Query.FieldByName('Autoincrem').AsInteger;
      FNumeroPedido := ANumeroPedido;
      FCodigoProduto := Query.FieldByName('CodigoProduto').AsInteger;
      FQuantidade := Query.FieldByName('Quantidade').AsInteger;
      FValorUnitario := Query.FieldByName('ValorUnitario').AsCurrency;
      FValorTotal := Query.FieldByName('ValorTotal').AsCurrency;
    end
    else
      raise Exception.Create('Produto do pedido não encontrado!');
  finally
    Query.Free;
  end;
end;

procedure TPedidoProduto.SaveToDatabase(ANumeroPedido: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    if FAutoincrem = 0 then
    begin
      Query.SQL.Text := 'INSERT INTO PedidosProdutos (NumeroPedido, CodigoProduto, Quantidade, ValorUnitario, ValorTotal) ' +
                        'VALUES (:NumeroPedido, :CodigoProduto, :Quantidade, :ValorUnitario, :ValorTotal)';
      Query.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
      Query.ParamByName('CodigoProduto').AsInteger := FCodigoProduto;
      Query.ParamByName('Quantidade').AsInteger := FQuantidade;
      Query.ParamByName('ValorUnitario').AsCurrency := FValorUnitario;
      Query.ParamByName('ValorTotal').AsCurrency := FValorTotal;
      Query.ExecSQL;

      Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS Autoincrem';
      Query.Open;
      FAutoincrem := Query.FieldByName('Autoincrem').AsInteger;
    end
    else
    begin
      Query.SQL.Text := 'UPDATE PedidosProdutos SET CodigoProduto = :CodigoProduto, Quantidade = :Quantidade, ' +
                        'ValorUnitario = :ValorUnitario, ValorTotal = :ValorTotal WHERE Autoincrem = :Autoincrem';
      Query.ParamByName('CodigoProduto').AsInteger := FCodigoProduto;
      Query.ParamByName('Quantidade').AsInteger := FQuantidade;
      Query.ParamByName('ValorUnitario').AsCurrency := FValorUnitario;
      Query.ParamByName('ValorTotal').AsCurrency := FValorTotal;
      Query.ParamByName('Autoincrem').AsInteger := FAutoincrem;
      Query.ExecSQL;
    end;
  finally
    Query.Free;
  end;
end;

procedure TPedidoProduto.DeleteFromDatabase;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'DELETE FROM PedidosProdutos WHERE Autoincrem = :Autoincrem';
    Query.ParamByName('Autoincrem').AsInteger := FAutoincrem;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.

