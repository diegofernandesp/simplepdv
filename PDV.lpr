program PDV;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, unfPrincipal, cVenda, cVendaItem, unfPagamento,
  unfFuncoes, unfFiltroRelatorioVendas;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmPagamento, frmPagamento);
  Application.CreateForm(TfrmFiltroVendas, frmFiltroVendas);
  Application.Run;
end.

