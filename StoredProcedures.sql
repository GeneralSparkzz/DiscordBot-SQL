drop procedure SP_AddUser;
drop procedure SP_AddGuild;
drop procedure SP_AddUserToGuild;
drop procedure SP_Log_Command;
drop procedure SP_IsUserInGuild;
drop procedure SP_DoesGuildExist;
drop procedure SP_Log_Ban;
drop procedure SP_FetchBans;
drop procedure SP_RemoveUserFromGuild;

go

create procedure SP_AddUser
	@UserID varchar(20),
	@Username varchar(200)
as
	declare @ResultCount smallint;

	select @ResultCount = count(*) from GuildUser where UserID = @UserID;
	if(@ResultCount = 0)
	begin
		insert into GuildUser(UserID, Username) values (@UserID, @Username);
	end
go

create procedure SP_AddGuild
	@GuildID varchar(20),
	@GuildName varchar(200)
as
	declare @ResultCount smallint;

	select @ResultCount = count(*) from Guild where GuildID = @GuildID;
	if(@ResultCount = 0)
	begin
		insert into Guild(GuildID, GuildName) values (@GuildID, @GuildName);
	end
go

create procedure SP_AddUserToGuild
	@UserID varchar(20),
	@GuildID varchar(20)
as
	declare @ResultCount smallint;
	select @ResultCount = count(UserConnectorID) from GuildUserConnector where UserID = @UserID and GuildID = @GuildID;
	if(@ResultCount = 0)
	begin
		insert into GuildUserConnector(GuildID, UserID) values (@GuildID, @UserID);
	end
go

create procedure SP_Log_Command
	@GuildID varchar(20),
	@UserID varchar(20),
	@Command varchar(100)
as
	insert into CommandLog values (@GuildID, @UserID, @Command, GETDATE());
go

create procedure SP_Log_Ban
	@GuildID varchar(20),
	@PunishedID varchar(20),
	@PunishedName varchar(200),
	@Reason varchar(200)
as
	declare @ResultCount smallint;
	select @ResultCount = Count(ID) from Bans where GuildID = @GuildID and BannedID = @PunishedID;
	if(@ResultCount = 0)
	begin
		insert into Bans(GuildID, BannedID, BannedName, BannedReason) values(@GuildID, @PunishedID, @PunishedName, @Reason);
	end
go

create procedure SP_IsUserInGuild
	@GuildID varchar(20),
	@UserID varchar(20)
as
	declare @ResultCount smallint;
	select count(*) from GuildUserConnector where UserID = @UserID and GuildID = @GuildID;
	if(@ResultCount = 0)
		begin
		return 0;
		end
	else
		begin
		return 1
		end
go

create procedure SP_DoesGuildExist
	@GuildID varchar(20)
as
	declare @ResultCount smallint;
	select @ResultCount = count(*) from Guild where GuildID = @GuildID;
	if(@ResultCount = 0)
		begin
		exec SP_AddGuild @GuildID;
		end
go

create procedure SP_FetchBans
	@GuildID varchar(20),
	@Count smallint,
	@Offset int
as
	select BannedName, BannedReason, BannedID from Bans where GuildID = @GuildID order by (select null) offset @Offset rows fetch next @Count rows only;
go

create procedure SP_FetchUsers
	@GuildID varchar(20),
	@Count smallint,
	@Offset int
as
	select GU.Username, GU.UserID from GuildUser GU join GuildUserConnector GUC on GU.UserID = GUC.UserID where GUC.GuildID = @GuildID order by (select null) offset @Offset rows fetch next @Count rows only;
go

create procedure SP_RemoveUserFromGuild
	@GuildID varchar(20),
	@UserID varchar(20)
as
	delete from GuildUserConnector where GuildID = @GuildID and UserID = @UserID;
go

select * from GuildUserConnector where GuildID = '592047298880602112';

delete from Bans where GuildID = '592047298880602112' and BannedID = '232625208958255105';

exec SP_FetchBans '592047298880602112', 10, 0;
exec SP_FetchUsers '592047298880602112', 10, 0;
exec SP_AddGuild '592047298880602112', 'Fuzzy Bois'