


%macro syndata(
  lib=casuser,
  data=syndata,
  options=%str(replace=yes),
  replication=0,
  slash=,
  Nnorm=200,
  Nunif=200,
  Nparm=15,
  Nzero=10,
  NR=400,
  NG=100000,
  ctlonly=N,
  ctlopt=,
  ctlslash=
);

 
/*--------------------------------------------------------------------*/
/*-- these factors create about 100GB input dataset                 --*/
/*-- you can boost that to 1TB by making either of these bigger     --*/
/*-- by a factor of 10 :-)                                          --*/
/*--                                                                --*/
/*-- reps:     4 number of times we repeat the entire groupset      --*/
/*-- nr:      30 number of rows in a group (on average)             --*/
/*-- nunif:   500 number of normal   NORM variables                 --*/
/*-- nnorm:   500 number of uniform  UNIF variables                 --*/
/*-- nparm:    15 number of normal   PARM variables - same value    --*/
/*--                                      for each row always       --*/
/*-- nzero:    10 number of normal   ZERO variables - same value    --*/
/*--                                      for each row always       --*/
/*-- ng:   100000 number of groups (should exceed 100K)             --*/
/*--------------------------------------------------------------------*/


%let NNsize=%eval((&Nnorm+&Nunif+&Nparm+&Nzero+76) * 8);
%let NCsize=%eval( 12 * 10 );

%put NOTE: approx size is ( &NR * &NG * (&NNsize+&NCsize) ) / (1024 * 1024 * 1024);
%put NOTE: approx size is %eval( ( &NR * &NG * (&NNsize+&NCsize) ) / (1024 * 1024 * 1024) ) GB;



%let norm_mean = 72;
%let norm_std  = 12;

%let x_mean = 0.3;
%let x_std  = 0.2;

%let parm_mean = 0;
%let parm_std  = 0.3;

%let zero_mean = 0.5;
%let zero_std  = 0.3;

%let intercept = 2;



proc delete data=&&lib..control; 
  run;
  
proc delete data=&&lib..controlp; 
  run;
  
data &lib..control(&ctlopt) &ctlslash;

  array parm parm1-parm&Nparm;
  array zero zero1-zero&Nzero;


  call streaminit(12345);
  do i = 1 to &Nparm;
     parm[i] = rand('NORMAL', &parm_mean, &parm_std); 
     end;

  do i = 1 to &Nzero;
     zero[i] = rand('NORMAL', &zero_mean, &zero_std); 
     end;


  mystart=0;
  mystop =0;
  mydate=0;    format mydate date9.;
  mytime=0;    format mytime time11.;


  do i = 1 to &NG;

    cn1 = 1;
    cn2    = mod(i,2);
    cn3    = mod(i,3);
    cn4    = mod(i,4);
    cn5    = mod(i,5);
    cn10   = mod(i,10);
    cn13   = mod(i,13);
    cn20   = mod(i,20);
    cn50   = mod(i,50);
    cn67   = mod(i,67);
    cn100  = mod(i,100);
    cn1k   = mod(i,1000);
    cn10k  = mod(i,10000);
    cn100k = mod(i,100000);


    length  cc1 cc2 cc3 cc4 cc5 cc10 cc20 cc50 cc100 cc1k cc10k cc100k $10;

    cc1    = put(cn1     , roman10.);
    cc2    = put(cn2     , roman10.);
    cc3    = put(cn3     , roman10.);
    cc4    = put(cn4     , roman10.);
    cc5    = put(cn5     , roman10.);
    cc10   = put(cn10    , roman10.);
    cc13   = put(cn13    , roman10.);
    cc20   = put(cn20    , roman10.);
    cc50   = put(cn50    , roman10.);
    cc67   = put(cn67    , roman10.);
    cc100  = put(cn100   , roman10.);
    cc1k   = put(cn1k    , roman10.);
    cc10k  = put(cn10k   , roman10.);
    cc100k = put(cn100k  , roman10.);


    grp     +1;

    rows    = floor(&NR * 2 * RAND('UNIFORM'));
    cumrows + rows;

    seed   = floor(99999999999 * RAND('UNIFORM'));
    mystop = mystart + rows;

    output;
  
    mystart  = mystop + 1;
    mydate = mystart;
    mytime = mystart;
    end;

  run;

proc cas;
  table.partition
    / casout={name="controlp" caslib="casuser"}
      table={name="control" caslib="casuser"};
  tableDetails / caslib="casuser" name="controlp";    
  tableDetails / caslib="casuser" name="controlp" level="BLOCK";    
  run;  


%if &ctlonly = N %then %do;

proc delete data=&lib..&data; 
  run;

proc delete data=&lib..&data.p; 
  run;
  
