create Database Gym_Management_System;
use Gym_Management_System;


-- *************CREATING TABLES*****************

create table MANAGER (
    Manager_ID varchar(45) NOT NULL,
    Branch_Num int not null,
    First_Name varchar(30) NOT NULL,
    Last_Name varchar(30) NOT NULL,
    PRIMARY KEY (Manager_ID)
);
create table MANAGER_PHONE (
    Manager_ID varchar(45) NOT NULL,
    Phone_Number int NOT NULL,
    FOREIGN KEY (Manager_ID) REFERENCES MANAGER(Manager_ID)
);

create table BRANCH(
	Branch_Num int not null,
    City varchar(40) not null,
    Town varchar(30) not null,
    Opening_Hours varchar(30) not null,
    Capacity varchar(30) not null,
    Street_Name varchar(30) not null,
    Building_Num int not null,
    primary key (Branch_Num)
);

create table MEMBER (
    Member_ID varchar(30) NOT NULL,
    Trainer_ID varchar(45) not null,
	MemType_ID varchar(45) not null,
    First_Name varchar(45) NOT NULL,
    Last_Name varchar(45),
    House_Num int,
    Street_Name varchar(45) NOT NULL,
    City varchar(30),
    primary key (Member_ID)
);
create table Member_4n_Numbers (
    Member_ID VARCHAR(30) NOT NULL,
    Phone_Number INT NOT NULL,
    FOREIGN KEY (Member_ID) REFERENCES MEMBER(Member_ID),
    primary key (Member_ID, Phone_Number)
);

create table MEMBERSHIP_TYPE(
	MemType_ID varchar(45) not null,
    Type_Name varchar(45) not null,
    Description_ varchar(45) not null,
    Time_Period varchar(45) not null,
    price float not null,
    primary key(Memtype_id)
);

create table TRAINER(
	Trainer_ID varchar(45) not null,
    Branch_Num int not null,
    First_Name varchar(45) not null,
    Last_Name varchar(45) not null,
    Salary float not null,
    Experience_yrs int not null,
    Street_Name varchar(45) not null,
    City varchar(30) not null,
    primary key(Trainer_ID)
);
create table Trainer_4n_Numbers (
    Trainer_ID varchar(30) not null,
    Phone_Number int not null,
    FOREIGN KEY (Trainer_ID) REFERENCES TRAINER(Trainer_ID),
    primary key (Trainer_ID, Phone_Number)
);

create table EQUIPMENT(
	Equipment_Number int not null,
    Equipment_Name varchar(30) not null,
    Cost float not null,
    primary key(Equipment_Number)
);
create table Equipment_branchAndUnits(
	Equipment_Number int not null,
    Branch_Num int not null,
    Number_of_Units int not null,
    FOREIGN KEY (equipment_number) REFERENCES equipment(equipment_number),
    primary key(Equipment_number,branch_num,number_of_units)
);
create table Equipment_repair_history(
	Equipment_number int not null,
    repair_history varchar(30) not null,
    FOREIGN KEY (equipment_number) REFERENCES equipment(equipment_number),
    primary key(Equipment_number,repair_history)
);

create table SCHEDULE_(
	Date_ date not null,
    Start_Time time not null,
    Duration_hrs float not null,
    Member_ID varchar(30) NOT NULL,
    primary key(Date_,start_time,Duration_hrs)
);

create table PAYMENT(
	Member_ID varchar(30) NOT NULL,
	Time_ time ,
    Date_ date not null,
    amount float not null,
    primary key(Time_,Date_,amount)
);






-- ***************foreign key**************

alter table manager
ADD CONSTRAINT FK_manager
foreign key(Branch_num) references Branch(Branch_num)
on delete cascade on update cascade;

alter table MANAGER_PHONE
ADD CONSTRAINT FK_manager_phone
foreign key(Manager_ID) references MANAGER(Manager_ID)
on delete cascade on update cascade;

alter table MEMBER
ADD CONSTRAINT FK_member_trainer
foreign key(Trainer_ID) references TRAINER(Trainer_ID)
on delete cascade on update cascade;

