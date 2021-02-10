echo "Apagando diretório de output"
sudo -u hdfs hdfs dfs -rm -R /user/everis-bigdata/pokemon

echo "Importando a tabela"
sudo -u hdfs sqoop import \
--connect jdbc:mysql://localhost/trainning \
--username root --password "Everis@2021" \
--fields-terminated-by "|" \
--split-by Generation \
--target-dir /user/everis-bigdata/pokemon \
--query 'SELECT * FROM pokemon WHERE $CONDITIONS' \
--where 'Number IS NOT NULL' \
--compress \
--num-mappers 4
