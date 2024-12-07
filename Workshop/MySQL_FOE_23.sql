create Database FOE_23;
use FOE_23;
create table DEPARTMENT(
	Dept_ID varchar(45),
    Dept_Head varchar(255) not null,
    primary key (Dept_ID)
);
drop table DEPARTMENT;

create table EMPLOYEE(
	Empl_ID varchar(15) not null,
    Dept_ID varchar(45) ,
    Area varchar(50) ,
    Designation varchar(50),
    primary key (Empl_ID)
);
drop table EMPLOYEE;


    
Insert into DEPARTMENT ( Dept_ID , Dept_Head) 
values( 'EIE' ,  'Menuka');

insert into department values ( 'MME' ,  'Ranil');
insert into department values ( 'CEE' ,  'Lasitha');

insert into employee 
values ( 'EE001' ,  'EIE' , 'Software', 'Lecturer');
insert into employee 
values ( 'EE002' ,  'EIE' , 'Communication', 'Senior Lecturer');
insert into employee 
values ( 'EE007' ,  'EIE' , 'software', 'Lecturer');
insert into employee 
values ( 'MM001' ,  'MME' , 'Manufacturing' );
insert into employee 
values ( 'CE001' ,  'CEE' , 'Communication', 'Senior Lecturer');
insert into employee 
values ( 'EE007' ,  'MME' , 'Automobile', 'Lecturer');


alter table EMPLOYEE Add constraint FK_DeptID foreign key(Dept_ID) references department(Dept_ID)
on delete set null on update cascade;



create table PROJECT(
	Employee_ID varchar(45),
    Project varchar(255) ,
    primary key ( Project, Employee_ID)
);

insert into Project values ('EE001' , 'Prj_01');
insert into Project values ('EE001' , 'Prj_02');
insert into Project values ('CE008' , 'Prj_01');

/* insert into Project values ('EE001' , 'Prj_01'),('EE001' , 'Prj_02'),('CE008' , 'Prj_01');  can insert like this way also */

create table ProjEmoRelationship(
	ProjID varchar(15) NOT NULL,
    EmplID varchar(25) not null,
    primary key (projID,EmplID),
    constraint fk_prj foreign key(projID) references project(project),
    constraint  fk_emp foreign key(EmplID) references Employee(Empl_ID)
);
drop table project;

alter table employee add Age int default 25;
alter table employee add Joined_date date default '2019-12-17';
alter table employee add Joined_time time default '00:00:00';
alter table employee add Married boolean default 1;
alter table employee add Security_Code binary(6) default 010101 ;
alter table employee add Experience decimal(3,1) default 10.0 ;

alter table employee add check( Age > 20 and Age < 60);
alter table employee add check ( Experience < 50 ) ;
show create table employee;

/* how to change area into specialization*/

alter table employee change Area Specialization varchar(20);
alter table employee modify column Designation varchar(25);

alter table employee 
drop primary key,
Add unique(Empl_ID),
Add constraint PK_Emp primary key(Empl_ID, Designation);

show create table employee;
 
alter table employee drop column Experience;




-- DATA MODIFICATION

Delete from employee where Dept_ID != 'EIE' ;
Delete from employee where Empl_ID = 'EE002' ;

alter table employee alter joined_time set default null;

insert into employee (Empl_ID, Dept_ID, Designation) values( 'CE008' , 'CEE' , 'Lecturer');

update employee set Age = 27 where Empl_ID = 'EE001' ;

update employee set Age = 39 ;

-- Retrieve data

Select Empl_ID, Dept_ID, Specialization, Age, Married, Designation, Joined_Date, Joined_time, Security_code from Employee;
Select * from Employee;
Select * from Employee where Designation = "Lecturer";
Select Empl_id, security_Code from employee where age > 25 ;
Select age,joined_date from employee where married = 1 order by age asc;


-- Head = departmentID and H = Dean
-- Alias Head table   
-- 5)
select * from employee as E inner join department as D on E.Dept_ID = D.Dept_ID;
select * from department as D inner join employee as E on E.Dept_ID = D.Dept_ID;

select * from employee natural	join department;