alter table MEMBER
ADD CONSTRAINT FK_member_membership_type
foreign key(MemType_ID) references MEMBERSHIP_TYPE(MemType_ID)
on delete cascade on update cascade;

alter table Member_4n_Numbers
ADD CONSTRAINT FK_member_phone
foreign key(Member_ID) references MEMBER(Member_ID)
on delete cascade on update cascade;

alter table TRAINER
ADD CONSTRAINT FK_trainer_branch
foreign key(Branch_Num) references BRANCH(Branch_Num)
on delete cascade on update cascade;

alter table Trainer_4n_Numbers
ADD CONSTRAINT FK_trainer_phone
foreign key(Trainer_ID) references TRAINER(Trainer_ID)
on delete cascade on update cascade;

alter table Equipment_branchAndUnits
ADD CONSTRAINT fk_equipment_branchAndUnits
FOREIGN KEY (equipment_number) REFERENCES equipment(equipment_number)
on delete cascade on update cascade;

alter table Equipment_repair_history
ADD CONSTRAINT fk_equipment_repair_history
FOREIGN KEY (equipment_number) REFERENCES equipment(equipment_number)
on delete cascade on update cascade;

alter table SCHEDULE_
ADD CONSTRAINT FK_schedule_member
foreign key(Member_ID) references MEMBER(Member_ID)
on delete cascade on update cascade;

alter table PAYMENT
ADD CONSTRAINT FK_payment_Member
foreign key(Member_ID) references MEMBER(Member_ID)
on delete cascade on update cascade;




-- Set trigger to Get Updated salary of the trainer based on the experience_yrs he has...
DELIMITER $
CREATE TRIGGER UpdatedTrainerSalary
BEFORE UPDATE ON TRAINER
FOR EACH ROW
BEGIN
    DECLARE experience_bonus INT;
    SET experience_bonus = NEW.Experience_yrs * 1000; -- Assuming Rs.1000 bonus per year of experience
    SET NEW.Salary = NEW.Salary + experience_bonus;
END;
$
DELIMITER ;


-- Set trigger to get a message if the new salary is lower then the old salary. It can't be reduced.
DELIMITER $
CREATE TRIGGER EnforceMinSalary
BEFORE UPDATE ON TRAINER
FOR EACH ROW
BEGIN
    IF NEW.Salary < OLD.Salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Trainer salary cannot be decreased.';
    END IF;
END;
$
DELIMITER ;




-- ******************Inserting Values to every tables***********************************

INSERT INTO BRANCH VALUES (101,  'Colombo', 'Nugegoda', '8:00 AM - 10:00 PM', '200', 'Duplication Road', 12);
INSERT INTO BRANCH VALUES (102,  'Kandy', 'Peradeniya', '7:00 AM - 9:00 PM', '150', 'Peradeniya Road', 25);
INSERT INTO BRANCH VALUES (103,  'Galle', 'Hikkaduwa', '6:00 AM - 8:00 PM', '100', 'Galle Road', 10);
INSERT INTO BRANCH VALUES (104,  'Matara', 'Weligama', '9:00 AM - 11:00 PM', '180', 'Weligama Road', 30);
INSERT INTO BRANCH VALUES (105,  'Negombo', 'Kurana', '10:00 AM - 12:00 PM', '120', 'Kurana Road', 15);
INSERT INTO BRANCH VALUES (106,  'Kandy', 'Katugastota', '7:30 AM - 9:30 PM', '170', 'Katugastota Road', 20);


INSERT INTO MANAGER VALUES ('MAN001', 101, 'John', 'Doe');
INSERT INTO MANAGER VALUES ('MAN002', 102, 'Jane', 'Smith');
INSERT INTO MANAGER VALUES ('MAN003', 103, 'Saman', 'Perera');
INSERT INTO MANAGER VALUES ('MAN004', 104, 'Kumardi', 'Silva');
INSERT INTO MANAGER VALUES ('MAN005', 105, 'Ravi', 'Fernando');
INSERT INTO MANAGER VALUES ('MAN006', 106, 'Nishan', 'Rajapaksa');

