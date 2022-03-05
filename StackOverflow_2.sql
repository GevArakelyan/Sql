-- Each logical read is 8K read.
-- To find most expensive queries
sp_BlitzWho


-- To see information about table
sp_BlitzIndex @TableName = 'Posts'

create index [OwnerUserId_Incl] on [StackOverflow].[dbo].[Posts] ([OwnerUserId])
include ([CreationDate], Score) with (drop_existing = on);
