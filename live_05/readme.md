# **<u>Explorando o poder do NoSQL com Cassandra e Hbase</u>**

------

[slides](./slides/slides_live_05.pdf)

Arquivos: [employees.csv](./arquivos/base_localidade.csv), [salaries.zip](./arquivos/salaries.zip) e [salaries_com_rowkey.zip](./arquivos/salaries_com_rowkey.zip) 



**HBase**

- É um BD distribuído e orientado a colunas (Column Family ou Wide Column)
- O armzenamento é esparso, distribuído, persistente, multidimensional e ordenado Map.
- Maior desvantagem do HBase é não ter uma linguagem própria como SQL e não suportar índices em colunas fora do rowkey e não suportar tabelas secundárias de índices
- Maior vantagem é a facilidade e integração com o ecossistema Hadoop
- Map é indexado por uma linha chave (row key), coluna chave (column key), e uma coluna timestamp
- Cada valor no Map é interpretado como um vetor de bytes (array of bytes)
- O array of bytes nos permite gravar portanto qualquer informação se for necessário, inclusive documentos, arquivos JSON, .csv, etc.



Comandos:
 - create: cria uma tabela
- list: lista todas as tabelas no HBase independente do namespace
- disable: desabilita uma tabela
- is_disabled: checa se uma tabela éstá desabilitada
- enable: habilita uma tabela
- is_enabled: checa se uma tabela está habilitada
- describe: exibe informações dedefinição de uma tabela
- alter altera as definições de uma tabela
- exists: verifica se uma tabela existe
- drop: exclui uma tabela
- drop_all: exclue todas tabelas que se saplicam a um padrão de nomes
  via regra de Regex

- cria namespace
create_namespace 'empresa'

- cria tabela em um namespace e com family columns
create '[<namespace>:<nome da tabela>','<nome da family column>'{propriedades}
create [empresa]:funcionarios,'pessoais','profissionais'

ATENÇÃO: Para mudar a estrutura de uma tabela, antes é preciso disabilitar a tabela.
Após desabilitar a tabela é possível listar (list) e verificar sua existência (exists), mas não poderemos escanear (scan)

- desablitar

  disable '<nome da tabela>'
  disable_all '<prefixo da tabela>.*'

- habilitar
  enable '<nome da tabela>'

- dropar
  drop '<nome da tabela>'
  drop_all '<prefixo da tabela>.*'

- verifica se a tabela já esta desativada ou ativada
  is_enabled '<nome da tabela>'
  is_disabled '<nome da tabela>'

- alterar a estrutura (schema) da tabela
  alter '<nome da tabela>', NAME=><Column familyname>, VERSION=>X

- verifica se alteração foi efetiva em todos os nós
  alter_status '<nome da tabela>'



**PRÁTICA**

```shell
#Acessando
hbase shell

# hbase>
#Listando tabelas
list

#Visualizar detalhes sobre o sistemas
status #Variações: status'simple' | status 'summary' | status 'detailed'

#Exibir versão do HBase
version

#Exibir comandos que se referenciam a uma tabela
table_help

# se ao listar as tabelas tiver algum erro pode ser que o yarn está em safemode
# então podemos desabilitar o safemode do yarn
# desabilitar
sudo -u hdfs hadoop dfsadmin -safemode leave

# habilitar
sudo -u hdfs hadoop dfsadmin -safemode enter

# como entrar no safemode não é um bom sinal
# devemos descobrir o motivo e se possível resolver
sudo -u hdfs hadoop fsck / | egrep -v '^\.+$' | grep -v eplica

# e apagar os arquivos corrompidos
sudo -u hdfs hdfs dfs -rm /hbase/WALs/bigdata-srv,60020,1611677706546/bigdata-srv%2C60020%2C1611677706546.meta.1611677793175.meta

# hbase>
# criar tabela
create 'funcionario','pessoais','profissionais'

# inserir dados
put 'funcionario', '1', 'pessoais:nome', 'Maria'
put 'funcionario', '2', 'profissionais:empresa', 'Everis'

# alterar a tabela funcionario, acrescentado column family 'hobby'
disable 'funcionario'
alter 'funcionario', NAME=>'hoppy', VERSIONS=>5

# scan a tabela até a versão 3
scan 'funcionario', {VERSIONS=>3}

# conta o núnero de registros, de acordo com o row key
count 'funcionario'

# deleta a célula da versão atual
delete 'funcionario', '1', 'hobby:nome'

# cria tabela c/ TTL (tempo de vida dos dados após serem inseridos)
create 'ttl_exemplo', {'NAME'=>'cf', 'TTL'=>20}
```