select * from employee as E left outer join department as D on E.Dept_ID = D.Dept_ID;	-- it keeps all the entries of left side table which is employee table
select * from employee as E right outer join department as D on E.Dept_ID = D.Dept_ID;    -- it keeps all the tuples of the Department table, that's th different between left and right
-- it keeps all the entries, even it doesm't match with the data

-- full outer join table
(select * from employee as E left outer join department as D on E.Dept_ID = D.Dept_ID) 
union
(select * from employee as E right outer join department as D on E.Dept_ID = D.Dept_ID);
-- 

create view my_view as select * from employee natural join department;
select age from my_view;
drop view my_view;

-- cartesian product
select * from employee cross join department;
select * from department cross join employee;

select count(*) from employee cross join department;

select E.Empl_ID as Employee_ID, D.Dept_Head as Department_Head from employee as E natural join department as D where Joined_date > '2017-12-31';
select distinct designation from employee;     -- -shows the distinct designatoin types

select dept_ID, count(dept_ID) as Num_of_Employees, avg(age) as Average_Age from employee group by Dept_ID;
select Dept_ID as Department_ID, count(dept_ID) as Employee_number, max(age) as Age_Max from employee group by Dept_ID having Employee_number > 2 ; -- where count(dept_ID) > 2 ;

-- 13)
select * from employee
where ((Designation like '%Lecturer%') and (Joined_Date like '201_-1_-__')); 

-- 14)
select age , Age+10 as Age10 from employee where Age in (27,39,55);

-- 15) 
select age from employee where Specialization is null;

select E.Empl_ID , E.Joined_date from Employee as E natural join Department as D  where D.Dept_head = 'Lasitha'
union
select J.Empl_ID, J.Joined_date from Employee as J inner join Project as P on J.Empl_ID = P.project = 'prj_2';

create view UV1 as select E.Empl_ID, E.Joined_date from Employee as E natural join Department as D where D.Dept_Head = 'Lasitha' ;
Create view UV2 as select J.Empl_ID, J.joined_date from Employee as J inner join project as P on J.Empl_ID = P.Project where P.Project = 'Prj_2';
(select * from UV1) union (select * from UV2);  					-- We use userview to simplify queries 
drop view UV3;
drop view UV4;

create view UV3 as select E.Empl_ID, E.Joined_time from Employee as E inner join Project as P on E.Empl_ID = P.Employee_ID where P.Project = 'Prj_01' ;
select * from UV3;
Create view UV4 as select J.Empl_ID, J.joined_date from Employee as J natural join Department as D where D.Dept_head = 'Menuka';
(select * from UV3) intersect (select * from UV4);  

select E.Empl_ID , E.Joined_date from Employee as E natural join Department as D 
inner join 
Project as P on E.Empl_ID = P.Employee_ID where D.Dept_Head = 'Menuka' AND P.project = 'Prj_01';

select * from employee as E natural join Department as D 	where D.Dept_head = 'Menuka';
select E.Empl_ID , E.Security_Code from employee as E natural join Department as D 	where D.Dept_head = 'Menuka'
union
select E.Empl_ID , E.Security_Code from employee as E inner join Project as P on E.Empl_ID = P.Employee_ID where P.Project != 'Prj_01'; 



-- -------------------------------------------------
create table Dependent(
	Empl_ID varchar(15) not null,
    Depe_name varchar(45) ,
    sex varchar(10),
    primary key (Empl_ID,depe_name),
    constraint fk_dependent foreign key(Empl_ID) references
    employee(Empl_ID)
);
drop table dependent;

insert into dependent
values ( 'EE001' ,  'Meranda' , 'M');
insert into dependent
values ( 'EE001' ,  'Mcintyre' , 'F');
insert into dependent
values ( 'EE002' ,  'Mark' , 'F');
insert into dependent
values ( 'EE003' ,  'Supun' , 'M');


create view DEP_EMP as select * from  Employee natural join Dependent;
select * from DEP_EMP;

select P.Employee_ID from project as p where project = 'prj_01'
and P.Employee_ID in
(select D.empl_id from dependent as D where sex = 'M') ;

select Empl_ID, designation, Married,age from employee where age > all(select age from employee where Empl_id in ('EE001' , 'CE008')); 
select Dept_Head from department where Dept_Head in (select Depe_name from dependent);













	