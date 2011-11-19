DROP SEQUENCE seq_inserat;
DROP SEQUENCE seq_download;
DROP SEQUENCE seq_bewertung;

DROP TABLE AnwendungInserat;
DROP TABLE interessiert;
DROP TABLE unterstuetzt;
DROP TABLE InseratPlattform;
DROP TABLE untergeordnet;
DROP TABLE eingeordnet;
DROP TABLE gekauft;
DROP TABLE Autor;
DROP TABLE Unterkategorie;
DROP TABLE Kategorie;
DROP TABLE Inserat;
DROP TABLE Download;
DROP TABLE Plattform;
DROP TABLE Bewertung;
ALTER TABLE Anwendung DROP CONSTRAINT empfohlen_fk;
DROP TABLE Version;
DROP TABLE Anwendung;
DROP TABLE Entwickler;
DROP TABLE Benutzer;

drop function download_check();
drop function f_anwendungen_verteuern();
drop function f_benutzer_loeschen();
drop function f_erhoehter_preis(app_name character varying);