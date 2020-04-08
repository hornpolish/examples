option set=SAS_HADOOP_CONFIG_PATH="/opt/sas/viya/config/data/hadoop/conf";
option set=SAS_HADOOP_JAR_PATH="/opt/sas/viya/config/data/hadoop/lib";

libname hadoop hadoop server="rdcgrdb.unx.sas.com"  user="kent";

proc datasets lib=hadoop;
  run;

proc print data=hadoop.cars;
  run;
