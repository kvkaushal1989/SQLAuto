USE [BankSecurity]
GO
/****** Object:  StoredProcedure [dbo].[CreateUpdateQuery]    Script Date: 07-04-2022 07:30:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER ProcEDURE [dbo].[CreateUpdateQuery]
@TableName	sysname
AS
BEGIN
--declare @TableName sysname = @TableToConvert-- 'Addon'
declare @ResultPRM NVARCHAR(max) = ''

select @ResultPRM = @ResultPRM + '@'+ColumnName + ' '+ColumnType+' = NULL,
'
from
(
    select 
        replace(col.name, ' ', '_') ColumnName,
        column_id ColumnId,
        case typ.name 
            when 'bigint' then 'bigint'
            when 'binary' then 'binary'
            when 'bit' then 'bit'
            when 'char' then 'char(1)'
            when 'date' then 'date'
            when 'datetime' then 'datetime'
            when 'datetime2' then 'datetime2'
            when 'datetimeoffset' then 'datetimeoffset'
            when 'decimal' then 'decimal(12,2)'
            when 'float' then 'float'
            when 'image' then 'image'
            when 'int' then 'int'
            when 'money' then 'money'
            when 'nchar' then 'nchar(1)'
            when 'ntext' then 'ntext'
            when 'numeric' then 'numeric'
            when 'nvarchar' then 'nvarchar(max)'
            when 'varchar' then 'varchar(max)'
            when 'real' then 'real'
            when 'smalldatetime' then 'smalldatetime'
            when 'smallint' then 'smallint'
            when 'smallmoney' then 'smallmoney'
            when 'text' then 'text'
            when 'time' then 'time'
            when 'timestamp' then 'timestamp'
            when 'tinyint' then 'tinyint'
            when 'uniqueidentifier' then 'uniqueidentifier'
            when 'varbinary' then 'varbinary'
            when 'NVARCHAR' then 'NVARCHAR'
            when 'VARCHAR' then 'VARCHAR(max)'
            else 'UNKNOWN_' + typ.name
        end ColumnType,
        case 
            when col.is_nullable = 1 and typ.name in ('bigint', 'bit', 'date', 'datetime', 'datetime2', 'datetimeoffset', 'decimal', 'float', 'int', 'money', 'numeric', 'real', 'smalldatetime', 'smallint', 'smallmoney', 'time', 'tinyint', 'uniqueidentifier') 
            then '?' 
            else '' 
        end NullableSign
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)
) t
order by ColumnId

set @ResultPRM = @ResultPRM  + '
'
PRINT @ResultPRM

--declare @TableName sysname = @TableToConvert-- 'Addon'
declare @Result NVARCHAR(max) =  'INSERT INTO [dbo].['+@TableName+'] ('

select @Result = @Result + '
		['+ColumnName + '], '
from
(
    select 
        replace(col.name, ' ', '_') ColumnName,
        column_id ColumnId
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)
) t
order by ColumnId

set @Result = @Result  + '
	) ' 

declare @ResultWO NVARCHAR(max) =  'VALUES ('

select @ResultWO = @ResultWO + '
		@'+ColumnName + ', '
from
(
    select 
        replace(col.name, ' ', '_') ColumnName,
        column_id ColumnId
    from sys.columns col
        join sys.types typ on
            col.system_type_id = typ.system_type_id AND col.user_type_id = typ.user_type_id
    where object_id = object_id(@TableName)
) t
order by ColumnId

set @ResultWO = @ResultWO  + '
	)'
  
PRINT @Result+@ResultWO

END