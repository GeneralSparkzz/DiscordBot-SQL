drop table GuildUserConnector;
drop table CommandLog;
drop table GuildUser;
drop table Bans;
drop table JoinLogs;
drop table Guild;

go

-- Info about a guild
create table Guild(
	GuildID varchar(20) primary key,
	GuildName varchar(200)
)

-- Info about a user all guilds can access
create table GuildUser(
	UserID varchar(20) primary key,
	Username varchar(200)
)

-- Stores info of a user and a specific guild, allows many to many
create table GuildUserConnector(
	UserConnectorID int primary key identity,
	GuildID varchar(20),
	UserID varchar(20)
)

-- Logs all user commands - Can be purged on date
create table CommandLog(
	CommandID int primary key identity,
	GuildID varchar(20),
	UserID varchar(20),
	Command varchar(100),
	LogDate date
)

create table Bans(
	ID int primary key identity,
	GuildID varchar(20),
	BannedID varchar(20),
	BannedName varchar(200),
	BannedReason varchar(200)
)

create table JoinLogs(
	ID int primary key identity,
	GuildID varchar(20),
	UserID varchar(20),
	Status varchar(10)
)

go

alter table GuildUserConnector add constraint FK_GuildUserConnector_Guild foreign key (GuildID) references Guild(GuildID);
alter table GuildUserConnector add constraint FK_GuildUserConnector_GuildUser foreign key (UserID) references GuildUser(UserID);

alter table CommandLog add constraint FK_CommandLog_Guild foreign key(GuildID) references Guild(GuildID);

alter table Bans add constraint FK_Bans_Guild foreign key (GuildID) references Guild(GuildID);

alter table JoinLogs add constraint FK_JoinLogs foreign key(GuildID) references Guild(GuildID);
go

select * from GuildUser;
select * from Bans;
select * from Guild;

select * from GuildUserConnector where UserID = '232625208958255105';

select count(GuildID) from Guild;
select count(UserID) from GuildUser;

select count(B.BannedID) as BannedCount from Bans B join Guild G on B.GuildID = G.GuildID where G.GuildID = '592047298880602112';
select count(GU.UserID) as UserCount from GuildUser GU join GuildUserConnector GUC on GU.UserID = GUC.UserID where GUC.GuildID = '592047298880602112';
select count(GU.UserID) as UserCount from GuildUser GU join GuildUserConnector GUC on GU.UserID = GUC.UserID where GUC.GuildID = '635550305420836906';