Comandos utilizados via API

-  put: insere/atualiza um valor em uma determinada célula de uma tabela

- get: consulta todo o conteúdo de uma linha ou célua em uma tabela
- delete: exclui um valor de uma célula em uma tabela
- deleteall: eclui todas as células de uma linha específica
- scan: varre toda a tabela retornando os dados contidos
- count: conta e retorna o número de linhas em uma tabelatruncate: desabilita, exclui e recria uma tabela em específico





**Cassandra**

- BD distribuído e orientado a colunas (Wide Column)

- Diferente do Hbase, os dados armazenados são tipados e há conceitos mais complexos de modelagem, como chave primária composta, partition key e cluster key

- Possui uma linguagem própria pararecida com SQL (CQL), porem algumas operações não são suportdas e/ou recomendadas, por ex. joins, alguns agrupamentos e tipos de filtros

- A recomendação para modelagem de dados no Cassandra é pensar em quais query deve ser consumidas e agregar as informações em uma tabela, evitando joins

- Uma grande diferença para o Hbase, é que o Cassandra suporta tabela secundárias de índices e permite filtros em colunas fora da primary key.



Comandos

```shell
#cqlsh>
help

Documented shell commands:
===========================
CAPTURE      COPY  DESCRIBE  EXPAND  LOGIN   SERIAL  SOURCE
CONSISTENCY  DESC  EXIT      HELP    PAGING  SHOW    TRACING

CQL help topics:
================
ALTER                        CREATE_TABLE_OPTIONS  SELECT
ALTER_ADD                    CREATE_TABLE_TYPES    SELECT_COLUMNFAMILY
ALTER_ALTER                  CREATE_USER           SELECT_EXPR
ALTER_DROP                   DELETE                SELECT_LIMIT
ALTER_RENAME                 DELETE_COLUMNS        SELECT_TABLE
ALTER_USER                   DELETE_USING          SELECT_WHERE
ALTER_WITH                   DELETE_WHERE          TEXT_OUTPUT
APPLY                        DROP                  TIMESTAMP_INPUT
ASCII_OUTPUT                 DROP_COLUMNFAMILY     TIMESTAMP_OUTPUT
BEGIN                        DROP_INDEX            TRUNCATE
BLOB_INPUT                   DROP_KEYSPACE         TYPES
BOOLEAN_INPUT                DROP_TABLE            UPDATE
COMPOUND_PRIMARY_KEYS        DROP_USER             UPDATE_COUNTERS
CREATE                       GRANT                 UPDATE_SET
CREATE_COLUMNFAMILY          INSERT                UPDATE_USING
CREATE_COLUMNFAMILY_OPTIONS  LIST                  UPDATE_WHERE
CREATE_COLUMNFAMILY_TYPES    LIST_PERMISSIONS      USE
CREATE_INDEX                 LIST_USERS            UUID_INPUT
CREATE_KEYSPACE              PERMISSIONS
CREATE_TABLE                 REVOKE
```



```shell
# subir o serviço do Cassandra
sh script_apoio/cassandra_start_all_service.sh

# entrar
cqlsh

# cql>
# Criação do keyspace(schema, namespace)
CREATE KEYSPACE empresa
WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 3};

# Criação de tabela
create table empresa.funcionario(
empregadoid int primary key,
empregadonome text,
empregadocargo text,
);

# Criação de índice secundário para consulta
CREATE INDEX rempresacargoON empresa.funcionario(empregadocargo);
```



**EXERCÍCIOS**

