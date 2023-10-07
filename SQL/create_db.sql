-- Создание БД и схемы
CREATE DATABASE school_db;
CREATE SCHEMA test;

-- Создание таблиц
CREATE TABLE table_faculties
(
    id   SERIAL NOT NULL PRIMARY KEY,
    name TEXT   NOT NULL
);

CREATE TABLE table_subjects
(
    id   SERIAL NOT NULL PRIMARY KEY,
    name TEXT   NOT NULL
);

CREATE TABLE table_persons
(
    id            SERIAL NOT NULL PRIMARY KEY,
    last_name     TEXT   NOT NULL,
    first_name    TEXT   NOT NULL,
    patronymic    TEXT   NULL,
    date_of_birth DATE   NOT NULL
);

CREATE TABLE table_teachers
(
    id         SERIAL  NOT NULL PRIMARY KEY,
    person_id  INT     NOT NULL,
    faculty_id INT     NOT NULL,
    is_active  BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (person_id) REFERENCES table_persons (id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    FOREIGN KEY (faculty_id) REFERENCES table_faculties (id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE table_teacher_subjects
(
    id         SERIAL NOT NULL PRIMARY KEY,
    teacher_id INT    NOT NULL,
    subject_id INT    NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES table_teachers (id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    FOREIGN KEY (subject_id) REFERENCES table_subjects (id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE table_students
(
    id         SERIAL  NOT NULL PRIMARY KEY,
    person_id  INT     NOT NULL,
    faculty_id INT     NOT NULL,
    is_active  BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (person_id) REFERENCES table_persons (id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    FOREIGN KEY (faculty_id) REFERENCES table_faculties (id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE table_marks
(
    id         SERIAL NOT NULL PRIMARY KEY,
    student_id INT    NOT NULL,
    date       DATE   NOT NULL DEFAULT CURRENT_DATE,
    subject_id INT    NOT NULL,
    mark       INT    NOT NULL,
    teacher_id INT    NOT NULL,
    FOREIGN KEY (student_id) REFERENCES table_students (id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    FOREIGN KEY (subject_id) REFERENCES table_subjects (id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    FOREIGN KEY (teacher_id) REFERENCES table_teachers (id)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

-- Создание представлений
CREATE VIEW view_teachers AS
SELECT table_teachers.id    AS id,
       last_name,
       first_name,
       patronymic,
       date_of_birth,
       table_faculties.name AS faculty,
       is_active
FROM table_teachers
         JOIN table_persons
              ON table_teachers.person_id = table_persons.id
         JOIN table_faculties
              ON table_teachers.faculty_id = table_faculties.id;

CREATE VIEW view_students AS
SELECT table_students.id    AS id,
       last_name,
       first_name,
       patronymic,
       date_of_birth,
       table_faculties.name AS faculty,
       is_active
FROM table_students
         JOIN table_persons
              ON table_students.person_id = table_persons.id
         JOIN table_faculties
              ON table_students.faculty_id = table_faculties.id;

CREATE VIEW view_marks AS
SELECT concat(view_students.last_name, ' ', view_students.first_name, ' ', view_students.patronymic) AS student_name,
       date,
       table_subjects.name                                                                           AS subject,
       mark,
       concat(view_teachers.last_name, ' ', view_teachers.first_name, ' ', view_teachers.patronymic) AS teacher_name
FROM table_marks
         JOIN view_students
              ON table_marks.student_id = view_students.id
         JOIN table_subjects
              ON table_marks.subject_id = table_subjects.id
         JOIN view_teachers
              ON table_marks.teacher_id = view_teachers.id;

CREATE VIEW view_teacher_subjects AS
SELECT concat(view_teachers.last_name, ' ', view_teachers.first_name, ' ', view_teachers.patronymic) AS teacher_name,
       table_subjects.name                                                                           AS subject
FROM table_teacher_subjects
         JOIN view_teachers
              ON table_teacher_subjects.teacher_id = view_teachers.id
         JOIN table_subjects
              ON table_teacher_subjects.subject_id = table_subjects.id;

-- Заполнение таблиц тестовыми данными
INSERT INTO test.table_faculties (name)
VALUES ('SoftDev');
INSERT INTO test.table_faculties (name)
VALUES ('Design');

INSERT INTO test.table_subjects (name)
VALUES ('C#');
INSERT INTO test.table_subjects (name)
VALUES ('SQL');
INSERT INTO test.table_subjects (name)
VALUES ('UI/UX');
INSERT INTO test.table_subjects (name)
VALUES ('Photo');

INSERT INTO test.table_persons (last_name, first_name, patronymic, date_of_birth)
VALUES ('Starinin', 'Andrey', 'Nikolaevich', '1986-02-18');
INSERT INTO test.table_persons (last_name, first_name, patronymic, date_of_birth)
VALUES ('Karenina', 'Anna', null, '2000-10-30');
INSERT INTO test.table_persons (last_name, first_name, patronymic, date_of_birth)
VALUES ('Susanin', 'Ivan', null, '1995-07-31');

INSERT INTO test.table_teachers (person_id, faculty_id)
VALUES (1, 1);
INSERT INTO test.table_teachers (person_id, faculty_id)
VALUES (2, 2);

INSERT INTO test.table_teacher_subjects (teacher_id, subject_id)
VALUES (1, 1);
INSERT INTO test.table_teacher_subjects (teacher_id, subject_id)
VALUES (1, 2);
INSERT INTO test.table_teacher_subjects (teacher_id, subject_id)
VALUES (1, 4);
INSERT INTO test.table_teacher_subjects (teacher_id, subject_id)
VALUES (2, 3);
INSERT INTO test.table_teacher_subjects (teacher_id, subject_id)
VALUES (2, 4);

INSERT INTO test.table_students (person_id, faculty_id)
VALUES (2, 2);
INSERT INTO test.table_students (person_id, faculty_id)
VALUES (3, 1);
INSERT INTO test.table_students (person_id, faculty_id, is_active)
VALUES (1, 1, false);

INSERT INTO test.table_marks (student_id, date, subject_id, mark, teacher_id)
VALUES (1, '2023-09-05', 4, 5, 1);
INSERT INTO test.table_marks (student_id, date, subject_id, mark, teacher_id)
VALUES (2, '2023-09-05', 1, 4, 1);
INSERT INTO test.table_marks (student_id, subject_id, mark, teacher_id)
VALUES (2, 3, 2, 2);
