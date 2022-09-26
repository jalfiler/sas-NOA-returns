*Chequala Fuller, Taylor Mack, Jomaica Alfiler, and Monica Cao;
*OMSBA 5270 - Data Translation Challenge;
*August 26, 2022;


*Purpose: This program reads in the dtc_noa_merge data file and keeps the SALE variable to calculate lag sales for use in the model and overall analysis.;


*call out the file path and read in the data file;
libname tmp2 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
run;

*read in data file;
data a1; set tmp2.dtc_all_combined;


data a2; set a1;
keep GVKEY2 CUSIP CHE MSA SEQ DLTT DLC SALE RET FDYEAR;


proc print data = a2(obs = 500); run;


proc sort; by GVKEY2 FDYEAR;
proc expand out = yy method = none;
convert FDYEAR = LFDYEAR / transform = (lag 1);
convert SALE = LSALE  / transform = (lag 1);
by GVKEY2;


data a3;  set yy;
if FDYEAR - lFDYEAR = 1;

*check point: check the data;
proc print data = a3(obs = 5000); run;

data new; set a3;
data tmp4.dtc_final_set; set new;
proc means; run;


*check point: check the data;
proc print data = new(obs = 5000); run;

