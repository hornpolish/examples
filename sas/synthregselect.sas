
%let lib=casuser;
%let data=syndatap;

ods noproctitle;

proc regselect data=&lib..&data;

	class cc5 cc50 cc100 cn1 cn2 cn3 cn4 cn5 cn10 cn20 cn100 cn10k;

	model y=norm1 norm2 norm3 norm4 norm5 norm6 
		norm7 norm8 norm9 norm10 norm11 norm12 norm13 norm14 norm15 norm16 norm17 
		norm18 norm19 norm20 unif1 unif2 unif3 unif4 unif5 unif6 unif7 unif8 unif9 
		unif10 unif11 unif12 unif13 unif14 unif15 unif16 unif17 unif18 unif19 unif20 
		/;

	selection method=backward
       (select=sbc stop=sbc choose=sbc) hierarchy=none;

run;
ods noproctitle;
