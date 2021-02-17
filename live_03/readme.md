# **<u>Orquestrando ambientes de big data distruibuidos com Zookeeper, Yarn e Sqoop</u>**

------

[slides](./slides/slides_live_03.pdf)

Arquivos: 

- [install_sqoop.sh](./arquivos/install_sqoop.sh)

- [pokemon.sql](./arquivos/pokemon.sql)

- [sqoop_import.sh](./arquivos/sqoop_import.sh)

  

 **Anotações gerais**

Zookeeper

- Serviço de coordenação distribuído
- Gerenciamento de grande conjunto de hosts (nós)
- Arquitetura simples e API
- Vem p/ simplificar o processo do desevolvedor
- Fornece as rotas necessárias para as peças do cluster
- identifica os nós por nome (DNS like)
- Gerencia e coordena as configurações
- Funciona c/ esquema de eleição de líder (usa sempre pelo menos 3 Zookeeper)
- Pode indisponibilizar o dado enquanto está sendo modificado
- ajuda na recuperação automática de falhas (HBase, por exemplo)



Sqoop

- originalmente desenvolvido pela Cloudera
- Movimenta dados entre BD relacional e o HDFS;
- Podemos importar tabelas (todas ou específicas, inteira ou parte) para oHDFS
- E exportar dados do HDFS para o BD;
- Perite a automatização do processo de ingestão
- usando sqoop usar a versão 1, a 2 é deplecado
- Realiza a leitura linha por linha da tabela para escrevero arquivo no HDFS (processo lento, mas efetivo)
- O resultado do import é um conjunto de arquivos com a cópia dos dados da tabela importada
- Under the hood, gera classes Java, permitindo que o usuário possa interagir com o dado importado
- Pode importar dados e metadados de BD SQL direto p/ o Hive
- Utiliza MapReduce p/ realizar import/export dos dados, provendo um processo paralelo e tolerante a falhas- Permite especificar o intervalo e quais colunas serão importadas
- Possibilita a especificação de delimitadores e formatos de arquivos
- Realiza conexões c/ BD em paralelo, executando comandos de select(import) e insert/update(export)
- Aceita conexão c/ diversos plug-ins: MySQL, PostgreSQL, Oracle, entre outros;
- O formato padrão do arquivo importado p/ o HDFS é CSV.



