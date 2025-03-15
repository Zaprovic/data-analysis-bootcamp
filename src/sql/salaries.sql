drop database if exists planes;

create database if not exists planes;

use planes;

drop table if exists pilots;

drop table if exists employees;

create table if not exists employees (
    employee_id int primary key,
    first_name varchar(255),
    salary float
);

create table if not exists pilots (
    pilot_id int auto_increment primary key,
    airline_name varchar(255),
    employee_id int,
    foreign key (employee_id) references employees (employee_id) on delete cascade
);

insert into
    employees (
        employee_id,
        first_name,
        salary
    )
values (7007, 'Kim', 60000),
    (7004, 'Laura', 20000),
    (7002, 'Will', 80050),
    (7009, 'Warren', 80780),
    (7001, 'Smith', 25000),
    (7003, 'Katy', 78000);

select * from employees;

insert into
    pilots (airline_name, employee_id)
values (
        'Airbus 380',
        (
            select employee_id
            from employees
            where
                first_name = 'Kim'
        )
    ),
    (
        'Boeing',
        (
            select employee_id
            from employees
            where
                first_name = 'Laura'
        )
    ),
    (
        'Airbus 380',
        (
            select employee_id
            from employees
            where
                first_name = 'Will'
        )
    ),
    (
        'Airbus 380',
        (
            select employee_id
            from employees
            where
                first_name = 'Warren'
        )
    ),
    (
        'Boeing',
        (
            select employee_id
            from employees
            where
                first_name = 'Smith'
        )
    ),
    (
        'Airbus 380',
        (
            select employee_id
            from employees
            where
                first_name = 'Katy'
        )
    );

select e.employee_id, e.first_name, p.airline_name, e.salary
from employees e
    inner join pilots p on e.employee_id = p.employee_id;

-- Use CTE for the next query

with
    avgVal (a) as (
        select avg(e.salary)
        from employees e
    )
select e.first_name, e.salary
from avgVal, employees e
where
    e.salary > a;

select e.employee_id, e.first_name, p.airline_name, e.salary
from employees e
    inner join pilots p on e.employee_id = p.employee_id;

with
    mp as (
        select e.employee_id, e.first_name, p.airline_name, e.salary
        from employees e
            inner join pilots p on e.employee_id = p.employee_id
    ),
    average_salary (a) as (
        select avg(e.salary)
        from employees e
    ),
    total_salaries (airline_name, total) as (
        select mp.airline_name, sum(salary) as total_salary
        from mp
        group by
            mp.airline_name
    )
select total_salaries.airline_name
from total_salaries, average_salary
where
    total_salaries.total > average_salary.a;

with
    total_salaries as (
        select p.airline_name, sum(e.salary) as total_salary
        from employees e
            inner join pilots p on e.employee_id = p.employee_id
        group by
            p.airline_name
    )
select ts.airline_name
from total_salaries ts
where
    ts.total_salary > (
        select avg(e.salary)
        from employees e
    );