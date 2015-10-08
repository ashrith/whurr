#! /usr/bin/env bash

touch /tmp/start.of.test >>/tmp/start.of.test 2>&1

echo '-----BEGIN RSA PRIVATE KEY-----
##PUT YOUR AMAZON PEM KEY HERE. BUT PLEASE DO NOT PUBLISH IT!
-----END RSA PRIVATE KEY-----
' | tee -a /home/ubuntu/amazon-key-name >>/tmp/start.of.test 2>&1


chmod 400 /home/ubuntu/amazon-key-name >>/tmp/start.of.test 2>&1
chown ubuntu.ubuntu /home/ubuntu/amazon-key-name >>/tmp/start.of.test 2>&1

apt-get install -y gdebi-core >>/tmp/start.of.test 2>&1
wget http://archive.cloudera.com/cdh5/one-click-install/precise/amd64/cdh5-repository_1.0_all.deb -O /tmp/cdh-repo.deb >>/tmp/start.of.test 2>&1
wget http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key -O /tmp/archive.key >>/tmp/start.of.test 2>&1
apt-key add /tmp/archive.key >>/tmp/start.of.test 2>&1
yes | gdebi /tmp/cdh-repo.deb >>/tmp/start.of.test 2>&1

apt-get update >>/tmp/start.of.test 2>&1


apt-get install -y hadoop-yarn-resourcemanager >>/tmp/start.of.test 2>&1
apt-get install -y hadoop-hdfs-namenode >>/tmp/start.of.test 2>&1
apt-get install -y hadoop-hdfs-secondarynamenode >>/tmp/start.of.test 2>&1
apt-get install -y hadoop-yarn-nodemanager hadoop-hdfs-datanode hadoop-mapreduce >>/tmp/start.of.test 2>&1
apt-get install -y hadoop-mapreduce-historyserver hadoop-yarn-proxyserver >>/tmp/start.of.test 2>&1
apt-get install -y hadoop-client >>/tmp/start.of.test 2>&1

apt-get install -y hadoop-0.20-mapreduce-jobtracker >>/tmp/start.of.test 2>&1
apt-get install -y hadoop-hdfs-namenode >>/tmp/start.of.test 2>&1
apt-get install -y hadoop-hdfs-secondarynamenode >>/tmp/start.of.test 2>&1
apt-get install -y hadoop-0.20-mapreduce-tasktracker hadoop-hdfs-datanode >>/tmp/start.of.test 2>&1
apt-get install -y hadoop-client >>/tmp/start.of.test 2>&1

apt-get install -y pkg-config >>/tmp/start.of.test 2>&1

apt-get install -y python-software-properties >>/tmp/start.of.test 2>&1
add-apt-repository -y ppa:webupd8team/java >>/tmp/start.of.test 2>&1
apt-get update >>/tmp/start.of.test 2>&1
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get install -y oracle-java7-installer >>/tmp/start.of.test 2>&1

apt-get install -y libtool  autoconf g++ make >>/tmp/start.of.test 2>&1
apt-get install -y unzip >> /tmp/start.of.test 2>&1

wget https://github.com/google/protobuf/archive/v2.5.0.zip -O /tmp/protobuf.zip >>/tmp/start.of.test 2>&1	

nwd=`pwd`
cd /tmp/
unzip -o protobuf.zip >>/tmp/start.of.test 2>&1
cd protobuf-*/ >> /tmp/start.of.test 2>&1
./autogen.sh >>/tmp/start.of.test 2>&1
./configure --prefix=/usr/local >>/tmp/start.of.test 2>&1
make >>/tmp/start.of.test 2>&1
make install >>/tmp/start.of.test 2>&1

cd $nwd >>/tmp/start.of.test 2>&1

ldconfig


cp -r /etc/hadoop/conf.empty /etc/hadoop/conf.whurr >>/tmp/start.of.test 2>&1
update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.whurr 50 >>/tmp/start.of.test 2>&1
update-alternatives --set hadoop-conf /etc/hadoop/conf.whurr >>/tmp/start.of.test 2>&1

