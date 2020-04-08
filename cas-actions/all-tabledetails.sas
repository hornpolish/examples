cas adminSess;

proc cas;
   session adminSess;

   table.caslibInfo  result=cliR/
      srcType="ALL";
   run;

   clib = cliR.caslibinfo;

   do row over clib;
      lib = row.name;
      print "Tables for " lib;

      table.tableInfo result=tiR/ 
         caslib=lib;
      run;

      tabList = tiR.tableInfo;
      
      nRows = 0;
      nRows = tablist.nrows;
      print lib " has " nrows " tables";

      if nRows > 0 then do;
         do trow over tabList;
            table = trow.name;
            print "Details for " table;

            table.tableDetails /
                caslib=lib
                table=table;
            run;
            end;
         
         end;
      end;
quit;

cas adminSess disconnect;