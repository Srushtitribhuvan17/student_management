create table student (
    id int auto_increment primary key,
    name varchar(100),
    email varchar(100) unique,
    course_id int,
    class_id int
);

create table student_backup (
    id int,
    name varchar(100),
    email varchar(100),
    course_id int,
    class_id int,
    backup_time timestamp default current_timestamp
);

create table course (
    id int auto_increment primary key,
    course_name varchar(100)
);

create table course_backup (
    id int,
    course_name varchar(100),
    backup_time timestamp default current_timestamp
);

create table class (
    id int auto_increment primary key,
    class_name varchar(100),
    class_teacher varchar(100)
);

create table class_backup (
    id int,
    class_name varchar(100),
    class_teacher varchar(100),
    backup_time timestamp default current_timestamp
);

create table marks (
    id int auto_increment primary key,
    student_id int,
    subject varchar(100),
    marks_obtained int,
    foreign key (student_id) references student(id)
);

create table marks_backup (
    id int,
    student_id int,
    subject varchar(100),
    marks_obtained int,
    backup_time timestamp default current_timestamp
);

delimiter //

create procedure addstudent (
    in stu_name varchar(100),
    in stu_email varchar(100),
    in course_id int,
    in class_id int
)
begin
    insert into student (name, email, course_id, class_id)
    values (stu_name, stu_email, course_id, class_id);
end //

create trigger backup_student_before_delete
before delete on student
for each row
begin
    insert into student_backup (id, name, email, course_id, class_id)
    values (old.id, old.name, old.email, old.course_id, old.class_id);
end //

create trigger backup_course_before_delete
before delete on course
for each row
begin
    insert into course_backup (id, course_name)
    values (old.id, old.course_name);
end //

create trigger backup_class_before_delete
before delete on class
for each row
begin
    insert into class_backup (id, class_name, class_teacher)
    values (old.id, old.class_name, old.class_teacher);
end //

create trigger backup_marks_before_delete
before delete on marks
for each row
begin
    insert into marks_backup (id, student_id, subject, marks_obtained)
    values (old.id, old.student_id, old.subject, old.marks_obtained);
end //

delimiter ;

insert into course (course_name) values ('bca'), ('bba'), ('ba');
insert into class (class_name, class_teacher) values ('class a', 'mr. amit'), ('class b', 'ms. reena');
call addstudent('rahul sharma', 'rahul@gmail.com', 1, 1);
call addstudent('anita desai', 'anita@gmail.com', 2, 2);

insert into marks (student_id, subject, marks_obtained) values (1, 'math', 88), (2, 'english', 75);

select
    s.id as student_id,
    s.name as student_name,
    s.email,
    c.course_name,
    cl.class_name,
    cl.class_teacher
from student s
join course c on s.course_id = c.id
join class cl on s.class_id = cl.id;
