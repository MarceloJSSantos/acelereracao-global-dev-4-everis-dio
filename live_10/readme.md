# **<u>Criando pipelines de dados eficientes - Parte 2 (Spark SQL e PySpark)</u>**

------

[slides](./slides/slides_live_10.pdf)

arquivos:

- [country_vaccinations.csv](./arquivos/country_vaccinations.csv)
- [country_vaccinations.json](./arquivos/country_vaccinations.json)
- [arquivo_rdd.txt](./arquivos/arquivo_rdd.txt)

notebooks:

- [PySpark_everis_p2](./arquivos/PySpark_everis_p2.ipynb)(DataBricks)

  

Caso de Uso

- Objetivo: Criar um painel de movimentação de vendas por produto
- Saídas:
  - produto
  - preço do produto
  - quantidade vendida por produto
  - impostos/taxas
  - etc.
- Período: em até 10 anos, por dia, mês e ano
- Fechamento dos dados: 7h do dia posterior



Que tipo de informação podemos extrair?

Lógico:

1. Procurar/mapear informações de produtos em alguma base de dados de produto
2. Criar histórico/base vegetativa de até 10 anos
3. Possível ingestão de dados Batch (dia -1 = dados de ontem até -10 anos)

Físico:

1. Qual a melhor estratégia de particionamento?
2. Qual banco de dados devo utilizar?
3. Como o usuário irá consultar essas informações?
4. Qual tipo de arquivo de arquivo devo utilizar?
5. Qual tipo de compressão devo utilizar?



ARQUITETURAS

ON PREMISES

![arquitetura_on_premise](.\img\arquitetura_on_premise.png)

- Data Source:

  Mainframe; RDBMS; Input manual; Som; imagem; API; APACHE kafka

- Data ingestion

  - Stream/Batch/Lote/memory: APACHE Spark; APACHE nifi; Flume

  - I/O: APACHE pig
  - Import/Export RDBMS: sqoop

- File System
  - hadoop HDFS
    - formatos: AVRO; PARQUET; CSV; JSON
- Storage
  - Disco/MapReduce: HIVE
  - Fast: APACHE HBASE; APACHE KUDU
  - Interface: IMPALA
  - MariaDB
  - Fast: elasticsearch
  - APACHE Spark; APACHE STORM
- Data Visualization: Tableau; MicroStrategy
- REST API: APACHE Camel

CLOUD (AWS)

![arquitetura_on_premise](.\img\arquitetura_cloud_aws.png)

- Devops
  - CodeCommit (git); CodePipeline
- IaaC
  - Cloudformation
- File System
  - Bucket S3
- Spark/ETL
  - EMR; GLUE
- RDBMS
  - Oracle; MySQL; SQL Server; etc.
- NoSQL
  - Amazon DynamoDB
- Data Consulting
  - Athena
- Data Visualization
  - Direct Connect;  Storage Gateway
  - ECS (container); EC2 => Tableau; MicroStrategy
  - Quicksight



Camadas

![arquitetura_on_premise](.\img\camadas.png)

Quando trabalhamos em um ambiente de Big Data, existem vários formatos de dados. Os dados podem ser formados em um formato legível como arquivo JSON ou CSV, mas isso não significa que essa é a melhor maneira de realmente armazenar os dados.

Existem três formatos de arquivo otimizados para uso em clusters Hadoop:

- Optimized Row Columnar (ORC)
- Avro
- Parquet

Cada uma das 3 camadas se tratam de subdiretórios dentro do sistema de arquivos distribuídos, HDFS, e podem ser mapeados através da propriedade LOCATION.



TIPO DE ARMAZENAMENTOS

![arquitetura_on_premise](.\img\tipos_armazenamento.png)

- Parquet
  - Orientado por coluna (armazenar dados em colunas): os armazenamentos de dados orientados por coluna são otimizados para cargas de trabalho analíticas pesadas em leitura
  - Altas taxas de compressão (até 75% com compressão Snappy)
  - Apenas as colunas necessárias seriam buscadas / lidas (reduzindo a E / S do disco)
  - Pode ser lido e escrito usando Avro API e Avro Schema

Referência: http://parquet.apache.org/documentation/latest/

![arquitetura_on_premise](.\img\formato_parquet.png)

- Avro

  - Com base em linha (armazenar dados em linhas): bancos de dados baseados em linha são melhores para cargas de trabalho transacionais pesadas de gravação
  - Serialização de suporte
  - Formato binário rápido
  - Suporta compressão de bloco e divisível
  - Evolução do esquema de suporte (o uso de JSON para descrever os dados, enquanto usa o formato binário para otimizar o tamanho do armazenamento)
  - Armazena o esquema no cabeçalho do arquivo para que os dados sejam autodescritivos

  Referência: https://avro.apache.org/docs/1.10.1/

![arquitetura_on_premise](.\img\formato_avro.png)

- ORC

  - Orientado por coluna (armazenar dados em colunas): os armazenamentos de dados orientados por coluna são otimizados para cargas de trabalho analíticas pesadas em leitura
  - Altas taxas de compressão (ZLIB)
  - Suporte ao tipo Hive (datetime, decimal e os tipos complexos como struct, list, map e union)
  - Metadados armazenados usando buffers de protocolo, que permitem adição e remoção de campos
  - Compatível com HiveQL
  - Suporte a Serialização

  Referência: https://cwiki.apache.org/confluence/display/Hive/LanguageManual+ORC#LanguageManualORC-ORCFiles

  ![arquitetura_on_premise](.\img\formato_orc.png)



**Spark SQL**



PRÁTICA

Baixar o arquivo  de dados: https://www.kaggle.com/gpreda/covid-world-vaccination-progress

Ver [PySpark_everis_p2](./arquivos/PySpark_everis_p2.ipynb)(Notebook DataBricks)



vídeo até 1:46:50

slide até 39/55