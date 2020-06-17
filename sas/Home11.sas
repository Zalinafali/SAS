
/*  11.1  */

option mprint=1;

%macro create(prefix, N, k, l);
	%do n=1 %to &N;
		data &prefix.&n;
			array tab[&k];
			do i=1 to &l;
				do j=1 to &k;
					tab[j] = 2*rand("uniform") - 1;
				end;
				output;
			end;
		drop j;
		run;
	%end;
%mend create;

%create(ds, 3, 10, 5);


/*  11.2  */

%macro count(set, variables, n);

	%let i = 1;
	%let tmp = %scan(&variables, &i, " ");
	
	%do %while (%length(&tmp) > 0);

		data sol2_&i;
			set &set end=last;
			if &tmp > &n then counter+1;
			
			if last then do;
				&tmp = counter;
				output;
			end;
			keep &tmp;
		run;
	
		%let i = %eval(&i + 1);
		%let tmp = %scan(&variables, &i, " ");
		
	%end;
	
	data sol2;
		merge
		%do k=1 %to %eval(&i-1);
			sol2_&k
		%end;
		;
	run;

%mend count;

%count(work.ds1, tab2 tab4 tab5, 0.1);


/*  11.3  */


%macro nodots();

	%let set = lab11.dots;
	%let col = 30;
	
	data nodots_ds;
		set &set;
		if z1 ne . then output;
		keep z1;
	run;
	
	%let i=2;

	%put &i;
	%put &col;

	%do %while(&i <= &col);

		%put &i;

		data sol3;
			set &set;
			if z&i ne . then output;
			keep z&i;
		run;
		
		%let i=%eval(&i + 1);
		
		data nodots_ds;
			merge nodots_ds sol3;
		run;
		
	%end;

%mend nodots;

%nodots();


/*  11.4  */

/* I don't understand exactly what I need to do here. In the task it's written that it should be done in two ways,
 	but the second way needs the first one, so I did it in the one macro.  */

data a;
	do i=1 to 50;
		x = ceil(rand("uniform") * 10);
		output;
	end;
	keep x;
run;

%macro averg(set);

	data temp;
		set &set;
		x1 = x;
		drop x;
	run;

	%let i = 2;
	
	%do %while (&i <= 50);
	
		data temp1;
			set &set;
			if _n_ >= &i then do;
				x&i = x;
				output;
			end;
			drop x;
		run;
		
		data temp;
			merge temp temp1;
		run;

		%let i = %eval(&i + 1);
	%end;
	
	proc transpose data=temp out=ta;
	run;

	proc means data=ta;
		output out = mns;
	run;
	
	data average;
		set mns;
		if _STAT_ eq "MEAN" then do;
			array temp[50] col1-col50;
			do i=1 to dim(temp);
				avg = temp[i];
				output;
			end;
		end;
		keep avg;
	run;

%mend averg;

%averg(a);


/*  11.5  */


%macro countWords(variables);
	%let c = 0;
	%let i = 1;
	
	%let temp = %scan(&variables,&i," ");
	
	%do %while (%length(&temp) > 0);
		%let c = %eval(&c + 1);
		%let i = %eval(&i + 1);
		%let temp = %scan(&variables,&i," ");
	%end;

	%put Number of words: &c;
%mend countWords;

%countWords(aa bbb c ddddd   ee);


%macro writeWordsToMacro(variables);
	%let i = 1;
	
	%let temp = %scan(&variables,&i," ");
	
	%do %while (%length(&temp) > 0);
		
		%global &temp;
		
		%let i = %eval(&i + 1);
		%let temp = %scan(&variables,&i," ");
	%end;	
%mend writeWordsToMacro;

%writeWordsToMacro(aa bbb c ddddd   ee);

%put _user_;


/*  11.6  */

%macro factorial(n);
	%let i = &n;
	%let res = 1;
	
	%do %while (&i > 1);
		%let res = %eval(&i * &res);
		%let i = %eval(&i - 1);
	%end;

	%put Factorial from &n: &res;
%mend;

%factorial(5);


/*  11.7  */

option mprint = 1;

%macro namesWithoutChars(names, chars);
	%let i = 1;	
	%let name = %scan(&names, &i, " ");
	
	%do %while (%length(&name) > 0);
		%let j = 1;
		%let flag = 0;
		%let char = %scan(&chars, &j, " ");
		
		%do %while (%length(&char) > 0);
			%if %sysfunc(find(&name,&char)) ne 0 %then %let flag = 1;
			
			%let j = %eval(&j+1);
			%let char = %scan(&chars, &j, " ");
		%end;
		
		%if &flag eq 0 %then %put Name: &name;
	
		%let i = %eval(&i+1);
		%let name = %scan(&names, &i, " ");
	%end;

%mend namesWithoutChars;

%namesWithoutChars(agh dad bob, d e r o);


/*  11.8 ??? */

/* not mine solution */
%macro comb(n,k);
	
	%let start = 1 ;
 	%let stop = %eval( &n - &k) ;
 	
 	data combinations ;
	
		%do i = 1 %to &k;
			%let stop = %eval(&stop + 1) ;
				do var&i = &start to &stop ;
			%let start = %str(%(var&i + 1 %)) ;
		%end ;
		
		output;
		
		%do i = 1 %to &k ;
 			end ;
 		%end ;

	run;

%mend comb;

%comb(6,3);







