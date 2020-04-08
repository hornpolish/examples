%let driver=SAS Institute, Inc 8.0 SQL Server Wire Protocol;
%let host=40.88.23.189;
%let host=azbdcsql.unx.sas.com;
%let port=31433;
%let user=admin;
%let pass=yM+z3)opil6jZn+OPXkM)2z6;
%let database=daghazdb;
%let schema=dbo;

libname x sasiosrv noprompt="DRIVER=&driver;UID=&user;PWD=&pass;HOST=&host;PORT=&port;DATABASE=&database;SSLLibName=/usr/lib64/libssl.so.10;CryptoLibName=/usr/lib64/libcrypto.so.10;ValidateServerCertificate=0;" schema=&schema;

proc delete data=x.a;
data x.a; x=1; run;
proc datasets dd=x; run;
proc contents data=x.a; run;