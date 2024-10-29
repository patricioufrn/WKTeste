unit uPedido;

interface

uses
  FireDAC.Comp.Client, System.SysUtils, System.Generics.Collections, uPedidoProduto;

type
  TPedido = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDate;
    FCodigoCliente: Integer;
    FValorTotal: Currency;
    FProdutos: TObjectList<TPedidoProduto>;
    FConexao: TFDConnection;
  public
    constructor Create(AConexao: TFDConnection);
    destructor Destroy; override;
    procedure LoadFromDatabase(ANumeroPedido: Integer);
    procedure SaveToDatabase;
    procedure DeleteFromDatabase;

    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property Produtos: TObjectList<TPedidoProduto> read FProdutos;
  end;

implementation

{ TPedido }

constructor TPedido.Create(AConexao: TFDConnection);
begin
  FConexao := AConexao;
  FProdutos := TObjectList<TPedidoProduto>.Create;
end;

destructor TPedido.Destroy;
begin
  FProdutos.Free;
  inherited;
end;

procedure TPedido.LoadFromDatabase(ANumeroPedido: Integer);
var
  Query: TFDQuery;
  Produto: TPedidoProduto;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'SELECT NumeroPedido, DataEmissao, CodigoCliente, ValorTotal FROM Pedidos WHERE NumeroPedido = :NumeroPedido';
    Query.ParamByName('NumeroPedido').AsInteger := ANumeroPedido;
    Query.Open;

    if not Query.IsEmpty then
    begin
      FNumeroPedido := Query.FieldByName('NumeroPedido').AsInteger;
      FDataEmissao := Query.FieldByName('DataEmissao').AsDateTime;
      FCodigoCliente := Query.FieldByName('CodigoCliente').AsInteger;
      FValorTotal := Query.FieldByName('ValorTotal').AsCurrency;

      Query.SQL.Text := 'SELECT * FROM PedidosProdutos WHERE NumeroPedido = :NumeroPedido';
      Query.Open;

      FProdutos.Clear;
      while not Query.Eof do
      begin
        Produto := TPedidoProduto.Create(FConexao);
        Produto.LoadFromDatabase(Query.FieldByName('Autoincrem').AsInteger, ANumeroPedido);
        FProdutos.Add(Produto);
        Query.Next;
      end;
    end
    else
      raise Exception.Create('Pedido não encontrado!');
  finally
    Query.Free;
  end;
end;

procedure TPedido.SaveToDatabase;
var
  Query: TFDQuery;
  Produto: TPedidoProduto;
begin
  Query := TFDQuery.Create(nil);
  try
    FConexao.StartTransaction;
    try
      if FNumeroPedido = 0 then
      begin
        Query.SQL.Text := 'INSERT INTO Pedidos (DataEmissao, CodigoCliente, ValorTotal) VALUES (:DataEmissao, :CodigoCliente, :ValorTotal)';
        Query.ParamByName('DataEmissao').AsDate := FDataEmissao;
        Query.ParamByName('CodigoCliente').AsInteger := FCodigoCliente;
        Query.ParamByName('ValorTotal').AsCurrency := FValorTotal;
        Query.ExecSQL;

        Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS NumeroPedido';
        Query.Open;
        FNumeroPedido := Query.FieldByName('NumeroPedido').AsInteger;
      end
      else
      begin
        Query.SQL.Text := 'UPDATE Pedidos SET DataEmissao = :DataEmissao, CodigoCliente = :CodigoCliente, ValorTotal = :ValorTotal WHERE NumeroPedido = :NumeroPedido';
        Query.ParamByName('DataEmissao').AsDate := FDataEmissao;
        Query.ParamByName('CodigoCliente').AsInteger := FCodigoCliente;
        Query.ParamByName('ValorTotal').AsCurrency := FValorTotal;
        Query.ParamByName('NumeroPedido').AsInteger := FNumeroPedido;
        Query.ExecSQL;
      end;

      for Produto in FProdutos do
        Produto.SaveToDatabase(FNumeroPedido);

      FConexao.Commit;
    except
      FConexao.Rollback;
      raise;
    end;
  finally
    Query.Free;
  end;
end;

procedure TPedido.DeleteFromDatabase;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'DELETE FROM PedidosProdutos WHERE NumeroPedido = :NumeroPedido';
    Query.ParamByName('NumeroPedido').AsInteger := FNumeroPedido;
    Query.ExecSQL;

    Query.SQL.Text := 'DELETE FROM Pedidos WHERE NumeroPedido = :NumeroPedido';
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.