INSERT INTO MANAGER_PHONE VALUES ('MAN001', 771234567);
INSERT INTO MANAGER_PHONE VALUES ('MAN001', 741234567);
INSERT INTO MANAGER_PHONE VALUES ('MAN002', 772345678);
INSERT INTO MANAGER_PHONE VALUES ('MAN002', 742345467);
INSERT INTO MANAGER_PHONE VALUES ('MAN003', 723456789);
INSERT INTO MANAGER_PHONE VALUES ('MAN004', 774567890);
INSERT INTO MANAGER_PHONE VALUES ('MAN005', 755678901);
INSERT INTO MANAGER_PHONE VALUES ('MAN006', 766789012);


INSERT INTO EQUIPMENT VALUES (1, 'Treadmill', 250000);
INSERT INTO EQUIPMENT VALUES (2, 'Elliptical Machine', 180000);
INSERT INTO EQUIPMENT VALUES (3, 'Stationary Bike', 150000);
INSERT INTO EQUIPMENT VALUES (4, 'Rowing Machine', 200000);
INSERT INTO EQUIPMENT VALUES (5, 'Dumbbells Set', 100000);
INSERT INTO EQUIPMENT VALUES (6, 'Bench Press', 150000);
INSERT INTO EQUIPMENT VALUES (7, 'Smith Machine', 300000);
INSERT INTO EQUIPMENT VALUES (8, 'Leg Press Machine', 250000);
INSERT INTO EQUIPMENT VALUES (9, 'Yoga Mats', 50000);
INSERT INTO EQUIPMENT VALUES (10, 'Resistance Bands', 30000);
INSERT INTO EQUIPMENT VALUES (11, 'Jump Ropes', 20000);
INSERT INTO EQUIPMENT VALUES (12, 'Exercise Balls', 60000);
INSERT INTO EQUIPMENT VALUES (13, 'Barbell Set', 120000);
INSERT INTO EQUIPMENT VALUES (14, 'Kettlebells', 90000);
INSERT INTO EQUIPMENT VALUES (15, 'Pull-Up Bar', 80000);

INSERT INTO Equipment_branchAndUnits VALUES (1, 101, 5);
INSERT INTO Equipment_branchAndUnits VALUES (1, 104, 3);
INSERT INTO Equipment_branchAndUnits VALUES (1, 105, 4);
INSERT INTO Equipment_branchAndUnits VALUES (2, 102, 2);
INSERT INTO Equipment_branchAndUnits VALUES (2, 103, 4);
INSERT INTO Equipment_branchAndUnits VALUES (2, 106, 5);
INSERT INTO Equipment_branchAndUnits VALUES (3, 106, 3);
INSERT INTO Equipment_branchAndUnits VALUES (3, 104, 4);
INSERT INTO Equipment_branchAndUnits VALUES (3, 101, 2);
INSERT INTO Equipment_branchAndUnits VALUES (4, 104, 5);
INSERT INTO Equipment_branchAndUnits VALUES (5, 101, 3);
INSERT INTO Equipment_branchAndUnits VALUES (6, 106, 4);
INSERT INTO Equipment_branchAndUnits VALUES (7, 101, 4);
INSERT INTO Equipment_branchAndUnits VALUES (8, 102, 5);
INSERT INTO Equipment_branchAndUnits VALUES (9, 103, 3);

INSERT INTO Equipment_repair_history VALUES (10, 'Replaced belt');
INSERT INTO Equipment_repair_history VALUES (6, 'Fixed resistance mechanism');
INSERT INTO Equipment_repair_history VALUES (3, 'Replaced seat');
INSERT INTO Equipment_repair_history VALUES (8, 'Fixed handle grip');
INSERT INTO Equipment_repair_history VALUES (5, 'Replaced damaged weights');
INSERT INTO Equipment_repair_history VALUES (2, 'Repaired frame');


