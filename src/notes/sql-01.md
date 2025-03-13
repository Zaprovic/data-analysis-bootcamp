## **Creating tables**

In the `CREATE` statement we always use the same syntax when creating a new table. Inside the parenthesis we define the columns of the table, separated by commas. The general syntax would be as follows

```sql
CREATE TABLE IF NOT EXISTS <tableName> (
    column1 <dataType> <tableConstraint> DEFAULT <defaultValue>,
    column2 <dataType> <tableConstraint> DEFAULT <defaultValue>,
    ...
    columnN <dataType> <tableConstraint> DEFAULT <defaultValue>
)
```

The structure of a table is solely defined by its data schema, which defines a series of columns. Each column has a name, a data type, and a set of constraints which are optional, as well as the optional default value for the column.


### ***Data types***
Different databases support different data types, but the common types support numeric, string and other ones such as dates, booleans, or even binary data. Here are some of the most common data types:

| Data Type | Description |
|-----------|-------------|
| INT | Integer data type |
| VARCHAR | Variable-length character string |
| TEXT | Variable-length character string |
| DATE | Date data type |
| BOOLEAN | Boolean data type |
| FLOAT | Floating-point number |


### ***Constraints***
Constraints are optional attributes that can be added to a column to define additional properties. Although being optional, sometimes they can become quite handy. Here are some of the most common constraints:

| Constraint | Description |
|------------|-------------|
| NOT NULL | Specifies that the column cannot contain NULL values |
| UNIQUE | Specifies that the column must contain unique values |
| PRIMARY KEY | Specifies that the column is the primary key of the table |
| DEFAULT | Specifies the default value for the column |
| AUTO_INCREMENT | Specifies that the column is an auto-incrementing primary key |
| FOREIGN KEY | Specifies a foreign key relationship between two tables |


## **Reading data from tables**

Creating tables is relatively easy once we get used to the syntax, and determining which datatypes are more suitable for the columns. Reading data is also pretty easy, and we can use the `SELECT` statement to get the data we need, subjected to conditions as well.

```sql
SELECT column1, column2, ..., columnN
FROM <tableName>;
```

In the select statement we can specify which columns we want to retrieve, and we can also specify conditions to filter the data by using constraints with the `WHERE` keyword.

```sql
SELECT column1, column2, ..., columnN
FROM <tableName>
    WHERE <condition1>
        AND/OR <condition2>
        AND/OR ... <conditionN>;
```

These constraints are used with logical operators, and the most common ones are

- `=` for equality (case sensitive)
- `LIKE` for case **insensitive exact** string matching
- `<` for less than
- `>` for greater than
- `<=` for less than or equal to
- `>=` for greater than or equal to
- `<>` for not equal to ( `!=` ) and is also case sensitive
- `IN` for checking if a value is in a list
- `NOT IN` for checking if a value is not in a list
- `BETWEEN AND` for checking if a value is between two values
- `NOT BETWEEN AND` for checking if a value is not between two values
- `%` is used anywhere in the string to match any sequence of zero or more characters. So for example `LIKE %AT%` will match to stuff like `CAT`, `AT`, `ATE`, `BAT`, etc.
- `_` is used anywhere in the string to match a **single character**. So for example `LIKE AN_%` will match to stuff like `ANT`, `AND` but not `AN`

### ***Ordering results***
Sometimes can become difficult to read the results of a query, and we can use the `ORDER BY` keyword to sort the results by a column. To help this, we use the `ORDER BY` clause followed by the column name and the order we want to sort by. The order can be ascending (`ASC`) or descending (`DESC`).

```sql
SELECT column1, column2, ..., columnN
FROM <tableName>
ORDER BY <columnName> <ASC/DESC>;
```

### ***Limiting results***

Sometimes we only want to retrieve a few rows from a table, and we can use the `LIMIT` keyword to limit the number of rows returned. The `LIMIT` keyword is followed by the number of rows we want to retrieve. We can also add an `OFFSET` keyword to skip a certain number of rows before retrieving the rows we want.

```sql
SELECT column1, column2, ..., columnN
FROM <tableName>
LIMIT <numberOfRows> OFFSET <numberOfRowsToSkip>;
```

So in summary, we can use the `SELECT` statement to retrieve data from a table, and we can use the `WHERE` and `ORDER BY` clauses to filter and sort the data, and the general syntax for this would be as follows

```sql
SELECT column1, column2, ..., columnN
FROM <tableName>
    WHERE <condition1>
        AND/OR <condition2>
        AND/OR ... <conditionN>
    ORDER BY <columnName> <ASC/DESC>
    LIMIT <numberOfRows> OFFSET <numberOfRowsToSkip>;
```

