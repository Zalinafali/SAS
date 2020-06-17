
/*  9.1  */

/* a */

proc sql outobs=1;

	select *, count(*) as nr_of_rentals
	from (  select rental_offices.*
			from lab9.rental_offices as rental_offices
			inner join lab9.rental as rental on rental_offices.nr_place = rental.nr_rent_office
			group by rental_offices.nr_place
			having rental.date_rent >= '1999-01-01'
				and rental.date_rent <= '1999-06-06'
		 )
	group by rental_offices.nr_place
	order by nr_of_rentals desc
	;

quit;

/* b */

proc sql;

	select customers.name, customers.surname
	from lab9.customers as customers
	inner join lab9.rental as rental on customers.nr_customer = rental.nr_customer
	inner join lab9.cars as cars on rental.nr_car = cars.nr_car
	group by customers.nr_customer
	having count(*) > 1
		and cars.brand='OPEL'
	;
	
quit;

/* c */

proc sql;

	select rental_offices.*, rental.date_rent, rental.date_return, cars.*
	from lab9.rental_offices as rental_offices
	inner join lab9.rental as rental on rental_offices.nr_place = rental.nr_rent_office
	inner join lab9.cars as cars on rental.nr_car = cars.nr_car
	group by rental_offices.nr_place
	having rental.date_rent >= '1998-10-01'
		and rental.date_rent <= '1998-12-31'
	order by (input(rental.date_return, yymmdd10.) - input(rental.date_rent, yymmdd10.))
	;
	
quit;

/* d */

proc sql;

	select customers.*, cars.brand, count(*) as unique_rentals
	from (	select distinct customers.*, cars.brand, count(*) as num_of_rentals
			from lab9.customers as customers
			inner join lab9.rental as rental on customers.nr_customer = rental.nr_customer
			inner join lab9.cars as cars on rental.nr_car = cars.nr_car
			group by customers.nr_customer
			having num_of_rentals > 1		
		 )
	group by customers.nr_customer
	having unique_rentals = num_of_rentals
	;

quit;

/* e */

proc sql;
	
	select *
	from lab9.employees as employees
	where not (exists(	select *
						from lab9.rental as rental
						where ((rental.date_rent >= '1999-10-01'
									and rental.date_rent < '2000-02-01')
								or	(rental.date_return >= '1999-10-01'
									and rental.date_return < '2000-02-01')
								)
							and employees.nr_employee = rental.nr_employee_rent
					 )
				or exists(	select *
							from lab9.rental as rental
							where ((rental.date_rent >= '1999-10-01'
										and rental.date_rent < '2000-02-01')
									or (rental.date_return >= '1999-10-01'
										and rental.date_return < '2000-02-01')
									)
								and employees.nr_employee = rental.nr_employee_return
						 )
			  )
	;
quit;

/* f */

proc sql;

	(	select distinct employees1.name, employees1.surname
		from lab9.employees as employees1
		inner join	lab9.rental as rental1 on employees1.nr_employee = rental1.nr_employee_rent
		having rental1.nr_rent_office <> rental1.nr_office_return
			and employees1.nr_employee = rental1.nr_employee_rent
			and rental1.nr_office_return is not null
	)
	union
	(	select distinct employees2.name, employees2.surname
		from lab9.employees as employees2
		inner join	lab9.rental as rental2 on employees2.nr_employee = rental2.nr_employee_return
		having rental2.nr_rent_office <> rental2.nr_office_return
			and employees2.nr_employee = rental2.nr_employee_return
			and rental2.nr_office_return is not null
	)
	order by surname;
	;
	
quit;

/* g */

proc sql outobs=1;
	select nr_employee, name, surname, date_employment, department, position, nr_phone, sum(costs) as profit
	from (
			select *
			from lab9.employees as employees
			inner join (	select nr_employee_rent, nr_employee_return,
								((input(date_return, yymmdd10.) - input(date_rent, yymmdd10.) + 1) * rental.day_price) as costs
							from lab9.rental as rental
							where rental.date_return < '2000-01-01'
								and rental.date_return >= '1999-01-01'				
						) as rental1
				on employees.nr_employee = rental1.nr_employee_rent
			where employees.date_employment < '1998-01-01'
			union
			select *
			from lab9.employees as employees
			inner join (	select nr_employee_rent, nr_employee_return,
								((input(date_return, yymmdd10.) - input(date_rent, yymmdd10.) + 1) * rental.day_price) as costs
							from lab9.rental as rental
							where rental.date_return < '2000-01-01'
								and rental.date_return >= '1999-01-01'				
						) as rental1
				on employees.nr_employee = rental1.nr_employee_return
			where employees.date_employment < '1998-01-01'
		)
	group by nr_employee
	order by profit desc
	;

quit;

/* h */

proc sql;

	select nr_car, date_rent, date_return, customers.name, customers.surname,
		((input(date_return, yymmdd10.) - input(date_rent, yymmdd10.) + 1) * rental.day_price) as costs
	from lab9.rental as rental
	inner join lab9.customers as customers on rental.nr_customer = customers.nr_customer
	where nr_car = '000003'
	;

quit;


/*  9.2 ?????? */

proc sql;

	select dates.instrument, dates.date as date, measurements.date as measurement_date, measurement
	from lab9.dates as dates
	inner join lab9.measurements as measurements on dates.instrument = measurements.instrument
	group by dates.instrument, dates.date
	having min(abs(dates.date - measurements.date)) = abs(dates.date - measurements.date)
	;

quit;

/*  9.3  */

proc sql;

	select avg(sales) as avg
	from lab8.small as small
	left join lab8.large as large on small.id= large.id
	;
	
quit;


/*  9.4  */

data razem;
	merge lab9.a(in = ina) lab9.b(in = inb);
	by a b c;
	if inb;
	if inb and not ina then indyk=1;
run;

proc sql;

	select *,
		case 
			when exists ( select * from lab9.a as da where db.a = da.a and db.b = da.b and db.c = da.c)
	      		then .
	      	else 1
		end as indyk
	from lab9.b as db
	;

quit;


/*  9.5  */

data lab9.sol5;
	set lab9.students (rename=(id_student=student));
	
	array classmates(5);
	
	k = 0;
	do i=1 to nob;
		set lab9.students (rename=(id_class=class)) nobs=nob point=i;
		if class = id_class then do;
			if id_student ne student then do;
				k+1;
				classmates(k) = id_student;
			end;
		end;
	end;
	output;
	drop k id_student class;
run;










