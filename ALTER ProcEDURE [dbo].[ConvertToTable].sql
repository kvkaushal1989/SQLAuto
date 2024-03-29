USE [BankSecurity]
GO
/****** Object:  StoredProcedure [dbo].[ConvertToTable]    Script Date: 07-04-2022 07:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER ProcEDURE [dbo].[ConvertToTable]
@TableName	sysname
AS
BEGIN
--declare @TableName sysname = @TableToConvert-- 'Addon'
declare @Result NVARCHAR(max) =  ' <ngx-datatable
          #table
          class="material data-table"
          [rows]="rows"
          [limit]="10"
          [columnMode]="force"
          [headerHeight]="50"
          [footerHeight]="50"
          [rowHeight]="80"
          [scrollbarH]="true"
          >'

select @Result = @Result + '	
	<ngx-datatable-column name="'+ColumnName + '">'+
		'		
		<ng-template ngx-datatable-cell-template let-row="row" let-value="value">'+
		'			
		{{ row.'+ColumnName + ' }}'+
		'		
		</ng-template>'+
		'	
	</ngx-datatable-column>'
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
</ngx-datatable>' 


PRINT @Result


END