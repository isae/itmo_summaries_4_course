-- 1.

SELECT Students.Sid,Sn,Cid,Mark FROM Students NATURAL JOIN Marks
    WHERE Cid=6 AND Mark = 5;

-- 2.

SELECT * FROM Students 
    WHERE Sid NOT IN (
        SELECT Students.Sid FROM Students NATURAL JOIN Marks
            WHERE Cid=6 AND Mark = 5
    );
SELECT DISTINCT Sid, Sn FROM Students NATURAL JOIN Teaching 
    WHERE Sid NOT IN (
        SELECT Students.Sid FROM Students NATURAL JOIN Marks
            WHERE Cid=6 AND Mark = 5
    ) AND Cid = 6;

-- 3.
SELECT DISTINCT Sid, Sn FROM Marks NATURAL JOIN Students
    WHERE Lid = 3;

-- 4.
SELECT * FROM Students 
    WHERE Sid NOT IN (
        SELECT DISTINCT Sid FROM Marks NATURAL JOIN Students 
        WHERE Lid = 3
    );    

-- 5.
SELECT * FROM Students NATURAL JOIN (
    SELECT Sid,COUNT(Cid) as allM FROM Marks
        WHERE Lid=3 GROUP BY Sid HAVING allM = (
            SELECT COUNT(Cid) as allC FROM (
                SELECT DISTINCT Lid,cid FROM Teaching 
                WHERE Lid=3
            ) as DT GROUP BY Lid)
    ) as A;

-- 6.
SELECT  Sn, GROUP_CONCAT(Cid) FROM Students NATURAL JOIN Teaching GROUP BY Sid;

-- 7.
SELECT DISTINCT Sid,Sn FROM Students NATURAL JOIN Teaching WHERE Lid=3;

-- 8.
-- 9.
-- 10.
SELECT Sid, AVG(Mark) FROM Marks WHERE Sid = 1;
SELECT Sid, AVG(Mark) FROM Marks GROUP BY Sid;

-- 11.
SELECT Gid, AVG(avgM) FROM (
    SELECT Sid, Gid, Sn, AVG(Mark) as avgM FROM Marks NATURAL JOIN Students 
        GROUP BY (Sid)
    ) as G GROUP BY (Gid);

-- 12.
SELECT T.Sid, T.Sn, IFNULL(taught, 0) as taught, 
                    IFNULL(passed, 0) as passed, 
                    IFNULL(taught,0)-IFNULL(passed,0) as remaining 
FROM (
        (
            SELECT Sid, Sn, COUNT(Sid) as taught FROM Students 
            NATURAL JOIN Groups 
            NATURAL JOIN Teaching GROUP BY Sid
        ) as T 
        LEFT JOIN
        (
            SELECT Sid, Sn, COUNT(Sid) as passed FROM Students 
            NATURAL JOIN Marks GROUP BY Sid
        ) as T2 
        ON (T.Sid=T2.Sid)
     );
