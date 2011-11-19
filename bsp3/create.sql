CREATE TABLE Benutzer (
	name VARCHAR(50) PRIMARY KEY,
	passwort VARCHAR(50) NOT NULL,
	mail VARCHAR(50) NOT NULL
);

CREATE TABLE Entwickler (
	name VARCHAR(50) PRIMARY KEY REFERENCES Benutzer (name),
	beschreibung VARCHAR(100) NOT NULL
);

CREATE TABLE Anwendung (
	name VARCHAR(50) PRIMARY KEY,
	preis NUMERIC(5,2) NOT NULL,
	beschreibung VARCHAR(100) NOT NULL,
	empfohlen INTEGER NOT NULL
);

CREATE TABLE Version (
	anwendung VARCHAR(50) REFERENCES Anwendung (name) DEFERRABLE INITIALLY DEFERRED,
	vnr INTEGER,
	PRIMARY KEY (anwendung, vnr)
);

ALTER TABLE Anwendung ADD CONSTRAINT empfohlen_fk FOREIGN KEY (name, empfohlen) REFERENCES Version (anwendung, vnr) DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE Bewertung (
	id INTEGER PRIMARY KEY,
	punkte INTEGER NOT NULL CHECK (punkte BETWEEN 0 AND 5),
	kommentar VARCHAR(100) NOT NULL,
	rezensent VARCHAR(50) NOT NULL REFERENCES Benutzer (name),
	anwendung VARCHAR(50) NOT NULL,
	vnr INTEGER NOT NULL,
	FOREIGN KEY (anwendung, vnr) REFERENCES Version (anwendung, vnr)
);

CREATE TABLE Plattform (
	name VARCHAR(50),
	vnr INTEGER,
	PRIMARY KEY (name, vnr)
);

CREATE TABLE Download (
	id INTEGER,
	datum TIMESTAMP NOT NULL,
	benutzer VARCHAR(50) REFERENCES Benutzer (name) NOT NULL,
	plattform_name VARCHAR (50) NOT NULL,
	plattform_vnr INTEGER NOT NULL,
	anwendung VARCHAR(50) NOT NULL,
	vnr INTEGER NOT NULL,
	FOREIGN KEY (plattform_name, plattform_vnr) REFERENCES Plattform (name, vnr),
	FOREIGN KEY (anwendung, vnr) REFERENCES Version (anwendung, vnr)
);

CREATE TABLE Inserat (
	id INTEGER PRIMARY KEY,
	titel VARCHAR(100) NOT NULL,
	text VARCHAR(100) NOT NULL,
	autor VARCHAR(50) NOT NULL REFERENCES Entwickler (name)
);

CREATE TABLE Kategorie (
	name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Unterkategorie (
	name VARCHAR(50) PRIMARY KEY REFERENCES Kategorie (name),
	beschreibung VARCHAR(100) NOT NULL
);

CREATE TABLE Autor (
	entwickler VARCHAR(50) REFERENCES Entwickler (name),
	anwendung VARCHAR(50) REFERENCES Anwendung (name),
	PRIMARY KEY (entwickler, anwendung)
);

CREATE TABLE gekauft (
	benutzer VARCHAR(50) REFERENCES Benutzer (name),
	anwendung VARCHAR(50) REFERENCES Anwendung (name),
	datum TIMESTAMP NOT NULL,
	PRIMARY KEY (benutzer, anwendung)
);

CREATE TABLE eingeordnet (
	anwendung VARCHAR(50) REFERENCES Anwendung (name),
	kategorie VARCHAR(50) REFERENCES Kategorie (name),
	PRIMARY KEY (anwendung, kategorie)
);

CREATE TABLE untergeordnet (
	kategorie VARCHAR(50) REFERENCES Kategorie (name),
	unterkategorie VARCHAR(50) REFERENCES Unterkategorie (name),
	PRIMARY KEY (kategorie, unterkategorie)
);

CREATE TABLE InseratPlattform (
	inserat INTEGER REFERENCES Inserat (id),
	plattform_name VARCHAR(50),
	plattform_vnr INTEGER,
	FOREIGN KEY (plattform_name, plattform_vnr) REFERENCES Plattform (name, vnr),
	PRIMARY KEY (inserat, plattform_name, plattform_vnr)
);

CREATE TABLE unterstuetzt (
	anwendung VARCHAR(50),
	vnr INTEGER,
	plattform_name VARCHAR(50),
	plattform_vnr INTEGER,
	FOREIGN KEY (anwendung, vnr) REFERENCES Version (anwendung, vnr),
	FOREIGN KEY (plattform_name, plattform_vnr) REFERENCES Plattform (name, vnr),
	PRIMARY KEY (anwendung, vnr, plattform_name, plattform_vnr)
);

CREATE TABLE interessiert (
	entwickler VARCHAR(50) REFERENCES Entwickler (name),
	inserat INTEGER REFERENCES Inserat (id),
	PRIMARY KEY (entwickler, inserat)
);

CREATE TABLE AnwendungInserat (
	inserat INTEGER REFERENCES Inserat (id),
	anwendung VARCHAR(50) REFERENCES Anwendung (name),
	PRIMARY KEY (inserat, anwendung)
);

CREATE SEQUENCE seq_bewertung;
CREATE SEQUENCE seq_download;
CREATE SEQUENCE seq_inserat INCREMENT BY 10 MINVALUE 100 NO MAXVALUE NO CYCLE;
