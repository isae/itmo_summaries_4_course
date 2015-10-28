DROP DATABASE ctd;
CREATE DATABASE ctd CHARACTER SET utf8 COLLATE utf8_bin;
USE ctd;

CREATE TABLE groups 
(
Gid int NOT NULL,
Gn varchar(20) NOT NULL,
PRIMARY KEY (Gid)
);

CREATE TABLE students
(
Sid int NOT NULL,
Sn varchar(50) NOT NULL,
Gid int NOT NULL,
PRIMARY KEY (Sid, Gid),
CONSTRAINT std_gid_gid FOREIGN KEY (Gid) REFERENCES groups(Gid)
);

CREATE TABLE lecturers
(
Lid int NOT NULL,
Ln varchar(50) NOT NULL,
PRIMARY KEY (Lid)
);

CREATE TABLE courses
(
Cid int NOT NULL,
Cn varchar(100) NOT NULL,
PRIMARY KEY(Cid)
);

CREATE TABLE teaching
(
Gid int NOT NULL,
Cid int NOT NULL,
Lid int NOT NULL,
PRIMARY KEY (Gid, Cid, Lid),
CONSTRAINT tch_gid_gid FOREIGN KEY (Gid) REFERENCES groups(Gid),
CONSTRAINT tch_lid_lid FOREIGN KEY (Lid) REFERENCES lecturers(Lid),
CONSTRAINT tch_cid_cid FOREIGN KEY (Cid) REFERENCES courses(Cid)
);

CREATE TABLE marks
(
Sid int NOT NULL,
Gid int NOT NULL,
Cid int NOT NULL,
Lid int NOT NULL,
Mark int NOT NULL,
CONSTRAINT mrk_tch_sid_gid FOREIGN KEY (Sid, Gid) REFERENCES students (Sid, Gid),
CONSTRAINT mrk_tch_gid_cid_lid FOREIGN KEY (Gid, Cid, Lid) REFERENCES teaching (Gid, Cid, Lid)
);

INSERT INTO groups (Gid, Gn) 
VALUES 
(1, "M3437"), 
(2, "M3438"), 
(3, "M3439");

INSERT INTO students (Sid, Sn, Gid) 
VALUES
(1,  "Александр Лобода", 3),
(2,  "Александр Дейнека", 1),
(3,  "Илья Иванов", 3),
(4,  "Сергей Игушкин", 2),
(5,  "Жавлон Исомуродов", 1),
(6,  "Георгий Коноплич", 3),
(7,  "Илья Дронов", 1),
(8,  "Елена Кошик", 3);


INSERT INTO courses (Cid, Cn) 
VALUES
(1, "Математический анализ"),
(2, "Математическая логика"),
(3, "Дискретная математика"),
(4, "Язык программирования C++"),
(5, "Архитектура ЭВМ"),
(6, "БД");


INSERT INTO lecturers (Lid, Ln)
VALUES 
(1, "Николай Додонов"),
(2, "Георгий Корнеев"),
(3, "Андрей Станкевич"),
(4, "Павел Скаков"),
(5, "Ирина Суслина");

INSERT INTO teaching (Gid, Cid, Lid)
VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1),
(1, 3, 3),
(2, 3, 3),
(3, 3, 3),
(1, 5, 4),
(2, 5, 4),
(3, 5, 4),
(1, 6, 2),
(2, 6, 2),
(3, 6, 3);

INSERT INTO marks (Sid, Gid, Cid, Lid, Mark)
VALUES
(1, 3, 6, 3, 5),
(1, 3, 6, 3, 4),
(2, 1, 6, 2, 5),
(3, 3, 6, 3, 5),
(3, 3, 3, 3, 5),
(4, 2, 6, 2, 5),
(8, 3, 6, 3, 5),
(8, 3, 3, 3, 5),
(7, 1, 6, 2, 5);
