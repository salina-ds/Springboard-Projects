/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: 
Password: 

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name, 
       membercost
FROM Facilities
WHERE membercost > 0


name             membercost

Tennis Court 1          5.0
Tennis Court 2          5.0
Massage Room 1          9.9
Massage Room 2          9.9
Squash Court            3.5



/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( * )
FROM Facilities
WHERE membercost = 0

COUNT(*)

       4



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, 
       name, 
       membercost, 
       monthlymaintenance
  FROM Facilities
 WHERE membercost > 0
   AND membercost < ( monthlymaintenance * .20 )

	
facid     name         membercost     monthlymaintenance

0         Tennis Court 1      5.0                    200
1         Tennis Court 2      5.0                    200
4         Massage Room 1      9.9                   3000
5         Massage Room 2      9.9                   3000
6         Squash Court        3.5                     80


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
  FROM Facilities
 WHERE facid IN ( 1, 5 )

facid    name             membercost      guestcost    initialoutlay    monthlymaintenance

1        Tennis Court 2          5.0           25.0             8000                   200
5        Massage Room 2          9.9           80.0             4000                  3000


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, 
       monthlymaintenance,
       CASE WHEN monthlymaintenance <= 100 THEN 'cheap'
            WHEN monthlymaintenance > 100 THEN 'expensive'
            ELSE NULL
        END AS tier
  FROM Facilities
ORDER BY 2 DESC

name              monthlymaintenance     tier

Massage Room 1                  3000     expensive
Massage Room 2                  3000     expensive
Tennis Court 1                   200     expensive
Tennis Court 2                   200     expensive
Squash Court                      80     cheap
Badminton Court                   50     cheap
Snooker Table                     15     cheap
Pool Table                        15     cheap
Table Tennis                      10     cheap


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */


SELECT firstname, 
       surname, 
       joindate
  FROM Members
 WHERE joindate = (

                   SELECT MAX(joindate)
                     FROM Members
                   )

firstname     surname      joindate 

Darren        Smith        2012-09-26 18:08:45


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT CASE WHEN b.memid = 0 THEN m.surname
            WHEN b.memid > 0 THEN CONCAT(m.firstname, " ", m.surname) 
            ELSE NULL
       END AS name, 
       f.name AS facility
  FROM Bookings b
  JOIN Facilities f
    ON b.facid = f.facid
  JOIN Members m
    ON b.memid = m.memid
 WHERE f.name like 'Tennis%'
 GROUP BY 1, 2

name               facility

Anne Baker         Tennis Court 1
Anne Baker         Tennis Court 2
Burton Tracy       Tennis Court 1
Burton Tracy       Tennis Court 2
Charles Owen       Tennis Court 1
Charles Owen       Tennis Court 2
Darren Smith       Tennis Court 2
David Farrell      Tennis Court 1
David Farrell      Tennis Court 2
David Jones        Tennis Court 1
David Jones        Tennis Court 2
David Pinker       Tennis Court 1
Douglas Jones      Tennis Court 1
Erica Crumpet      Tennis Court 1
Florence Bader     Tennis Court 1
Florence Bader     Tennis Court 2
Gerald Butters     Tennis Court 1
Gerald Butters     Tennis Court 2
GUEST              Tennis Court 1
GUEST              Tennis Court 2
Henrietta Rumney   Tennis Court 2
Jack Smith         Tennis Court 1
Jack Smith         Tennis Court 2
Janice Joplette    Tennis Court 1
Janice Joplette    Tennis Court 2
Jemima Farrell     Tennis Court 1
Jemima Farrell     Tennis Court 2
Joan Coplin        Tennis Court 1
John Hunt          Tennis Court 1
John Hunt          Tennis Court 2
Matthew Genting    Tennis Court 1
Millicent Purview  Tennis Court 2
Nancy Dare         Tennis Court 1
Nancy Dare         Tennis Court 2
Ponder Stibbons    Tennis Court 1
Ponder Stibbons    Tennis Court 2
Ramnaresh Sarwin   Tennis Court 1
Ramnaresh Sarwin   Tennis Court 2
Tim Boothe         Tennis Court 1
Tim Boothe         Tennis Court 2
Tim Rownam         Tennis Court 1
Tim Rownam         Tennis Court 2
Timothy Baker      Tennis Court 1
Timothy Baker      Tennis Court 2
Tracy Smith        Tennis Court 1
Tracy Smith        Tennis Court 2


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.membercost * b.slots AS cost,
       CONCAT(m.firstname, " ", m.surname) AS name,            
       f.name AS facility_name, 
       SUBSTR(starttime, 1, 10) AS date, 
       SUBSTR(starttime, 12, 8) AS time
  FROM Bookings b 
  JOIN Members m
    ON b.memid = m.memid
  JOIN Facilities f
    ON b.facid = f.facid
 WHERE SUBSTR(b.starttime, 1, 10) = '2012-09-14'
   AND b.memid > 0
   AND (f.membercost * b.slots) > 30