echo 'export HADOOP=/usr/lib/hadoop
export HADOOP_HOME=$HADOOP
export HADOOP_LIB=$HADOOP/lib
export HADOOP_COMMON_HOME=$HADOOP
export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce
export HADOOP_HDFS_HOME=/usr/lib/hadoop-hdfs
export YARN_HOME=/usr/lib/hadoop-yarn
export PATH=$PATH:$HADOOP_BIN
export HADOOP_CONF_DIR=/etc/hadoop/conf
export HADOOP_BIN=$HADOOP_HOME/bin
export HADOOP_OPTS=-Djava.awt.headless=true
export HADOOP_LIBS=/etc/hadoop/conf:/usr/lib/hadoop/lib/:/usr/lib/hadoop/.//:/usr/lib/hadoop-hdfs/./:/usr/lib/hadoop-hdfs/lib/:/usr/lib/hadoop-hdfs/.//:/usr/lib/hadoop-yarn/lib/:/usr/lib/hadoop-yarn/.//:/usr/lib/hadoop-mapreduce/lib/:/usr/lib/hadoop-mapreduce/.//
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
export R_LIBS=$HOME/R_LIBS
' | tee /etc/profile.d/hadoop.sh >>/tmp/start.of.test 2>&1


apt-get --yes install libpcre3-dev liblzma-dev libbz2-dev /tmp/start.of.test 2>&1
R CMD javareconf >>/tmp/start.of.test 2>&1

echo "deb https://cran.rstudio.com/bin/linux/ubuntu precise/" | sudo tee -a /etc/apt/sources.list >> /tmp/start.of.test 2>&1
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9 >>/tmp/start.of.test 2>&1

apt-get update >>/tmp/start.of.test 2>&1
apt-get --yes --force-yes install r-base-core=3.0.0-2precise >> /tmp/start.of.test 2>&1
echo r-base-core hold | dpkg --set-selections /tmp/start.of.test 2>&1

apt-get install r-recommended=3.0.0-2precise r-cran-codetools=0.2-8-2precise0 r-base-core=3.0.0-2precise r-cran-boot=1.3-9-1precise0 r-cran-cluster=1.14.4-1precise0 r-cran-foreign=0.8.53-2precise0 r-cran-mass=7.3-26-1precise0 r-cran-kernsmooth=2.23-10-2precise0 r-cran-lattice=0.20-15-1precise0 r-cran-nlme=3.1.109-1precise0 r-cran-matrix=1.0-12-1precise0 r-cran-mgcv=1.7-22-2precise0 r-cran-survival=2.37-4-2precise0 r-cran-rpart=4.1-1-2precise0 r-cran-class=7.3-7-1precise0 r-cran-nnet=7.3-6-2precise0 r-cran-spatial=7.3-6-1precise0

ldconfig >>/tmp/start.of.test 2>&1
R CMD javareconf >>/tmp/start.of.test 2>&1

wget http://www.rforge.net/rJava/snapshot/rJava_0.9-8.tar.gz -O /tmp/rJava.tar.gz >>/tmp/start.of.test 2>&1
R CMD INSTALL /tmp/rJava.tar.gz >>/tmp/start.of.test 2>&1

wget https://cran.r-project.org/src/contrib/codetools_0.2-14.tar.gz -O /tmp/codetools.tar.gz >>/tmp/start.of.test 2>&1
R CMD INSTALL /tmp/codetools.tar.gz >> /tmp/start.of.test 2>&1
wget http://ml.stat.purdue.edu/rhipebin/Rhipe_0.75.0_cdh5mr2.tar.gz -O /tmp/rhipe.tar.gz >>/tmp/start.of.test 2>&1
sudo -u ubuntu  mkdir /home/ubuntu/R_LIBS; export R_LIBS=/home/ubuntu/R_LIBS; R CMD INSTALL /tmp/rhipe.tar.gz  >>/tmp/start.of.test 2>&1
apt-get install -y libcurl4-openssl-dev >>/tmp/start.of.test 2>&1

wget https://cran.r-project.org/src/contrib/digest_0.6.8.tar.gz -O /tmp/digest.tar.gz >>/tmp/start.of.test 2>&1
R CMD INSTALL /tmp/digest.tar.gz >>/tmp/start.of.test 2>&1

echo "#library(Rhipe)
#library(digest)
#rhinit()
#rhoptions(zips = '/tmp/bin/RhipeLib.tar.gz')
#rhoptions(runner = 'sh ./RhipeLib/library/Rhipe/bin/RhipeMapReduce.sh')"| tee -a /home/ubuntu/.Rprofile >>/tmp/start.of.test 2>&1

chown ubuntu.ubuntu /home/ubuntu/.Rprofile >>/tmp/start.of.test 2>&1


