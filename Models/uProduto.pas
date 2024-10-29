unit uProduto;

interface

uses
  FireDAC.Comp.Client, System.SysUtils;

type
  TProduto = class
  private
    FCodigo: Integer;
    FDescricao: string;
    FPrecoVenda: Currency;
    FConexao: TFDConnection;
  public
    constructor Create(AConexao: TFDConnection);
    procedure LoadFromDatabase(ACodigo: Integer);
    procedure SaveToDatabase;
    procedure DeleteFromDatabase;

    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
    property PrecoVenda: Currency read FPrecoVenda write FPrecoVenda;
  end;

implementation

{ TProduto }

constructor TProduto.Create(AConexao: TFDConnection);
begin
  FConexao := AConexao;
end;

procedure TProduto.LoadFromDatabase(ACodigo: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'SELECT Codigo, Descricao, PrecoVenda FROM Produtos WHERE Codigo = :Codigo';
    Query.ParamByName('Codigo').AsInteger := ACodigo;
    Query.Open;

    if not Query.IsEmpty then
    begin
      FCodigo := Query.FieldByName('Codigo').AsInteger;
      FDescricao := Query.FieldByName('Descricao').AsString;
      FPrecoVenda := Query.FieldByName('PrecoVenda').AsCurrency;
    end
    else
      raise Exception.Create('Produto não encontrado!');
  finally
    Query.Free;
  end;
end;

procedure TProduto.SaveToDatabase;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;

    if FCodigo = 0 then
    begin
      Query.SQL.Text := 'INSERT INTO Produtos (Descricao, PrecoVenda) VALUES (:Descricao, :PrecoVenda)';
      Query.ParamByName('Descricao').AsString := FDescricao;
      Query.ParamByName('PrecoVenda').AsCurrency := FPrecoVenda;
      Query.ExecSQL;

      Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS Codigo';
      Query.Open;
      FCodigo := Query.FieldByName('Codigo').AsInteger;
    end
    else
    begin
      Query.SQL.Text := 'UPDATE Produtos SET Descricao = :Descricao, PrecoVenda = :PrecoVenda WHERE Codigo = :Codigo';
      Query.ParamByName('Descricao').AsString := FDescricao;
      Query.ParamByName('PrecoVenda').AsCurrency := FPrecoVenda;
      Query.ParamByName('Codigo').AsInteger := FCodigo;
      Query.ExecSQL;
    end;
  finally
    Query.Free;
  end;
end;

procedure TProduto.DeleteFromDatabase;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'DELETE FROM Produtos WHERE Codigo = :Codigo';
    Query.ParamByName('Codigo').AsInteger := FCodigo;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.