INSERT INTO MEMBERSHIP_TYPE VALUES ('MET001', 'Gold', 'Access to all facilities', '1 year', 10000);
INSERT INTO MEMBERSHIP_TYPE VALUES ('MET002', 'Silver', 'Limited access to facilities', '6 months', 7000);
INSERT INTO MEMBERSHIP_TYPE VALUES ('MET003', 'Bronze', 'Basic access to facilities', '3 months', 5000);
INSERT INTO MEMBERSHIP_TYPE VALUES ('MET004', 'Platinum', 'Premium access to all facilities', '2 years', 15000);
INSERT INTO MEMBERSHIP_TYPE VALUES ('MET005', 'Student', 'Discounted membership for students', '1 year', 8000);
INSERT INTO MEMBERSHIP_TYPE VALUES ('MET006', 'Corporate', 'Discounted membership for corporate employees', '1 year', 12000);


INSERT INTO TRAINER VALUES ('TRN001', 101, 'Kusal', 'Perera', 60000, 5, 'Galle Road', 'Colombo');
INSERT INTO TRAINER VALUES ('TRN002', 102, 'Chamari', 'Atapattu', 55000, 4, 'Kandy Road', 'Kandy');
INSERT INTO TRAINER VALUES ('TRN003', 103, 'Lasith', 'Malinga', 65000, 6, 'Matara Road', 'Galle');
INSERT INTO TRAINER VALUES ('TRN004', 104, 'Angelo', 'Mathews', 60000, 5, 'Weligama Road', 'Matara');
INSERT INTO TRAINER VALUES ('TRN005', 105, 'Muttiah', 'Muralitharan', 70000, 8, 'Katunayake Road', 'Negombo');
INSERT INTO TRAINER VALUES ('TRN006', 106, 'Rangana', 'Herath', 55000, 4, 'Kandy Road', 'Kandy');

INSERT INTO Trainer_4n_Numbers VALUES ('TRN001', 771234567);
INSERT INTO Trainer_4n_Numbers VALUES ('TRN001', 741234567);
INSERT INTO Trainer_4n_Numbers VALUES ('TRN002', 772345678);
INSERT INTO Trainer_4n_Numbers VALUES ('TRN002', 742345467);
INSERT INTO Trainer_4n_Numbers VALUES ('TRN003', 723456789);
INSERT INTO Trainer_4n_Numbers VALUES ('TRN004', 774567890);


INSERT INTO MEMBER VALUES ('M001', 'TRN003', 'MET003', 'Saman', 'Perera', 789, 'Third Road', 'Galle');
INSERT INTO MEMBER VALUES ('M002', 'TRN004', 'MET004', 'Kumari', 'Silva', 1011, 'Fourth Lane', 'Matara');
INSERT INTO MEMBER VALUES ('M003', 'TRN001', 'MET001', 'John', 'Doe', 123, 'Main Street', 'Colombo');
INSERT INTO MEMBER VALUES ('M004', 'TRN006', 'MET006', 'Nisha', 'Rajapaksa', 1415, 'Sixth Avenue', 'Kandy');
INSERT INTO MEMBER VALUES ('M005', 'TRN005', 'MET005', 'Ravi', 'Fernando', 1213, 'Fifth Street', 'Negombo');
INSERT INTO MEMBER VALUES ('M006', 'TRN002', 'MET002', 'Jane', 'Smith', 456, 'Second Avenue', 'Kandy');
INSERT INTO MEMBER VALUES ('M007', 'TRN002', 'MET002', 'Samantha', 'Silva', 1819, 'Eighth Lane', 'Kandy');
INSERT INTO MEMBER VALUES ('M008', 'TRN003', 'MET003', 'Kasun', 'Fernando', 2021, 'Ninth Street', 'Galle');
INSERT INTO MEMBER VALUES ('M009', 'TRN001', 'MET001', 'Malith', 'Perera', 1617, 'Seventh Road', 'Colombo');
INSERT INTO MEMBER VALUES ('M010', 'TRN004', 'MET004', 'Nuwan', 'Rajapaksa', 2223, 'Tenth Avenue', 'Matara');

