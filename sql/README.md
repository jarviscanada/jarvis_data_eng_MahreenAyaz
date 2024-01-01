
### Members Table
```sql
CREATE TABLE cd.members (
  memid integer NOT NULL, 
  surname character varying(200) NOT NULL, 
  firstname character varying(200) NOT NULL, 
  address character varying(300) NOT NULL, 
  zipcode integer NOT NULL, 
  telephone character varying(20) NOT NULL, 
  recommendedby integer, 
  joindate timestamp NOT NULL, 
  CONSTRAINT members_pk PRIMARY KEY (memid), 
  CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby) REFERENCES cd.members(memid) ON DELETE 
  SET 
    NULL
);

### Booking Table
CREATE TABLE cd.bookings (
  bookid integer NOT NULL, 
  facid integer NOT NULL, 
  memid integer NOT NULL, 
  starttime timestamp NOT NULL, 
  slots integer NOT NULL, 
  CONSTRAINT bookings_pk PRIMARY KEY (bookid), 
  CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid) ON DELETE CASCADE, 
  CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid) ON DELETE CASCADE
);

### Facilities Table
CREATE TABLE cd.facilities (
  facid integer PRIMARY KEY, 
  name character varying(100) NOT NULL, 
  membercost numeric NOT NULL, 
  guestcost numeric NOT NULL, 
  initialoutlay numeric NOT NULL, 
  monthlymaintenance numeric NOT NULL
);


Modifing Data:

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

--Question 12: Using 'Join'
select starttime
from cd.bookings
join cd.members on cd.members.memid = cd.bookings.memid
where firstname = 'David' and surname = 'Farrell';

--Question 13: Using 'Join' and 'Where' clause
select cd.bookings.starttime as start, cd.facilities.name
from cd.bookings join cd.facilities on cd.bookings.facid = cd.facilities.facid
where cd.bookings.starttime between '2012-09-21 00:00:00'and '2012-09-21 23:59:59' and cd.facilities.name like '%Tennis Court%'
order by start;

--Question 14: Using 'self join'
select distinct B.firstname,B.surname
from cd.members B join cd.members A on B.memid = A.recommendedby
order by surname,firstname;

--Question 15: Using 'self join'
select mems.firstname as memfname, mems.surname as memsname, recs.firstname as recfname, recs.surname as recsname
	from 
		cd.members mems
		left outer join cd.members recs
			on recs.memid = mems.recommendedby
order by memsname, memfname;  

--Question 16: 'self join'
memsselect distinct mems.firstname || ' ' || mems.surname as member,
(
  select distinct rems.firstname || ' ' || rems.surname as recommener
  from cd.members rems
  where rems.memid = mems.recommendedby
 )
from cd.members 

--Question 17: 'Group by'
select recommendedby, count(*)
from cd.members
where recommendedby is not null
group by recommendedby
order by recommendedby;

--Question 18: Using 'Sum'
select facid, sum (slots) as "Total slots"
from cd.bookings
group by facid
order by facid;

--Question 19: Using 'Sum'
select facid, sum(slots) as "Total Slots"
from cd.bookings
where starttime >= '2012-09-01' and starttime <'2012-10-01'
group by facid
order by sum (slots);

--Question 20: Using'extract'
select facid, extract(month from starttime) as month, sum(slots) as "Total Slots"
from cd.bookings
where extract(year from starttime) = 2012
group by facid, month
order by facid, month;

--Question 21:'Count'
select count(distinct memid) from cd.bookings

--Question 22: 'Join'
select mems.surname, mems.firstname, mems.memid, min(bks.starttime) as starttime
from cd.bookings bks
join cd.members mems on mems.memid = bks.memid
where starttime >= '2012-09-01'
group by mems.surname, mems.firstname, mems.memid
order by mems.memid;  

--Question 23: Count
select count(*) over(), firstname, surname
from cd.members
order by joindate  

--Question 24: Produce a numbered list of members
select row_number() over(order by joindate), firstname, surname
from cd.members
order by joindate  

--Question 25: Output the facility id that has the highest number of slots booked, again
select facid, total from (
select facid, sum(slots) total, rank() over (order by sum(slots) desc) rank
from cd.bookings
group by facid
	) as ranked
where rank = 1  

--Question 26: Format name of members using 'Pipe'
select surname || ', ' || firstname as name from cd.members 

--Question 27: Finding telephone number with parentheses
select memid, telephone from cd.members where telephone ~ '[()]';   

--Question 28: Count the number of members whose surname starts with each letter of the alphabet
select substr (mems.surname,1,1) as letter, count(*) as count 
from cd.members mems
group by letter
order by letter  
