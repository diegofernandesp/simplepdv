# Simple PDV

Objetivo desse projeto foi atender a uma necessidade pontual de um trabalho voluntário que eu exerço. O programa atende aos seguintes propósitos:
  - Vender produtos de forma rápida, fácil e intuitiva
  - Imprimir os produtos comprados pelos clientes em uma mini-impressora, ou impressora não-fiscal, em forma tickets. Os tickets podem ser trocados nos balcões de entrega de produtos. 
  - Totalizar os produtos vendidos e emitir um relatório totalizador ao final do dia.

# Tecnologias Utilizadas

  - Lazarus 1.6.4.
  - Firebird 2.5. 

# Hardware Homologado
Até o momento homologamos apenas a impressora Bematech MP-4200TH Usb para impressão dos tickets e relatórios.

# Como testar
Compile o programa utilizando a versão indicada do Lazarus.
Configure o arquivo PDV.INI conforme abaixo:

> [CONFIG]

> DATABASENAME=C:\PDV\DB\HOMOLOG.GDB

> IMPRESSORA=\\127.0.0.1\BEMATECH4200

DATABASENAME = Caminho onde encontra-se o arquivo de banco de dados.

IMPRESSORA = Caminho do compartilhamento da impressora ou nome da porta utilizada. Também pode ser utilizado um arquivo TXT para teste (Ex: IMPRESSORA=C:\TESTE.TXT).
