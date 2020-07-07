-- Add fuzzy bois
exec SP_AddGuild '592047298880602112';

select * from Guild;

-- Add sparku
exec SP_AddUser '109886053590028288';

select * from GuildUser;


-- Add sparku to fuzzy bois
exec SP_AddUserToGuild '109886053590028288', '592047298880602112';

select * from GuildUserConnector;
select * from GuildUserConnector where GuildID = '592047298880602112';

-- Log sparku's command
exec SP_Log_Command '592047298880602112', '109886053590028288', '~debug SetupMentionedUsers @Sparku';

select * from CommandLog;

-- Log a punishment Test: Fuzzybois, Sparku, Snuggle
exec SP_Log_Punishment '592047298880602112', '109886053590028288', '677210383005515789', 'kicked - Yes';

select * from PunishLog;

exec SP_IsUserInGuild '592047298880602112', '109886053590028288';
exec SP_IsUserInGuild '000000000000000000', '109886053590028288';


select * from GuildUser;
select * from Guild;
select * from GuildUserConnector;

select * from CommandLog;