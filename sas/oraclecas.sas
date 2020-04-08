
cas mycas;

caslib myora 
  datasource=(
    srctype="oracle",
    username="kent",
    password="kent",
    path="exadat12c",
    );
    
    
proc casutil;
list files incaslib="myora";
run;
