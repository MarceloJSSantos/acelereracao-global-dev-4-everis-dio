## script para e reiniciar servicos aula de hive/impala.
## caminho: /home/everis/script_apoio
# restart_all_service_hive.sh

sudo service hadoop-hdfs-namenode restart
sudo service hadoop-hdfs-secondarynamenode restart
sudo service hadoop-hdfs-datanode restart
sudo service hadoop-yarn-nodemanager restart
sudo service hadoop-yarn-resourcemanager restart
sudo service hadoop-mapreduce-historyserver restart
sudo service zookeeper-server stop
sudo service hbase-master stop
sudo service hbase-regionserver stop
sudo service hive-metastore restart
sudo service hive-server2 restart
sudo service impala-server restart
sudo service impala-state-store restart
sudo service impala-catalog restart
sudo mysqld restart
service --status-all
free -m
