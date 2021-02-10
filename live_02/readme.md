# **<u>Monitoramento de cluster Hadoop de alto nível com HDFS e Yarn</u>**

------

[slides](./slides/slides_live_02.pdf)

 **Anotações gerais**

deamon (programas)

Hadoop

- tamanho mínimo do bloco 128mb
- fator de replicação: default=3

```shell
# trabalhar c/ terminal mobaXterm
# ifconfig pegar inet (ip)
ssh <inet> -l everis

# iniciar os serviços
sh start_all_service.sh
```

(conceitos)
nó = máquina
daemon = programa = serviço



Hadoop

- Open-source

- Escalável

- Faz uso de hardware comum

- Possui filesystem distribuído (HDFS)

- Infra confiável capaz de lidar c/ falhas (hardware, software, rede)



Distros
OpenSource -> Apache Hadoop



HDFS

- Baseado no Google FS

- Escalável e tolerante a falhas

- tabalha bem c/ arquivo de texto, sequence file, Parquet, AVRO, ORC

- bloco de tamnhos de 128m

- fator de replicação default 3

camadas
HDFS -> OS filesystem -> disco rígido



NameNode:

- gerencia o namespace

- Se namenode parar o cluster fica inacessível

- tem os metadados

DataNode

- armazena os blocos de arquivos
- tem os dados em si

Secondy NameNode
- tarefas de ponto de verificação e manutenção do namenode
- substitui o namenode se o mesmo "cair"



PUT/GET

```shell
# copiar arquivo do HDFS para o SO local
# [programa] [subsistema] [comando] [caminho HDFS]
hdfs dfs -get /tmp/file_teste.txt

# Caso dê erro de permissão quando for realizar o PUT
sudo -u hdfs hdfs dfs -chmod -R 777 /tmp

# Caso o Namenode entre em Safe Mode
sudo -u hdfs hdfs dfsadmin -safemode leave

# ingestão de arquivo do SO local no HDFS
# [programa] [subsistema] [comando] [caminho SO] [caminho HDFS]
hdfs dfs -put file_teste.txt /user/everis-bigdata/
```



**PRÁTICA**

```shell
# descobrir ip do servidor
# é o ip em inet (192.168. ...)
ifconfig

# desabilita o firewall no servidor linux
sudo systemctl disable firewalld && sudo systemctl stop firewalld

# conectar com o Moba
# SSH <ip do servidor> -l ("ele" mnúsculo) <login>
SSH 192.168.1.86 -l everis
  
# acertar o ip
# e modificar o ip do arquivo para o ip descoberto
nano /etc/
   
# start de todos os serviços
sh script_apoio/start_all_service.sh

# verifica se cada serviço está OK
service hadoop-hdfs-namenode status
service hadoop-hdfs-secondarynamenode status

# reiniciar a máquina
shutdown now

# copiar arquivo do HDFS para o SO local
hdfs dfs -get /tmp/file_teste.txt
 
# ingestão de arquivo so SO local no HDFS
hdfs dfs -put file_teste.txt /user/everis-bigdata/

# lista os diretórios e arquivos no HDFS
hdfs dfs -ls -h /user/everis-bigdata/

# caso dê algum erro de permissão	
sudo -u hdfs hdfs dfs -chmod -R 777 /tmp/file_teste

# visualizar o conteúdo do arquivo
# ... head -10 (mostra só as 10 primeiras linhas)
hdfs dfs -cat /user/everis-bigdata/file_teste.txt | head -10

# remover arquivo do HDFS
hdfs dfs -rm /user/everis-bigdata/file_teste.txt

# criar diretório no HDFS
hdfs dfs -mkdir /user/everis-bigdata/delete

# copiar arquivo no HDFS
hdfs dfs -cp /user/everis-bigdata/file_teste.txt /user/everis-bigdata/delete

# mover arquivo no HDFS
hdfs dfs -mv /user/everis-bigdata/file_teste.txt /user/everis-bigdata/delete

# criar arquivo vazio
hdfs dfs -touchz /user/everis-bigdata/delete/empty_file

# deletar o diretório recursivo
hdfs dfs -rm -R /user/everis-bigdata/delete

# ver o uso de disco de cada diretório
sudo -u hdfs hdfs dfs -du -h /user/everis-bigdata/

# ver condições do cluster
sudo -u hdfs hdfs fsck /user/everis-bigdata/ -files -blocks
```



YARN

- gerenciamento de recursos

- monitoramento de Jobs

- recursos dos nós, que são alocados somente quando requisitados (via container)

Componentes

- Application: um job submetido ao Hadoop

- Application Master: gerencia a execução e o escalonamento das tarefas (há 1 por aplicação)

