SET FOREIGN_KEY_CHECKS=0;


DROP TABLE IF EXISTS `groups` ;
CREATE TABLE IF NOT EXISTS `groups` (
  `group_id` INT NOT NULL,
  `group_no` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`group_id`)  
);


DROP TABLE IF EXISTS `students` ;
CREATE TABLE IF NOT EXISTS `students` (
  `student_id` INT NOT NULL ,
  `student_name` VARCHAR(45) NOT NULL ,
  `group_id` INT NOT NULL,
  PRIMARY KEY (`student_id`),
  CONSTRAINT `group_id`
    FOREIGN KEY (`group_id`)
    REFERENCES `groups` (`group_id`)
);


DROP TABLE IF EXISTS `lecturers` ;
CREATE TABLE IF NOT EXISTS `lecturers` (
  `lecturer_id` INT NOT NULL,
  `lecturer_name` VARCHAR(45) NULL ,
  PRIMARY KEY (`lecturer_id`)  
);

DROP TABLE IF EXISTS `courses` ;
CREATE TABLE IF NOT EXISTS `courses` (
  `course_id` INT NOT NULL ,
  `course_name` VARCHAR(45) NOT NULL ,
  PRIMARY KEY (`course_id`)  
);



DROP TABLE IF EXISTS `marks` ;
CREATE TABLE IF NOT EXISTS `marks` (
  `student_id` INT NOT NULL ,
  `teaching_id` INT NOT NULL ,
  `mark` INT NOT NULL,
  CONSTRAINT `student_id`
    FOREIGN KEY (`student_id`)
    REFERENCES `students` (`student_id`),
  CONSTRAINT `teaching_id`
    FOREIGN KEY (`teaching_id`)
    REFERENCES `teaching` (`teaching_id`)
);


DROP TABLE IF EXISTS `teaching` ;
CREATE TABLE IF NOT EXISTS `teaching` (
  `teaching_id` INT NOT NULL,
  `lecturer_id` INT NOT NULL ,
  `course_id` INT NOT NULL ,
  `group_id` INT NOT NULL,
  CONSTRAINT `teaching_id` PRIMARY KEY (`teaching_id`),
  CONSTRAINT `teaching_lecturer_id`
    FOREIGN KEY (`lecturer_id`)
    REFERENCES `lecturers` (`lecturer_id`),
  CONSTRAINT `teaching_course_id`
    FOREIGN KEY (`course_id`)
    REFERENCES `courses` (`course_id`),
  CONSTRAINT `teaching_group_id`
    FOREIGN KEY (`group_id`)
    REFERENCES `groups` (`group_id`)
);


SET FOREIGN_KEY_CHECKS=1;


INSERT INTO groups (group_id, group_no) VALUES (1, 'M3437'), (2, 'M3438'), (3, 'M3439');
INSERT INTO students (student_id, student_name, group_id) VALUES (1, 'Shalamov',3), (2, 'Asadchy',3), (3, 'Akhundov', 2), (4, 'Matveev', 2), (5, 'Nechaev', 1); 

INSERT INTO lecturers (lecturer_id, lecturer_name) VALUES (1, 'Korneev'), (2,'Dodonov'), (3, 'Suslina'); 

INSERT INTO courses (course_id, course_name) VALUES (1,'Java'), (2,'���� ������'), (3,'�������������� ������'), (4, 'Probability theory'); 


-- korneev-dbms-m3439
INSERT INTO teaching (teaching_id, lecturer_id, course_id, group_id) VALUES (1, 1, 2, 3);
INSERT INTO marks (teaching_id, student_id, mark) VALUES  (1, 1, 4), (1, 2, 4);

-- korneev-dbms-m3438
INSERT INTO teaching (teaching_id, lecturer_id, course_id, group_id) VALUES (2, 1, 2, 2);
INSERT INTO marks (teaching_id, student_id, mark) VALUES  (2, 3, 5);

-- dodonov-�����-all
INSERT INTO teaching (teaching_id, lecturer_id, course_id, group_id) VALUES (3, 2, 3, 1), (4, 2, 3, 2), (5, 2, 3, 3);
INSERT INTO marks (teaching_id, student_id, mark) VALUES  (4, 3, 3), (5, 1, 4), (5, 2, 4);

-- suslina-PT-m3439
INSERT INTO teaching (teaching_id, lecturer_id, course_id, group_id) VALUES (6, 3, 4, 3);
INSERT INTO marks (teaching_id, student_id, mark) VALUES  (6, 1, 5), (6, 2, 4);

-- korneev-java-m3439
INSERT INTO teaching (teaching_id, lecturer_id, course_id, group_id) VALUES (7, 1, 1, 3);
INSERT INTO marks (teaching_id, student_id, mark) VALUES  (7, 1, 5), (7, 2, 5);

-- 1)���������� � ��������� � �������� ������� �� �������� ����� �������.
-- ] ������ - 5
SELECT DISTINCT student_id, student_name FROM students NATURAL JOIN marks NATURAL JOIN courses WHERE course_name='���� ������' AND mark=4;

-- 2)���������� � ��������� �� ������� ������ �� �������� ����� �������:
-- -- �)����� ���� ���������
SELECT student_id, student_name FROM students WHERE student_id NOT IN (SELECT student_id FROM students NATURAL JOIN marks NATURAL JOIN teaching NATURAL JOIN courses WHERE course_name='���� ������'); 
-- -- �)����� ���������, � ������� ���� ���� �������
SELECT student_id, student_name FROM students NATURAL JOIN groups NATURAL JOIN teaching NATURAL JOIN courses WHERE course_name='���� ������' AND student_id NOT IN (SELECT student_id FROM students NATURAL JOIN marks NATURAL JOIN teaching NATURAL JOIN courses WHERE course_name='���� ������'); 

