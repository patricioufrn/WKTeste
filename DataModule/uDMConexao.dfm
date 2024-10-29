object DMConexao: TDMConexao
  OnCreate = DataModuleCreate
  Height = 750
  Width = 539
  PixelsPerInch = 120
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=dbvendas'
      'User_Name=root'
      'Password=123456'
      'Server=localhost'
      'UseSSL=true'
      'DriverID=MySQL')
    Left = 120
    Top = 128
  end
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    Left = 312
    Top = 136
  end
  object SQLConnection: TSQLConnection
    LoginPrompt = False
    Left = 112
    Top = 336
  end
  object ADOConnection: TADOConnection
    Left = 312
    Top = 336
  end
end
