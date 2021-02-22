# **<u>Processando grandes conjuntos de dados de forma paralela e distribuída com Spark</u>**

------

[slides](./slides/slides_live_08.pdf)

arquivos:

- [avengers.csv](./arquivos/avengers.csv)

- [FL_insurance_sample.csv](./arquivos/FL_insurance_sample.csv)

  

INSTALAÇÃO

1) Baixar em http://spark.apache.org/downloads.html
(sugestão de uso da versão 2.4.7 c/ a pre-build do Hadoop 2.7)

2) Descompactar o arquivo baixado (tar -zxvf spark-2.4.7-bin-hadoop2.7.tgz);

3) mover para o local desejado

4) configurar a variável de ambiente SPARK_HOME para pasta onde foi descopactado o Spark para facilitar, configurar no PATH do sistema a pasta bin, dentro do diretório Spark adicionar ao arquivo /etc/bash.bashrc (Debian)  ou /etc/bashrc (RHEL)

```
export SPARK_HOME="/opt/spark-2.3.1-bin-hadoop2.7"
PATH="$PATH:$SPARK_HOME/bin"
export PYSPARK_PYTOHN="python3"
```

- verificando os arquivos do Spark
```shell
# leva até a pasta do Spark
cd $SPARK_HOME/jars

# lista os arquivos e pasta
ls -l
# ou nome da pasta de definição livre (onde descopactamos o arquivo baixado)
# no caso está em .../opt/spark-2.4.7-bin-hadoop2.6.tgz
cd ..
ls -l
```



**Formas de trabalhar c/ Spark**

- via shell (de forma interativa - linha de comando)
  - spark-shell (Scala)
  - pyspark-shell (Python)
  - sql-shell (SQL)
  - R-shell (R) (só em versões mais moderanas)
  - spark-submit (de forma interativa - arquivo bath)

- via notebooks
  - Jupyter Notebooks (Python)
  - Zeppelin Notebooks (Python e Scala)
  - Google Colab (Python)
  - Databriks Notebooks (Scala, Python, Java, SQL, R)



PRÁTICA

- acessando

```shell
# Ao acessar via spark-shell omesmo cria automaticamente o SparkContext(sc) e o SparkSession(spark)
spark-shell
# ao subir o spark-shell ele nos traz
# Spark context Web UI available at http://bigdata-srv:4042 (interface web)
# Spark context available as 'sc' (master = local[*], app id = local-1612060902210). (id do job)
# Spark session available as 'spark'. (nome do spark session)
```

- baixar o arquivo "https://raw.githubusercontent.com/fivethirtyeight/data/master/avengers/avengers.csv" e colocar na pasta "/home/everis/arquivos/"
- podemos baixar direto para VM usando wget, dentro pasta que você quer baixar

```sh
wget https://raw.githubusercontent.com/fivethirtyeight/data/master/avengers/avengers.csv
```

```scala
// lê o arquivo e coloca em uma variável no spark
// lê um arquivo do formato CSV, com delimitador "," e com a primeira linha com cabeçalho 
val insurance = spark.read.format("csv").option("sep", ",")
	.option("header", "true")
	.load("file:///home/everis/arquivos/avengers.csv")

// mostra o conteúdo do arquivo
insurance.show()

// mostra conteúdo do arquivo, só 5 primeiros registros e não costa os dados dascolunas
insurance.show(5, false)

// mostra conteúdo do arquivo, só 5 primeiros registros de colunas específicas
insurance.select("URL", "Name/Alias").show(5, false)

// cria um novo ds conforme a composição
val ds2 = insurance.select("URL", "Name/Alias")
```

Pyspark shell
- Shell interativo usando a linguagem Python
- Assim como o spark-shell, o pyspark tambem cria o SparkContext(sc) e o SparkSession(spark);
- nota: não dá apara usar as setas para voltar os comandos ou apagar



Melhor documentação para o spark é a própria página do Spark.
http://spark.apache.org/

- Documentation -> escolha a versão -> Programming Guides



```python
# lê um arquivo do formato CSV, com delimitador "," e com a primeira linha com cabeçalho 
insurance = spark.read.format("csv").option("sep", ",")
	.option("header", "true").load("file:///home/everis/arquivos/avengers.csv")

# mostra o conteúdo do arquivo
insurance.show()

# mostra conteúdo do arquivo, só 5 primeiros registros de colunas específicas
insurance.select("URL", "Name/Alias", "Gender").show(5)

# cria um novo ds conforme a composição
ds2 = insurance.select("URL", "Name/Alias","Gender")
```



