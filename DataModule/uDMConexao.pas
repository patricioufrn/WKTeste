unit uDMConexao;

interface

uses
  System.SysUtils, System.Classes, Data.DB, IniFiles, Vcl.Forms, Dialogs,
  FireDAC.Comp.Client, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.Stan.Def,
  FireDAC.Stan.Async, FireDAC.Stan.Option, FireDAC.Stan.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Pool, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, SqlExpr, Data.Win.ADODB,
  FireDAC.Stan.Error, FireDAC.Phys, Data.DBXMySQL, uCliente;

type
  TDMConexao = class(TDataModule)
    FDConnection: TFDConnection;
    SQLConnection: TSQLConnection;
    ADOConnection: TADOConnection;
    FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    FConnectionType: string;
    procedure ConfigurarConexaoFireDAC;
    procedure ConfigurarConexaoDBExpress;
    procedure ConfigurarConexaoADO;
    procedure CarregarConfiguracao;
  public
    procedure Conectar;
    function BuscarClientePorCodigo(CodigoCliente: Integer): TCliente;
  end;

var
  DMConexao: TDMConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDMConexao.BuscarClientePorCodigo(CodigoCliente: Integer): TCliente;
var
  Query: TFDQuery;
  Cliente: TCliente;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'SELECT Codigo, Nome, Cidade, UF FROM Clientes WHERE Codigo = :CodigoCliente';
    Query.ParamByName('CodigoCliente').AsInteger := CodigoCliente;
    Query.Open;

    if not Query.IsEmpty then
    begin
      Cliente := TCliente.Create;
      Cliente.Codigo := Query.FieldByName('Codigo').AsInteger;
      Cliente.Nome := Query.FieldByName('Nome').AsString;
      Cliente.Cidade := Query.FieldByName('Cidade').AsString;
      Cliente.UF := Query.FieldByName('UF').AsString;
      Result := Cliente;
    end;
  finally
    Query.Free;
  end;
end;

procedure TDMConexao.CarregarConfiguracao;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  try
    FConnectionType := IniFile.ReadString('Database', 'ConnectionType', 'FireDAC');
  finally
    IniFile.Free;
  end;
end;

procedure TDMConexao.ConfigurarConexaoFireDAC;
var
  IniFile: TIniFile;
  Database, Username, Server, Password, LibraryPath: string;
  Port: Integer;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  try
    Database := IniFile.ReadString('Database', 'Database', '');
    Username := IniFile.ReadString('Database', 'Username', '');
    Server := IniFile.ReadString('Database', 'Server', '');
    Port := IniFile.ReadInteger('Database', 'Port', 3306);
    Password := IniFile.ReadString('Database', 'Password', '');
    LibraryPath := IniFile.ReadString('Database', 'LibraryPath', '');

    FDConnection.Params.Clear;
    FDConnection.DriverName := 'MySQL';
    FDConnection.Params.Database := Database;
    FDConnection.Params.UserName := Username;
    FDConnection.Params.Password := Password;
    FDConnection.Params.Add('Server=' + Server);
    FDConnection.Params.Add('Port=' + IntToStr(Port));
    FDConnection.Params.Add('UseSSL=False');
    FDConnection.Params.Values['VendorLib'] := LibraryPath;
  finally
    IniFile.Free;
  end;
end;

procedure TDMConexao.ConfigurarConexaoDBExpress;
var
  IniFile: TIniFile;
  Database, Username, Server, Password: string;
  Port: Integer;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  try
    Database := IniFile.ReadString('Database', 'Database', '');
    Username := IniFile.ReadString('Database', 'Username', '');
    Server := IniFile.ReadString('Database', 'Server', '');
    Port := IniFile.ReadInteger('Database', 'Port', 3306);
    Password := IniFile.ReadString('Database', 'Password', '');

    SQLConnection.Params.Clear;
    SQLConnection.DriverName := 'MySQL';
    SQLConnection.Params.Values['HostName'] := Server;
    SQLConnection.Params.Values['Database'] := Database;
    SQLConnection.Params.Values['User_Name'] := Username;
    SQLConnection.Params.Values['Password'] := Password;
    SQLConnection.Params.Values['Port'] := IntToStr(Port);

    SQLConnection.LoginPrompt := False;
  finally
    IniFile.Free;
  end;
end;

procedure TDMConexao.ConfigurarConexaoADO;
var
  IniFile: TIniFile;
  Database, Username, Server, Password, Provider: string;
  Port: Integer;
begin
  IniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  try
    Database := IniFile.ReadString('Database', 'Database', '');
    Username := IniFile.ReadString('Database', 'Username', '');
    Server := IniFile.ReadString('Database', 'Server', '');
    Port := IniFile.ReadInteger('Database', 'Port', 3306);
    Password := IniFile.ReadString('Database', 'Password', '');
    Provider := IniFile.ReadString('Database', 'Provider', 'MSDASQL');

    ADOConnection.ConnectionString :=
      Format('Provider=%s;Driver={MySQL ODBC 8.0 Driver};Server=%s;Port=%d;Database=%s;User ID=%s;Password=%s;',
        [Provider, Server, Port, Database, Username, Password]);
  finally
    IniFile.Free;
  end;
end;

procedure TDMConexao.Conectar;
begin
  CarregarConfiguracao;

  if UpperCase(FConnectionType) = 'FIREDAC' then
  begin
    FDConnection.Connected := False;
    ConfigurarConexaoFireDAC;
    try
      FDConnection.Connected := True;
      ShowMessage('Conectado com FireDAC');
    except
      on E: Exception do
        ShowMessage('Erro ao conectar com FireDAC: ' + E.Message);
    end;
  end
  else if UpperCase(FConnectionType) = 'DBEXPRESS' then
  begin
    SQLConnection.Connected := False;
    ConfigurarConexaoDBExpress;
    try
      SQLConnection.Connected := True;
      ShowMessage('Conectado com DBExpress');
    except
      on E: Exception do
        ShowMessage('Erro ao conectar com DBExpress: ' + E.Message);
    end;
  end
  else if UpperCase(FConnectionType) = 'ADO' then
  begin
    ADOConnection.Connected := False;
    ConfigurarConexaoADO;
    try
      ADOConnection.Connected := True;
      ShowMessage('Conectado com ADO');
    except
      on E: Exception do
        ShowMessage('Erro ao conectar com ADO: ' + E.Message);
    end;
  end
  else
    ShowMessage('Tipo de conexão inválido no arquivo config.ini');
end;

procedure TDMConexao.DataModuleCreate(Sender: TObject);
begin
  Conectar;
end;

end.

