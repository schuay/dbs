create schema dbo;

create table dbo.user (
name varchar(64) not null primary key,
passwort varchar(64) not null,
mail varchar(64) not null);

create table dbo.developer (
name varchar(64) references dbo.user(name) not null primary key,
beschreibung varchar(128) not null);

create table dbo.application (
name varchar(64) not null primary key,
beschreibung varchar(128) not null,
preis numeric not null,
recommended_version_vnr int not null);

create table dbo.version (
application_name varchar(64) not null references dbo.application(name) deferrable initially deferred,
vnr int not null);
alter table dbo.version add primary key (application_name, vnr); 
alter table dbo.application add foreign key (name, recommended_version_vnr) 
	references dbo.version(application_name, vnr) deferrable initially deferred;

--PK
create table dbo.platform (
name varchar(64) not null,
vnr int not null);
alter table dbo.platform add primary key (name, vnr); 

create table dbo.category (
name varchar(64) not null primary key,
beschreibung varchar(128) not null);

create table dbo.category_relations (
id serial primary key,
parent_name varchar(64) not null references dbo.category(name),
child_name varchar(64) not null references dbo.category(name),
unique (parent_name, child_name));

create table dbo.review (
id serial primary key,
user_name varchar(64) not null references dbo.user(name),
application_name varchar(64) not null,
version_vnr int not null,
punkte int not null check (punkte between 0 and 5),
kommentar varchar(128) not null);
alter table dbo.review add unique (user_name, application_name, version_vnr);
alter table dbo.review add foreign key (application_name, version_vnr)
references dbo.version (application_name, vnr);

--sequence
create sequence dbo.advert_id_seq increment 10 start 100;
create table dbo.advert (
id int primary key DEFAULT nextval('dbo.advert_id_seq'),
titel varchar(64) not null,
text varchar(128) not null,
developer_name varchar(128) not null references dbo.developer(name));

--------------------------
-- relations
--------------------------

create table dbo.downloads (
id serial primary key,
datum timestamp not null,
user_name varchar(128) not null references dbo.user(name),
platform_name varchar(128) not null,
platform_vnr int not null,
application_name varchar(128) not null,
version_vnr int not null);
alter table dbo.downloads add foreign key (platform_name, platform_vnr)
references dbo.platform(name, vnr);
alter table dbo.downloads add foreign key (application_name, version_vnr)
references dbo.version(application_name, vnr);

create table dbo.purchases (
id serial primary key,
datum timestamp not null,
user_name varchar(128) not null references dbo.user(name),
application_name varchar(64) not null references dbo.application(name));
alter table dbo.purchases add unique(user_name, application_name);

create table dbo.version_platform (
id serial primary key,
application_name varchar(64) not null ,
version_vnr int not null,
platform_name varchar(128) not null,
platform_vnr int not null);
alter table dbo.version_platform add unique (application_name, version_vnr, platform_name, platform_vnr);
alter table dbo.version_platform add foreign key (application_name, version_vnr)
references dbo.version(application_name, vnr);
alter table dbo.version_platform add foreign key (platform_name, platform_vnr)
references dbo.platform(name, vnr);

create table dbo.app_author (
id serial primary key,
application_name varchar(64) not null references dbo.application(name),
developer_name varchar(128) not null references dbo.developer(name));
alter table dbo.app_author add unique (application_name, developer_name);

create table dbo.app_category (
id serial primary key,
application_name varchar(64) not null references dbo.application(name),
category_name varchar(64) not null references dbo.category(name),
unique (application_name, category_name));

create table dbo.ad_interested (
id serial primary key,
developer_name varchar(128) not null references dbo.developer(name),
advert_id int not null references dbo.advert(id));
alter table dbo.ad_interested add unique (developer_name, advert_id);

create table dbo.ad_application (
id serial primary key,
advert_id int not null references dbo.advert(id),
application_name varchar(64) not null references dbo.application(name));
alter table dbo.ad_application add unique (advert_id, application_name);

create table dbo.ad_platform (
id serial primary key,
advert_id int not null references dbo.advert(id),
platform_name varchar(128) not null,
platform_vnr int not null,
unique (advert_id, platform_name, platform_vnr));
alter table dbo.ad_platform add foreign key (platform_name, platform_vnr)
references dbo.platform(name, vnr);