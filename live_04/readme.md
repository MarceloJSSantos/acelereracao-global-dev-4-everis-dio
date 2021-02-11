# **<u>Como realizar consultas de maneira simples no ambiente complexo de Big Data com HIVE e Impala</u>**

------

[slides](./slides/slides_live_04.pdf)

Arquivos: [base_localidade.csv](./arquivos/base_localidade.csv), [employee.txt](./arquivos/employee.txt) e [restart_all_service_hive.sh](./arquivos/restart_all_service_hive.sh) 

**Anotações gerais**

Impala e Hive são frameworks que provêm SQL para consulta a dados no HDFS e HBase, fazendo uso de um driver JDBC



Hive

Faz uso da HQL (semelhante ao SQL), abstração de alto nível do MapReduce

- Gera jobs MapReduce ou Spark no cluster Hadoop
- A linguagem de consulta pode ser executada em 3 diferentes mecanismos (MapReduce, Tez e Spark)



Impala

"É um SQL de alta performance"

- É uma engine MPP (Massive Parallel Processing) open source p/ execução de queries SQL em ambiente Haddop
  
- Possui baixa latência (em milissegundos) - muito rápido

- Oferece melhora de performancede 5X a 50X
- Ideal p/queries interativas e análise de dados
- Muitas novidades são implementadas atualmente



Hive vs. Impala

- Impala não salva resultados intermediários no disco durante consultas demoradas,  ocasionando, dependendo da versão, cancelamento de uma consulta em execução se algum host falhar

- Para processamento em lote de dados o Hive é uma melhor opção
- Já para processamento em tempo real de consultas ad hoc em subconjunto de dados, o Impala é a melhor opção.
- Impala é mais rápido que o Hive, mas seu uso depende da solução esperada em problemas de big data
- O Impala consome muita memória e não é executado de forma eficiente para operação de dados pesados, como joins, porque não é possível inserir tudo na memória



Metastore

- O Hive e o Impala trabalham c/ o mesmo dado nas "tabelas" no HDFS, metadado e metastore.
- Queries são feitas em tabelas, assim como em BD tradicionais.
- Tabela = diretório no HDFS, contendo 1 ou vários arquivos
- caminho padrão das tabelas no HDFS:
  -  /user/hive/warehouse/<table name>
- suporta diversos formatos



Armazenamento

- Os dados são organizados em tabelas e partições
- Tabela  = diretório c/ 1 ou vários arquivos
- partição = subdiretórios c/ 1 ou + arquivos

- Diversos tipos de dados



**COMANDOS**

- criação de BD
	> CREATE DATABASE loudacre;
	> CREATE DATABASE IF NOT EXISTS loudacre;
	>  (será criado /user/hive/wahouse/loudacre.db)
	
- apagar BD
	> DROP DATABASE loudacre;
	> DROP DATABASE IF EXISTS loudacre;

- criar tabelas
  > CREATE TABLE tablename (colunename DATATYPE, ... )
  > ROW FROMAT DELIMITED
  > FIELDS TERMINATED BY char (',', '|', ...)
  > STORED AS (TEXTFILE|SEQUENCEFILE|...)
  > -caminho lógico
  > 	/user/hive/warehouse/tablename (default database)
  > 	/user/hive/warehouse/dbname.db/tablename (named database)

  > CREATE TABLE josbs_archived LIKE jobs;

  > CREATE TABLE ny_customers AS
  > SELECT cust_id, fname
  > FROM customers
  > WHERE state = 'NY';

- Há 2 tipos de tabelas:

  - MANAGED (gerenciadas)

    arquivos criado pelo próprio HDFS;

    caso dropemos a tabela, todo o dado posteriomente criado éeleminado no processo.

    ex. CREATE TABLE ny_customers AS...

    

  - EXTERNAL (externa)

    cria um metadadopara acesso ao arquivo no HDFS

    nesse caso, dropnado a tabela, os dados permamecem

    ex. CREATE EXTERNAL TABLE ny_customers ...

  

- SHOW TABLES;

- SHOW nametable;

- DESCRIBE nametable;

- SHOW CREATE TABLE nametable;



Formatos de arquivos

CREATE TABLE ...

...

STORED AS [formato do arquivo]

- PARQUET
	- formato colunar
	- reduz o espaço de armazenamento
	- aumenta a performance
	- mais eficiente na adição de muitos registros de uma vez
	- melhor escolha p/ acesso a dados colunares
	
- AVRO
	- principal, similar ao parquet
- ORC
	- similar ao parquet
	

Partição
	Não particione pouco e nem demais
	

- criando tabela particionada
...
PARTITIONED BY (colunename DATATYPE, ...)
...

- comentários em tabelas
...
COMMENT 'comentario...'
...

**PRÁTICA**

```shell
# inicia os serviços os serviços (script padrão)
sh script_apoio/start_all_service.sh

# renicia e para alguns serviços não utilizados (script exclusivo p/ Hive e Impala)
sh script_apoio/restart_all_service_hive.sh

# desabilita o safemode do HIVE
sudo -u hdfs hadoop dfsadmin -safemode leave

# Acessando o client do HIVE
hive

# Acessando o client do Impala
impala-shell  
```

