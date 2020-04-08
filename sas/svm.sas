data casuser.bigdata ;
   array x{5} x1-x5;
   drop i n;
   do n=1 to 10000000;
      do i=1 to dim(x);
         x{i} = ranbin(10816, 12, 0.6);
         x6 = sum(x2-x4) + ranuni(6068);
      end;
      if x6 > 0.5 then y = 1;
      else if x6 < -0.5 then y = 0;
      else y = ranbin(6084, 1, 0.4);
      output;
   end;
run;


proc svmachine data=casuser.bigdata;
   input x1-x6 / level=interval;
   target y;
run;


data casuser.bigdata ;
   array x{15} x1-x15;
   drop i n;
   do n=1 to 10000000;
      do i=1 to dim(x);
         x{i} = ranbin(10816, 12, 0.6);
      end;
      xx1 = sum(x2-x4) + ranuni(6068);
      xx2 = sum(x6-x9) + ranuni(606);
      xx3 = sum(x9-x13) + ranuni(6068);
      
      if xx1 > 0.5 or xx2 > 0.5 or xx3 > 0.5 then y = 1;
      else if xx1 < -0.5 or xx2 < -0.5 or xx3 < -0.5 then y = 0;
      else y = ranbin(6084, 1, 0.4);
      output;
   end;
run;


proc svmachine data=casuser.bigdata;
   input x1-x15 xx1-xx3 / level=interval;
   target y;
run;