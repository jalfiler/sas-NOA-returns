*this program answers the questions that answer the assignment;
libname tmp1 'C:\Users\cfuller\OneDrive - Seattle University\Desktop\omsba5270\dtc_project';
run;

data a1; set tmp1.dtc_returns;
if RET = "." then RET = 0;

data a2; set a1;
FDYEAR = year(DATADATE);
MO = month(DATADATE);

data a3; set a2;

proc sort; by LPERMNO DATADATE;

data a4; set a3;
keep LPERMNO RET FDYEAR MO;

data a5; set a4;
if MO = 1 then RET1 = RET;
if RET1 = "." then delete;
keep LPERMNO RET1 FDYEAR;

proc sort; by LPERMNO FDYEAR;
proc sort ; by LPERMNO FDYEAR;
proc means; run;

data a6; set a3;
keep LPERMNO RET LPERMNO FDYEAR;

data a7; set a6;
if MO = 2 then RET2 = RET;
if RET2 = "." then delete;
keep LPERMNO RET2 FDYEAR;
proc sort ; by LPERMNO FDYEAR;

data a8;
merge a5 a7;
by LPERMNO FDYEAR;

data a9; set a8;
data a10; set a9;

proc print data = a10 (obs = 5000); run;

*create temporary files of cleaned data by year one variable at a time;
data tmp1.dtc_returns_cleaned; set a10;

