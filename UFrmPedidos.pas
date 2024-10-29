unit UFrmPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, FireDAC.Comp.Client, uCliente;

type
  TFrmPedidos = class(TForm)
    Panel1: TPanel;
    EditCodigoCliente: TEdit;
    Label1: TLabel;
    EditNomeCliente: TEdit;
    BtnBuscarCliente: TButton;
    Label2: TLabel;
    EditCidade: TEdit;
    Label3: TLabel;
    EditUF: TEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    Label4: TLabel;
    EditCodigoProduto: TEdit;
    Label5: TLabel;
    EditQuantidade: TEdit;
    EditDescricaoProduto: TEdit;
    EditValorUnitario: TEdit;
    Label6: TLabel;
    BtnAdicionarProduto: TButton;
    Panel4: TPanel;
    Label7: TLabel;
    LabelTotalPedido: TLabel;
    BtnGravarPedido: TButton;
    BtnCancelarPedido: TButton;
    BtnCarregarPedido: TButton;
    GridProdutos: TStringGrid;
    procedure BtnBuscarClienteClick(Sender: TObject);
    procedure BtnAdicionarProdutoClick(Sender: TObject);
    procedure BtnGravarPedidoClick(Sender: TObject);
    procedure BtnCarregarPedidoClick(Sender: TObject);
    procedure BtnCancelarPedidoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure EditCodigoClienteKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure AtualizarTotalPedido;
  public
    { Public declarations }
  end;

var
  FrmPedidos: TFrmPedidos;

implementation

{$R *.dfm}

uses uDMConexao;

procedure TFrmPedidos.BtnBuscarClienteClick(Sender: TObject);
var
  CodigoCliente: Integer;
  Cliente: TCliente;
begin
  CodigoCliente := StrToIntDef(EditCodigoCliente.Text, 0);
  if CodigoCliente = 0 then
  begin
    ShowMessage('Por favor, insira um código de cliente válido.');
    Exit;
  end;

  try
    Cliente := DMConexao.BuscarClientePorCodigo(CodigoCliente);
    try
      EditNomeCliente.Text := Cliente.Nome;
      EditCidade.Text := Cliente.Cidade;
      EditUF.Text := Cliente.UF;
    finally
      Cliente.Free;
    end;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

procedure TFrmPedidos.BtnAdicionarProdutoClick(Sender: TObject);
var
  CodigoProduto, Quantidade: Integer;
  ValorUnitario, ValorTotal: Currency;
  DescricaoProduto: string;
  Query: TFDQuery;
begin
  CodigoProduto := StrToIntDef(EditCodigoProduto.Text, 0);
  Quantidade := StrToIntDef(EditQuantidade.Text, 0);

  if (CodigoProduto = 0) or (Quantidade = 0) then
  begin
    ShowMessage('Por favor, insira valores válidos para o código do produto e quantidade.');
    Exit;
  end;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DMConexao.FDConnection;
    Query.SQL.Text := 'SELECT Descricao, PrecoVenda FROM Produtos WHERE Codigo = :CodigoProduto';
    Query.ParamByName('CodigoProduto').AsInteger := CodigoProduto;
    Query.Open;

    if Query.IsEmpty then
    begin
      ShowMessage('Produto não encontrado.');
      Exit;
    end;

    DescricaoProduto := Query.FieldByName('Descricao').AsString;
    ValorUnitario := Query.FieldByName('PrecoVenda').AsCurrency;
  finally
    Query.Free;
  end;

  ValorTotal := Quantidade * ValorUnitario;

  with GridProdutos do
  begin
    RowCount := RowCount + 1;
    Cells[0, RowCount - 1] := IntToStr(CodigoProduto);
    Cells[1, RowCount - 1] := DescricaoProduto;
    Cells[2, RowCount - 1] := IntToStr(Quantidade);
    Cells[3, RowCount - 1] := CurrToStrF(ValorUnitario, ffCurrency, 2);
    Cells[4, RowCount - 1] := CurrToStrF(ValorTotal, ffCurrency, 2);
  end;

  AtualizarTotalPedido;

  EditCodigoProduto.Clear;
  EditQuantidade.Clear;
  EditValorUnitario.Text := CurrToStrF(ValorUnitario, ffCurrency, 2);
end;

procedure TFrmPedidos.BtnGravarPedidoClick(Sender: TObject);
var
  Query: TFDQuery;
  NumeroPedido, CodigoCliente: Integer;
  DataEmissao: TDate;
  ValorTotal: Currency;
