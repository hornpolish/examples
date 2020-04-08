
cas mycas;

libname myora oracle path="exadat12c"  user="kent" password="kent";

proc datasets lib=myora;
  run;
  
proc print data=myora.cars;
  run; 


ods noproctitle;
ods graphics / imagemap=on;

proc means data=myora.cars chartype mean std min max n vardef=df;
	var MSRP MPG_City MPG_Highway Weight Wheelbase;
	output out=work.Means_stats mean=std=min=max=n= / autoname;
run;

/* To get the regression model and output plots use this code */

proc glmselect data=myora.cars 
    outdesign(addinputvars)=Work.reg_design 
		plots=(criterionpanel);
	model MPG_Highway=MSRP MPG_City Weight Wheelbase/ showpvalues 
		selection=stepwise
 
(select=sbc);
run;

%put GLSMOD: &_GLSMOD;
proc reg data=Work.reg_design alpha=0.05 
    plots(only)=(diagnostics residuals observedbypredicted);
	ods select DiagnosticsPanel ResidualPlot ObservedByPredicted;
	model MPG_Highway=&_GLSMOD /;
	run;
quit;


proc delete data=Work.reg_design;
run;

cas mycas listhistory;