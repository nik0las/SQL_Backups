/*---------------------------
*Author by Nikos Athanasakis
*----------------------------*/

--Update date 02/09/2022

-->Variable Definition 
DECLARE @fileName VARCHAR(90);
DECLARE @db_name VARCHAR(20);
DECLARE @fileDate VARCHAR(20);

-->Βαζουμε διαδρομη αρχειου κ ονομα βασης
SET @fileName = N'E:\PYLON_BACKUP\'; -- change to the relevant path
SET @db_name = N'PLN_AMANAKI';     -- change to the relevant database name
--SET @fileDate = CONVERT(VARCHAR(20), GETDATE(),112); -- Only DATE

SET @fileDate = CONVERT(NVARCHAR(20),GETDATE(),112) + '_' + REPLACE(CONVERT(NVARCHAR(20),GETDATE(),108),N':',N'')

SET @fileName = @fileName + @db_name + '_' + RTRIM(@fileDate) + N'.bak';

BACKUP DATABASE @db_name TO DISK = @fileName WITH NOFORMAT,NOINIT, COMPRESSION ,STATS=5,NAME =@db_name; 

-------------------------------------------------------------------------------------------------------------------
--Remove older full backups 
DECLARE @KeepLastDays VARCHAR(50)
DECLARE @LASTDAYS FLOAT

SET @LASTDAYS = -10 /* ΤΑ 10 ΤΕΛΕΥΤΑΙΑ BACKUP FILES*/
SELECT @KeepLastDays = CAST(DATEADD(d, @LASTDAYS, GETDATE()) AS VARCHAR)

DECLARE @PathName VARCHAR(90);
SET @PathName = N'E:\PYLON_BACKUP\';

EXECUTE master.dbo.xp_delete_file 0, @PathName ,N'bak', @KeepLastDays,1



/* wiki master.dbo.xp_delete_file
File Type = 0 for backup files or 1 for report files.
Folder Path = The folder to delete files. The path must end with a backslash "".
File Extension = This could be 'BAK' or 'TRN' or whatever you normally use.
Date = The cutoff date for what files need to be deleted.
Subfolder = 0 to ignore subfolders, 1 to delete files in subfolders. */