# Common table expressions and subqueries

In most cases after performing a join or any other operation, the output we get is a SQL table and we would like to query this new table to deep dive more in the information it returns. There are two options to do this: using subqueries or common table expressions (CTEs)

| employee_id | first_name | salary |
| ----------- | ---------- | ------ |
| 7007        | kim        | 60000  |
| 7004        | laura      | 20000  |
| 7002        | will       | 80050  |
| 7009        | warren     | 80780  |
| 7001        | smith      | 25000  |
| 7003        | katy       | 78000  |

| pilot_id | airline_name | employee_id |
| -------- | ------------ | ----------- |
| 1        | airbus 380   | 7007        |
| 2        | boeing       | 7004        |
| 3        | airbus 380   | 7002        |
| 4        | airbus 380   | 7009        |
| 5        | boeing       | 7001        |
| 6        | airbus 380   | 7003        |

Based on these two tables, we can perform a join to create a new table that displays the information for each employee with their corresponding airlines

```sql
select e.employee_id, e.first_name, p.airline_name, e.salary
from employees e
    inner join pilots p on e.employee_id = p.employee_id;
```

| employee_id | first_name | airline_name | salary |
| ----------- | ---------- | ------------ | ------ |
| 7007        | kim        | airbus 380   | 60000  |
| 7004        | laura      | boeing       | 20000  |
| 7002        | will       | airbus 380   | 80050  |
| 7009        | warren     | airbus 380   | 80780  |
| 7001        | smith      | boeing       | 25000  |
| 7003        | katy       | airbus 380   | 78000  |

This is not something new if you already know about joins, but what may be new is the fact that this returns a table, which can be queried as well.

```sql
-- Querying using cte
with
    mp as (
        select e.employee_id, e.first_name, p.airline_name, e.salary
        from employees e
            inner join pilots p on e.employee_id = p.employee_id
    )
select *
from mp;
```

```sql
-- quering using subquery
select *
from (
        select e.employee_id, e.first_name, p.airline_name, e.salary
        from employees e
            inner join pilots p on e.employee_id = p.employee_id
    ) as mp;
```

Subqueries may seem more intuitive at first, as they naturally follow the `FROM` keyword when selecting data. Their syntax makes it clear which table is being queried. However, a key limitation of subqueries is their lack of reusability—if the same result set is needed multiple times in a query, the subquery must be **repeated**, leading to redundancy and reduced maintainability. In contrast, **Common Table Expressions (CTEs)** provide a way to define a **temporary named result set** at the start of a query, allowing it to be referenced multiple times without repetition. By aliasing the CTE, queries become **more structured, readable, and easier to modify**, especially in complex operations.

Now suppose we want to know which employees earn more than the average salary. We can achieve this pretty easily using a common table expression

```sql
with
    avgVal (a) as (
        select avg(e.salary)
        from employees e
    )
select e.first_name, e.salary
from avgVal, employees e
where
    e.salary > a;
```

Within the CTE a table `avgVal` is created. This table only returns a single column that is being labeled as `a` (we can also alias in the select statement), this creates like a local context in where the table `avgVal` can be used for querying purposes. Notice that after the CTE the query is not finished, but instead a new query is created, which used the local variable of `avgVal` and table of `employees` aliased as `e`. Up until this point we not only have the information of employees but also the average salary at the same time, in the same table, so filtering the records where the salary is greater than the average becomes trivial.

Let us do something a little bit more complex. What if we want to find the airlines where the total salary of all pilots is greater than the average salary of the pilots (employees). Wrapping our heads around this can be difficult at first but here is how we can think about it:

Every pilot (employee) belongs to a different airline but there may be two or more working for the same airline as well. Since we need the total salary this means a sum has to be performed, and this aggregate is grouped by airline name, so we can start with that part by first creating a context to store the joined table

```sql
with
    mp as (
        select e.employee_id, e.first_name, p.airline_name, e.salary
        from employees e
            inner join pilots p on e.employee_id = p.employee_id
    )
select mp.airline_name, sum(salary) as total_salary
from mp
group by
    mp.airline_name;
```

| airline_name | total_salary |
| ------------ | ------------ |
| Boeing       | 45000        |
| Airbus 380   | 298830       |

We have to calculate the average of the salaries, which means requiring an additional context. We can create multiple contexts under the same `WITH` statement just by separating by commas.

```sql
with
    mp as (
        select e.employee_id, e.first_name, p.airline_name, e.salary
        from employees e
            inner join pilots p on e.employee_id = p.employee_id
    ),
    average_salary as (
        select avg(e.salary)
        from employees e
    )
select mp.airline_name, sum(salary) as total_salary
from mp
group by
    mp.airline_name;
```

One of the coolest things about these contexts is that, after declaring them we can query anything related to the context variables. So we can either access to calculate the total salary by airline, or display the average salary of the pilots, because both variables are predefined in the context. Now we need a final context to store the aggregate of total salaries per airline.

```sql
with
    mp as (
        select e.employee_id, e.first_name, p.airline_name, e.salary
        from employees e
            inner join pilots p on e.employee_id = p.employee_id
    ),
    average_salary as (
        select avg(e.salary)
        from employees e
    ),
    total_salaries as (
        select mp.airline_name, sum(salary) as total_salary
        from mp
        group by
            mp.airline_name
    )
select *
from total_salaries;
```

This is amazing, because in a single query we are temporarily storing three queries, and we can do this as many times as we want, and even storing queries that have contexts within them. Now it’s just a matter of filtering the rows where the total salary is bigger than the average.

```sql
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
```

## Videos

[SQL WITH Clause - Maven Analytics](https://www.youtube.com/watch?v=LJC8277LONg)
