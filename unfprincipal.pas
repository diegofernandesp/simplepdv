unit unfPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, db, FileUtil, LR_Class, LR_DBSet,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, DBGrids, Buttons,
  cVenda, cVendaItem, unfPagamento, unfFuncoes, unfFiltroRelatorioVendas,
  contnrs, Grids, Menus;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    btnLimpar: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    DBGrid1: TDBGrid;
    dtsProdutos: TDataSource;
    edtValorTotal: TEdit;
    IBConnection1: TIBConnection;
    imgRem: TImage;
    imgAdd: TImage;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Panel1: TPanel;
    sqlProdutos: TSQLQuery;
    sqlGravar: TSQLQuery;
    sqlProdutosATIVO: TStringField;
    sqlProdutosCODIGO: TLongintField;
    sqlProdutosDESCRICAO: TStringField;
    sqlProdutosPRECO: TFloatField;
    SQLTransaction1: TSQLTransaction;
    procedure btnLimparClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure atualizaTela();
    procedure lancarItem(addRem: String);
    procedure limparTela();
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);

    function pagamento: Boolean;
    function gravarVenda: Integer;
    function valorGenerator(gen: String; inc: Integer): Integer;
  private
    { private declarations }
    venda: TVenda;
  public
    { public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.atualizaTela;
var
  i: Integer;
begin
  memo1.lines.clear;
  Memo1.Lines.Add('------------------------------------------');
  Memo1.Lines.Add('        Oratório Sao Domingos Savio');
  Memo1.Lines.Add('          Festa de Dom Bosco 2017');
  Memo1.Lines.Add('------------------------------------------');
  Memo1.Lines.Add('Cód  Desc                  Qtd  Total(R$) ');
  for i:=0 to venda.ItensVenda.Count-1 do
  begin
     Memo1.Lines.Add(
                     repl(IntToStr((venda.ItensVenda.Items[i] as TVendaItem).Produto ),4) + ' ' +
                     repl((venda.ItensVenda.Items[i] as TVendaItem).Descricao, 21) + ' ' +
                     repl(FloatToStr((venda.ItensVenda.Items[i] as TVendaItem).Quantidade), 4) + ' ' +
                     FormatFloat('#,##0.00', (venda.ItensVenda.Items[i] as TVendaItem).ValorTotal)
     );
  end;
  Memo1.Lines.Add('------------------------------------------');
  Memo1.Lines.Add('Total: R$ '+FormatFloat('#,##0.00', (venda.Valor)));
  Memo1.Lines.Add('------------------------------------------');
  Memo1.Lines.Add('              Deus o Abencoe');

  edtValorTotal.Text:= 'R$ ' + FormatFloat('#,##0.00', (venda.Valor));
end;

procedure TfrmPrincipal.lancarItem(addRem: String);
var
   item: TVendaItem;
begin
   if venda = Nil then
   begin
      venda := TVenda.Create();
      Memo1.Lines.Clear;
   end;

   item := TVendaItem.Create(
        sqlProdutosCODIGO.AsInteger,
        sqlProdutosDESCRICAO.AsString,
        1,
        sqlProdutosPRECO.AsFloat
   );

   if addRem = 'A' then
      venda.addItem(item)
   else
      venda.remItem(item);

   atualizaTela;
end;

procedure TfrmPrincipal.limparTela;
begin
  edtValorTotal.Clear;
  venda := Nil;
end;

procedure TfrmPrincipal.MenuItem1Click(Sender: TObject);
begin

end;

procedure TfrmPrincipal.MenuItem3Click(Sender: TObject);
begin

end;

procedure TfrmPrincipal.MenuItem4Click(Sender: TObject);
begin
  if frmFiltroVendas = nil then
     frmFiltroVendas := TfrmFiltroVendas.Create(Application);
  frmFiltroVendas.ShowModal;
end;

procedure TfrmPrincipal.MenuItem5Click(Sender: TObject);
var
  idx: String;
  sqlQuery: TSQLQuery;
begin
  if not InputQuery('Informe o número da venda a cancelar', 'Cancelamento de Venda', idx) then
     Exit;

  sqlQuery := TSQLQuery.Create(Nil);
  sqlQuery.DataBase := IBConnection1;
  sqlQuery.Transaction := SQLTransaction1;

  sqlQuery.SQL.Add('update VENDAS set CANCELADO = ''S'' where CODIGO = :CODIGO');
  sqlQuery.ParamByName('CODIGO').AsInteger := StrToInt(idx);
  sqlQuery.ExecSQL;
  SQLTransaction1.CommitRetaining;
  if sqlQuery.RowsAffected = 1 then
     ShowMessage('Venda cancelada com sucesso.')
//FreeAndNil(sqlQuery);
end;

function TfrmPrincipal.pagamento: Boolean;
begin
  if frmPagamento = nil then
     frmPagamento := TfrmPagamento.Create(Nil);
  frmPagamento.valorTotal:= venda.Valor;
  frmPagamento.ShowModal;
  result := frmPagamento.confirmado;
  FreeAndNil(frmPagamento);
end;

function TfrmPrincipal.gravarVenda: Integer;
var
  i, idVenda: Integer;
begin
  idVenda:=valorGenerator('GEN_VENDAS_PK', 1);
  sqlGravar.Close;
  sqlGravar.SQL.Clear;
  sqlGravar.SQL.Add('insert into VENDAS (CODIGO, DATA, VALOR)');
  sqlGravar.SQL.Add('values (:CODIGO, :DATA, :VALOR)');
  sqlGravar.ParamByName('CODIGO').AsInteger:= idVenda;
  sqlGravar.ParamByName('DATA').AsDateTime:= venda.Data;
  sqlGravar.ParamByName('VALOR').AsCurrency:= venda.Valor;
  sqlGravar.ExecSQL;
  SQLTransaction1.CommitRetaining;

  for i:=0 to venda.ItensVenda.Count-1 do
  begin
    sqlGravar.Close;
    sqlGravar.SQL.Clear;
    sqlGravar.SQL.Add('insert into ITENSVENDA (CODIGO, VENDAS, PRODUTOS, QUANTIDADE, PRECOUNITARIO)');
    sqlGravar.SQL.Add('                values (:CODIGO, :VENDAS, :PRODUTOS, :QUANTIDADE, :PRECOUNITARIO)');
    sqlGravar.ParamByName('CODIGO').AsInteger:=valorGenerator('GEN_ITENSVENDA_PK', 1);
    sqlGravar.ParamByName('VENDAS').AsInteger:=idVenda;
    sqlGravar.ParamByName('PRODUTOS').AsInteger:=(venda.ItensVenda[i] as TVendaItem).Produto;
    sqlGravar.ParamByName('QUANTIDADE').AsInteger:=(venda.ItensVenda[i] as TVendaItem).Quantidade;
    sqlGravar.ParamByName('PRECOUNITARIO').AsCurrency:=(venda.ItensVenda[i] as TVendaItem).ValorUnitario;
    sqlGravar.ExecSQL;
    SQLTransaction1.CommitRetaining;
  end;
  Result := idVenda;
end;

function TfrmPrincipal.valorGenerator(gen: String; inc: Integer): Integer;
var
  sqlQuery: TSQLQuery;
begin
  sqlQuery := TSQLQuery.Create(Nil);
  sqlQuery.DataBase := IBConnection1;
  sqlQuery.Transaction := SQLTransaction1;

  sqlQuery.SQL.Add('select gen_id('+gen+','+IntToStr(inc)+') as VALOR from RDB$DATABASE');
  sqlQuery.Open;

  result := sqlQuery.FieldByName('VALOR').AsInteger;
  FreeAndNil(sqlQuery);
end;

procedure TfrmPrincipal.btnLimparClick(Sender: TObject);
begin
  if pergunta('Deseja relamente limpar a venda atual?') then
  begin
     limparTela();
     Memo1.Lines.Clear;
  end;
end;

procedure TfrmPrincipal.BitBtn2Click(Sender: TObject);
begin
  if pagamento then
  begin
     venda.Numero:=gravarVenda;
     enviarParaImpressora(carregarValorINI(ARQUIVO_INI, 'CONFIG', 'IMPRESSORA'), venda.impressaoItens);
     limparTela();
  end;
end;

procedure TfrmPrincipal.BitBtn3Click(Sender: TObject);
var
  idx: String;
begin
  if not InputQuery('Informe o índice do item', 'Cancelamento de Item', idx) then
     Exit;

  venda.deleteItem(StrToInt(idx)-1);
  atualizaTela();
end;

procedure TfrmPrincipal.DBGrid1CellClick(Column: TColumn);
begin
  if Column.Title.Caption = 'A' then
     lancarItem('A');

  if Column.Title.Caption = 'R' then
     lancarItem('R');
end;

procedure TfrmPrincipal.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.Title.Caption = 'A' then
  begin
     DBGrid1.Canvas.FillRect(Rect);
     DBGrid1.Canvas.Draw(Rect.Left + 6, Rect.Top + 2, imgAdd.Picture.Bitmap);
  end;

  if Column.Title.Caption = 'R' then
  begin
     DBGrid1.Canvas.FillRect(Rect);
     DBGrid1.Canvas.Draw(Rect.Left + 6, Rect.Top + 2, imgRem.Picture.Bitmap);
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  IBConnection1.Connected:= False;
  IBConnection1.DatabaseName:= carregarValorINI(ARQUIVO_INI, 'CONFIG', 'DATABASENAME');
  IBConnection1.Connected:= True;
  sqlProdutos.Open;
end;

initialization
  ARQUIVO_INI := ExtractFilePath(Application.ExeName)+'\PDV.INI';

end.

