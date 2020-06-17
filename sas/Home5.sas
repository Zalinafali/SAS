
/*   5.1    */

data lab5.sol1;
	set lab5.a;
	by x;
	
	retain maxdif;
	
	lu = lag(u);
	
	if first.x then do;
		maxdif = 0;
	end;
	else if maxdif < abs(u - lu) then maxdif = abs(u - lu);
	if last.x then do;
		output;
	end;
	
	drop u;
run;

/*   5.2    */

data lab5.sol2;
	set lab5.b;
	by x;
	
	array y(*) y1-y10;
	array maxnum(10);
	
	retain maxnum;
	
	if first.x then do;
		do i=1 to 10;
			maxnum(i) = y(i);
		end;
		n = 10;
		do while(n>1);
			do i=1 to n-1;
				if (maxnum(i) > maxnum(i+1)) then do;
					t = maxnum(i);
					maxnum(i) = maxnum(i+1);
					maxnum(i+1) = t;
				end;
			end;
			n = n-1;
		end;
	end;	
	else
		do;
			do i=1 to 10;
				if(y(i) > maxnum(1)) then do;
					maxnum(1) = y(i);
					do i=1 to 9;
						if (maxnum(i) > maxnum(i+1)) then do;
							t = maxnum(i);
							maxnum(i) = maxnum(i+1);
							maxnum(i+1) = t;
						end;
					end;			
				end;
			end;
		end;
	if last.x then do;
		output;
	end;
	
	keep x maxnum:;
run;

/*   5.3    */

data lab5.sol3;
	set lab5.c;
	by x;
	
	retain n;
	
	array y(*) y1-y10;
	array _y(5,10) _temporary_;
	
	array res(10);
	array sum_y(10);

	if first.x then do;
		n = 1;
		do i=1 to 10;
			_y(n,i) = y(i);
		end;
	end;
	
	else
		do;
			n = n+1;
			do i=1 to 10;
				_y(n,i) = y(i);
			end;
		end;
	
	if last.x then do;
	
		do i=1 to 10;
			sum_y(i) = 0;
			res(i) = 0;
		end;
	
		do i=1 to 5;
			do j=1 to 10;
				if (_y(i,j) ^= .) then do;
					sum_y(j) = sum_y(j) + _y(i,j);
					res(j) = res(j) + 1;				
				end;
			end;
		end;
		
		do i=1 to 10;
			sum_y(i) = sum_y(i) / res(i);
		end;
		
		do i=1 to 5;
			do j=1 to 10;
				if(_y(i,j) ^= .) then res(j) = _y(i,j);
				else res(j) = sum_y(j);
			end;
			output;
		end;
	end;
	
	keep x res: ;
	format res: 3.2;
run;

/*   5.4    */

data lab5.sol4;
	set lab5.values;
	
	num_words = countw(x,", ");
	
	do i=1 to num_words;
		wrd = scan(x,i,", ");
		num_wrd = input(wrd, 8.);
		output;
	end;
	
	keep num_wrd;
run;

/*   5.5    */

proc sort data=lab5.alert_client out=lab5.alert_clients;
	by client_id descending alert_date;
run;

data lab5.sol5a;
	set lab5.alert_clients;	
	by client_id;
	
	retain flag;
	
	lad = lag(alert_date);
	
	if first.client_id then flag=0;
	else do;	
		 if lad-alert_date < 2*365 then flag=1;
		 end;
	
	if last.client_id and flag eq 1 then output;
	
	keep client_id;
run;


data lab5.sol5b;
	set lab5.alert_client;
	
	array lastdate(500) _temporary_;
	array outputed(500) _temporary_;
	
	if lastdate(client_id - 1000) eq . then lastdate(client_id - 1000) = alert_date;
	else
		if outputed(client_id - 1000) eq . and lastdate(client_id - 1000) - alert_date < 2*365 then do;
			outputed(client_id - 1000) = 1;
			output;
		end;
		else
			if outputed(client_id - 1000) eq . then lastdate(client_id - 1000) = alert_date;  

	keep client_id;
run;

/* 5.6  */

data lab5.sol6;
	set lab5.d;
	
	format date date9.

	array y(*) y1-y12;
	
	do i=1 to dim(y);
		date = mdy (i, 1, 2014 + _n_);
		val = y(i);
		output;
	end;
	
	keep date val;
run;

/*   5.7    */

data lab5.sol7;
	set lab5.dtrans;
	
	length yr 4;
	
	array res(12) y1-y12 (12*0);
	
	i = mod(_n_, 12);
	if (i ^= 0) then res(i) = y;
	else do;
		 	res(12) = y;
		 	yr = year(date);
		 	output;
		 end;
		 
	keep yr y1-y12 ;
	rename yr = year;
run;














