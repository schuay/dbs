

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

select setval('dbo.application_id_seq', 1);
select setval('dbo.version_id_seq', 1);

insert into dbo.application (name, beschreibung, preis, recommended_version_id)
select 'app', 'app', 1, 2;

insert into dbo.application (name, beschreibung, preis, recommended_version_id)
with recursive body as (
select 1 as id, cast(name || 0 as varchar(64)) as name, beschreibung, preis, recommended_version_id from dbo.application
union all
select id + 1, cast(name || id as varchar(64)), beschreibung, preis, recommended_version_id from body where id < 10)
select name, beschreibung, preis, recommended_version_id from body;

-- version

insert into dbo.version (application_id, vnr)
select 2, 1;

insert into dbo.version (application_id, vnr)
with recursive body as (
select 3 as application_id, 1 as vnr from dbo.version
union all
select application_id + 1, vnr from body where application_id < 5)
select application_id, vnr from body;

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

insert into dbo.review (user_id, version_id, punkte, kommentar)
select 2, 2, 5, 'kein kommentar';

insert into dbo.review (user_id, version_id, punkte, kommentar)
with recursive body as (
select 3 as id, version_id, punkte, kommentar from dbo.review
union all
select id + 1, version_id, punkte, kommentar from body where id < 5)
select id, version_id, punkte, kommentar from body;

-- advert

insert into dbo.advert (titel, text, developer_id)
select 'title', 'text', 2;

insert into dbo.advert (titel, text, developer_id)
select 'title', 'text', 3;

insert into dbo.advert (titel, text, developer_id)
select 'title', 'text', 4;

-- {sub,}category

insert into dbo.category (name, beschreibung)
select 'category 1', 'cat' union select 'category 2', 'cat' union select 'category 3', 'cat' union select 'category 4', 'cat';

insert into dbo.category (name, beschreibung)
select 'subcategory 1', 'subcat' union select 'subcategory 2', 'subcat' union
select 'subcategory 3', 'subcat' union select 'subcategory 4', 'subcat';

-- relations

insert into dbo.ad_application (advert_id, application_id)
select 100,2 union select 110,3 union select 120,4;

insert into dbo.ad_interested (developer_id, advert_id)
select 2, 100 union select 3, 100 union select 2, 110;

insert into dbo.ad_platform (advert_id, platform_id)
select 100, 2 union select 110, 2 union select 100, 3;

insert into dbo.app_author (application_id, developer_id)
select 2, 3 union select 3, 4 union select 3, 5;

insert into dbo.app_category (application_id, category_id)
select 2, 2 union select 4, 2 union select 2, 3;

insert into dbo.category_relations (parent_id, child_id)
select 2, 6 union select 2, 7 union select 3, 6;

insert into dbo.downloads (datum, user_id, platform_id, version_id)
select current_timestamp, 2, 3, 4 union select current_timestamp, 3, 2, 4 union select current_timestamp, 2, 4, 3;

insert into dbo.purchases (user_id, application_id)
select 2, 2 union select 3, 4 union select 5, 5;

insert into dbo.version_platform (version_id, platform_id)
select 2, 2 union select 3, 3 union select 4, 4;