- Container: unidade de alocação de recursos (ex. c1 = 1Gb RAM, 2 CPU)

- Resource Manager: gerenciador global de recursos

- Node Manager: gerencia o ciclo de vida e monitora os recursos do container



**PRÁTICA**

```shell
# infra (bigdata-srv)
sudo sed -i 's|hdfs://|hdfs://bigdata-srv:8020/|g' /etc/hadoop/conf/yarn-site.xml

# para ver se deu certo
cat /etc/hadoop/conf/yarn-site.xml | grep bigdata-srv
		
# Que ira mostrar:
#	<value>bigdata-srv</value>
#	<value>hdfs://bigdata-srv:8020/bigdata-srv:8020/var/log/hadoop-rn/apps</value>

# Verificar status de utilização de memória
free -mh

# começar o processamento map/reduce	
# sudo -u [programa] [subcomando] [tipo de arquivo] [jar c/ a aplicação que ira rodar] [função/método do app(jar) c/ a lógica do processo] [arquivo de entrada para ser processado] [local de saída do arquivo com o resultado do processo]
sudo -u hdfs yarn jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount /tmp/file_teste.txt /tmp/wc_output

# Verificando o que tem no arquivo file_teste.txt
hdfs dfs -cat /tmp/file_teste.txt

# Verificando o diretório do output
hdfs dfs -ls /tmp/wc_output

# Verificando o arquivo de saída
hdfs dfs -cat /tmp/wc_output/part-r-00000

# Verificando o log do job com more
sudo -u hdfs yarn logs -applicationId application_1611297663370_0001 |more

# Verificando o log do job com o tail -f
sudo -u hdfs yarn logs -applicationId application_1611297663370_0001 |tail -f

# Copiando log para o servidor local
sudo -u hdfs yarn logs -applicationId application_1611297663370_0001 > wordcount.log

# interrompe os serviços via script
sh script_apoio/stop_all_service.sh

## Individualmente
sudo service hive-server2 stop
sudo service hive-metastore stop
sudo service hbase-master stop
sudo service hbase-regionserver stop
sudo service impala-catalog stop
sudo service impala-state-store stop
sudo service impala-server stop
sudo service hadoop-mapreduce-historyserver stop
sudo service hadoop-yarn-resourcemanager stop
sudo service hadoop-yarn-nodemanager stop
sudo service hadoop-hdfs-datanode stop
sudo service hadoop-hdfs-namenode stop
sudo service hadoop-hdfs-secondarynamenode stop
sudo service zookeeper-server stop

#  inicia novamente via script 
sh script_apoio/start_all_service.sh

## Individualmente
sudo service hive-server2 start
sudo service hive-metastore start
...
sudo service zookeeper-server start
```



Erro:

Ao executar "sudo -u hdfs yarn jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount /tmp/file_teste.txt /tmp/wc_output" minha aplicação não saia de "State: ACCEPTED" site do cluster e no terminal fica parado em "INFO mapreduce.Job: Running job: job_1611181306457_0001"

Após a sugestão de rodar novamente o comando abaixo, 

```shell
sudo sed -i 's|hdfs://|hdfs://bigdata-srv:8020/|g' /etc/hadoop/conf/yarn-site.xml
```

sem sucesso, então retirei as linhas abaixo do arquivo /etc/hadoop/conf/yarn-site.xml e funcionou 

```xml
<property>
	<description>Where to aggregate logs to.</description>
	<name>yarn.nodemanager.remote-app-log-dir</name>
	<value>hdfs://bigdata-srv:8020/bigdata-srv:8020/bigdata-srv:8020/bigdata-srv:8020/var/log/hadoop$
</property>
```



LOGs
```shell
# ver log da aplicação
sudo -u hdfs yarn logs -applicationId application_1611228392475_0001_01_000001 | more

# salvar log da aplicação no SO local
sudo -u hdfs yarn logs -applicationId application_1611228392475_0001_01_000001 > log_application_1611228392475_0001_01_000001.log
```



RESUMO

HDFS é a camada de armazenamento do Hadoop

- Divide os dados em blocos e os distribui pelo cluster
- Os workers rodam o daemon DataNode e o master o daemon NameNode
- MapReduve foi o primeiro framework de computação distribuída utilizado c/ o HDFS
  (em desuso, há frameworks melhores hoje)
- Processamento passou a ser nos servidores onde o dado está armazenado
  (aproximou)



YARN gerencia os recursos no cluster

- Trabalha c/ o HDFS p/ executar as tarefas quando o dado é armazenado
- Os workers rodam o daemon NodeManager e o master o daemon ResourceManager
- É possível monitorar os jobs através da porta 8088