rm /etc/hadoop/conf.whurr/core-site.xml >>/tmp/start.of.test 2>&1
rm /etc/hadoop/conf.whurr/mapred-site.xml >>/tmp/start.of.test 2>&1
rm /etc/hadoop/conf.whurr/yarn-site.xml >>/tmp/start.of.test 2>&1
rm /etc/hadoop/conf.whurr/hdfs-site.xml >>/tmp/start.of.test 2>&1


echo '<?xml version="1.0"?> 
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
<!-- This is the NameNode -->
<name>fs.defaultFS</name>
<value>hdfs://10.0.48.5:8020</value>
</property>
</configuration>
' | tee /etc/hadoop/conf.whurr/core-site.xml >>/tmp/start.of.test 2>&1

echo '<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property>
<name>mapreduce.framework.name</name>
<value>yarn</value>
</property>
</configuration>
' | tee /etc/hadoop/conf.whurr/mapred-site.xml >>/tmp/start.of.test 2>&1

echo '<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>

<property>
<!-- This should match the name of the resource manager in your local deployment -->
<name>yarn.resourcemanager.hostname</name>
<value>10.0.48.5</value>
</property>

<property>
<name>yarn.nodemanager.aux-services</name>
<value>mapreduce_shuffle</value>
</property>

<property>
<!-- How much RAM on this server can be used for Hadoop -->
<!-- We will use (total RAM - 2GB). We have 64GB in our example, so use 62GB -->
<name>yarn.nodemanager.resource.memory-mb</name>
<value>6000</value>
</property>

<property>
<!-- How many CPU cores on this server can be used for Hadoop -->
<!-- We will use them all, which is 16 per node in our example cluster -->
<name>yarn.nodemanager.resource.cpu-vcores</name>
<value>2</value>
</property>

<property>
<name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
<value>org.apache.hadoop.mapred.ShuffleHandler</value>
</property>

<property>
<name>yarn.resourcemanager.scheduler.class</name>
<value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler</value>
</property>

<property>
<name>yarn.log-aggregation-enable</name>
<value>true</value>
</property>

<property>
<!-- List of directories to store temporary localized files. -->
<!-- Spread these across all local drives on all nodes -->
<name>yarn.nodemanager.local-dirs</name>
<value>file:///mnt/hadoop/yarn/local</value>
</property>

<property>
<!-- Where to store temporary container logs. -->
<!-- Spread these across all local drives on all nodes -->
<name>yarn.nodemanager.log-dirs</name>
<value>file:///mnt/hadoop/yarn/log</value>
</property>

<property>
<!-- This should match the name of the NameNode in your local deployment -->
<name>yarn.nodemanager.remote-app-log-dir</name>
<value>hdfs://10.0.48.5/var/log/hadoop-yarn/apps</value>
</property>


