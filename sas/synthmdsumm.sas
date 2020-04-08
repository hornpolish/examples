%let lib=casuser;
%let data=syndatap;

proc delete data=&lib..mdsumm1;
  run;
proc delete data=&lib..mdsumm2;
  run;

proc mdsummary data=&lib..&data;
  var y;
  groupby host cc10;
  output out=&lib..mdsumm1;
  run;
  
proc print data=&lib..mdsumm1(obs=200);
  var host cc10 _column_ _nobs_ _mean_ _min_ _max_;
  run;
  

proc mdsummary data=&lib..&data;
  var y norm1 norm2 norm3 norm4 norm5 norm6 norm7 norm8 norm9 norm10;
  groupby host cc10 cc10k rowm885;
  output out=&lib..mdsumm2;
  run;
  
proc print data=&lib..mdsumm2(obs=400);
  var host cc10 _column_ _nobs_ _mean_ _min_ _max_;
  run;
  