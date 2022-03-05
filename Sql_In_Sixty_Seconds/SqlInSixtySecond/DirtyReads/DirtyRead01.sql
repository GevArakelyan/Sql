-- https://www.youtube.com/watch?v=sbBFHFxxE1Y

use Sample1
go
create table Toys ([name] varchar(100), price int)
go

insert into Toys values ('Car', 99), ('Bird',100), ('Bike', 100)
go

begin transaction

update toys
set price = price + 1
where name = 'Car';

waitfor delay '00:00:10';

update Toys
set price = price + 1
where name = 'Car';
commit


--drop table Toys
--go
