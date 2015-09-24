DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE study_group (
    group_id INT,
    name VARCHAR(6),
    constraint group_pk primary key(group_id));
CREATE TABLE student(
    student_id INT, 
    first_name VARCHAR(50),
    surname VARCHAR(50),
    group_id INT,
    constraint student_pk primary key(student_id),
    constraint student_group_fk foreign key(group_id) references study_group(group_id));
CREATE TABLE teacher(
    teacher_id INT,
    fisrst_name VARCHAR(50),
    surname VARCHAR(50),
    constraint teacher_pk primary key(teacher_id));
CREATE TABLE discipline(
    discipline_id INT,
    title VARCHAR(50),
    constraint discipline_pk primary key(discipline_id));
CREATE TABLE student_discipline(
    student_discipline_id INT,
    student_id INT,
    discipline_id INT,
    mark INT NULL,
    constraint student_discipline_pk primary key(student_discipline_id),
    foreign key(student_id) references student(student_id),
    foreign key(discipline_id) references discipline(discipline_id));
CREATE TABLE teacher_discipline(
    teacher_discipline_id INT,
    teacher_id INT,
    discipline_id INT,
    constraint teacher_discipline_pk primary key(teacher_discipline_id),
    foreign key(teacher_id) references teacher(teacher_id),
    foreign key(discipline_id) references discipline(discipline_id));

--- TEST DATA

INSERT INTO study_group(group_id, name) VALUES 
    (1, 'M3437'),
    (2, 'M3438'),
    (3, 'M3439');

INSERT INTO student(student_id, first_name, surname, group_id) VALUES
    (1, 'Илья', 'Исаев', 3);

