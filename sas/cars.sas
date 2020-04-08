
proc contents data=sashelp.cars; run;

proc print data=sashelp.cars(obs=20);
  run;
