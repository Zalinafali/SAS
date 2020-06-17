
/*  1  */

data ex1;
	set lab13.a nobs=obs end=end;

	array tmp(2,31) _temporary_;
	
	tmp(1,_n_) = x;
	tmp(2,_n_) = y;
	
	if end then do;
			x = tmp(1,1);
			y = tmp(2,1);
			output;
			
			do i=2 to obs;
				if tmp(1,i) eq . then x = tmp(1,i-1);
				else x = tmp(1,i);
					
				if tmp(2,i) eq . then y = tmp(2,i+1);
				else y = tmp(2,i);
				output;
			end;
	end;
	
	keep x y ;
run;


/*  2  */

data ex2;
	retain x y x_w y_w last;

	infile "C:/SAS Iniversity Edition/myfolders/Lab13/b.txt" _infile_ = line;
	input;
	
	r = line;
	
	if mod(_n_, 5) eq 0 then do;
			r = line;
			x = substr(r, x_w, 1);
			y = substr(r, y_w, 1);
			output;
		end;
	else do;
			if last eq "x" then do;
				x_w = r;
			end;
			if last eq "y" then do;
				y_w = r;
			end;
			last = r;
		end;
	keep x y;
run;


/*  3  */


data ex3;
	merge lab13.w1 (rename=(z1=z11 z2=z12 z3=z13)) lab13.w2 (rename=(z1=z21 z2=z22 z3=z23));
	by id;
	
	if (z11 + z12 + z13) > (z21 + z22 + z23) then do;
			z1 = z11;
			z2 = z12;
			z3 = z13;
		end;
	else do;
			z1 = z21;
			z2 = z22;
			z3 = z23;
		end;
	keep z1 z2 z3;
run;






