1. Criar uma tabela que representa lista de Cidades e que permite armazenar até 5 versões na Column Famility com os seguintes campos:
   Código da cidade como rowKey

- Column Family=info
  - Nome da Cidade
  - Data de Fundação

- Column Family=responsaveis

  - Nome Prefeito

  - Data de Posse do Prefeito

  - Nome Vice prefeito

- Column Family=estatisticas
  - Data da última Eleição
  - Quantidade de moradores
  - Quantidade de eleitores
  - Ano de fundação



**RESPOSTAS**

```shell
# EXERCÍCIO 1
# hbase>
# cria o namespace
create_namespace 'exercicio'

# cria a tabela c/ as family columns
create 'exercicio:cidade','info','responsaveis','estatisticas'

# desabilita a tabela para fazer as alterações de versão das family columns
disable 'exercicio:cidade'

# altera as versão das family columns
alter 'exercicio:cidade', NAME=>'info', VERSIONS=>5
alter 'exercicio:cidade', NAME=>'responsaveis', VERSIONS=>5
alter 'exercicio:cidade', NAME=>'responsaveis', VERSIONS=>5

# verificamos se as alterações foram efetivas
describe 'exercicio:cidade'

# habilita a tabela após as alterações
enable 'exercicio:cidade'

# Nota: as colunas serão definidas na inserção dos dados
```

2. Inserir 10 cidades na tabela criada de cidades. (feito só 5)

```shell
put 'exercicio:cidade', '1', 'info:nm_cidade', 'cidade 1'
put 'exercicio:cidade', '1', 'info:dt_fundacao', '1905-12-24'
put 'exercicio:cidade', '1', 'responsaveis:nm_prefeito', 'Joao do Bujao'
put 'exercicio:cidade', '1', 'responsaveis:dt_posse', '2021-01-01'
put 'exercicio:cidade', '1', 'responsaveis:nm_vice_prefeito', 'Picole'
put 'exercicio:cidade', '1', 'estatisticas:dt_ult_eleicao', '2020-10-15'
put 'exercicio:cidade', '1', 'estatisticas:qt_moradores', '12850'
put 'exercicio:cidade', '1', 'estatisticas:qt_eleitores', '10521'
put 'exercicio:cidade', '1', 'estatisticas:ano_fundacao', '1905'

put 'exercicio:cidade', '2', 'info:nm_cidade', 'cidade 2'
put 'exercicio:cidade', '2', 'info:dt_fundacao', '1718-01-24'
put 'exercicio:cidade', '2', 'responsaveis:nm_prefeito', 'Pedrinho'
put 'exercicio:cidade', '2', 'responsaveis:dt_posse', '2021-01-01'
put 'exercicio:cidade', '2', 'responsaveis:nm_vice_prefeito', 'Carlos Souza'
put 'exercicio:cidade', '2', 'estatisticas:dt_ult_eleicao', '2020-10-15'
put 'exercicio:cidade', '2', 'estatisticas:qt_moradores', '120850'
put 'exercicio:cidade', '2', 'estatisticas:qt_eleitores', '100521'
put 'exercicio:cidade', '2', 'estatisticas:ano_fundacao', '1718'

put 'exercicio:cidade', '3', 'info:nm_cidade', 'cidade 3'
put 'exercicio:cidade', '3', 'info:dt_fundacao', '1510-01-18'
put 'exercicio:cidade', '3', 'responsaveis:nm_prefeito', 'Salistiano'
put 'exercicio:cidade', '3', 'responsaveis:dt_posse', '2021-01-01'
put 'exercicio:cidade', '3', 'responsaveis:nm_vice_prefeito', 'Silverinha'
put 'exercicio:cidade', '3', 'estatisticas:dt_ult_eleicao', '2020-10-15'
put 'exercicio:cidade', '3', 'estatisticas:qt_moradores', '2120850'
put 'exercicio:cidade', '3', 'estatisticas:qt_eleitores', '2101500'
put 'exercicio:cidade', '3', 'estatisticas:ano_fundacao', '1510'

put 'exercicio:cidade', '4', 'info:nm_cidade', 'cidade 4'
put 'exercicio:cidade', '4', 'info:dt_fundacao', '1814-10-18'
put 'exercicio:cidade', '4', 'responsaveis:nm_prefeito', 'Chagas Neto'
put 'exercicio:cidade', '4', 'responsaveis:dt_posse', '2021-01-01'
put 'exercicio:cidade', '4', 'responsaveis:nm_vice_prefeito', 'Chagas Filho'
put 'exercicio:cidade', '4', 'estatisticas:dt_ult_eleicao', '2020-10-15'
put 'exercicio:cidade', '4', 'estatisticas:qt_moradores', '23120850'
put 'exercicio:cidade', '4', 'estatisticas:qt_eleitores', '22101500'
put 'exercicio:cidade', '4', 'estatisticas:ano_fundacao', '1814'

put 'exercicio:cidade', '5', 'info:nm_cidade', 'cidade 5'
put 'exercicio:cidade', '5', 'info:dt_fundacao', '1950-03-08'
put 'exercicio:cidade', '5', 'responsaveis:nm_prefeito', 'Pedro Pedreira'
put 'exercicio:cidade', '5', 'responsaveis:dt_posse', '2021-01-01'
put 'exercicio:cidade', '5', 'responsaveis:nm_vice_prefeito', 'Charles Silva'
put 'exercicio:cidade', '5', 'estatisticas:dt_ult_eleicao', '2020-10-15'
put 'exercicio:cidade', '5', 'estatisticas:qt_moradores', '100850'
put 'exercicio:cidade', '5', 'estatisticas:qt_eleitores', '99502'
put 'exercicio:cidade', '5', 'estatisticas:ano_fundacao', '1950'
```