-- 3) ���������� � ���������, ������� ���� �� ���� ������ � ��������� �������.
-- ] ������: lecturer_id=1
SELECT DISTINCT student_id, student_name FROM students NATURAL JOIN marks NATURAL JOIN teaching WHERE lecturer_id=1;

-- 4) �������������� ���������, �� ������� �� ����� ������ � ��������� �������.
-- ] ������: lecturer_id=1
SELECT student_id FROM students WHERE student_id NOT IN (SELECT student_id FROM students NATURAL JOIN marks NATURAL JOIN teaching WHERE lecturer_id=1);

-- 5) ���������, ������� ������ �� ���� ��������� ��������� �������.
-- ] ������: lecturer_id=1
SELECT student_id, student_name, COUNT(DISTINCT course_id) as c 
    FROM students NATURAL JOIN marks NATURAL JOIN teaching WHERE lecturer_id=1
        GROUP BY student_id  
        HAVING c = (SELECT COUNT(DISTINCT course_id) FROM lecturers NATURAL JOIN teaching NATURAL JOIN courses WHERE lecturer_id=1);

-- 6) ��� ������� �������� ��� � ��������, ������� �� ������ ��������.
-- ��������������, ��� ������� ������ �� �������� �� ����������� �������� �� ����, ���� ������� ����������� ����� ��������. (�������� 61 ���� �� �������� ��� �� ����������� �������� �� �������� �������� ����� �������� ��������)
SELECT student_name, course_name FROM students NATURAL JOIN groups NATURAL JOIN teaching NATURAL JOIN courses;

-- 7) �� ������� ���� ���������, � ������� �� ���� ���-������ ����������.
-- ] ������: lecturer_id=1
SELECT DISTINCT(student_id), student_name FROM students NATURAL JOIN groups NATURAL JOIN teaching WHERE lecturer_id=1;

-- 8) ���� ���������, �����, ��� ��� ������� ������ ��������� �������� ���� � ������ �������.
CREATE OR REPLACE VIEW XY AS (SELECT course_id, student_id as sid2 FROM students NATURAL JOIN marks NATURAL JOIN teaching);
CREATE OR REPLACE VIEW YZ AS (SELECT course_id, student_id as sid1 FROM students NATURAL JOIN marks NATURAL JOIN teaching);
CREATE OR REPLACE VIEW S2 AS (SELECT sid2 FROM XY);
CREATE OR REPLACE VIEW S1 AS (SELECT sid1 FROM YZ);
-- ��� ���������� ������������� ������ ��������� ��������� ���� �������� � ��������� ������, ������ ����� �� ������ ���������� � ����� ���� ��������� ��� XY YZ S2 S1 ��� ��� ����.
SELECT DISTINCT sid1, sid2 FROM S2 CROSS JOIN S1 WHERE (sid1, sid2) NOT IN (
    SELECT sid1, sid2 FROM S2 CROSS JOIN YZ WHERE (sid1, sid2, course_id) NOT IN (SELECT * FROM XY NATURAL JOIN YZ)

) AND sid1!= sid2 GROUP BY sid1, sid2;

-- 9) ����� ������ � ��������, ��� ��� �������� ������ ����� �������.
CREATE OR REPLACE VIEW XY AS (SELECT course_id as cid, student_id FROM groups NATURAL JOIN TEACHING NATURAL JOIN MARKS);
CREATE OR REPLACE VIEW YZ AS (SELECT student_id, group_id as gid FROM students NATURAL JOIN groups);
CREATE OR REPLACE VIEW SL AS (SELECT cid FROM XY);
CREATE OR REPLACE VIEW SR AS (SELECT gid FROM YZ);
-- ��� ���������� ������������� ������ ��������� ��������� ���� �������� � ��������� ������, ������ ����� �� ������ ���������� � ������ ���� ��������� ��� XY YZ SL SR ��� ��� ����.
SELECT DISTINCT gid, cid FROM SL CROSS JOIN SR WHERE (gid, cid) NOT IN (
    SELECT gid, cid FROM SL CROSS JOIN YZ WHERE (gid, cid, student_id) NOT IN (SELECT * FROM XY NATURAL JOIN YZ)

);
-- 10) ������� ���� ��������.
-- -- �) �� �������������� -- ] student_id=1
SELECT student_id, AVG(mark) as avgmark FROM students NATURAL JOIN marks WHERE student_id=1;
-- -- �) ��� ������� ��������
SELECT student_id, AVG(mark) as avgmark FROM students NATURAL JOIN marks GROUP BY student_id;  

-- 11) ������� ���� ������� ������ ��������� ������ ������.
SELECT group_id, AVG(avgsmark) as avggark 
    FROM groups NATURAL JOIN (
        (SELECT group_id, student_id, AVG(mark) as avgsmark 
            FROM students NATURAL JOIN marks NATURAL JOIN groups GROUP BY student_id) T
    ) GROUP BY group_id;
    
-- 12) ��� ������� �������� ����� ���������, ������� � ���� ����, ����� ������� ��������� � ����� �� ������� ���������.
SELECT T.student_id, T.student_name, IFNULL(tought, 0) as tought, IFNULL(passed, 0) as passed, IFNULL(tought,0)-IFNULL(passed,0) as remaining FROM (
    (SELECT student_id, student_name, COUNT(student_id) as tought FROM students NATURAL JOIN groups NATURAL JOIN teaching GROUP BY student_id) T
    LEFT JOIN
    (SELECT student_id, student_name, COUNT(student_id) as passed FROM students NATURAL JOIN marks GROUP BY student_id) T2 ON (T.student_id=T2.student_id)
 );
