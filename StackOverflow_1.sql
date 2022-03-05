-- https://www.brentozar.com/sql/watch-brent-tune-queries/
-- Brent Ozar_Watch Brent Tune Queries https://www.youtube.com/watch?v=uwGCPtga06U&t=2426s
-- When using temp variable sql mostly thinks that it contains 1 row.
-- use temp table not table variable if statistics are needed

create table #VoteStats (PostId int, up int, down int)

insert #VoteStats
select
    PostId,
    up = sum(case when VoteTypeId = 2 then 1 else 0 end),
    down = sum(case when VoteTypeId = 3 then 1 else 0 end)
from Votes
where VoteTypeId in (2, 3)
group by PostId
HAVING sum(case when VoteTypeId = 2 then 2 else 0 end) > sum(case when VoteTypeId = 3 then 1 else 0 end)



select top 100 p.Id as [Post Link], up, down from #VoteStats
join Posts p on PostId = p.Id
where p.CommunityOwnedDate is null and p.ClosedDate is null
order by up desc

drop table #VoteStats
--- Let's optimize above query

set statistics io ON

; with VoteStats as
    (
        select
            PostId,
            up = sum(case when VoteTypeId = 2 then 1 else 0 end),
            down = sum(case when VoteTypeId = 3 then 1 else 0 end)
        from Votes
        where VoteTypeId in (2, 3)
        group by PostId
        HAVING sum(case when VoteTypeId = 2 then 2 else 0 end) > sum(case when VoteTypeId = 3 then 1 else 0 end)
    )
select top 100 p.Id as [Post Link]
from VoteStats vs
Inner join Posts p on vs.PostId = p.Id
where p.CommunityOwnedDate is null and p.ClosedDate is null
order by vs.up desc
-- This one has little difference in performance and uses less logical reads
-- We can create index that ms sql hints 
CREATE NONCLUSTERED INDEX IX_VoteTypeId_Includes
ON [dbo].[Votes] ([VoteTypeId])
INCLUDE ([PostId]);
GO
-- above index will make query little faster but reads may be more
create view dbo.vwPostVotes with schemabinding as
select v.PostId,
up = sum(case when v.VoteTypeId = 2 then 1 else 0 end),
down = sum(case when v.VoteTypeId = 3 then 1 else 0 end)
totalvotes = COUNT_BIG(*)
from dbo.Votes as v
inner join dbo.Posts as p on v.PostId = p.Id
where v.VoteTypeId in (2, 3)
    and p.CommunityOwnedDate is null
    and p.ClosedDate is null
group by v.PostId;
go

create unique clustered index CL_PostId on dbo.vwPostVotes (PostId);
go

select top 100 PostId as [Post Link]
from dbo.vwPostVotes
where down * 2 > up
order by up desc
-- above query will be less than second
-- schema binding makes our view materialized ( it will be stored on disk as tables)
-- now insert/update/delete will be slower on main tables

-- we can do better
-- we can create clustered index on top of indexed view

create index IX_up on dbo.vwPostVotes (up desc, down);
go
select top 100 PostId as [Post Link]
from dbo.vwPostVotes
where down * 2 > up
order by up desc
-- above index makes logical 10x less