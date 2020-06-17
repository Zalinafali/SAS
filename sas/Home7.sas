
/* TODO: 
			7.4 f
			7.4 g
*/


/*  7.1  */

data lab7.sol1a;
	array z(10);
	k = 0;
	do while(k < 20);
		k = k + 1;
		do i=1 to 10;
			z(i) = i + k;
		end;
		output;
	end;
	drop k i;
run;

data lab7.sol1b;
	set lab7.sol1a end=e;
	
	array temp(10,20) _temporary_;
	array rd(10) z1-z10;
	array t(20);
	
	do i = 1 to 10;
		temp(i, _n_) = rd(i);
	end;
	
	if e then do;
		do i = 1 to 10;
			do j = 1 to 20;
				t(j) = temp(i,j);
			end;
			output;
		end;
	end;
	keep t1-t20;
run;

/*  7.2  */

proc transpose data=lab7.z1 out=lab7.sol2 (drop=_NAME_) prefix = _;
	by art;
	id dat;
run;

/* 7.3  */

proc transpose data=lab7.z out=lab7.sol3a (rename=(_NAME_=variable));
run;

proc sort data=lab7.sol3a out=lab7.sorted3;
	by variable;
run;

proc transpose data=lab7.sorted3 out=lab7.sol3b (drop=_NAME_);
	id variable;
run;

/*  7.4  */

/* a */
proc sql;
	select x, y
	from (select x, y, count(y) as occur
		  from lab7.a
		  group by x, y
		 )
	group by x
	having occur = max(occur)
	;
quit;

/* b */
proc sql;
	select x, y
	from(select x, y, count(y) as occur
			from lab7.a
			group by x, y
		)
	group by x
	having occur = max(occur)
	;
quit;

/* c */
proc sql;
	select x, y
	from (select x, y, count(y) as occur
		  from lab7.a
		  group by x, y
		 )
	group by x
	having occur = 1 and y = min(y)
	;
quit;

/* d */
proc sql;
	select x, y
	from (select x, y, count(y) as occur
		  from lab7.a
		  group by x, y
		 )
	group by x
	having occur = 1
	;
quit;

/* e */
proc sql;
	select distinct x
	from(
			select x, y, count(*) as val
			from(
				select distinct x, y
				from lab7.a
			)	
			group by x
		)
	having val = max(val)
	;
quit;

/* f ????? */
proc sql;
	select distinct x, y
	from (select x, y
		  from lab7.a
		  group by x, y
		 )
	;
quit;

/* g  ???? */
proc sql;
	select distinct x, y
	from lab7.a
	;
quit;

proc sql;
	select x, y, count(*) as val
			from(
				select distinct x, y
				from lab7.a
			)	
			group by x
	;
quit;

/* h */
proc sql;
	select y
	from (select distinct x, y
		  from lab7.a
		  group by y
		 )
	group by y
	having count(*) >= (select count(*) from (select distinct x from lab7.a))/2
	;
quit;

data test;
 	set lab7.a;
 	
 	if (_N_ eq 10) then y = ;
run;

/*  7.5  */

/* a */
proc sql;
	select distinct id
	from lab7.z3
	where id not in (select id from lab7.z3 where year < 1993)
	;
quit;

/* b */
proc sql;
	select distinct id
	from lab7.z3
	having
		id in (select id from lab7.z3 having year = min(year)) and
		id in (select id from lab7.z3 having year = max(year))
	;
quit;

/* c */
proc sql;
	select id
	from(select id, year, (max(year) - min(year) + 1) as years
			from(select distinct id, year
					from lab7.z3
				)
		)
	group by id
	having count(id) = years
	;
quit;

/* creates dataset test in which id 001 has every year to test the query c) */
data test;
	set lab7.z3;
	if _N_ eq 2 then do; 
			year = 1996;
			id = 001;
		end;
	if _N_ eq 3 then do; 
			year = 1997;
			id = 001;
		end;
	if _N_ eq 4 then do; 
			year = 2001;
			id = 001;
		end;
	if _N_ eq 5 then do; 
			year = 2002;
			id = 001;
		end;
run;

/*  7.6  */

/* a */
proc sql;
	select f.a1, f.x1
	from lab7.b f
	having
		f.x1 > (select min(x2)
			    from lab7.b
			    where a2 = f.a1
			   )
		and
		f.x1 < (select max(x2)
			    from lab7.b
			    where a2 = f.a1
			   )
	;
quit;

/* b */
proc sql;
	select f.a1 as most_occur
	from (select f.a1, count(f.x1) as x1_sum
			from lab7.b f
			group by f.a1), 
		 (select s.a2, count(s.x2) as x2_sum
			from lab7.b s
			group by s.a2)
		 having f.a1 = s.a2
		 	and (x1_sum + x2_sum) = max(x1_sum + x2_sum)  
	;
quit;

/*  7.7  */

/* a */
proc sql;
	select months
	from(select months, count(months) as sum
			from (select month(day) as months
					from lab7.c
					where r2 is null
		 		 )
			group by months		
		)
	having sum = max(sum)
	;
quit;

/* b */
/* not sure exactly what to do, assumed scatter as difference between max and min */
proc sql;
	select months
	from (select month(day) as months, (max(r1) - min(r1)) as scatter
			from lab7.c
			group by months
		 )
	having scatter = max(scatter)
	;
quit;















