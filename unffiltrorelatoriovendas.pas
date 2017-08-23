unit unfFiltroRelatorioVendas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, LR_Class, LR_DBSet, Forms,
  Controls, Graphics, Dialogs, Buttons, StdCtrls, unfFuncoes, sqldb, db;

type

  { TfrmFiltroVendas }

  TfrmFiltroVendas = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    DTP_Data1: TDateTimePicker;
    DTP_Data2: TDateTimePicker;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    sqlVendas: TSQLQuery;
    sqlVendasDESCRICAO: TStringField;
    sqlVendasPRECOTOTAL: TFloatField;
    sqlVendasPRECOUNITARIO: TFloatField;
    sqlVendasQTDTOTAL: TFloatField;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imprimir40Colunas;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmFiltroVendas: TfrmFiltroVendas;

implementation

{$R *.lfm}

{ TfrmFiltroVendas }

procedure TfrmFiltroVendas.BitBtn1Click(Sender: TObject);
begin
  sqlVendas.Close;
  sqlVendas.SQL.Clear;
  sqlVendas.SQL.Add('select                                                            ');
  sqlVendas.SQL.Add('   descricao,                                                     ');
  sqlVendas.SQL.Add('   precounitario,                                                 ');
  sqlVendas.SQL.Add('   sum(quantidade) as qtdtotal,                                   ');
  sqlVendas.SQL.Add('   sum(quantidade*precounitario) as precototal from itensvenda    ');
  sqlVendas.SQL.Add('inner join vendas on (vendas.codigo = itensvenda.vendas)          ');
  sqlVendas.SQL.Add('inner join produtos on (produtos.codigo = itensvenda.produtos)    ');
  sqlVendas.SQL.Add('where cast(vendas.data as date) between :pdata1 and :pdata2       ');
  sqlVendas.Params.ParamByName('pdata1').AsDate:= DTP_Data1.Date;
  sqlVendas.Params.ParamByName('pdata2').AsDate:= DTP_Data2.Date;
  sqlVendas.SQL.Add('and coalesce(cancelado,''N'') <> ''S''                            ');
  sqlVendas.SQL.Add('group by 1,2                                                      ');
  sqlVendas.SQL.Add('order by 1,2                                                      ');
  sqlVendas.Open;

  if CheckBox1.Checked then
  begin
     imprimir40Colunas;
     ShowMessage('Documento enviado com sucesso!');
  end
  else
  begin
     frReport1.LoadFromFile(ExtractFilePath(Application.ExeName)+'\Reports\RelatorioVendas.lrf');
     frReport1.ShowReport;
  end;
end;

procedure TfrmFiltroVendas.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmFiltroVendas.FormCreate(Sender: TObject);
begin
  DTP_Data1.Date:= now;
  DTP_Data2.Date:= now;
end;

procedure TfrmFiltroVendas.imprimir40Colunas;
var
  conteudo: String;
  total: Double;
begin
  conteudo :=         '------------------------------------------';
  conteudo += #13#10+ '        Oratorio Sao Domingos Savio       ';
  conteudo += #13#10+ '            Relatorio de Vendas           ';
  conteudo += #13#10+ '------------------------------------------';
  conteudo += #13#10+ 'DESCRICAO                 QTD    VL. TOT  ';
 sqlVendas.First;
  total := 0;
  while not sqlVendas.eof do
  begin
    conteudo += #13#10+ repl(sqlVendasDESCRICAO.AsString, 25) + ' ' +
                        repl(sqlVendasQTDTOTAL.AsString, 6) + ' ' +
                        FormatFloat('#,##0.00', sqlVendasPRECOTOTAL.AsFloat);
    total:= total+sqlVendasPRECOTOTAL.AsFloat;
    sqlVendas.Next;
  end;
  conteudo += #13#10+ '------------------------------------------';
  conteudo += #13#10+ '        Valor Total: R$'+FormatFloat('#,##0.00',total);
  conteudo += #13#10+ '------------------------------------------';
  conteudo += #13#10+ 'Piquete/SP '+DateTimeToStr(Now);
  conteudo += #13#10+ '------------------------------------------';
  conteudo += #13#10+' ';
  conteudo += #13#10+' ';
  conteudo += #13#10+' ';
  conteudo += #13#10+' ';
  conteudo += #13#10+' ';
  conteudo += #27+'m';
  enviarParaImpressora(carregarValorINI(ARQUIVO_INI, 'CONFIG', 'IMPRESSORA'), conteudo);
end;

end.

