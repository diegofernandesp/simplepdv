unit unfFuncoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, LCLType, IniFiles;

  procedure enviarParaImpressora(impressora: String; conteudo: String);
  function pergunta(texto: String): boolean;
  function carregarValorINI(arquivo, grupo, variavel: String): String;
  function repl(texto: String; tamanho: Integer): String;

var
  ARQUIVO_INI : String;

implementation

procedure enviarParaImpressora(impressora: String; conteudo: String);
var  documento : textfile;
begin
  AssignFile(documento, impressora);
  TRY
    Rewrite(documento);
    writeln(documento, conteudo);
  FINALLY
    CloseFile(documento);
  END;
end;

function pergunta(texto: String): boolean;
var
   Reply, BoxStyle: Integer;
begin
   BoxStyle := MB_ICONQUESTION + MB_YESNO;
   Reply := Application.MessageBox(PChar(texto), 'Halconn Softwares', BoxStyle);
   if Reply = IDYES then
      Result := True
   else
      Result := False;
end;

function carregarValorINI(arquivo, grupo, variavel: String): String;
var
  ArquivoINI: TIniFile;
  valor : string;
begin
  ArquivoINI := TIniFile.Create(arquivo);
  valor := ArquivoINI.ReadString(grupo, variavel, 'Erro ao ler o valor');
  ArquivoINI.Free;
  Result := valor;
end;

function repl(texto: String; tamanho: Integer): String;
var
  i: Integer;
begin
  Result := '';
  for i:=0 to tamanho-1 do
  begin
     if Copy(texto,i+1,1) <> '' then
        Result := Result+Copy(texto,i+1,1)
     else
        Result := Result+' ';
  end;
end;

end.

