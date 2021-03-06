select 
	PlanUse = case when p.usecounts > 1 THEN '>1' else '1' end
,	PlanCount = count(1) 
,	SizeInMB = sum(p.size_in_bytes/1024./1024.)
FROM sys.dm_exec_cached_plans p
group by case when p.usecounts > 1 THEN '>1' else '1' end

GO




--If size of Adhoc is listed first or second, perhaps Optimize for Ad Hoc Workloads should be enabled (see comments) 
SELECT objtype AS [CacheType]
        , count_big(*) AS [Total Plans]
        , sum(cast(size_in_bytes as decimal(18,2)))/1024/1024 AS [Total MBs]
--        , avg(usecounts) AS [Avg Use Count]
        , sum(cast((CASE WHEN usecounts = 1 THEN size_in_bytes ELSE 0 END) as decimal(18,2)))/1024/1024 AS [Total MBs – USE Count 1]
        , sum(CASE WHEN usecounts = 1 THEN 1 ELSE 0 END) AS [Total Plans – USE Count 1]
FROM sys.dm_exec_cached_plans
GROUP BY grouping sets (objtype, ())
ORDER BY [Total MBs – USE Count 1] DESC
go 
/*


go

EXEC sys.sp_configure N'show advanced options', N'1' 
GO
RECONFIGURE WITH OVERRIDE
go
EXEC sys.sp_configure 
go
EXEC sys.sp_configure N'show advanced options', N'0' 
GO
RECONFIGURE WITH OVERRIDE
go
EXEC sys.sp_configure 
go
EXEC sys.sp_configure N'optimize for ad hoc workloads' 
go
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
go
*/
/*
SELECT usecounts, cacheobjtype, objtype, TEXT, SizeMB= convert(decimal(19,2), p.size_in_bytes/1024./1024.), 'DBCC FREEPROCCACHE (', p.plan_handle, ')'
FROM sys.dm_exec_cached_plans p
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE usecounts =1 
ORDER BY usecounts DESC;
GO
*/

/*
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'optimize for ad hoc workloads', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
GO
*/