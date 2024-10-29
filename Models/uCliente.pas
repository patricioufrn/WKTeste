unit uCliente;

interface

uses
  FireDAC.Comp.Client, System.SysUtils;

type
  TCliente = class
  private
    FCodigo: Integer;
    FNome: string;
    FCidade: string;
    FUF: string;
    FConexao: TFDConnection;
  public
    constructor Create;
    procedure LoadFromDatabase(ACodigo: Integer);
    procedure SaveToDatabase;
    procedure DeleteFromDatabase;

    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
  end;

implementation

{ TCliente }

constructor TCliente.Create;
begin
  inherited Create;
end;

procedure TCliente.LoadFromDatabase(ACodigo: Integer);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'SELECT Codigo, Nome, Cidade, UF FROM Clientes WHERE Codigo = :Codigo';
    Query.ParamByName('Codigo').AsInteger := ACodigo;
    Query.Open;

    if not Query.IsEmpty then
    begin
      FCodigo := Query.FieldByName('Codigo').AsInteger;
      FNome := Query.FieldByName('Nome').AsString;
      FCidade := Query.FieldByName('Cidade').AsString;
      FUF := Query.FieldByName('UF').AsString;
    end
    else
      raise Exception.Create('Cliente não encontrado!');
  finally
    Query.Free;
  end;
end;

procedure TCliente.SaveToDatabase;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    if FCodigo = 0 then
    begin
      Query.SQL.Text := 'INSERT INTO Clientes (Nome, Cidade, UF) VALUES (:Nome, :Cidade, :UF)';
      Query.ParamByName('Nome').AsString := FNome;
      Query.ParamByName('Cidade').AsString := FCidade;
      Query.ParamByName('UF').AsString := FUF;
      Query.ExecSQL;

      Query.SQL.Text := 'SELECT LAST_INSERT_ID() AS Codigo';
      Query.Open;
      FCodigo := Query.FieldByName('Codigo').AsInteger;
    end
    else
    begin
      Query.SQL.Text := 'UPDATE Clientes SET Nome = :Nome, Cidade = :Cidade, UF = :UF WHERE Codigo = :Codigo';
      Query.ParamByName('Nome').AsString := FNome;
      Query.ParamByName('Cidade').AsString := FCidade;
      Query.ParamByName('UF').AsString := FUF;
      Query.ParamByName('Codigo').AsInteger := FCodigo;
      Query.ExecSQL;
    end;
  finally
    Query.Free;
  end;
end;

procedure TCliente.DeleteFromDatabase;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConexao;
    Query.SQL.Text := 'DELETE FROM Clientes WHERE Codigo = :Codigo';
    Query.ParamByName('Codigo').AsInteger := FCodigo;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.

