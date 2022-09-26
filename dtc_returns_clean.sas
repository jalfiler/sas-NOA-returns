*Chequala Fuller;
*OMSBA 5270 - Data Translation Challenge;
*August 26, 2022;


*Purpose: This program cleans the RET data by identifying missing observations and removing/replacing them ;
*to omit any outliers or skewness in preparation of preparing data for the model and overall analysis.;


*call out the file path and read in the data file;
libname tmp1 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270';
libname tmp2 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
run;

*read in data file;
data a1; set tmp2.dtc_returns;
FDYEAR = year(DATADATE);
GVKEY2 = GVKEY * 1;

proc print data = a1(obs = 5000); run;
proc means; run;

*select variables for analysis;
data a2; set a1;
keep GVKEY2 DATADATE CUSIP LPERMNO RET FDYEAR;

*proc print data = a2(obs = 5000); *run;

*identify missing observations;
data a3; set a2;
proc univariate; var RET; run;


data a4; set a3;
if RET = "." then RET = 0;


proc print data = a4(obs = 5000); run;


*show the outliers;
data a5; set a4;
proc univariate; var RET; run;


*proc print data = a5(obs = 5000); *run;


*deal with outliers one year at a time;
data a6; set a5;
data a7; set a6;
if FDYEAR = 2000;
if FDYEAR = 2001;
if FDYEAR = 2002;
if FDYEAR = 2003;


*proc print data = a7(obs = 5000); *run;


proc univariate noprint; var RET;
output p1 = M1RET p99 = M99RET out = trim1; *min (1%) and max (99%);


data a8;
if _N_ = 1 then set trim1;
set a7;

*two additional variables have been created (M1AT and M99AT);
*check point: data has been adjusted so it is good to print and check every time an adjustment is made.;
*proc print data = a8(obs = 5000); *run;

data a9; set a8;

*remove the outliers;
data a10; set a9;
if RET > M99RET then RET = M99RET;
if RET < M1RET then RET = M1RET;


*proc print data = a10(obs = 5000); *run;

*remove unneccessary data;
data a11; set a10;
drop M1RET M99RET;


proc print data = a11(obs = 5000); *run;


proc univariate; var RET; run;


data a12; set a11;
data a13; set a12;


*create temporary files of cleaned data by year one variable at a time;
data tmp2.RET2000; set a13;
data tmp2.RET2001; set a13;
data tmp2.RET2002; set a13;
data tmp2.RET2003; set a13;


