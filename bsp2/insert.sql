

-- users
insert into dbo.user (name, passwort, mail)
select 'jg', 'jg', 'jg@com';

insert into dbo.user (name, passwort, mail)
with recursive body as (
select 1 as id, cast(name || 0 as varchar(64)) as name, passwort, mail from dbo.user
union all
select id + 1, cast(name || id as varchar(64)), passwort, mail from body where id < 10)
select name, passwort, mail from body;

-- devs
insert into dbo.developer(name, beschreibung)
select 'jg', 'jg';

insert into dbo.developer (name, beschreibung)
with recursive body as (
select 1 as id, cast(name || 0 as varchar(64)) as name,beschreibung from dbo.developer
union all
select id + 1, cast(name || id as varchar(64)), beschreibung from body where id < 5)
select name, beschreibung from body;

-- app

begin transaction;

insert into dbo.application (name, beschreibung, preis, recommended_version_vnr)
select 'app', 'app', 1, 1;

insert into dbo.application (name, beschreibung, preis, recommended_version_vnr)
with recursive body as (
select 1 as id, cast(name || 0 as varchar(64)) as name, beschreibung, preis, recommended_version_vnr from dbo.application
union all
select id + 1, cast(name || id as varchar(64)), beschreibung, preis, recommended_version_vnr from body where id < 10)
select name, beschreibung, preis, recommended_version_vnr from body;

-- version

insert into dbo.version (application_name, vnr)
select 'app', 1 union
select 'app0', 1 union
select 'app01', 1 union
select 'app012', 1 union
select 'app0123', 1 union
select 'app01234', 1 union
select 'app012345', 1 union
select 'app0123456', 1 union
select 'app01234567', 1 union
select 'app012345678', 1 union
select 'app0123456789', 1;

commit transaction;

-- platform 

insert into dbo.platform (name, vnr)
select 'linux', 1;

insert into dbo.platform (name, vnr)
with recursive body as (
select 1 as id, cast(name || 0 as varchar(64)) as name, vnr from dbo.platform
union all
select id + 1, cast(name || id as varchar(64)), vnr from body where id < 5)
select name, vnr from body;

-- review

insert into dbo.review (user_name, application_name, version_vnr, punkte, kommentar)
select 'jg', 'app0', 1, 5, 'kein kommentar' union
select 'jg', 'app0', 1, 5, 'kein kommentar' union
select 'jg', 'app0', 1, 5, 'kein kommentar';

-- advert

insert into dbo.advert (titel, text, developer_name)
select 'title', 'text', 'jg0' union
select 'title', 'text', 'jg01' union
select 'title', 'text', 'jg012';

-- {sub,}category

insert into dbo.category (name, beschreibung)
select 'category 1', 'cat' union select 'category 2', 'cat' union select 'category 3', 'cat' union select 'category 4', 'cat';

insert into dbo.category (name, beschreibung)
select 'subcategory 1', 'subcat' union select 'subcategory 2', 'subcat' union
select 'subcategory 3', 'subcat' union select 'subcategory 4', 'subcat';

-- relations

insert into dbo.ad_application (advert_id, application_name)
select 100,'app' union select 110,'app' union select 120,'app';

insert into dbo.ad_interested (developer_name, advert_id)
select 'jg', 100 union select 'jg', 100 union select 'jg', 110;

insert into dbo.ad_platform (advert_id, platform_name, platform_vnr)
select 100, 'linux', 1 union select 110, 'linux', 1 union select 100, 'linux', 1;

insert into dbo.app_author (application_name, developer_name)
select 'app0', 'jg' union select 'app01', 'jg' union select 'app012', 'jg';

insert into dbo.app_category (application_name, category_name)
select 'app0', 'category 1' union select 'app01', 'category 1' union select 'app012', 'category 1';

insert into dbo.category_relations (parent_name, child_name)
select 'category 1', 'subcategory 3' union select 'category 1', 'subcategory 2' union select 'category 2', 'subcategory 3';

insert into dbo.downloads (datum, user_name, platform_name, platform_vnr, application_name, version_vnr)
select current_timestamp, 'jg', 'linux', 1, 'app0', 1 union
select current_timestamp, 'jg', 'linux', 1, 'app01', 1 union
select current_timestamp, 'jg', 'linux', 1, 'app012', 1;

insert into dbo.purchases (datum, user_name, application_name)
select current_timestamp, 'jg', 'app0' union select current_timestamp, 'jg', 'app01' union select current_timestamp, 'jg', 'app012';

insert into dbo.version_platform (application_name, version_vnr, platform_name, platform_vnr)
select 'app0', 1, 'linux', 1 union select 'app01', 1, 'linux', 1 union select 'app012', 1, 'linux', 1;