## **Insert operations**
When inserting data into a database, we can use the INSERT statement, in which we declare what table to write into, the columns of data that we are filling and one or more rows of data to insert. In general, each row of data that is inserted should contain values for every corresponding column in the table and we can also insert multiples rows at a time by adding them sequentially.

The following is an insert statement with values for all the columns in the table

```sql
INSERT INTO <tableName>
VALUES 
(val11, val12, ..., val1N),
(val21, val22, ..., val2N),
(val31, val32, ..., val3N),
...
(valM1, valM2, ..., valMN);
```

We can also perform an insert  for specific columns as follows
```sql
INSERT INTO <tableName> (col1, col2, ..., colN)
VALUES
(val11, val12, ..., val1N),
(val21, val22, ..., val2N),
(val31, val32, ..., val3N),
...
(valM1, valM2, ..., valMN);
```

## **Updating rows**
Another common task in databases is updating records in a table, which is done via the `UPDATE` keyword, and just like the `INSERT` statement we have to specify exactly which table, columns and rows to update.

```sql
UPDATE <tableName>
SET col1=val1
	col2=val2,
	...,
	colN=valN,
WHERE condition;
```

The `WHERE` clause is extremely important, if not present, then the query will update all records in the table. One useful tip is to always write first the constraint and test in a `SELECT` query to make sure we are updating the right subset of data. It's also important to notice that we can use regex expression in the `WHERE` clause.



## **Altering tables**
As data changes over time, there is the possibility that a pre-existing table may need additional columns, and here is where we alter the table schema in order to add, remove or modify its columns and table constraints.

#### ***Adding columns***
```sql
ALTER TABLE <tableName>
ADD newCol <dataType> <optionalConstraint> DEFAULT <defaultValue>
```

#### ***Deleting columns***
As said, we can remove columns in a table. However, some databases (like SQLite) don’t support this feature and a workaround for this would be to create a new table and migrate the data over
```sql
ALTER TABLE <tableName>
DROP <col>;
```
#### ***Renaming tables***
```sql
ALTER <tableName>
RENAME TO <newTableName>;
```
#### ***Updating column definition***
Here is where it gets a little tricky, because updating column definition may differ depending on the database system (MySQL, PostgreSQL, SQL Server, Oracle, etc.) but typically goes as follows
```sql
/* Sentence to modify a column's data type */
ALTER TABLE <tableName>
MODIFY COLUMN <col> <newDataType>
```
```sql
/* Sentence to modify a column's constraint */
ALTER TABLE <tableName>
MODIFY COLUMN <col> <columnConstrain>
```
We have to be very careful when modifying a column’s constrain because these queries will also apply to existing records, so if not careful, it can result in data loss, although this error handling also depends on the database system, since some of them will try to cast values to the newly datatype if possible, or set existing values to `NULL` (which is almost as bad as deleting them).

#### ***Modifying primary and foreign keys***
This is also a special one, because when altering the primary key of a table, we would typically drop it first and then add a new one
```sql
/* Dropping original primary key on the table */
ALTER TABLE <tableName>
DROP PRIMARY KEY;

/* Adding new key in the table */
ALTER TABLE <tableName>
ADD PRIMARY KEY (<newKey>);
```
```sql
ALTER TABLE <tableName>
DROP FOREIGN KEY <foreignKey>;

ALTER TABLE <tableName>
ADD CONSTRAINT <foreignKey>
FOREIGN KEY (<newForeignKey>) REFERENCES <referencedTable>(<newForeignKey>);
```

## **Deleting rows**
Just like the `UPDATE` clause, there is an option to delete specific rows from a table. It is also recommended to use a `SELECT` query with constraints before deleting any records
```sql
DELETE FROM <tableName>
WHERE <condition>;
```


## **Dropping tables**
Just like the `ALTER` clause, we can also remove entire tables from the database. It is recommended to use the `IF EXISTS` clause so when running the SQL script it can do the check and avoid throwing errors
```sql
DROP TABLE IF EXISTS <tableName>;
```

## **Best practices for using SQL**
Using raw SQL to manipulate data is a doubled edge sword, because even though we can achieve extraordinary performance in the queries, we can delete or update rows pretty easily by accident. So here are some best practices for using SQL:

1. Always use a `SELECT` statement before using `UPDATE` and `DELETE`
2. Always use a `WHERE` clause in your `UPDATE` and `DELETE` statements
3. Use `LIMIT` to reduce impact
4. Enable foreign key constraints
5. Have a backup before making any bulk changes