**EXEMPLOS** (retirados do repositório do colega de turma [felipedoamarals](https://github.com/felipedoamarals/Aceleracao_Global_Dev4_Everis/blob/master/Live%20%233.md))

```shell
# Exemplo 1
sqoop import \
--connect jdbc:mysql://mysql.example.com/sqoop \
--username sqoop \
--password sqoop \
--table cities
--warehouse-dir /etl/input/ # Pemite especificar um diretório no HDFS como destino
--where "country = 'Brazil'" # Pa importar apenas um subconjunto de registros de uma tabela
-P ou --password-file my-sqoop-password
--as-sequencefile ou --as-avrodatafile # Para escrever o arquivo no HDFS em formato binário (Sequence ou Avro)
--compress # Comprime os blocos antes de gravar no HDFS em formato gzip por padrão
--compression-codec # Utilizar outros codecs de compressão, exemplo: org.apache.hadoop.io.compress.BZip2codec
--direct # Realiza import direto por meio das funcionalidades nativas do BD para melhorar a performance, exemplo: mysqldump ou pg_dump
--map-column-java c1=String # Especificar o tipo do campo
--num-mappers 10 # Especificar a quantidade de paralelismo para controlar o workload
--null-string '\\N'\
--null-non-string '\\N'
--incremental append ou lastmodified # Funcionalidade para incrementar os dados
--check-column id ou last_update_date # Identifica a coluna que será verificada para incrementar novos dados
--last-value 1 ou "2013-05-22 01:01:01" # Para especificar o último valor importado no Hadoop
			
# Exemplo 2 - Import da tabela accounts
sqoop import --table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser --password pw

# Exemplo 3 - Importa da tabela accounts utilizando um delimitador
sqoop import --table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser --password pw \
--fields-terminated-by "\t"

# Exemplo 4 - Import da tabela accounts limitando os resultados
sqoop import --table accounts \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser --password pw \
--where "state='CA'"

# Exemplo 5 - Import incremental baseado em um timestamp. Deve certificar-se de que esta coluna é atualizada quando os registros são atualizados ou adicionados
sqoop import --table invoices \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser --password pw \
--incremental lasmodified \
--check-column mod_dt \
--last-value '2015-09-30 16:00:00'

# Exemplo 6 - Import baseado no último valor de uma coluna específica
sqoop import --table invoices \
--connect jdbc:mysql://dbhost/loudacre \
--username dbuser --password pw \
--incremental append \
--check-column id \
--last-value 9878306
```



**Criado os arquivos necessários**

```shell
#Para instalação do Sqoop
# colar o conteúdo
sudo nano scripts_sqoop/install_sqoop.sh
sudo sh scripts_sqoop/install_sqoop.sh

# Para importação dos dados	no BD
# colar o conteúdo
sudo nano scripts_sqoop/pokemon.sql
mysql -u root -h localhost -pEveris@2021 < scripts_sqoop/pokemon.sql

#Contar linhas
hdfs dfs -cat /user/everis-bigdata/pokemon/1/* |wc -l

# para confirmar a importação
mysql -u root -h localhost -pEveris@2021
```

```mysql
# mysql> 
select * from trainning.pokemon limit 100;
quit ou exit
```

```shell
# Para importação dos dados do BD p/ o HDFS	
sudo nano scripts_sqoop/sqoop_import.sh

# iniciando os serviços
# (comentado as linhas dos serviços não utilizados HBase, Hive, Impala)
sh script_apoio/start_all_service.sh

# executa o job
sh scripts_sqoop/sqoop_import.sh

# mostra o arquivo gerado no HDFS
hdfs dfs -ls -h /user/everis-bigdata/pokemon

# ler 1 arquivo (como está zipado usamos -text)
hdfs dfs -text /user/everis-bigdata/pokemon/part-m-00000.gz | more

# ler todos os arquivos (como está zipado usamos -text)
hdfs dfs -text /user/everis-bigdata/pokemon/*.gz | more
```



**EXERCÍCIOS**

1. Todos os Pokémon lendários

  ```shell
  #testando a query no BD
  mysql -u root -h localhost -pEveris@2021
  ```

  ```mysql
  # mysql> 
  select * from trainning.pokemon where Legendary = 1;
  # resultado = 65 registros
  ```

  ```shell
  # Script Sqoop
  echo "Apagando diretório de output"
  sudo -u hdfs hdfs dfs -rm -R /user/everis-bigdata/pokemon/ex1
  echo "Importando a tabela"
  sudo -u hdfs sqoop import \
  --connect jdbc:mysql://localhost/trainning \
  --username root --password "Everis@2021" \
  --direct \
  --table pokemon \
  --where 'legendary = 1' \
  --target-dir /user/everis-bigdata/pokemon/ex1 \
  ```
-----

  

2. Todos os Pokemon de apenas um tipo

  ```shell
  # testando a query no BD
  mysql -u root -h localhost -pEveris@2021
  ```

  ```mysql
  # mysql> 
  select * from trainning.pokemon where Type2='';
  # resultado = 386 registros
  ```

  ```shell
  # Script Sqoop
  echo "Apagando diretório de output"
  sudo -u hdfs hdfs dfs -rm -R /user/everis-bigdata/pokemon/ex2
  echo "Importando a tabela"
  sudo -u hdfs sqoop import \
  --connect jdbc:mysql://localhost/trainning \
  --username root --password "Everis@2021" \
  --direct \
  --table pokemon \
  --where 'Type2 = ""' \
  --target-dir /user/everis-bigdata/pokemon/ex2 \
  ```
-----

  

3. Os top 10 Pokémon mais rápidos;

  ```shell
  # testando a query no BD
  mysql -u root -h localhost -pEveris@2021
  ```

  ```mysql
  # mysql> 
  select * from trainning.pokemon order by Speed DESC, Number limit 10;
  # Resultado
  #	1.º  -> Deoxys Speed Forme
  #	10.º -> Electrode 
  ```

  ```shell
  # script sqoop
  echo "Apagando diretório de output"
  sudo -u hdfs hdfs dfs -rm -R /user/everis-bigdata/pokemon/ex3
  echo "Importando a tabela"
  sudo -u hdfs sqoop import \
  --connect jdbc:mysql://localhost/trainning \
  --username root --password "Everis@2021" \
  --direct \
  --split-by Number \
  --query 'SELECT * FROM trainning.pokemon WHERE $CONDITIONS ORDER BY Speed DESC, Number LIMIT 10' \
  --m 1 \
  --target-dir /user/everis-bigdata/pokemon/ex3 \
  ```

-----



4. Os top 50 Pokémon com menos HP

```
mysql -u root -h localhost -pEveris@2021
```

```mysql
#mysql>
SELECT * FROM trainning.pokemon WHERE $CONDITIONS ORDER BY HP, Number LIMIT 50;
# Resultado
#	1.º  -> Shedinja
#	50.º -> Cyndaquil
```

```shell
# scrip sqoop  
echo "Apagando diretório de output"
sudo -u hdfs hdfs dfs -rm -R /user/everis-bigdata/pokemon/ex4
echo "Importando a tabela"
sudo -u hdfs sqoop import \
--connect jdbc:mysql://localhost/trainning \
--username root --password "Everis@2021" \
--direct \
--query 'SELECT * FROM trainning.pokemon WHERE $CONDITIONS ORDER BY HP, Number LIMIT 50' \
--m 1 \
--target-dir /user/everis-bigdata/pokemon/ex4 \
```

----



5. Os top 100 Pokémon com maiores atributos;

```shell
$ mysql -u root -h localhost -pEveris@2021
```

```mysql
#mysql>
SELECT *, (HP+Attack+Defense+SpAtk+SpDef+Speed) as atributos FROM trainning.pokemon ORDER BY (HP+Att^Ck+Defense+SpAtk+SpDef+Speed) DESC, Number LIMIT 100;
# Resultado
#	1.º   -> Mega Mewtwo X
#	100.º -> Registeel
```
```shell
# script sqoop
echo "Apagando diretório de output"
sudo -u hdfs hdfs dfs -rm -R /user/everis-bigdata/pokemon/ex5
echo "Importando a tabela"
sudo -u hdfs sqoop import \
--connect jdbc:mysql://localhost/trainning \
--username root --password "Everis@2021" \
--direct \
--query 'SELECT *, (HP+Attack+Defense+SpAtk+SpDef+Speed) as atributos FROM trainning.pokemon WHERE $CONDITIONS ORDER BY atributos DESC, Number LIMIT 100' \
--m 1 \
--target-dir /user/everis-bigdata/pokemon/ex5 \	
```

-----



Outros parâmetros Sqoop

```shell
--split-by Generation \
--fields-terminated-by "|" \
--split-by Generation \
--query 'SELECT * FROM pokemon WHERE $CONDITIONS' \
--where 'order by Speed DESC, Number limit 10' \
--compress \
--num-mappers 4
```

