drop table dbo.downloads;
drop table dbo.review;
drop table dbo.purchases;
drop table dbo.version_platform;
drop table dbo.app_author;
drop table dbo.app_category;
drop table dbo.category_relations;
drop table dbo.category;
drop table dbo.ad_interested;
drop table dbo.ad_application;
drop table dbo.ad_platform;
drop table dbo.platform;
drop table dbo.advert;
drop table dbo.developer;
drop table dbo.user;

alter table dbo.version drop constraint version_application_name_fkey;

drop table dbo.application;
drop table dbo.version;

drop sequence dbo.advert_id_seq;

drop schema dbo;

