options cashost="cascon" casport=5570;
cas;

proc casutil;
  load data=sashelp.cars outcaslib="casuser" casout="cascars";
  run;

libname casuser cas caslib=casuser;

proc cas;
  simple.summary
    / table={name="cascars" caslib="casuser"};
  run;

proc regselect data=casuser.cascars;
  model MPG_Highway=MSRP MPG_City Weight Wheelbase;
  run;

proc cas;
  history;
  listnodes;
  tableInfo / caslib="casuser";
  tableDetails / caslib="casuser" name="cascars" level="BLOCK";
  run;
