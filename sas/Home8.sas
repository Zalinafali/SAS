
/*  8.1  */

/* z2 file is corrupted */

/*  8.2  */

data lab8.sol2;
	set lab8.large end=end;
	do i=1 to num;
		set lab8.small(rename=(id=id1)) point=i nobs=num;
		if id1=id then do;
			k+1;
			mean+sales;
		end;
	end;
	if end then do;
		mean=mean/k;
		output;
	end;
	keep mean;
run;

/*  8.3  */

data lab8.sol3;
	set lab8.large end=end;
	do i=1 to num;
		set lab8.numbers point=i nobs=num;
		if _N_=nr then do;
			k+1;
			mean+sales;
		end;
	end;
	if end then do;
		mean=mean/k;
		output;
	end;
	keep mean;
run;

/*  8.4  */

data lab8.sol4;
	set lab8.dots end=end;
	array tmp(10,3) _temporary_;
	
	if z1 ne . then do;
		i+1;
		tmp(i,1) = z1;
	end;
	
	if z2 ne . then do;
		j+1;
		tmp(j,2) = z2;
	end;
	
	if z3 ne . then do;
		k+1;
		tmp(k,3) = z3;
	end;
	
	if end then do;
		do m=1 to 10;
			z1 = tmp(m,1);
			z2 = tmp(m,2);
			z3 = tmp(m,3);
			output;
		end;
	end;
	keep z1-z3;
run;

/*  8.5  */

data lab8.sol5num;
	do i=1 to 50;
		u = floor(5*ranuni(0));
		output;
	end;
	keep u;
run;

data lab8.sol5;
	set lab8.sol5num;
	array tmp(5) _temporary_;
	
	if _n_ <= dim(tmp) then tmp(_n_) = u;
	else do;
		do i=1 to dim(tmp)-1;
			tmp(i) = tmp(i+1);
		end;
		tmp(dim(tmp)) = u;
	end;
	
	if _n_ >= dim(tmp) then do;
		sum = sum(of tmp(*));
		output;
	end;
	
	keep sum;
run;

/*  8.6  ??????????? */

proc sql;
	create table aa as
	select *, count(y) as licznik
	from lab8.a
	group by x
	having count(y)>5
	;
quit;

data lab8.sol6;
	set lab8.a;
	by x;
	
	if first.x then do;
		indx = _n_;
		count = 0;
		set lab8.a (rename=(x=x1)) point=indx;
		if x eq x1 then output;
	end;
	
	keep x y count;
run;

/*  8.7  */

data lab8.year2007;
	do date="01JAN2007"D to "31DEC2007"D;
		output;
	end;
	format date ddmmyy10. ;
run;

data lab8.sol7;
		set lab8.year2007 (in=w0) lab8.zb1 (in=w1) lab8.zb2 (in=w2) lab8.zb3 (in=w3) lab8.zb4 (in=w4) lab8.zb5 (in=w5);
		by date;
		if w0=1 then d=0;
		if w1=1 then d=1;
		if w2=1 then d=2;
		if w3=1 then d=3;
		if w4=1 then d=4;
		if w5=1 then d=5;
		
		array tmp(5) _temporary_;
		array z(5);
		
		if first.date then do;
			do i=1 to 5;
				tmp(i) = .;
			end;
		end;
		
		if d ne 0 then tmp(d) = x;
		
		if last.date then do;
			do i=1 to 5;
				z(i) = tmp(i);
			end;
			output;
		end;
		
		keep date z:;
run;

/*  8.9  */

data lab8.sol9;
	set lab8.zxy end=end;
	retain count;
	
	do i=1 to xn;
		set lab8.zx (rename=(x=x1)) point=i nobs=xn;
		if x = x1 then do;
			do j=1 to yn;
				set lab8.zy (rename=(y=y1)) point=j nobs=yn;
				if y = y1 then do;
					count+1;
					i = xn;
					j = yn;
				end;
			end;
		end;
	end;
	
	if end then output;
	keep count;
run;