begin
  CodigoCliente := StrToIntDef(EditCodigoCliente.Text, 0);
  DataEmissao := Date;
  ValorTotal := StrToFloatDef(LabelTotalPedido.Caption, 0);

  if CodigoCliente = 0 then
  begin
    ShowMessage('Selecione um cliente para o pedido.');
    Exit;
  end;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DMConexao.FDConnection;
    DMConexao.FDConnection.StartTransaction;

    try
      Query.SQL.Text := 'INSERT INTO Pedidos (DataEmissao, CodigoCliente, ValorTotal) ' +
                        'VALUES (:DataEmissao, :CodigoCliente, :ValorTotal)';
      Query.ParamByName('DataEmissao').AsDate := DataEmissao;
      Query.ParamByName('CodigoCliente').AsInteger := CodigoCliente;
      Query.ParamByName('ValorTotal').AsFloat := ValorTotal;
      Query.ExecSQL;

      Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS NumeroPedido';
      Query.Open;
      NumeroPedido := Query.FieldByName('NumeroPedido').AsInteger;

      for var I := 1 to GridProdutos.RowCount - 1 do
      begin
        var CodigoProduto := StrToIntDef(GridProdutos.Cells[0, I], 0);
        var Quantidade := StrToIntDef(GridProdutos.Cells[2, I], 0);
        var ValorUnitario := StrToFloatDef(GridProdutos.Cells[3, I], 0);
        var ValorTotalItem := StrToFloatDef(GridProdutos.Cells[4, I], 0);

        Query.SQL.Text := 'INSERT INTO ItensPedido (NumeroPedido, CodigoProduto, Quantidade, ValorUnitario, ValorTotal) ' +
                          'VALUES (:NumeroPedido, :CodigoProduto, :Quantidade, :ValorUnitario, :ValorTotal)';
        Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
        Query.ParamByName('CodigoProduto').AsInteger := CodigoProduto;
        Query.ParamByName('Quantidade').AsInteger := Quantidade;
        Query.ParamByName('ValorUnitario').AsFloat := ValorUnitario;
        Query.ParamByName('ValorTotal').AsFloat := ValorTotalItem;
        Query.ExecSQL;
      end;

      DMConexao.FDConnection.Commit;
      ShowMessage('Pedido gravado com sucesso.');

      EditCodigoCliente.Clear;
      EditNomeCliente.Clear;
      EditCidade.Clear;
      EditUF.Clear;
      LabelTotalPedido.Caption := '0,00';
      GridProdutos.RowCount := 1;

    except
      on E: Exception do
      begin
        DMConexao.FDConnection.Rollback;
        ShowMessage('Erro ao gravar o pedido: ' + E.Message);
      end;
    end;

  finally
    Query.Free;
  end;
end;

procedure TFrmPedidos.EditCodigoClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (StrToIntDef(Trim(EditCodigoCliente.Text),0) > 0) then
    BtnBuscarCliente.Click;
end;

procedure TFrmPedidos.EditCodigoProdutoKeyPress(Sender: TObject; var Key: Char);
var
  CodigoProduto: Integer;
  Query: TFDQuery;
begin
  if Key = #13 then
  begin
    Key := #0;

    CodigoProduto := StrToIntDef(EditCodigoProduto.Text, 0);
    if CodigoProduto = 0 then
    begin
      ShowMessage('Por favor, insira um código de produto válido.');
      Exit;
    end;

    Query := TFDQuery.Create(nil);
    try
      Query.Connection := DMConexao.FDConnection;
      Query.SQL.Text := 'SELECT Descricao, PrecoVenda FROM Produtos WHERE Codigo = :CodigoProduto';
      Query.ParamByName('CodigoProduto').AsInteger := CodigoProduto;
      Query.Open;

      if not Query.IsEmpty then
      begin
        EditDescricaoProduto.Text := Query.FieldByName('Descricao').AsString;
        EditValorUnitario.Text := CurrToStrF(Query.FieldByName('PrecoVenda').AsCurrency, ffCurrency, 2);
      end
      else
      begin
        ShowMessage('Produto não encontrado.');
        EditDescricaoProduto.Clear;
        EditValorUnitario.Clear;
      end;

    finally
      Query.Free;
    end;
  end;
end;

procedure TFrmPedidos.BtnCarregarPedidoClick(Sender: TObject);
var
  NumeroPedido: Integer;
  Query: TFDQuery;
  CodigoCliente: Integer;