<property>
<name>yarn.application.classpath</name>
<value>
$HADOOP_CONF_DIR,
$HADOOP_COMMON_HOME/*,$HADOOP_COMMON_HOME/lib/*,
$HADOOP_HDFS_HOME/*,$HADOOP_HDFS_HOME/lib/*,
$HADOOP_MAPRED_HOME/*,$HADOOP_MAPRED_HOME/lib/*,
$HADOOP_YARN_HOME/*,$HADOOP_YARN_HOME/lib/*
</value>
</property>

</configuration>
' | tee /etc/hadoop/conf.whurr/yarn-site.xml >>/tmp/start.of.test 2>&1

mkdir -p /mnt/hadoop/yarn/local >>/tmp/start.of.test 2>&1
mkdir -p /mnt/hadoop/yarn/log >>/tmp/start.of.test 2>&1
chown -R yarn.yarn /mnt/hadoop/yarn/local
chown -R yarn.yarn /mnt/hadoop/yarn/log
chown -R yarn.yarn /mnt/hadoop/yarn

echo '<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>

<property>
<!-- Number of times each HDFS block is replicated. Default is 3. -->
<name>dfs.replication</name>
<value>3</value>
</property>

<property>
<!-- Size in bytes of each HDFS block. Should be a power of 2. -->
<!-- We use 2^27 -->
<name>dfs.blocksize</name>
<value>134217728</value>
</property>

<!-- Where the namenode stores HDFS metadata on its local drives -->
<!-- These are Linux filesystem paths that must already exist. -->
<property>
<name>dfs.namenode.name.dir</name>
<value>file:///mnt/hadoop/dfs/nn</value>
</property>

<!-- Where the secondary namenode stores HDFS metadata on its local drives -->
<!-- These are Linux filesystem paths that must already exist. -->
<property>
<name>dfs.namenode.checkpoint.dir</name>
<value>file:///mnt/hadoop/dfs/sn</value>
</property>

<!-- Where each datanode stores HDFS blocks on its local drives. -->
<!-- These are Linux filesystem paths that must already exist. -->
<property>
<name>dfs.datanode.data.dir</name>
<value>file:///mnt/hadoop/dfs/dn</value>
</property>

<property>
<!-- This should match the name of the NameNode in your local deployment -->
<name>dfs.namenode.http-address</name>
<value>10.0.48.5:50070</value>
</property>

<property>
<name>dfs.permissions.superusergroup</name>
<value>hadoop</value>
</property>

<property>
<name>dfs.client.read.shortcircuit</name>
<value>true</value>
</property>

<property>
<name>dfs.client.read.shortcircuit.streams.cache.size</name>
<value>1000</value>
</property>

<property>
<name>dfs.client.read.shortcircuit.streams.cache.expiry.ms</name>
<value>10000</value>
</property>

<property>
<!-- Leave the dn._PORT as is, do not try to make this a number -->
<name>dfs.domain.socket.path</name>
<value>/var/run/hadoop-hdfs/dn._PORT</value>
</property>

</configuration>
' | tee /etc/hadoop/conf.whurr/hdfs-site.xml >>/tmp/start.of.test 2>&1

mkdir -p /mnt/hadoop/dfs/nn >>/tmp/start.of.test 2>&1
mkdir -p /mnt/hadoop/dfs/sn >>/tmp/start.of.test 2>&1
mkdir -p /mnt/hadoop/dfs/dn >>/tmp/start.of.test 2>&1
chown -R hdfs.hdfs /mnt/hadoop/dfs/nn >>/tmp/start.of.test 2>&1
chown -R hdfs.hdfs /mnt/hadoop/dfs/sn >>/tmp/start.of.test 2>&1
chown -R hdfs.hdfs /mnt/hadoop/dfs/dn >>/tmp/start.of.test 2>&1
chown -R hdfs.hdfs /mnt/hadoop/dfs
chmod 700 /mnt/hadoop/dfs >>/tmp/start.of.test 2>&1
usermod -a -G hadoop ubuntu >>/tmp/start.of.test 2>&1


echo "ip-10-0-48-6.ec2.internal" | tee /etc/hadoop/conf.whurr/masters >>/tmp/start.of.test 2>&1

update-rc.d hadoop-0.20-mapreduce-jobtracker disable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-0.20-mapreduce-tasktracker disable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-mapreduce-historyserver disable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-hdfs-namenode disable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-hdfs-secondarynamenode disable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-hdfs-datanode disable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-yarn-nodemanager disable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-yarn-resourcemanager disable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-yarn-proxyserver disable >>/tmp/start.of.test 2>&1

ipvalue=$(ifconfig | grep -o "10.0.48.5") >>/tmp/start.of.test 2>&1

if [ $ipvalue == "10.0.48.5" ]; then 

sudo -u hdfs hdfs namenode -format >>/tmp/start.of.test 2>&1
/etc/init.d/hadoop-hdfs-namenode start >>/tmp/start.of.test 2>&1

sudo -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging >>/tmp/start.of.test 2>&1
sudo -u hdfs hadoop fs -mkdir -p /tmp/bin >>/tmp/start.of.test 2>&1
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp >>/tmp/start.of.test 2>&1
sudo -u hdfs hadoop fs -mkdir -p /user/history >>/tmp/start.of.test 2>&1
sudo -u hdfs hadoop fs -chmod -R 1777 /user/history >>/tmp/start.of.test 2>&1
sudo -u hdfs hadoop fs -chown mapred:hadoop /user/history >>/tmp/start.of.test 2>&1
sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn >>/tmp/start.of.test 2>&1
sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn >>/tmp/start.of.test 2>&1

update-rc.d hadoop-mapreduce-historyserver enable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-hdfs-namenode enable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-yarn-resourcemanager enable >>/tmp/start.of.test 2>&1

else

update-rc.d hadoop-hdfs-datanode enable >>/tmp/start.of.test 2>&1
update-rc.d hadoop-yarn-nodemanager enable >>/tmp/start.of.test 2>&1

fi

echo 'net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
' | tee -a /etc/sysctl.conf

export DEBIAN_FRONTEND=noninteractive
shutdown now -r
cp /tmp/start.of.test /home/ubuntu/start.of.test
touch /tmp/end.of.test >>/tmp/start.of.test 2>&1 

