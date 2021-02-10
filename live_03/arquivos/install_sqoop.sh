echo "Instalando o Sqoop..."
sudo yum install --assumeyes sqoop
cd /tmp
wget http://www.java2s.com/Code/JarDownload/java-json/java-json.jar.zip
unzip /tmp/java-json.jar.zip
sudo mv /tmp/java-json.jar /usr/lib/sqoop/lib/
sudo chown root: /usr/lib/sqoop/lib/java-json.jar
sqoop-version
