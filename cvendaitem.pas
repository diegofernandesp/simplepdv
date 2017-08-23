unit cVendaItem;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TVendaItem }

  TVendaItem = class
    Private
      FProduto: Integer;
      FQuantidade: Integer;
      FDescricao: String;
      FValorUnitario: Currency;
      function getValorTotal: Currency;
    published
      property Produto: Integer read FProduto write FProduto;
      property Quantidade: Integer read FQuantidade write FQuantidade;
      property Descricao: String read FDescricao write FDescricao;
      property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
      property ValorTotal: Currency read getValorTotal;
    public
      constructor Create(aProduto: Integer; aDescricao: String; aQuantidade: Integer; aValorUnitario: Double);
  end;

implementation

{TVenda}

function TVendaItem.getValorTotal: Currency;
begin
  Result := FQuantidade * FValorUnitario;
end;

constructor TVendaItem.Create(aProduto: Integer; aDescricao: String; aQuantidade: Integer;
  aValorUnitario: Double);
begin
  FProduto := aProduto;
  FDescricao := aDescricao;
  FQuantidade := aQuantidade;
  FValorUnitario := aValorUnitario;
end;

end.