INSERT INTO Member_4n_Numbers VALUES ('M001', 771234567);
INSERT INTO Member_4n_Numbers VALUES ('M001', 741234567);
INSERT INTO Member_4n_Numbers VALUES ('M002', 772345678);
INSERT INTO Member_4n_Numbers VALUES ('M003', 742345467);
INSERT INTO Member_4n_Numbers VALUES ('M003', 723456789);
INSERT INTO Member_4n_Numbers VALUES ('M004', 714567890);


INSERT INTO SCHEDULE_ VALUES ('2024-03-01', '09:00:00', 1.5, 'M001');
INSERT INTO SCHEDULE_ VALUES ('2024-03-01', '10:00:00', 3, 'M002');
INSERT INTO SCHEDULE_ VALUES ('2024-03-02', '08:00:00', 2, 'M003');
INSERT INTO SCHEDULE_ VALUES ('2024-03-02', '11:00:00', 1, 'M004');
INSERT INTO SCHEDULE_ VALUES ('2024-03-03', '10:00:00', 2.5, 'M005');
INSERT INTO SCHEDULE_ VALUES ('2024-03-03', '14:00:00', 1, 'M006');

INSERT INTO PAYMENT VALUES ('M001', '08:30:00', '2024-02-01', 15000);
INSERT INTO PAYMENT VALUES ('M003', '09:45:00', '2024-02-01', 5000);
INSERT INTO PAYMENT VALUES ('M005', '08:15:00', '2024-02-02', 10000);
INSERT INTO PAYMENT VALUES ('M009', '11:30:00', '2024-02-02', 8000);
INSERT INTO PAYMENT VALUES ('M007', '10:30:00', '2024-02-03', 7000);
INSERT INTO PAYMENT VALUES ('M010', '14:45:00', '2024-02-03', 12000);



-- ************* Update and Delete **********************


UPDATE Member SET House_Num = 456, Street_Name = 'Eighth Lane' WHERE Member_ID = 'M002';
UPDATE Member SET  Trainer_ID = 'TRN005'  WHERE Member_ID = 'M004';
-- DELETE FROM MEMBER WHERE Member_ID = 'M003';

UPDATE Member_4n_Numbers SET Phone_Number = 752345678 WHERE Member_ID = 'M002';
UPDATE Member_4n_Numbers SET Phone_Number = 745665234 WHERE Member_ID = 'M005';
-- DELETE FROM Member_4n_Numbers WHERE Member_ID = 'M010';

UPDATE Trainer SET Salary = 70000 WHERE Trainer_ID = 'TRN001';
UPDATE Trainer SET Experience_yrs = 7 WHERE Trainer_ID = 'TRN002';
-- DELETE FROM Trainer WHERE Trainer_ID = 'TRN006';

UPDATE Branch SET Capacity = '250' WHERE Branch_Num = 101;
UPDATE Branch SET Opening_Hours = '9:00 AM - 10:00 PM' WHERE Branch_Num = 102;
-- DELETE FROM Branch WHERE Branch_Num = 106;

UPDATE Manager SET Last_Name = 'Emayer' WHERE Manager_ID = 'MAN001';
UPDATE Manager SET First_name = 'Perara'  WHERE Manager_ID = 'MAN002';
-- DELETE FROM Manager_Phone WHERE Manager_ID = 'MAN006';
-- DELETE FROM Manager WHERE Manager_ID = 'MAN006';

UPDATE Schedule_ SET Start_Time = '10:30:00' WHERE Date_ = '2024-03-01' AND Member_ID = 'M001';
UPDATE Schedule_ SET Duration_hrs = 2 WHERE Date_ = '2024-03-02' AND Member_ID = 'M003';
-- DELETE FROM Schedule_ WHERE Date_ = '2024-03-03' AND Member_ID = 'M006';