RDDs (Resilient Distributed Dataset)
- é a principal abstração do Spark
- é uma coleção de elementos particionados entre os diversos nós de um cluster;
- Algumas características principais:
	- é resiliente a falhas, caso haja algum erro durante o processo, ele é capaz de se recuperar e continuar a atividade;
	- são estruturados para serem naturalmente distribuídos, sendo capazes de existir entre diversos nós de um cluster;
	- são imutáveis.
		- Um RDD gera outro RDD, jamais ele poderá ser modificado. Seu conteúdo poderá ser transformado, resultando em outro RDD.

spark-sql
- Shell interativo usando a linguagem SQL
- diferente dos anteiores, não cria o SparkContext(sc) e o SparkSession(spark);

```SPARQL
# acessa um arquivo em disco e aplica o SQL diretamente
# tem que usar '`' e não '''
SELECT * FROM csv.`file:///home/everis/arquivos/avengers.csv`
```



Declarando o Spark Context em Scala
necessário

- p/ uso em notebooks Google Colab
- p/ desenvolvimento de programas ser executado em spark-submit
- Em Shell ou Databriks ficará implícito

```scala
import org.apache.spark.SparkContext
import org.apache.spark.SparkConf
val conf = new SparkConf().setName("meu aplicativo spark")
val sc = new SparkContext(conf)
```



SparkSQL
- modulo do Spark que fica acima do módulo core.
- trabalha exclusivamente c/ objetos Dataframes e Datasets (abstrações das tabelas Spark(RDDs))



Dataframes vs. Datasets

- Dataframes: estrutura não tipado
- Datasets: estrutura com os dados tipados

Dataframes tem uma linguagem própria para trabalhar c/ eles, mas podemos fazer uso de SQL (ANSI 2003)
O Spark nos permite trabalhar c/ diversas fontes de dados:

- arquivos no HDFS;
- tabelas HIVE;
- tabelas HBase;
- tabelas de BD relacionais;

Facilitando assim o cruzamentos de dados de diversas fontes em um mesmo "lugar"

Spark Session é o ponto central do módulo de dataframes
- internamente o Spark Session tem um Spark Context associado
- da versão 2 em diante o Spark Session unificou o SQLContext e HiveContext
- o Spark Session aceita várias configurações

De maneira geral temos
Spark context = sc
Spark Session = spark

```scala
// cria um spark session (versão >2)em Scala
import org.apache.sql.SparkSession

val spark = SparkSession
	.builder()
	.appName("Spark SQL")
	.config("<configuração>","<valor da configuração>")
	.getOrCreate()

// Podemos ler diversos formato de arquivos
// lê um arquivo json
val dfJson = spark.read.json("file://.../arq.json")

// lê um arquivo parquet
val dfParquet = spark.read.format("parquet").load("hdfs:/.../arq.parquet")

// lê arquivo csv
val peopleDFcsv = spark.read.format("csv").option("sep",",").
	option("header","true").load("file://.../arq.csv")

// conectando c/ fontes de dados JDBC
// muitas vezes devemos baixar o driver e colocar junta da aplicação desenvolvida
val jdbcDF = spark.read
	.format("jdbc")
	.option("url","jdbc:postgressql:dbserver")
	.option("dbtable", "<nome do esquema>.<nome da tabela>")
	.option("user","<usuário>")
	.option("password", "<senha>")
	.option("driver", "com.driver.MyDriver")
	.load()
```



Operações de Dataframes

```scala
// carrega o arquivo
val df = spark.read.format("csv").option("sep", ",")
	.option("header", "true").load("file:///home/everis/arquivos/avengers.csv")

// exibe a estrutura do dataframe (nome das colunas)
df.printSchema()

// traz quantidade de registros específicados s/ cortar os dados
df.show(5,false)

// traz os registros das colunas específicadas
df.select("Name/Alias","Honorary","Death1").show(false)

// faz operações com os campos
//nota: todas as colunas, mesmo as que não terão operação precisa ter "$"
df.select($"Name/Alias",$"Appearances",$"Appearances"*3).show(false)

// filtragem
df.select("Name/Alias","Honorary","Death1","Appearances").filter($"Appearances">=1000).show(false)