3. Realizar uma contagem de linhas na tabela.

```shell
count 'exercicio:cidade'
```

4. Consultar só o código e nome da cidade.

```shell
scan 'exercicio:cidade', {COLUMNS => ['info:nm_cidade']}
```

5. Escolha uma cidade, consulte os dados dessa cidade em específico antes do próximo passo.

```shell
import org.apache.hadoop.hbase.filter.CompareFilter
import org.apache.hadoop.hbase.filter.SubstringComparator
scan 'exercicio:cidade', {FILTER => org.apache.hadoop.hbase.filter.RowFilter.new(CompareFilter::CompareOp.valueOf('EQUAL'),SubstringComparator.new("4"))}
```

6. Altere para a cidade escolhida os dados de Prefeito, Vice Prefeito e nova data de Posse.

```shell
put 'exercicio:cidade', '4', 'responsaveis:nm_prefeito', 'Chagas Neto (alterado)'
put 'exercicio:cidade', '4', 'responsaveis:dt_posse', '2021-01-15'
put 'exercicio:cidade', '4', 'responsaveis:nm_vice_prefeito', 'Chagas Filho (alterado)'
```

7. Consulte os dados da cidade alterada.

```shell
import org.apache.hadoop.hbase.filter.CompareFilter
import org.apache.hadoop.hbase.filter.SubstringComparator
scan 'exercicio:cidade', {FILTER => org.apache.hadoop.hbase.filter.RowFilter.new(CompareFilter::CompareOp.valueOf('EQUAL'),SubstringComparator.new("4"))}
```

8. Consulte todas as versões dos dados da cidade alterada.

```shell
scan 'exercicio:cidade', {FILTER => org.apache.hadoop.hbase.filter.RowFilter.new(CompareFilter::CompareOp.valueOf('EQUAL'),SubstringComparator.new("4")), VERSIONS=>5}
```

9. Exclua as três cidades com menor quantidade de habitantes e quantidade de eleitores. (só feito 2)

```sh
scan 'exercicio:cidade', {COLUMN=>['estatisticas:qt_eleitores']}
#após análise dos dados retornados, serão excluídos os ROWs 1 e 5
deleteall 'exercicio:cidade', '1'
deleteall 'exercicio:cidade', '5'
```

10. Liste todas as cidades novamente.

```shell
scan 'exercicio:cidade', {COLUMN=>['estatisticas:qt_eleitores']}
```

