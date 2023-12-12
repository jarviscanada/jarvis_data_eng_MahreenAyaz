--Question 1: Adding new facility 'spa' in cd.facilites table
Insert into cd.facilities
	(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
	values (9, 'Spa', 20, 30, 100000, 800);

--Question 2: Generating the value of next facid
insert into cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    select (select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800;   

--Question 3: Correction in entry of data
update cd.facilities
set initialoutlay = 10000
where facid = 1;

--Question 4: Alter the price by 10%
UPDATE cd.facilities
SET membercost = membercost * 1.1, guestcost = guestcost * 1.1
WHERE facid = '01';

--Question 5: Delete from cd.booking table
Delete from cd.bookings;

--Question 6: Delete a row from table 
Delete from cd.members where memid = 37;

--Question 7: Selected rows are retrieve
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0
  AND membercost < monthlymaintenance / 50;

--Question 8: Using '%....%'
Select* from cd.facilities where name like '%Tennis%';

--Question 9: Using In operator
select * from cd.facilities where facid in (1,5);

--Question 10: Selecting month by using <>=
Select memid, surname, firstname, joindate
from cd.members
where joindate >= '2012-09-01';


--Question 11: Using 'Union' function
select surname from cd.members
Union 
select name from cd.facilities;




