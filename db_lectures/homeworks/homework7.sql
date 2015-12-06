-- Исаев И. M3439
-- 1.
SELECT * FROM students;
SELECT * FROM students JOIN points USING (Sid);

DELETE FROM students WHERE Sid = ANY
    (SELECT Sid FROM points WHERE points >= 60);

SELECT * FROM students;

-- 2.

DELETE FROM students WHERE Sid = ANY
    (SELECT Sid FROM (
        SELECT students.Sid, Count(points) as tails FROM students JOIN points 
            WHERE students.Sid = points.Sid AND students.Gid = points.Gid AND 
            points<60 GROUP BY students.Sid,students.Gid HAVING tails >2
        ) as toDelete
    );

SELECT * FROM students;

-- 3.

SELECT * FROM groups;
DELETE FROM groups WHERE NOT EXISTS (
        SELECT NULL FROM students WHERE students.Gid = Groups.Gid
    );

SELECT * FROM groups;

-- 4.

CREATE VIEW Losers (Sid, Sn, Gid, tails) AS
    SELECT students.Sid, Sn, students.Gid, Count(points) as tails FROM students JOIN points 
            WHERE students.Sid = points.Sid AND students.Gid = points.Gid AND points<60 
            GROUP BY Sid, Gid;

SELECT * FROM Losers;

-- 5.

SET @LOOSER_T_TRIGGERS_ENABLED = 1;

CREATE TABLE LoserT AS SELECT * FROM Losers;

ALTER TABLE LoserT
    ADD CONSTRAINT lsT_sg_points_sg PRIMARY KEY (Sid, Gid);

DELIMITER $$

CREATE TRIGGER new_mark AFTER INSERT ON points
    FOR EACH ROW 
        IF @LOOSER_T_TRIGGERS_ENABLED = 1 THEN
            INSERT INTO LoserT 
            SELECT * FROM Losers L WHERE L.Sid=NEW.Sid AND L.Gid=NEW.Gid
            ON DUPLICATE KEY UPDATE LoserT.tails = L.tails;
        END IF;


CREATE TRIGGER deleted_mark BEFORE DELETE ON points
    FOR EACH ROW 
        BEGIN
            IF @LOOSER_T_TRIGGERS_ENABLED = 1 THEN
                UPDATE LoserT LT SET tails = tails - 1
                WHERE LT.Sid = OLD.Sid AND LT.Gid = OLD.Gid AND OLD.points < 60;
                DELETE FROM LoserT WHERE tails = 0;
            END IF;
        END$$

CREATE TRIGGER mark_changed AFTER UPDATE ON points
    FOR EACH ROW 
        BEGIN
            IF @LOOSER_T_TRIGGERS_ENABLED = 1 THEN
                DELETE FROM LoserT WHERE Sid = OLD.Sid AND Gid = OLD.Gid;
                DELETE FROM LoserT WHERE Sid = NEW.Sid AND Gid = NEW.Gid;
                INSERT INTO LoserT 
                    SELECT * FROM Losers L WHERE L.Sid=OLD.Sid AND L.Gid=OLD.Gid
                        ON DUPLICATE KEY UPDATE LoserT.tails = L.tails;
                INSERT INTO LoserT 
                    SELECT * FROM Losers L WHERE L.Sid=NEW.Sid AND L.Gid=NEW.Gid
                        ON DUPLICATE KEY UPDATE LoserT.tails = L.tails;
            END IF;
        END$$


SELECT * FROM LoserT;

-- 6.
SET @LOOSER_T_TRIGGERS_ENABLED = 0;

-- 7.

-- 8.
-- обеспечено схемой БД

-- 9.
-- MySQL :(
CREATE TRIGGER mark_updated BEFORE UPDATE ON points
    FOR EACH ROW
        BEGIN
            IF NEW.points <= OLD.points THEN
                CALL shall_not_decrement_points_you();
            END IF;
        END$$

DELIMITER ;
