# Database normalization
Normalization is the process of simplifying big and complex tables in a databases. This process can reduce data redundancy and also improve data integrity. It consists in decomposing large tables into smaller, well-structured tables and defining relationships between them using the concept of *normal forms*.

The normalization process aims to eliminate anomalies in database operations, from which the most often are
- Insertion anomalies - When inserting new data requires including redundant or unrelated information.
- Update anomalies - When modifying a single data value requires multiple updates across different places.
- Deletion anomalies - When deleting a record results in *unintentional loss of data*.

There is no such perfect database design, and even when a design is really robust, that does not guarantee the database won’t be vulnerable to attacks, however, there are some problems that can be avoided by using normalization, and when it comes to data integrity, we always want to avoid data disagreeing with itself. Normalized tables, besides of eliminating anomalies in operations, are also easier to understand and easier to enhance and extend, which can make them more scalable.
## Normal forms
The normal forms allows to determine if there is a danger that redundant data may be leaked into the tables. They basically allow to asses the level of danger and vulnerability to anomalies
### 1NF - First normal form
When it comes to relational databases, it shouldn’t matter the order in which elements in a table are retrieved, hence, they must always represent the same elements. If we somehow want to give an insight of order in the records of a table, we must be as descriptive as possible and specify what is it that is giving the order. One of the principles of first normal form is to never use row order to convey information

| Animal                | Weight      |
| --------------------- | ----------- |
| Capybara              | 45 kg       |
| Snow leopard          | 50 kg       |
| Blue poison dart frog | 4 g         |
| Goliath birdeater     | 200 g       |
| Komodo dragon         | 70 to 90 kg |
In the table above we can use the weight column to talk about what is the lightest or heaviest animal, so as 1NF goes this is good, however this is not enough to satisfy this normal form because the weight units are not the same for all records.

| Animal                | Weight |
| --------------------- | ------ |
| Capybara              | 45 kg  |
| Snow leopard          | 50 kg  |
| Blue poison dart frog | 0.004  |
| Goliath birdeater     | 0.2    |
| Komodo dragon         | 80     |

Now all weight units are in the same units, as well as they only contain a single value for the weights. Another constraint on 1NF is to always have a [[sql-02|primary key]] which is a special column in the table for which we are sure it will identify uniquely that record. In the case of the animals table, it would make sense to use the `Animal` column as the primary key, because every animal specimen has a different name. This makes sure we are never able to insert another animal with the same name, hence avoiding duplicates.

Now one last thing that 1NF must satisfy is to never have repeating groups in a column, so for example if we are storing an inventory of the items a player has in a game, at first we may have something like this

| Player | Inventory                         |
| ------ | --------------------------------- |
| mario  | 2 mushrooms, 1 star               |
| yoshi  | 4 star, 2 bullets, 3 fire flowers |
| daisy  | 3 bananas, 5 mushrooms            |
| peach  | 1 mushroom, 1 bullet              |
Data like this would be very difficult to query, if we would like to know, for example, which players have more than 1 bullet. We may be tempted to create multiple columns for each item, but we don’t know ahead how many different items a player may have, so having a fixed number of columns for each item is also impractical. A good design that satisfies 1NF will be as follows

| Player | item        | Quantity |
| ------ | ----------- | -------- |
| mario  | mushroom    | 2        |
| mario  | star        | 1        |
| yoshi  | star        | 4        |
| yoshi  | bullet      | 2        |
| yoshi  | fire flower | 3        |
| daisy  | banana      | 3        |
| daisy  | mushroom    | 5        |
| peach  | mushroom    | 1        |
| peach  | bullet      | 1        |
Recall that primary keys can be composite, and in this case of player inventory it makes sense to use the combination of player and item as the primary key.

In summary, these are the things we always want to avoid to satisfy first normal form
1. Using row order to convey information
2. Mixing data types
3. Having a table without a primary key
4. Having repeating groups
### 2NF - Second normal form
Here is where having a single table to store information may lack in how descriptive the database can be. Suppose we want to add another field to specify the level of the player

| Player | item        | Quantity | Level        |
| ------ | ----------- | -------- | ------------ |
| mario  | mushroom    | 2        | Intermediate |
| mario  | star        | 1        | Intermediate |
| yoshi  | star        | 4        | Advanced     |
| yoshi  | bullet      | 2        | Advanced     |
| yoshi  | fire flower | 3        | Advanced     |
| daisy  | banana      | 3        | Beginner     |
| daisy  | mushroom    | 5        | Beginner     |
| peach  | mushroom    | 1        | Intermediate |
| peach  | bullet      | 1        | Intermediate |
The problem seems quite evident. Notice that if we happen to update the level of a player, like mario, we may run into an *update anomaly* because there is the possibility that the update only happens in 1 of the 2 records where mario is. Also we may run into *insertion anomalies* if there is a new player with a level that is not still within the table, and finally there is also room for *deletion anomalies* because if a player looses some specific item and we drop it from the table, then if their level was unique in the table until that moment, it will become undefined.

To avoid this problem, second normal form establishes that any non-key attribute must have a direct dependency on the key attributes. In the case of the table above, the quantity only depends in the composite primary key and we denote it as follows
$$
\{\text{Player, Item}\} \to \{\text{Quantity}\}
$$
However, the level only depends on the name of the player, but not on the combination of player and item, and in order to fix this problem, we need an additional table with a primary key that yields a direct dependency on the non-key attributes of that new table.

| Player | Level        |
| ------ | ------------ |
| Mario  | Intermediate |
| Yoshi  | Advanced     |
| Daisy  | Beginner     |
| Peach  | Intermediate |

In the first table, the primary key is the `Player` column, because in a game there cannot be two player with the same name. On the other side, the second table’s primary key is the composition of `Player` and `Item`.

### 3NF - Third normal form
Remember that 2NF tells us that all of the non-key attributes of a table must depend on the key. The third normal form also specifies this but in a more rigorous way: **every non-key attribute of a table must depend on the key, the whole key and nothing but the key**. This basically means that if there are two non-key columns $c_{1}$ and $c_{2}$, it is not allowed that $c_{1}$ depends on $c_{2}$ and viceversa, instead, these two columns must depend exclusively on the primary key and nothing else.

In the case of the players, a problem like this arises when we want to be more specific on the player level. Suppose we add a new column of `Skill`, which is a number from 1 to 9 representing how skillful the player is.
- If skill is between 1 and 3 then the player is a beginner
- If skill is between 4 and 6 then the player is intermediate
- If skill is between 7 and 9 then the player is advanced
Here we have two non-key columns (`Skill` and `Level`) in which the level depends on the skill, so if the player’s skill changes, then the level must also change, but in order to avoid an update anomaly we create another table relating the skill and level

| Skill | Level        |
| ----- | ------------ |
| 1     | Beginner     |
| 2     | Beginner     |
| 3     | Beginner     |
| 4     | Intermediate |
| 5     | Intermediate |
| 6     | Intermediate |
| 7     | Advanced     |
| 8     | Advanced     |
| 9     | Advanced     |

## Videos
- [Learn Database Normalization - Decomplexify](https://www.youtube.com/watch?v=GFQaEYEc8_8&t=989s)