data &lib..&data(&options copies=&replication) &slash;

  set &lib..controlp;
  by grp;

   array norm[&Nnorm];
   array unif[&Nunif];
   array parm[&Nparm];
   array zero[&Nzero];
   i=0; drop i;

   length host $12;
   host    = _hostname_;
   thread  = _threadid_;

    mydate = mystart;
    mytime = mystart;
    myrow  = mystart;

    rowm5    = mod(myrow, 5);
    rowm15   = mod(myrow, 15);
    rowm45   = mod(myrow, 45);
    rowm95   = mod(myrow, 95);
    rowm115  = mod(myrow, 115);
    rowm225  = mod(myrow, 225);
    rowm445  = mod(myrow, 445);
    rowm885  = mod(myrow, 885);
    rowm1885 = mod(myrow, 1885);

    do r=1 to rows;

      do i = 1 to &Nnorm;
         if i <= &Nparm then
            norm[i] = RAND('NORMAL') * &x_std + &x_mean;
         else
            norm[i] = RAND('NORMAL') * &norm_std + &norm_mean;
         end;

      do i = 11 to &Nnorm by 10;
         norm[i] = norm[i-10] + RAND('NORMAL')/500;
         end;
         
      do i = 12 to &Nnorm by 10;
         norm[i] = norm[i-10] + RAND('NORMAL')/100;
         end;

      do i = 15 to &Nnorm by 10;
         norm[i] = norm[i-10] + RAND('NORMAL')/50;
         end;

      do i = 17 to &Nnorm by 10;
         norm[i] = norm[i-10] + RAND('NORMAL')/10;
         end;
         
      do i = 18 to &Nnorm by 10;
         norm[i] = norm[i-10] + RAND('NORMAL')/5;
         end;
         

      do i = 1 to &Nunif;
         unif[i] = RAND('UNIFORM'); 
         end;

      off1 = RAND('NORMAL');
      off2 = RAND('NORMAL');

      x_beta = &intercept + off1;
      do i = 1 to &Nparm;
         x_beta = x_beta + parm[i] * norm[i];
         end;

      u = exp(x_beta+0.2*RAND('NORMAL'));
      y = RAND('POISSON', u);
      countreg_y = y;

      zr=zero[1]*norm[1]
        +zero[2]*norm[6]
        +zero[3]*norm[11]
        +zero[4]*norm[12]
        +zero[5]*norm[15]
        + (-1)
        +off2;
        
      pzero = cdf('LOGISTIC',zr);
      if RAND('NORMAL')<pzero then countreg_y=0;


 
      TB_T075000 = RAND('UNIFORM') >= .25;
      TB_T049000 = RAND('UNIFORM') >= .51;
      TB_T020000 = RAND('UNIFORM') >= .80;
      TB_T005000 = RAND('UNIFORM') >= .95;
      TB_T002000 = RAND('UNIFORM') >= .98;
      TB_T001000 = RAND('UNIFORM') >= .99;

      TB_T000100 = RAND('UNIFORM') >= .999;
      TB_T000010 = RAND('UNIFORM') >= .9999;
      TB_T000001 = RAND('UNIFORM') >= .99999;

      RU = RAND('UNIFORM');
      RV = RAND('UNIFORM');
      RX = RAND('UNIFORM');
      RY = RAND('UNIFORM');
      RZ = RAND('UNIFORM');

      RYY  = RY*RY;
      RZZZ = RZ*RZ*RZ;


      M1c1 = 1000;
      M1c2 = 100;
      M1c3 = 10;

      M1c1a = M1c1 + RAND('UNIFORM')/1000 * M1c1;
      M1c1b = M1c1 + RAND('UNIFORM')/800  * M1c1;
      M1c1c = M1c1 + RAND('UNIFORM')/600  * M1c1;
      M1c1d = M1c1 + RAND('UNIFORM')/400  * M1c1;
      M1c1e = M1c1 + RAND('UNIFORM')/200  * M1c1;

      M1c2a = M1c2 + RAND('UNIFORM')/100  * M1c2;
      M1c2b = M1c2 + RAND('UNIFORM')/80   * M1c2;
      M1c2c = M1c2 + RAND('UNIFORM')/60   * M1c2;
      M1c2d = M1c2 + RAND('UNIFORM')/40   * M1c2;
      M1c2e = M1c2 + RAND('UNIFORM')/20   * M1c2;

      M1c3a = M1c3 + RAND('UNIFORM')/10   * M1c3;
      M1c3b = M1c3 + RAND('UNIFORM')/8    * M1c3;
      M1c3c = M1c3 + RAND('UNIFORM')/6    * M1c3;
      M1c3d = M1c3 + RAND('UNIFORM')/4    * M1c3;
      M1c3e = M1c3 + RAND('UNIFORM')/2    * M1c3;


      M1   = m1c1  + m1c2  * RX + m1c3  * RYY;
      M1a  = m1c1a + m1c2a * RX + m1c3a * RYY;
      M1b  = m1c1b + m1c2b * RX + m1c3b * RYY;
      M1c  = m1c1c + m1c2c * RX + m1c3c * RYY;
      M1d  = m1c1d + m1c2d * RX + m1c3d * RYY;
      M1e  = m1c1e + m1c2e * RX + m1c3e * RYY;
     
      output;

      mydate + 1;
      mytime + 1;

      end;


  run;
  
  
proc cas;
  tableDetails / caslib="&lib" name="&data";    
 *tableDetails / caslib="&lib" name="&data" level="PARTITION";    
  tableDetails / caslib="&lib" name="&data" level="NODE";    
  tableDetails / caslib="&lib" name="&data" level="SUM";    
  run;  

proc cas;
  table.partition
    / casout={name="&data.p" caslib="&lib" replication=&replication}
      table={name="&data" caslib="&lib"};
  tableDetails / caslib="&lib" name="&data.p";    
 *tableDetails / caslib="&lib" name="&data.p" level="PARTITION";    
  tableDetails / caslib="&lib" name="&data.p" level="NODE";    
  tableDetails / caslib="&lib" name="&data.p" level="SUM";    
  run;    


%end;


%mend;


%syndata(replication=0);

data _null_;
  x=sleep(20,1);
  put 'I have slept' x=;
  stop;
  run;

%syndata(replication=1);
