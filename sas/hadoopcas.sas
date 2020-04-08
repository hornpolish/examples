
cas mycas;

caslib hdlib 
  datasource=(
    srctype="hadoop",
    dataTransferMode="serial",
    username="kent",
    server="rdcgrdb.unx.sas.com",
    hadoopjarpath="/opt/sas/viya/config/data/hadoop/lib",
    hadoopconfigdir="/opt/sas/viya/config/data/hadoop/conf",
    schema="default");
    
    
proc casutil;
list files incaslib="hdlib";
run;
