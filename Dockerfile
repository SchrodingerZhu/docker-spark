FROM daocloud.io/library/ubuntu:devel
ENV DEBIAN_FRONTEND=noninteractive


RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y dist-upgrade

RUN apt-get -y install software-properties-common wget curl emacs openjdk-8-jdk build-essential

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list &&\
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 &&\
    apt-get update &&\
    apt-get -y install sbt 

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

ADD data/spark-2.4.0-bin-without-hadoop-scala-2.12.tgz /spark
RUN mv /spark/spark-2.4.0-bin-without-hadoop-scala-2.12 /spark/spark-2.4.0
ENV SPARK_HOME=/spark/spark-2.4.0

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV SPARK_HOME=/spark/spark-2.4.0
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
RUN cp -rf /hadoop/hadoop-3.1.2/share/hadoop/common/lib/slf4j-* /spark/spark-2.4.0/jars/
ADD data/spark-env.sh /spark/spark-2.4.0/conf/