```sql
# hive>
show databases;
create database teste01;
create database if not exists teste01;
create table teste01.table01(id int);
use teste01;
create table table02(id int);

# exibe os nomes das colunas na saída
set hive.cli.print.header=true;

# exibe o BD em uso no prompt
set hive.cli.print.current.db=true;

insert into table teste01 values(1);
select * from table01;
create external table table03(id int);
show create table table03;
insert into table table03 values(100); (inserção de registro em tabelas externas) 
```

- nota: importados arquivos ("employee.txt" e "base_localidade.csv") para o servidor (pasta "~/arquivos_importados/")  usando "import" do MobaXTerm



**Importando os dados do arquivo "employee.txt"**

- criamos a tabela externa
  - só o LOCATION será criado (pasta onde devemos colocar o arquivo para ser processado)
  - usada de forma temporária, normalmente o tipo das colunas são "STRING"

```sql
# hive>
CREATE EXTERNAL TABLE TB_EXT_EMPLOYEE(
id STRING,
groups STRING,
age STRING,
active_lifestyle STRING,
salary STRING)
ROW FORMAT DELIMITED FIELDS
TERMINATED BY '\;'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/external/tabelas/employee'
TBLPOPERTIES ("skip.header.line.count"="1");
```

```shell
# inclui o arquivo na pasta criada por LOCATION
hdfs dfs -put ~/arquivos_importados/employee.txt /user/hive/warehouse/external/tabelas/employee

# mostra o arquivo na pasta criada por LOCATION
hdfs dfs -ls -h /user/hive/warehouse/external/tabelas/employee
```

```sql
# testando c/ um select
# hive>
select count(*) as nr_registros from tb_ext_employee;
```

- criamos uma tabela definitiva melhorada (as colunas já são tipadas) baseada na externa

```sql
# hive>
CREATE TABLE tb_employee(
id INT,
groups STRING,
age INT,
active_lifestyle STRING,
salary DOUBLE)
PARTITIONED BY (dt_processamento STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS PARQUET TBLPROPERTIES ("parquet.compression"="SNAPPY");
```

- populamos a tabela criada com os dados da tabela externa

```sql
# hive>
INSERT INTO TABLE tb_employee PARTITION (dt_processamento='20201118')
SELECT id, groups, age, active_lifestyle, salary
FROM tb_ext_employee;
```

- nota: para vermos o schema do arquivo parquet, trazemos ele para o SO e usamos o parquet-tools

```shell
# retira o arquivo parquet e coloca na pasta do usuário (~) no SO local 
hdfs dfs -get /user/hive/warehouse/teste01.db/tb_employee/dt_processamento=20201118/000000_0 ~

# utilizamos o utilitário
parquet-tools schema ~/000000_0 
```



**Importando os dados do arquivo "base_localidade.csv"**

- criamos a tabela externa
  - só o LOCATION será criado (pasta onde devemos colocar o arquivo para ser processado)
	- usada de forma temporária, normalmente o tipo das colunas são "STRING"

```sql
CREATE EXTERNAL TABLE tb_ext_localidade(
street STRING,
city STRING,
zip STRING,
state STRING,
beds STRING,
baths STRING,
sq__ft STRING,
type STRING,
sale_date STRING,
price STRING,
latitude STRING,
longitude STRING)
PARTITIONED BY (particao STRING)
ROW FORMAT DELIMITED FIELDS
TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/external/tabelas/localidade'
TBLPROPERTIES ("skip.header.line.count"="1");
```

- outra forma de incluir o arquivo externo diretamente pelo HIVE em uma tabela definitiva

```sql
hive>
load data local inpath '~/arquivos_importados/base_localidade.csv' into table teste01.localidade partition (particao='2021-01-21);

CREATE TABLE tb_localidade(
street STRING,
city STRING,
zip STRING,
state STRING,
beds STRING,
baths STRING,
sq__ft STRING,
type STRING,
sale_date STRING,
price STRING,
latitude STRING,
longitude STRING)
PARTITIONED BY (particao STRING)
STORED AS PARQUET
```

- populamos a tabela criada com os dados da tabela externa

```sql
INSERT INTO TABLE tb_localidade PARTITION (particao='01')
select street,city,zip,state,beds,baths,sq__ft,type,sale_date,price,latitude,longitude
from tb_ext_localidade
```



- Acessando o Hive diretamento pelo prompt do shell

```shell
hive -S -e "select count(*) from teste01.localidade;"
```



Impala
	- usa os mesmos BD que o Hive (usa o mesmo espaço no HDFS)
	- comandos são os mesmos que o Hive.
	- Algumas vezes é preciso atualizar o Impala para acessar algumas tabelas recem criadas no Hive.

```sql
# impala>
INVALIDATE METADATA tb_ext_localidade;
```

- permite o uso de joins, desde que haja memória para isso

```sql
select te.id, tl.sq__ft, tl.street, te.salary
from tb_ext_employeeemployee te
outer join tb_ext_localidade tl
on te.id = tl.sq__ft;
```

