*Chequala Fuller, Taylor Mack, Jomaica Alfiler, and Monica Cao;
*OMSBA 5270 - Data Translation Challenge;
*August 26, 2022;


*Purpose: This program runs the regression model;



*call out the file path and read in the data file;
libname tmp1 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
run;

*read in data file;
data a1; set tmp1.dtc_final_set;
*proc print data = a1(obs = 5000); *run;

*data a2; *set a1;
*keep GVKEY2 CUSIP CHE MSA SEQ DLTT DLC SALE RET FDYEAR;

data a2; set a1;
if CHE ne ".";
if SEQ ne ".";
if DLTT ne ".";
if DLC = "." then DLC = 0;
if SALE ne ".";
if RET = "." then RET = 0;


*calculate the net operating asset (NOA);
data a3; set a2;
if SALE ne 0;
NOA = (SEQ - CHE  + (DLTT + DLC)) / LSALE;
*proc print data = a3(obs = 500); run;
proc univariate; var NOA; run;

*remove any missing observations from NOA;
data a4; set a3;
if NOA ne ".";
proc print data = a4(obs = 500); run;

*windsorize NOA before regression;
proc univariate noprint; var NOA;
output p1 = M1NOA p99 = M99NOA out = trim1;


data a5;
if _N_ = 1 then set trim1;
set a4;

*two additional variables have been created (M1NOA and M99NOA);
*check point: data has been adjusted so it is good to print and check every time an adjustment is made.;
*proc print data = a8(obs = 5000); *run;

data a6; set a5;

*remove the outliers;
data a7; set a6;
if NOA > M99NOA then NOA = M99NOA;
if NOA < M1NOA then NOA = M1NOA;


*remove unneccessary data;
data a8; set a7;
drop M1NOA M99NOA;

proc univariate; var NOA; run;


*run the regression model where y = RET and x = NOA;
proc reg;
model RET = NOA;		*y = x;
run;

