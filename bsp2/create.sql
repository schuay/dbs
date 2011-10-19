create schema dbo;

create table dbo.user (
id serial primary key,
name varchar(64) not null unique,
passwort varchar(64) not null,
mail varchar(64) not null);

create table dbo.developer (
id serial primary key,
name varchar(64) references dbo.user(name) not null unique,
beschreibung varchar(128) not null);

create table dbo.application (
id serial primary key,
name varchar(64) not null unique,
beschreibung varchar(128) not null,
preis numeric not null,
recommended_version_id int not null);

create table dbo.version (
id serial primary key,
application_id int not null references dbo.application(id) deferrable initially deferred,
vnr int not null);
alter table dbo.version add unique (application_id, vnr); 
alter table dbo.application add foreign key (recommended_version_id) 
	references dbo.version(id) deferrable initially deferred;

--PK
create table dbo.platform (
id serial primary key,
name varchar(64) not null,
vnr int not null);
alter table dbo.platform add unique (name, vnr); 

create table dbo.category (
id serial primary key,
name varchar(64) not null unique,
beschreibung varchar(128) not null);

create table dbo.category_relations (
id serial primary key,
parent_id int not null references dbo.category(id),
child_id int not null references dbo.category(id),
unique (parent_id, child_id));

create table dbo.review (
id serial primary key,
user_id int not null references dbo.user(id),
version_id int not null references dbo.version(id),
punkte int not null check (punkte between 0 and 5),
kommentar varchar(128) not null);
alter table dbo.review add unique (user_id, version_id);

--sequence
create sequence dbo.advert_id_seq increment 10 start 100;
create table dbo.advert (
id int primary key DEFAULT nextval('dbo.advert_id_seq'),
titel varchar(64) not null,
text varchar(128) not null,
developer_id int not null references dbo.developer(id));

--------------------------
-- relations
--------------------------

create table dbo.downloads (
id serial primary key,
datum timestamp not null,
user_id int not null references dbo.user(id),
platform_id int not null references dbo.platform(id),
version_id int not null references dbo.version(id));

create table dbo.purchases (
id serial primary key,
datum timestamp not null,
user_id int not null references dbo.user(id),
application_id int not null references dbo.application(id));
alter table dbo.purchases add unique(user_id, application_id);

create table dbo.version_platform (
id serial primary key,
version_id int not null references dbo.version(id),
platform_id int not null references dbo.platform(id));
alter table dbo.version_platform add unique (version_id, platform_id);

create table dbo.app_author (
id serial primary key,
application_id int not null references dbo.application(id),
developer_id int not null references dbo.developer(id));
alter table dbo.app_author add unique (application_id, developer_id);

create table dbo.app_category (
id serial primary key,
application_id int not null references dbo.application(id),
category_id int not null references dbo.category(id),
unique (application_id, category_id));

create table dbo.ad_interested (
id serial primary key,
developer_id int not null references dbo.developer(id),
advert_id int not null references dbo.advert(id));
alter table dbo.ad_interested add unique (developer_id, advert_id);

create table dbo.ad_application (
id serial primary key,
advert_id int not null references dbo.advert(id),
application_id int not null references dbo.application(id));
alter table dbo.ad_application add unique (advert_id, application_id);

create table dbo.ad_platform (
id serial primary key,
advert_id int not null references dbo.advert(id),
platform_id int not null references dbo.platform(id),
unique (advert_id, platform_id));