UPDATE Payment SET amount = 9000 WHERE Member_ID = 'M001' AND Time_ = '08:30:00' AND Date_ = '2024-02-01';
UPDATE Payment SET Date_ = '2024-02-03' WHERE Member_ID = 'M007' AND Time_ = '10:30:00';
-- DELETE FROM Payment WHERE Member_ID = 'M009' AND Time_ = '11:30:00' AND Date_ = '2024-02-02';

UPDATE Membership_Type SET Description_ = 'Discounted Membership for School Teachers' WHERE MemType_ID = 'MET006';
UPDATE Membership_Type SET price = 8500 WHERE MemType_ID = 'MET002';
-- DELETE FROM Membership_Type WHERE MemType_ID = 'MET001';

UPDATE Equipment SET Cost = 280000 WHERE Equipment_Number = 1;
UPDATE Equipment SET Equipment_Name = 'Bicep Machine' WHERE Equipment_Number = 2;
-- DELETE FROM Equipment WHERE Equipment_Number = 6;


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Chapter 4 - Transaction
-- ****************Simple queries***********

-- 1. Select all members who are from Colombo
SELECT * FROM MEMBER WHERE City = 'Colombo';

-- 2. Project operation
SELECT opening_hours, Street_Name, Town, City FROM Branch;

-- 3. Cartesian Product Operation

SELECT * FROM Manager NATURAL JOIN manager_phone;

-- 4. Creating a User View

CREATE VIEW user_view AS
SELECT Type_Name, Description_, price FROM Membership_type;
SELECT * FROM user_View;

-- 5. Renaming Operation

RENAME TABLE Schedule_ TO Workout_plan;

ALTER TABLE equipment_repair_history
RENAME COLUMN repair_history TO Recent_Repairs;


-- 6. Use of an Aggregation Function 

-- Maximum
SELECT MAX(capacity) AS max_Capacity FROM Branch;

-- Minimum
SELECT MIN(price) AS min_price FROM membership_type;

-- Average
SELECT AVG(cost) AS Average_Cost FROM Equipment;

-- 7)  use of LIKE keyword

SELECT * FROM Equipment WHERE Equipment_Name LIKE '%Machine%';




-- COMPLEX QUERIES
-- --------------------------

-- Set Operations

-- 8) Union

-- Union of Managers and Trainers into Employee

SELECT M.Manager_ID FROM Manager As M
UNION 
SELECT T.Trainer_ID FROM  Trainer as T;


-- 9) Intersection

SELECT M.First_Name, M.Trainer_ID, W.Duration_hrs, W.Start_Time
FROM member as M
LEFT JOIN Workout_plan as W ON M.Member_ID = W.Member_ID;


-- 10) Set difference

-- Finding the members who doesn't have the workout plan yet...
SELECT M.Member_ID
FROM MEMBER as M
LEFT JOIN Workout_Plan as W ON M.Member_ID = W.Member_ID
WHERE W.Member_ID IS NULL;



-- 11. Division

-- Query for finding the average member per branch
SELECT 
AVG(members_per_branch) as average_members_per_branch
FROM 
(SELECT COUNT(*) as members_per_branch 
	FROM member as m 
    join Trainer as T 
    on m.Trainer_ID = T.Trainer_ID
    GROUP BY Branch_Num) 
    as branch_member_counts;


-- 12. Inner Join

-- Table of member and their trainer names in one table
CREATE VIEW Member_Trainer_Details AS
SELECT m.First_Name AS Member_FirstName, m.Last_Name AS Member_LastName,
       t.First_Name AS Trainer_FirstName, t.Last_Name AS Trainer_LastName
FROM MEMBER m
INNER JOIN TRAINER t ON m.Trainer_ID = t.Trainer_ID;
select * from Member_trainer_details;


-- 13. Natural Join

-- Members having trainers who have more than 5 years of experience and from Colombo
Create view Members_having_GOODtrainer_and_from_colombo as
Select
 M.Member_ID , M.Trainer_ID, M.First_name as Member, T.First_Name as Trainer
 from 
 Member as M 
 join 
 trainer as T 
 on M.Trainer_ID = T.Trainer_ID
 where T.Experience_yrs >= 5 and m.city = 'colombo';
 -- drop view Members_having_GOODtrainer_and_from_colombo;
 select * from Members_having_GOODtrainer_and_from_colombo;