11. Adicione na ColumnFamily “estatísticas”, duas novas colunas de “quantidade de partidos políticos” e “Valor em Reais à partidos” para as 2 cidades mais populosas cadastradas.
scan 'exercicio:cidade', {COLUMN=>['estatisticas:qt_eleitores']}
#após análise dos dados retornados, serão incluídas as colunas nos registros c/ ROWs 3 e 4

```shell
put 'exercicio:cidade', '3', 'estatisticas:qt_partidos_politicos', '16'
put 'exercicio:cidade', '3', 'estatisticas:vl_reais_partidos_politicos', '250450,56'
put 'exercicio:cidade', '4', 'estatisticas:qt_partidos_politicos', '13'
put 'exercicio:cidade', '4', 'estatisticas:vl_reais_partidos_politicos', '870890,15'
```

12. Liste novamente todas as cidades.

```shell
scan 'exercicio:cidade', {COLUMN=>['estatisticas:qt_eleitores','estatisticas:qt_partidos_politicos','estatisticas:vl_reais_partidos_politicos']}
```

Nota: refazer os exercícios anteriores usando o Cassandra



**Carga Massiva (Bulk Insert)**

No HBase é possível realizar essa carga por esses meios mais comuns:
- Classe Utilitária do HBase [org.apache.hadoop.hbase.mapreduce.ImportTsv].
- Intermediários em script com Sqoop, aplicações em Spark, Apache Phoenix, e etc, que implementam indiretamente a Hbase API.
- External Table do Hive utilizando StorageHandler para gravar os dados no Hbase/Cassandra.
- API

Exemplo de Bulk Insert usando classe Utilitária do HBase [org.apache.hadoop.hbase.mapreduce.ImportTsv]

1. Importar o arquivo employees.csv para a pasta /home/everis/arquivos/employee.csv
2. Criar a tabela employees no Hbase com a column Familty: employee_data

```shell
# inicia hbase
hbase shell

# hbase>
# cria o namespace
create_namespace 'ex_carga_massiva'

# cria a tabela c/ as family columns
create 'ex_carga_massiva:employees','employee_data'
```

3. Criar uma pasta no HDFS pelo shell do Linux
```shell
# cria pasta
sudo -u hdfs hadoop fs -mkdir /test

#Copia os arquivos exportados para o HDFS pelo shell do Linux
hadoop fs -copyFromLocal /home/everis/arquivos/employees.csv /test/employees.csv
```

4. Executar a importação no shell do Linux

```shell
# importa os dados do arquivo no HDFS p/ a tabela do hbase
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator=';' -Dimporttsv.columns=HBASE_ROW_KEY,employee_data:birth_date,employee_data:first_name,employee_data:last_name,employee_data:gender,employee_data:hire_date ex_carga_massiva:employees /test/employees.csv
```



**Exercício**

1. Criar a tabela salaries no HBASE com o schema: emp_no, salary, from_date, to_date
```shell
# cria a tabela c/ as family columns
create 'ex_carga_massiva:salaries','salarie_data'
```

2. Efetuar a carga de dados via ImportTsvutilizando o arquivo salaries.csv

```shell
# Copia os arquivos exportados para o HDFS pelo shell do Linux
hadoop fs -copyFromLocal /home/everis/arquivos/salaries.csv /test/salaries.csv#

# importa os dados do arquivo no HDFS p/ a tabela do hbase
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator=';' -Dimporttsv.columns=HBASE_ROW_KEY,salarie_data:salary,salarie_data:from_date,salarie_data:to_date, ex_carga_massiva:salaries /test/salaries.csv
```





3. Verificar a quantidade na tabela carregada versus a quantidade de linhas do arquivo.

```shell
#hbase>
# quantidade de linhas carregadas: 144.925
count 'ex_carga_massiva:salaries'

# quantidade de linhas do arquivo: 1.376.056
hdfs dfs -cat /test/salaries.csv|wc -l
```

