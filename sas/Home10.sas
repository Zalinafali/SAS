
/*  10.1 ??????? */

data lab10.sol1keyfile;
	set lab8.small
	fmtname='sol1key';
	label = 'small';
	rename id = start;
run;

/*  10.2  */

data a;
	array z(5);
	n = 50;
	
	do i = 1 to n;
		do j = 1 to dim(z);
			z[j] = rand('normal', 100, 10);
		end;
		output;
	end;
	
	keep z: ;
run;

proc means data=a;
	output out = aMeans;
run;

data stat;
	set a;
	array z(5) z1-z5;
	length stat $8;
	
	stat = 'Wn';
	
	keep z1-z5 stat;
run;

data stat2;
	set aMeans;
	array z(5) z1-z5;
	stat = _STAT_;

	keep z1-z5 stat;
run;

proc append base=stat data=stat2;
run;


/*  10.3  */

data temp;
	set stat;
	array z(5) z1-z5;
	
	if _n_ <= 50 then do;
		output;	
	end;
	keep z1-z5;
run;

proc means data=temp StackODSOutput Q1 Q3 MEDIAN QRANGE;
	ods output summary=temp2;
run;

proc transpose data=temp2 out=ttemp2;
	id variable;
run;

data stat3;
	set ttemp2;
	array z(5) z1-z5;
	length stat $8.;
	
	stat = _NAME_;
	
	keep z1-z5 stat;
run;

proc append base=stat data=stat3;
run;


/*  10.4  */




/*  10.5  */

proc summary data=lab10.grades print;
	class student code;
	var grade;
	output out=summaryGrades MEAN= / autoname;
run;

data averages;
	set summaryGrades;
	
	if(_type_ eq 3) then output;
	
	keep student code grade_Mean;
	rename grade_Mean = avg;
run;


/*  10.6  */

proc summary data=lab10.data print;
	class group;
	var y x;
	output out=summaryData MEAN= / autoname;
run;

data temp;
	set summaryData;
	retain globX globY;
	
	if(_n_ eq 1) then do;
		globX = x_Mean;
		globY = y_Mean;
	end;
	else do;
		dist = abs(x_Mean - globX) + abs(y_Mean - globY);
		output;
	end;
	
	drop globX globY _type_ _freq_ ;
run;

proc sort data=temp out=sortedtemp;
	by dist;
run;

/* result */
data _null_;
	set sortedtemp;
	if(_n_ eq 1) then put group;
run;


/*  10.7  */


data numbers;
	array num {10} $ ("zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine");
	format x 3.1;
	x = 0.0;
	
	do while (x < 10.0);
		first = mod(x,10) + 1;
		second = mod(x*10, 10) + 1;
		name = catx(' ', num[first], 'point', num[second]);
		output;
		x = x + 0.1;
	end;
	
	keep x name;
run;

data cntlin;
	set numbers;
	fmtname = 'solnumbers';
	rename x = start name = label;
run;

proc format cntlin=cntlin;
run;

data test;
	format x solnumbers.;
	x = 0.0;
	do i=1 to 10;
		x = x + 0.3;
		y = x;
		output;
	end;
	drop i;
run;


/*  10.8  */

data randomSet;
	n = 50;	
	do i=1 to n;
		x = rand('uniform');
		output;
	end;
	keep x;
run;

proc means data=randomSet StackODSOutput MEDIAN QRANGE;
	ods output summary=means;
run; 

data sol8;
	alpha = 1;
	array outlier(2);
	set means;
	outlier[1] = Median - alpha * QRange;
	outlier[2] = Median + alpha * QRange;
	
	do k = 1 to n;
		set randomSet point=k nobs=n;
		if(x <= outlier[1] or x >= outlier[2]) then output;
	end;
	keep x;
run;