UNION ALL 

SELECT f.guestcost * b.slots AS cost,
       m.surname AS name,            
       f.name AS facility_name, 
       SUBSTR(starttime, 1, 10) AS date, 
       SUBSTR(starttime, 12, 8) AS time
  FROM Bookings b 
  JOIN Members m
    ON b.memid = m.memid
  JOIN Facilities f
    ON b.facid = f.facid
 WHERE SUBSTR(b.starttime, 1, 10) = '2012-09-14'
   AND b.memid = 0
   AND (f.guestcost * b.slots) > 30
               
  ORDER BY 1 DESC


cost       member           facility_name       date           time

320.0      GUEST            Massage Room 2      2012-09-14     11:00:00
160.0      GUEST            Massage Room 1      2012-09-14     16:00:00
160.0      GUEST            Massage Room 1      2012-09-14     13:00:00
160.0      GUEST            Massage Room 1      2012-09-14     09:00:00
150.0      GUEST            Tennis Court 2      2012-09-14     17:00:00
75.0       GUEST            Tennis Court 1      2012-09-14     19:00:00
75.0       GUEST            Tennis Court 2      2012-09-14     16:00:00
75.0       GUEST            Tennis Court 1      2012-09-14     14:00:00
70.0       GUEST            Squash Court        2012-09-14     09:30:00
39.6       Jemima Farrell   Massage Room 1      2012-09-14     14:00:00
35.0       GUEST            Squash Court        2012-09-14     15:00:00
35.0       GUEST            Squash Court        2012-09-14     12:30:00


/* Q9: This time, produce the same result as in Q8, but using a subquery. */


SELECT * 
  FROM (
        SELECT CASE WHEN b.memid > 0 THEN f.membercost * b.slots 
                    WHEN b.memid = 0 THEN f.guestcost * b.slots 
                    ELSE NULL 
               END AS cost,
               CASE WHEN b.memid > 0 THEN CONCAT(m.firstname, " ", m.surname)
                    WHEN b.memid = 0 THEN m.surname
                    ELSE NULL
               END AS member, 
               f.name AS facility_name, 
               SUBSTR(starttime, 1, 10) AS date, 
               SUBSTR(starttime, 12, 8) AS time
          FROM Bookings b 
          JOIN Members m
            ON b.memid = m.memid
          JOIN Facilities f
            ON b.facid = f.facid
         WHERE SUBSTR(b.starttime, 1, 10) = '2012-09-14'
        ) sub
  WHERE sub.cost > 30
  ORDER BY sub.cost DESC


cost       member           facility_name       date           time

320.0      GUEST            Massage Room 2      2012-09-14     11:00:00
160.0      GUEST            Massage Room 1      2012-09-14     13:00:00
160.0      GUEST            Massage Room 1      2012-09-14     16:00:00
160.0      GUEST            Massage Room 1      2012-09-14     09:00:00
150.0      GUEST            Tennis Court 2      2012-09-14     17:00:00
75.0       GUEST            Tennis Court 1      2012-09-14     19:00:00
75.0       GUEST            Tennis Court 2      2012-09-14     14:00:00
75.0       GUEST            Tennis Court 1      2012-09-14     16:00:00
70.0       GUEST            Squash Court        2012-09-14     09:30:00
39.6       Jemima Farrell   Massage Room 1      2012-09-14     14:00:00
35.0       GUEST            Squash Court        2012-09-14     12:30:00
35.0       GUEST            Squash Court        2012-09-14     15:00:00

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

 
SELECT SUM(CASE WHEN b.memid = 0 THEN b.slots * f.guestcost
                WHEN b.memid > 0 THEN b.slots * f.membercost
                ELSE NULL
           END) AS revenue, 
       f.name
  FROM Bookings b 
  JOIN Facilities f
    ON b.facid = f.facid
 GROUP BY 2
HAVING revenue < 1000
 ORDER BY 1


revenue         name

180.0           Table Tennis
240.0           Snooker Table
270.0           Pool Table