-- 14. Left Outer Join
-- Details of Branch and associated Managers
CREATE VIEW Branch_Manager_Details AS
SELECT b.Branch_Num,m.First_Name AS Manager_Name, b.City, b.Town, b.Opening_Hours, b.Capacity,
       b.Street_Name, b.Building_Num
FROM BRANCH b
LEFT OUTER JOIN MANAGER m ON b.Branch_Num = m.Branch_Num;
-- drop view Branch_Manager_Details;
select * from Branch_Manager_Details;

-- 15. Right Outer Join
-- Details of branch which contains Trainer details and their experience years
CREATE VIEW Trainer_Branch_Details AS
SELECT t.Trainer_ID, t.First_Name as Trainer_name, b.branch_num,
		t.Experience_yrs, b.Opening_Hours,b.Capacity,
		b.City AS Branch_City
FROM TRAINER t
RIGHT OUTER JOIN BRANCH b 
ON t.Branch_Num = b.Branch_Num;
-- drop view Trainer_Branch_Details;
select * from Trainer_Branch_Details;


-- 16. full outer join

-- Details of member payment according to the order of date

create view Member_Payment_Details as
SELECT m.member_ID,m.MemType_ID, m.first_name,m.city,p.Time_,p.Date_,p.amount
FROM member as M
LEFT JOIN payment as P 
ON M.member_ID = M.Member_ID
UNION
SELECT m.member_ID,m.MemType_ID, m.first_name,m.city,p.Time_,p.Date_,p.amount
FROM member as M
RIGHT JOIN payment as P 
ON M.member_ID = M.Member_ID;
-- drop view Member_Payment_Details;
select * from Member_Payment_Details order by date_;


-- 17. Outer Union

-- Equipment details with related branch

CREATE VIEW Membership_Type_union_Workout_plan AS
SELECT MemType_ID AS ID, Type_Name, price, 'MS_Type' AS Type
FROM membership_type
UNION
SELECT Member_ID AS ID, Duration_hrs, Start_Time, 'Plan' AS Type
FROM workout_plan;
-- drop view Membership_Type_union_Workout_plan;
select * from Membership_Type_union_Workout_plan;



--  nested queries in combination with any other relational algebraic operation.


-- 18. 
-- Returning details of members and trainers who are both located in Colombo using nested query

SELECT *
FROM (
    SELECT Member_ID, Trainer_ID, First_Name, Last_Name
    FROM MEMBER
    WHERE City = 'Colombo'
) AS Colombo_Members
INNER JOIN (
    SELECT Trainer_ID, First_Name, Last_Name
    FROM TRAINER
    WHERE City = 'Colombo'
) AS Colombo_Trainers ON Colombo_Members.Trainer_ID = Colombo_Trainers.Trainer_ID;


-- 19. 

-- find all the members who have a membership type as gold and are assigned to a trainer with more than 4 years of experience
SELECT *
FROM MEMBER
WHERE MemType_ID = (
        SELECT MemType_ID
        FROM MEMBERSHIP_TYPE
        WHERE Type_Name = 'Gold'
    )
    AND Trainer_ID IN (
        SELECT Trainer_ID
        FROM TRAINER
        WHERE Experience_yrs > 4
    );


-- 20.
-- Finding the total amount earned from payments made by members who have a membership type with a price higher than the average price of all membership types

SELECT SUM(amount) AS Total_Earnings
FROM PAYMENT
WHERE Member_ID IN (
    SELECT Member_ID
    FROM MEMBER
    WHERE MemType_ID IN (
        SELECT MemType_ID
        FROM MEMBERSHIP_TYPE
        WHERE price > (
            SELECT AVG(price)
            FROM MEMBERSHIP_TYPE
        )
    )
);







