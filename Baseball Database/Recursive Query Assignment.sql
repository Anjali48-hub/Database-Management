/*by pg395*/
Use Spring_2018_Baseball;

/* After creating the prereq table and loading the associated data into the Baseball database, we write this recursive query (from the partial results shared) that provides a list of courses and its direct or indirect prereqs. */

With rec_prereq(course_id, prereq_id) As (
(Select course_id, prereq_id
From prereq)	Union ALL
(Select rec_prereq.course_id, prereq.prereq_id
From rec_prereq, prereq
Where rec_prereq.prereq_id = prereq.course_id)
		)
Select * 
From rec_prereq
Order by course_id;

/*Let the above Query be considered to be or called or marked as (A)*/

/* However when we run this query we get the following error message:
		Msg 530, Level 16, State 1, Line 4
The statement terminated. The maximum recursion 100 has been exhausted before statement completion. */

/* So to find out the problem causing this issue we write the below query, which would let us know which are the rows that have prereq_id pointing back at its corresponding course_id in list, causing the Recursive Query to go in some infinite loop. */

Select * from prereq p1, prereq p2
Where p1.course_id = p2.prereq_id and
	  p2.course_id = p1.prereq_id
order by p1.course_id;

/* We found that there were 2 such rows, which had prereq_id referencing back at their respective 
	course_id. We deleted those rows with the following query. */
Delete from prereq where prereq.course_id = 852 and prereq.prereq_id = 133
Delete from prereq where prereq.course_id = 864 and prereq.prereq_id = 634

/* We again run the original Recursive Query that is (A). Now it runs fine producing a total of 168 rows of course_id and its direct or indirect prereq_ids. */