4. Crie a tabela salaries_concatenado agora para o arquivo salaries_com_row_key.csv, observe que esse arquivo tem uma coluna a mais que é a row_key concatenada.
```shell
#hbase>
# cria a tabela c/ as family columns
create 'ex_carga_massiva:salaries_concatenado', 'salarie_concat_data'

#Copia os arquivos exportados para o HDFS pelo shell do Linux
hadoop fs -copyFromLocal /home/everis/arquivos/salaries_com_rowkey.csv /test/salaries_com_rowkey.csv

# importa os dados do arquivo no HDFS p/ a tabela do hbase
# nota: entre os nomes das colunas não pode haver espaço
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator=';' -Dimporttsv.columns=HBASE_ROW_KEY,salarie_concat_data:emp_no,salarie_concat_data:salary,salarie_concat_data:from_date,salarie_concat_data:to_date, ex_carga_massiva:salaries_concatenado /test/salaries_com_rowkey.csv

# quantidade de linhas carregadas: 1.376.056
count 'ex_carga_massiva:salaries'

# quantidade de linhas do arquivo: 1.376.056
hdfs dfs -cat /test/salaries_com_rowkey.csv|wc -l 
```

5. Porque o primeiro arquivos carregou menos registros?
    Resposta: Porque ele sobrescreveu todas as linhas com a mesma ROW_KEY, ficando apenas o value da última carregada

  

**Integração NoSQL com Hadoop**

- É possível realizar essa integração utilizando a implementação da interface StorageHandlercom a classe org.apache.hadoop.hive.hbase.HBaseStorageHandlerque o Hbase disponibiliza.
- No Hive a interface StorageHandlerpermite que outras aplicações externas ao Hive (i.e Cassandra, Azure Table, JDBC (MySQL), MongoDB, ElasticSearch, e etc) implementem e disponibilizem operações dessas estruturas e dados armazenados ao Apache Hive.

- A idéia é que o Hive tenha visibilidade do metadados quando a tabela é criado no Hive mas os dados e o controle de armazenamento esteja externo.
- É uma evolução do conceito de tabela gerenciada (managed) e externa (external) do Hive.



Exemplo

Utilizando a tabela employee utilizada nos exercícios anteriores, vamos dar visibilidade ao Hive dessa estrutura do HBase.

1. Vamos criar um novo schema no Hive.
```shell
# iniciar hive
hive

# hive>
# cria BD
CREATE DATABASE tabelas_hbases;
```

2. Criar a tabela employee no Hive.

```shell
CREATE EXTERNAL TABLE tabelas_hbases.employees(
emp_no INT,
birth_date string,
first_name string,
last_name string,
gender string,
hire_date string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES("hbase.columns.mapping"=":key, employee_data:birth_date, employee_data:first_name,employee_data:last_name,employee_data:gender,employee_data:hire_date")
TBLPROPERTIES("hbase.table.name"="ex_carga_massiva:employees", "hbase.mapred.output.outputtable"="employees");
```



**Exercício**

1. Criar a tabela externa salaries no Hive que representa a mesma tabela que foi carregada em exercícios anteriores no Hbase.

```shell
CREATE EXTERNAL TABLE tabelas_hbases.salaries(
emp_no_ano_inicial string,
emp_no string,
salary INT,
from_date string,
to_date string)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES("hbase.columns.mapping"=":key, salarie_concat_data:emp_no, salarie_concat_data:salary,
salarie_concat_data:from_date, salarie_concat_data:to_date")
TBLPROPERTIES("hbase.table.name"="ex_carga_massiva:salaries_concatenado", "hbase.mapred.output.outputtable"="salaries");
```

2. Consultar os empregados com o maior salário em cada ano.

```shell
# hive>
select substr(from_date, 0, 4) as ano, 
max(struct(salary, emp_no)).col1 as salary,
max(struct(salary, emp_no)).col2 as emp_no
from salaries
group by substr(from_date, 0, 4);
```

3. Consultar o quanto foi gasto em salários por ano.

```shell
# hive>
select substr(from_date, 0, 4) as ano, sum(salary) as soma_salary_ano
from salaries
group by substr(from_date, 0, 4);
```

