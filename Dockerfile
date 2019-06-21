FROM daocloud.io/library/ubuntu:disco
ENV DEBIAN_FRONTEND=noninteractive


RUN sed -i 's/archive.ubuntu.com/mirrors.xtom.com.hk/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.xtom.com.hk/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y dist-upgrade

RUN apt-get -y install software-properties-common wget curl nano openjdk-8-jdk build-essential

ADD data/scala-2.12.8.deb /scala/
RUN dpkg -i /scala/scala-2.12.8.deb

ADD data/hadoop-3.1.2.tar.gz /hadoop/
ENV HADOOP_HOME=/hadoop/hadoop-3.1.2 
ENV PATH=$PATH:$HADOOP_HOME/bin 
ENV PATH=$PATH:$HADOOP_HOME/sbin 
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME 
ENV HADOOP_HDFS_HOME=$HADOOP_HOME 
ENV YARN_HOME=$HADOOP_HOME 
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

ADD data/spark-2.4.3-bin-without-hadoop-scala-2.12.tgz /spark
RUN mv /spark/spark-2.4.3-bin-without-hadoop-scala-2.12 /spark/spark-2.4.3
ENV SPARK_HOME=/spark/spark-2.4.3

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV SPARK_HOME=/spark/spark-2.4.3
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
RUN cp -rf /hadoop/hadoop-3.1.2/share/hadoop/common/lib/slf4j-* /spark/spark-2.4.3/jars/
ADD data/spark-env.sh /spark/spark-2.4.3/conf/