// contar nr. de registros
df.count()

// agrupa e contar
df.groupBy("Gender").count().show()

// renomeia o nome de coluna e agrupa e contando
// withColumn("<novo nome>", col("<nome antigo>"))
df.withColumn("Gênero",col("Gender")).groupBy("Gênero").count().show()

// agregações média, soma, min e max
df.agg(avg("Year")).show()
df.agg(sum("Year")).show()
df.agg(min("Year")).show()
df.agg(max("Year")).show()
```



**Exercício**
Baixar o arquivo em "https://raw.githubusercontent.com/shankarmsy/practice_Pandas/master/FL_insurance_sample.csv" e obter a média do campo "eq_site_limit", agrupado por "construction"

```shell
# baixando o arquivo
wget https://raw.githubusercontent.com/shankarmsy/practice_Pandas/master/FL_insurance_sample.csv
```

```scala
// carregando o arquivo no pandas
val dfEx = spark.read.format("csv").option("sep", ",")
	.option("header", "true")
	.load("file:///home/everis/arquivos/FL_insurance_sample.csv")

// verifica os nomes das colunas
dfEx.printSchema()

// agrupa e calcula a média
dfEx.groupBy("construction").agg(avg("eq_site_limit")).show()
```

```
+-------------------+------------------+
|       construction|avg(eq_site_limit)|
+-------------------+------------------+
|Reinforced Concrete|4015452.1939953812|
|               Wood|23953.954232889966|
|        Steel Frame|5.97785294117647E7|
|            Masonry|193878.50877173975|
| Reinforced Masonry|  712295.683029586|
+-------------------+------------------+
```



Trabalhando com SQL no spark

```scala
// cadastramos o nosso dataframe como uma tempview
// cria uma tempview de um dataframe
dfEx.createTempView("seguro")

// cria ou recria se já existir uma tempview de um dataframe
dfEx.createOrReplaceTempView("seguro")

// cria e/ou recria uma tempview em ambiente compartilhado
dfEx.createGlobalTempView("seguro")
dfEx.createGlobalOrReplaceTempView("seguro")

// então podemos realizar operações de SQLContext
spark.sql("SELECT * FROM seguro").show()
spark.sql("SELECT * FROM global_temp.seguro").show()
spark.sql("SELECT county, point_latitude, point_longitude FROM seguro LIMIT 10").show()

// cria um novo dataframe do retono da query via sparkSQL
val newDF = spark.sql("SELECT * FROM seguro")

// exibe os dados do dataframe
newDF.show()

// carregando um arquivo diretamente via SQL
spark.sql("SELECT * FROM csv.`file:///home/everis/arquivos/FL_insurance_sample.csv`").show()

// grava os dados do dataframe em arquivo no SO
dfEx.write.format("csv")
.option("sep", ",")
.option("header", "true")
.save("file:///home/everis/arquivos/exportados")

// grava os dados do dataframe em arquivo no SO
// usando save mode
// - Append: caso já exista o dataframe, adiciona os dados ao final ("append")
// - ErrorIfExists: caso já exista o dataframe, lança uma exceção ("errorifexists")
// - Ignore: caso já exista o dataframe, não altera os dados do anterior ("ignore")
// - Overwrite: caso já exista o dataframe, substitui os dados do anterior ("overwrite")
dfEx.write.format("csv")
.option("sep", ",")
.option("header", "true")
.mode("errorifexists")
.save("file:///home/everis/arquivos/exportados")

dfEx.coalesce(1).write.format("csv")
.option("sep", ";")
.option("header", "true")
.save("file:///home/everis/arquivos/exportados")

// valores particionados?
dfEx.write.partitionBy("county").format("csv")
.option("sep", ",")
.option("header", "true")
.save("file:///home/everis/arquivos/exportados/particionado")

// entender o que faz esta instrução
dfEx.write.bucketBy(42,"county").sortBy("statecode").saveAsTable("people_bucketed")

// foi preciso copiar o driver do MySQL na pasta SPARK_HOME/jars
// após reiniciar a sessão do Spark p/ funcionar
cd $SPARK_HOME
wget -q "http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.32/mysql-connector-java-5.1.32.jar" -O mysql-connector-java.jar

