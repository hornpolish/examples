proc cas;
tabledetails result=r / table='cars', level='node';
print r.TableDetails[,{'Node','Rows'}];
quit;
