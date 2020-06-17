
/*  6.1  */

data lab6.sol1;
	i = 1;
	set lab6.a point=i;
	
	array num (10) k1-k10;
	array tmp (10) _temporary_;
	
	do j = 1 to 10;
		tmp(j) = num(j);
	end;
	
	j = 1;
	i = tmp(j);
	do while(i ^= .);
		set lab6.a point=i;
		j = j + 1;
		i = tmp(j);
		output;
	end;
	stop;
	drop j;
run;

/*  6.2  */

data lab6.sol2a;
	k = 1;
	set lab6.tree point=k;
	array node (2) left right;
	
	r = ceil(2 * rand("Uniform"));
	k = node(r);
	output;
	
	do while(k ^= .);
		set lab6.tree point=k;
		r = ceil(2 * rand("Uniform"));
		k = node(r);
		output;
	end;
	stop;
run;

/*  6.3  */

data lab6.sol3_1;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/p1.txt" dlm="x" missover;
	input id height weight sex $ age name $;
run;

data lab6.sol3_2;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/p2.txt" missover;
	input id 1 height 2-4 weight 5-6 sex $ 7 age 8-9 name $;
run;

data lab6.sol3_3;
	informat id 1. name $ 16. salary comma9.2 date yymmdd8.;
	format salary comma9.2 date yymmdd8.;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/p3.txt" missover;
	input id name $ & salary :comma9.2 date yymmdd8.;
run;

data lab6.sol3_4;
	informat name $ 8. surname $ 16. number 4.;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/p4.txt";
	input name $ / surname $ / number;
run;

/*  6.4  */

data lab6.sol4a;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/experiment.txt" missover;
	input date yymmdd8. number status $;
run;

data lab6.sol4b;
	format duration 4.;
	set lab6.sol4a;	
	retain st;
	
	if(_N_ eq 1) then st = 0;
	
	if(status eq "START") then st = date;
	else if(status eq "STOP" and st ne 0) then do;
			duration = date - st;
			st = 0;
			output;
		end;
	keep duration;
run;

/*  6.5  */

data lab6.sol5;
	format date ddmmyy10.;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/fileB.txt" missover;
	input date ddmmyy10. @"r1" r1 @1 @"r2" r2 @1 @"r3" r3 @1 @"r4" r4;
run;

/*  6.6  */

data lab6.sol6;
	format id 2. date ddmmyy8. person $ 8. amount comma6.2;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/fileC.txt" missover;
	input id persons $ 10. num1 :comma6. num2 :comma6. dt ddmmyy10.;
	retain date;
	
	if(dt ne .) then date = dt;
	
	do i=1 to countw(persons,"/");
		person = scan(persons,i);
		if i eq 1 then amount = num1;
			else amount = num2;
		output;
	end;
	
	keep date person amount;
run;

/*  6.7  */

data lab6.sol7;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/fileD.txt" missover;
	input id $ x cont $ @;
	
	do while(cont eq "x");
		input x cont $ @;
	end;
	drop cont;
run;

/*  6.8  */

data lab6.sol8;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/p.txt" missover;
	
	array dt(10) _temporary_;
	array rd(10);
	
	do i=1 to 10;
		input dt(i) @;
	end;
	
	k = 1;
	do while(dt(k) ne .);
		input #(dt(k)) @;
		do i=1 to 10;
			input rd(i) @;
		end;
		output;
		k = k+1;
	end;
	input #10;
	keep rd1-rd10;
run;

/*  6.9  */

data lab6.sol9;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/gaps.txt" dlm=" . " missover;
	input one two three;
run;

/*  6.10  */

data lab6.sol10;
	infile "C:/SAS Iniversity Edition/myfolders/Lab6/blocks.txt" truncover;
	
	format r2004 1. r2005 1. r2006 1. r2007 1.;

	array t4(100) _temporary_;
	array t5(100) _temporary_;
	array t6(100) _temporary_;
	array t7(100) _temporary_;
	
	array d4(12);
	array d5(12);
	array d6(12);
	array d7(12);
	
	retain k;
	
	k=1;
	
	do i=k to k+3;
		input #i dt @;
		if(dt eq 2004) then do;
				do j=1 to 12;
					input d4(j) @;
				end;
			end;
		else if(dt eq 2005) then do;
				do j=1 to 12;
					input d5(j) @;
				end;
			end;
		else if(dt eq 2006) then do;
				do j=1 to 12;
					input d6(j) @;
				end;
			end;
		else if(dt eq 2007) then do;
				do j=1 to 12;
					input d7(j) @;
				end;
			end;
	end;
	
	do i=1 to 12;
		r2004 = d4(i);
		r2005 = d5(i);
		r2006 = d6(i);
		r2007 = d7(i);
		output;
	end;
	keep r2004 r2005 r2006 r2007;
run;