// gravar em BD
dfEx.write.format("jdbc")
.option("url", "jdbc:mysql://localhost/trainning")
.option("dbtable","trainning.tab_seguro_spark_2")
.option("user", "root")
.option("password","Everis@2021")
.save
```



UDFs (User Defined Functions)

https://spark.apache.org/docs/latest/sql-ref-functions-udf-scalar.html

São funções que são definidas pelo usuário e podem ser utilizadas para realizar transformações nos dados:

```scala
// registra uma UDF
spark.udf.register("minhaUDF", (s: String) => s.length())
// cria uma view para uso c/ SQL
dfEx.createTempView("seguro")
// usando a UDF criada
spark.sql("SELECT DISTINCT minhaUDF(county) as `nr letras`, county FROM seguro").show()
```



UDAFs (User Defined Aggregation Functions)

https://spark.apache.org/docs/latest/sql-ref-functions-udf-aggregate.html

são semelhantes as UDFs , porém são responsáveis por realizar funções de agregação, sendo do tipo:
- Untyped
- Typed

A partir da versão 2.3 do Spark foram inseridas as Pandas UDFs  
	- São UDFs otimizadas para python , utilizando as capacidades do Apache Arrow;
	- Elas melhoram muito a velocidade de execução de UDFs em python

----

**NÃO TESTADO**

```python
Utilizando Pandas UDFs: (não consegui rodar no pyspark-shell)
# lê um arquivo do formato CSV, com delimitador "," e com a primeira linha com cabeçalho 
df = spark.read.format("csv").option("sep", ",").option("header", "true").load("file:///home/everis/arquivos/FL_insurance_sample.csv")

from pyspark.sql.functions import col, pandas_udf
from pyspark.sql.types import LongType
def multiply_func(a,b):
    return a * b
multiply = pandas_udf(multiply_func, returnType=LongType())
df.select(multiply(col("policyID"), col("policyID"))).show()
```

-------

Importante!
- UDFs , UDAFs e Pandas UDFs são naturalmente mais pesadas e impactarão na performance do seu processo;
- Sempre que possível execute operações diretamente com comandos de Dataframe ou código SQL nativo: https://spark.apache.org/docs/2.4.7/api/sql/index.html



Spark e Hive

- Podemos acessar diretamente o Hive via spark

----

**NÃO TESTADO**

```scala
import java.io.File
import org.apache.spark.sql.{Row, SaveMode, SparkSession}
import spark.implicits._
import spark.sql

val warehouseLocation = new File("spark warehouse").getAbsolutePath

val spark = SparkSession
.builder()
.appName("Spark Hive")
.config("spark.sql.warehouse.dir", warehouseLocation)
.enableHiveSupport()
.getOrCreate()

spark.sql("CREATE TABLE IF NOT EXISTS src(key INT, value STRING) USING hive")
spark.sql("LOAD DATA LOCAL INPATH 'file:///home/everis/arquivos/kv1.txt' INTO TABLE src")

spark.sql("SELECT * FROM src").show()

val df = spark.table("src")
df.write.mode(SaveMode.Overwrite).saveAsTable("hive_records")
```

----



Persist e Cache

Pontos importantes para melhorar a performance dos nossos programas:

- Em geral o Spark pode precisar refazer uma determinada transformação várias vezes a cada ação. Para otimizar nossos programas podemos usar o conceito de persist (ou cache), comando que armazenará os dados na memória para ser reutilizado;
- Pode melhorar muito a performance do seu projeto, mas deve ser usada com parcimônia, dependendo dos recursos do cluster;

Exemplo

----

**NÃO TESTADO**

```scala
val dfJson = spark.read.json ("file:///examples/src/main/resources/people.json")

