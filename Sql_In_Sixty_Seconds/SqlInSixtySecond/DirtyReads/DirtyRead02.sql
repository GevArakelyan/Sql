use Sample1
go
select *
from Toys
where price = 100
go

select*
from Toys with(nolock)
where price = 100
go

