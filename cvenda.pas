unit cVenda;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, cVendaItem, contnrs;

type

  { TVenda }

  TVenda = class
    Private
      FNumero: Integer;
      FData: TDateTime;
      FItensVenda: TObjectList;
      function getValor: Currency;
    published
      property Data: TDateTime read FData write FData;
      property ItensVenda: TObjectList read FItensVenda write FItensVenda;
      property Valor: Currency read getValor;
      property Numero: Integer read FNumero write FNumero;
    public
      constructor Create();
      procedure addItem(aItem: TVendaItem);
      procedure remItem(aItem: TVendaItem);
      procedure deleteItem(aIndice: Integer);
      function impressaoItens: String;
  end;

implementation

{ TVenda }

function TVenda.getValor: Currency;
var
  i: Integer;
begin
  Result := 0;
  for i:=0 to FItensVenda.Count-1 do
  begin
    Result := Result + (FItensVenda.Items[i] as TVendaItem).ValorTotal;
  end;
end;

constructor TVenda.Create();
begin
  FData := Now;
  FItensVenda := TObjectList.Create();
end;

procedure TVenda.addItem(aItem: TVendaItem);
var
  i: Integer;
begin
  for i:=0 to FItensVenda.Count-1 do
  begin
     if (FItensVenda.Items[i] as TVendaItem).Produto = aItem.Produto then
     begin
       (FItensVenda.Items[i] as TVendaItem).Quantidade := (FItensVenda.Items[i] as TVendaItem).Quantidade + aItem.Quantidade;
       Exit;
     end;
  end;
  FItensVenda.Add(aItem);
end;

procedure TVenda.remItem(aItem: TVendaItem);
var
  i: Integer;
begin
  for i:=0 to FItensVenda.Count-1 do
  begin
     if (FItensVenda.Items[i] as TVendaItem).Produto = aItem.Produto then
     begin
       (FItensVenda.Items[i] as TVendaItem).Quantidade := (FItensVenda.Items[i] as TVendaItem).Quantidade - aItem.Quantidade;
       if (FItensVenda.Items[i] as TVendaItem).Quantidade = 0 then
       begin
          FItensVenda.Delete(i);
          Exit;
       end;

       Exit;
     end;
  end;
end;

procedure TVenda.deleteItem(aIndice: Integer);
begin
  FItensVenda.Delete(aIndice);
end;

function TVenda.impressaoItens: String;
var
  docImprimir: String;
  i,j: Integer;
begin
  docImprimir:='';
  for i:=0 to FItensVenda.Count-1 do
  begin
    for j:=1 to (FItensVenda.Items[i] as TVendaItem).Quantidade do
    begin
      docImprimir+=#13#10+'------------------------------------------------';
      docImprimir+=#13#10+#27+#69'            Oratorio Domingos Savio             '+#27+#70;
      docImprimir+=#13#10+'------------------------------------------------';
      docImprimir+=#13#10+'      Venda N. '+IntToStr(FNumero)+' -- '+DateTimeToStr(FData);
      docImprimir+=#13#10+'------------------------------------------------';
      docImprimir+=#13#10+#27+#87+#49+UpperCase((FItensVenda.Items[i] as TVendaItem).Descricao)+#27+#87+#48;
      docImprimir+=#13#10+'------------------------------------------------';
      docImprimir+=#13#10+'              Festa Dom Bosco 2017          ';
      docImprimir+=#13#10+'            Agradecemos sua Presenca        ';
      docImprimir+=#13#10+' ';
      docImprimir+=#27+'m';
    end;
  end;
  Result:=docImprimir;
end;

end.