begin
  NumeroPedido := StrToIntDef(InputBox('Carregar Pedido', 'Digite o número do pedido:', ''), 0);
  if NumeroPedido = 0 then
  begin
    ShowMessage('Número do pedido inválido.');
    Exit;
  end;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DMConexao.FDConnection;

    Query.SQL.Text := 'SELECT Numero, DataEmissao, CodigoCliente, ValorTotal ' +
                      'FROM Pedidos WHERE Numero = :NumeroPedido';
    Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
    Query.Open;

    if Query.IsEmpty then
    begin
      ShowMessage('Pedido não encontrado.');
      Exit;
    end;

    CodigoCliente := Query.FieldByName('CodigoCliente').AsInteger;
    EditCodigoCliente.Text := IntToStr(CodigoCliente);
    EditNomeCliente.Text := '';
    EditCidade.Text := '';
    EditUF.Text := '';
    LabelTotalPedido.Caption := FormatFloat('R$ #,##0.00', Query.FieldByName('ValorTotal').AsFloat);

    var Cliente := DMConexao.BuscarClientePorCodigo(CodigoCliente);
    if Assigned(Cliente) then
    begin
      try
        EditNomeCliente.Text := Cliente.Nome;
        EditCidade.Text := Cliente.Cidade;
        EditUF.Text := Cliente.UF;
      finally
        Cliente.Free;
      end;
    end;

    Query.SQL.Text := 'SELECT CodigoProduto, Quantidade, ValorUnitario, ValorTotal ' +
                      'FROM ItensPedido WHERE NumeroPedido = :NumeroPedido';
    Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
    Query.Open;

    GridProdutos.RowCount := 1;
    while not Query.Eof do
    begin
      GridProdutos.RowCount := GridProdutos.RowCount + 1;
      GridProdutos.Cells[0, GridProdutos.RowCount - 1] := Query.FieldByName('CodigoProduto').AsString;
      GridProdutos.Cells[1, GridProdutos.RowCount - 1] := 'Descrição do Produto'; // Substituir pela descrição real
      GridProdutos.Cells[2, GridProdutos.RowCount - 1] := Query.FieldByName('Quantidade').AsString;
      GridProdutos.Cells[3, GridProdutos.RowCount - 1] := FormatFloat('R$ #,##0.00', Query.FieldByName('ValorUnitario').AsFloat);
      GridProdutos.Cells[4, GridProdutos.RowCount - 1] := FormatFloat('R$ #,##0.00', Query.FieldByName('ValorTotal').AsFloat);

      Query.Next;
    end;

  finally
    Query.Free;
  end;
end;

procedure TFrmPedidos.BtnCancelarPedidoClick(Sender: TObject);
var
  NumeroPedido: Integer;
  Query: TFDQuery;
begin
  NumeroPedido := StrToIntDef(InputBox('Cancelar Pedido', 'Digite o número do pedido a cancelar:', ''), 0);
  if NumeroPedido = 0 then
  begin
    ShowMessage('Número do pedido inválido.');
    Exit;
  end;

  if MessageDlg('Tem certeza de que deseja cancelar o pedido número ' + IntToStr(NumeroPedido) + '?',
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := DMConexao.FDConnection;
    DMConexao.FDConnection.StartTransaction;

    try
      Query.SQL.Text := 'DELETE FROM ItensPedido WHERE NumeroPedido = :NumeroPedido';
      Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
      Query.ExecSQL;

      Query.SQL.Text := 'DELETE FROM Pedidos WHERE Numero = :NumeroPedido';
      Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
      Query.ExecSQL;

      DMConexao.FDConnection.Commit;
      ShowMessage('Pedido cancelado com sucesso.');

      EditCodigoCliente.Clear;
      EditNomeCliente.Clear;
      EditCidade.Clear;
      EditUF.Clear;
      LabelTotalPedido.Caption := '0,00';
      GridProdutos.RowCount := 1;

    except
      on E: Exception do
      begin
        DMConexao.FDConnection.Rollback;
        ShowMessage('Erro ao cancelar o pedido: ' + E.Message);
      end;
    end;

  finally
    Query.Free;
  end;
end;

procedure TFrmPedidos.AtualizarTotalPedido;
var
  I: Integer;
  Total: Currency;
begin
  Total := 0;
  for I := 1 to GridProdutos.RowCount - 1 do
  begin
    Total := Total + StrToFloatDef(GridProdutos.Cells[4, I], 0);
  end;
  LabelTotalPedido.Caption := CurrToStrF(Total, ffCurrency, 2);
end;

procedure TFrmPedidos.FormCreate(Sender: TObject);
begin
  with GridProdutos do
  begin
    ColCount := 5;
    Cells[0, 0] := 'Código Produto';
    Cells[1, 0] := 'Descrição';
    Cells[2, 0] := 'Quantidade';
    Cells[3, 0] := 'Valor Unitário';
    Cells[4, 0] := 'Valor Total';
  end;
end;

end.