dataframe.persist(StorageLevel.MEMORY_AND_DISK)
dataframe.unpersist()
dataframe.cache()
```

----

Possíveis "storage levels" para persistência

- MEMORY_ONLY
  Armazene RDD como objetos Java desserializados na JVM. Se o RDD não couber na memória, algumas partições não serão armazenadas em cache e serão recalculadas rapidamente cada vez que forem necessárias.
  Este é o nível padrão.

- MEMORY_AND_DISK
  Armazene RDD como objetos Java desserializados na JVM. Se o RDD não couber na memória, armazene as partições que não couberem no disco e leia-as quando for necessário.

- MEMORY_ONLY_SER(Java e Scala)
  Armazene RDD como objetos Java serializados (uma matriz de byte por partição). Isso geralmente é mais eficiente em termos de espaço do que objetos desserializados, especialmente ao usar um serializador rápido, mas mais intensivo da CPU para leitura.

- MEMORY_AND_DISK_SER (Java and Scala)
  Semelhante a MEMORY_ONLY_SER, mas transfere as partições que não cabem na memória para o disco, em vez de recomputá-las rapidamente cada vez que são necessárias.

- DISK_ONLY
  Armazene as partições RDD apenas no disco.

- MEMORY_ONLY_2, MEMORY_AND_DISK_2, etc.
  Igual aos níveis acima, mas replique cada partição em dois nós do cluster.

- OFF_HEAP (experimental)
  Semelhante a MEMORY_ONLY_SER, mas armazena os dados na memória fora do heap. Isso requer que a memória fora do heap esteja ativada.



Spark Submit

- É a maneira mais comum de executarmos um sistema em Spark
- Permite a configuração de diversos parâmetros do Spark
- Pode trabalhar tanto com códigos python (py , whl , .zip) quanto com pacotes . jar (e mais recentemente .R)
- Lista com todas as configurações do spark submit :  https://spark.apache.org/docs/latest/configuration.html

```shell
./bin/spark submit \
--class <main-class> \
--master <master-url> \
--deploy-mode <deploy-mode> \
--conf <key>=<value> \
... # outras opções
<application-jar> \
[application arguments]
```

- Executa o aplicativo localmente usando 8 núcleos

```shell
./bin/spark submit \
--class org.apache.spark.examples.SparkPi \
--master local[8] \
/path/to/examples.jar \
100
```

- Executar em um cluster  Spark autônomo no modo de implantação do cliente

```shell
./bin/spark submit \
--class org.apache.spark.examples.SparkPi \
--master spark://207.184.161.138:7077 \
--executor-memory 20G \
--total-executor-cores 100 \
/path/to/examples.jar \
1000
```

- Executar em um cluster autônomo Spark emmodo de implantação de cluster com supervisão

```shell
./bin/spark submit \
--class org.apache.spark.examples.SparkPi \
--master spark://207.184.161.138:7077 \
--deploy mode cluster \
--suervise \
--executor-memory 20G \
--total-executor-cores 100 \
/path/to/examples.jar \
1000
```

- Executa em um cluster YARN e exporta para HADOOP_CONF_DIR = XXX

```shell
./bin/spark submit \
--class org.apache.spark.examples.SparkPi \
--master yarn \
--deploy-mode cluster \# pode ser cliente para modo cliente
--executor-memory 20G \
--num-executors 50 \
/path/to/examples.jar \
1000
```



```shell
spark submit
--class com.everis.tricorder.TricorderRun \
--properties-file spark.conf \
--files log4j.properties,[Outros arquivos] \
--conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=file://log4j.properties" \
--conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=file://log4j.properties" \
./target/app.jar \
arg01 “val_arg01" \
arg02 “val_arg02"
```



```shell
spark.master yarn
spark.app.name "tricorder"
spark.yarn.queue Desenvolvimento
spark.dynamicAllocation.enabled true
spark.dynamicAllocation.initialExecutors 1
spark.dynamicAllocation.minExecutors 5
spark.dynamicAllocation.maxExecutors 10
spark.shuffle.service.enabled true
spark.executor.cores 6
spark.driver.cores 8
spark.executor.memory 10G
#spark.yarn.executor.memoryOverhead 1000
spark.driver.memory 20G
#spark.yarn.driver.memoryOverhead 1000
#spark.ui.port 4142
spark.ui.enabled false
spark.shuffle.compress true
spark.driver.maxResultSize 5000m
spark.default.parallelism 20000
spark.executor.heartbeatInterval 10s
spark.dynamicAllocation.sustainedSchedulerBacklogTimeout 1s
spark.dynamicAllocation.cachedExecutorIdleTimeout 120s
spark.dynamicAllocation.executorIdleTimeout 60s
spark.sql.broadcastTimeout 36000
spark.network.timeout 600s
spark.serializer org.apache.spark.serializer.KryoSerializer
spark.sql.shuffle.partitions 20000
spark.hadoop.hive.exec.dynamic.partition true
spark.hadoop.hive.exec.dynamic.partition.mode nonstrict
# Define the root logger with appender X
log4j.rootLogger = INFO,stdout
log4j.logger.com.everis = DEBUG,stdout
# Direct log messages to stdout
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target=System.out
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss}-5p %c{1}:%L-m%n
```

