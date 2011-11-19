--------------
-- Benutzer --
--------------
INSERT INTO Benutzer (name, passwort, mail) VALUES
	('Benutzer 1', 'abc', 'b1@example.org'),
	('Benutzer 2', 'def', 'b2@example.com'),
	('Benutzer 3', 'ghi', 'b3@example.com'),
	('Benutzer 4', 'jkl', 'b4@example.com'),
	('Benutzer 5', 'mno', 'b5@example.com');

-- Benutzer 1, 2 und 5 sind Entwickler
INSERT INTO Entwickler (name, beschreibung) VALUES
	('Benutzer 1', 'Ganz toller Entwickler'),
	('Benutzer 2', 'DBS-Profi'),
	('Benutzer 5', 'Inaktiver Benutzer');

-----------------
-- Anwendungen --
-----------------
BEGIN;

-- Anwendung 1 ist gratis, 2, 3 und 4 kostenpflichtig.
INSERT INTO Anwendung (name, preis, beschreibung, empfohlen) VALUES
	('Anwendung 1', 0, 'Beschreibung Anwendung 1', 1),
	('Anwendung 2', 0.99, 'Beschreibung Anwendung 2', 1),
	('Anwendung 3', 10, 'Beschreibung Anwendung 3', 1),
	('Anwendung 4', 1, 'Beschreibung Anwendung 4', 1);

-- Anwendung 1 hat zwei Versionen, 2, 3 und 4 nur eine.
INSERT INTO Version (anwendung, vnr) VALUES
	('Anwendung 1', 1),
	('Anwendung 1', 2),
	('Anwendung 2', 1),
	('Anwendung 3', 1),
	('Anwendung 4', 1);

COMMIT;

-- Autoren von Anwendung 1: Benutzer 1, 2
-- Autoren von Anwendung 2: Benutzer 2
-- Autoren von Anwendung 3: Benutzer 1
-- Autoren von Anwendung 4: Benutzer 1, 2
INSERT INTO Autor (entwickler, anwendung) VALUES
	('Benutzer 1', 'Anwendung 1'),
	('Benutzer 2', 'Anwendung 1'),
	('Benutzer 2', 'Anwendung 2'),
	('Benutzer 1', 'Anwendung 3'),
	('Benutzer 1', 'Anwendung 4'),
	('Benutzer 2', 'Anwendung 4');

------------------
-- Bewertungen --
-----------------
-- Anwendung 1 Version 1 hat eine Bewertung (4) von Benutzer 1.
-- Anwendung 1 Version 2 hat eine Bewertung (5) von Benutzer 1.
-- Anwendung 2 hat zwei Bewertungen (Durchschnitt 2.5) von Benutzer 1 (0) und Benutzer 5 (5).
-- Anwendung 3 hat keine Bewertungen.
-- Anwendung 4 hat eine Bewertung (5) von Benutzer 2.
-- Benutzer 1 hat drei Anwendungen bewertet (durchschnittlich mit 3).
-- Benutzer 2 hat eine Anwendung bewertet (durchschnittlich mit 5).
-- Benutzer 2, 3 und 4 haben nichts bewertet.
INSERT INTO Bewertung (id, punkte, kommentar, rezensent, anwendung, vnr) VALUES
	(nextval('seq_bewertung'), 4, 'Gut', 'Benutzer 1', 'Anwendung 1', 1),
	(nextval('seq_bewertung'), 5, 'Super', 'Benutzer 1', 'Anwendung 1', 2),
	(nextval('seq_bewertung'), 0, 'Unbrauchbar', 'Benutzer 1', 'Anwendung 2', 1),
	(nextval('seq_bewertung'), 5, 'Toll', 'Benutzer 2', 'Anwendung 4', 1),
	(nextval('seq_bewertung'), 5, 'Wunderbar', 'Benutzer 5', 'Anwendung 2', 1);

-----------------
-- Plattformen --
-----------------
-- Plattform 1 hat zwei Versionen, 2 hat nur eine.
INSERT INTO Plattform (name, vnr) VALUES
	('Plattform 1', 1),
	('Plattform 1', 2),
	('Plattform 2', 1);

-- Anwendung 1 Version 1 unterstützt: Plattform 1 Version 1
-- Anwendung 1 Version 2 unterstützt: Plattform 1 Version 1, Plattform 1 Version 2
-- Anwendung 2 unterstützt: Plattform 2 Version 1
-- Anwendung 3 und 4 unterstützt: Plattform 1 Version 1
INSERT INTO unterstuetzt (anwendung, vnr, plattform_name, plattform_vnr) VALUES
	('Anwendung 1', 1, 'Plattform 1', 1),
	('Anwendung 1', 2, 'Plattform 1', 1),
	('Anwendung 1', 2, 'Plattform 1', 2),
	('Anwendung 2', 1, 'Plattform 2', 1),
	('Anwendung 3', 1, 'Plattform 1', 1),
	('Anwendung 4', 1, 'Plattform 1', 1);

-----------
-- Käufe --
-----------
-- Benutzer 2, 3 und 4 haben Anwendung 2 gekauft (2011-09-01).
-- Niemand hat Anwendung 3 gekauft.
-- Benutzer 5 hat Anwendung 4 gekauft.
INSERT INTO gekauft (benutzer, anwendung, datum) VALUES
	('Benutzer 2', 'Anwendung 2', '2011-09-01'),
	('Benutzer 3', 'Anwendung 2', '2011-09-01'),
	('Benutzer 4', 'Anwendung 2', '2011-09-01'),
	('Benutzer 5', 'Anwendung 4', '1900-01-01');

---------------
-- Downloads --
---------------
-- Alle Downloads sind von 2011-09-02
-- Anwendung 1 Version 1 wurde von Benutzer 1 und 2 heruntergeladen für Plattform 1 Version 1.
-- Anwendung 1 Version 2 wurde von Benutzer 1 und 3 heruntergeladen für Plattform 1 Version 1.
-- Anwendung 2 wurde von Benutzer 2 heruntergeladen für Plattform 2
-- Anwendung 4 wurde von Benutzer 5 heruntergeladen für Plattform 1 vor langer Zeit.
INSERT INTO Download (id, datum, benutzer, plattform_name, plattform_vnr, anwendung, vnr) VALUES
	(nextval('seq_download'), '2011-09-02', 'Benutzer 1', 'Plattform 1', 1, 'Anwendung 1', 1),
	(nextval('seq_download'), '2011-09-02', 'Benutzer 2', 'Plattform 1', 1, 'Anwendung 1', 1),
	(nextval('seq_download'), '2011-09-02', 'Benutzer 1', 'Plattform 1', 1, 'Anwendung 1', 2),
	(nextval('seq_download'), '2011-09-02', 'Benutzer 3', 'Plattform 1', 1, 'Anwendung 1', 2),
	(nextval('seq_download'), '2011-09-02', 'Benutzer 2', 'Plattform 2', 1, 'Anwendung 2', 1),
	(nextval('seq_download'), '2000-01-01', 'Benutzer 5', 'Plattform 1', 1, 'Anwendung 4', 1);

--------------
-- Inserate --
--------------
-- Benutzer 1 hat drei Inserate aufgegeben.
-- Benutzer 2 hat ein Inserat aufgegeben.
INSERT INTO Inserat (id, titel, text, autor) VALUES
	(nextval('seq_inserat'), 'Programmierer gesucht', 'Suche erfahrenen Programmierung für diverse Projekte', 'Benutzer 1'),
	(nextval('seq_inserat'), 'Tester gesucht', 'Suche Tester für meine Anwendung', 'Benutzer 1'),
	(nextval('seq_inserat'), 'DBS-Experte gesucht', 'Suche DBS-Profi...', 'Benutzer 1'),
	(nextval('seq_inserat'), 'Benutzer gesucht', 'Meine Anwendung will keiner haben. Hilfe!', 'Benutzer 2');

-- Inserate 100, 110 und 120 sind für Plattform 1 Version 2
INSERT INTO InseratPlattform (inserat, plattform_name, plattform_vnr) VALUES
	(100, 'Plattform 1', 2),
	(110, 'Plattform 1', 2),
	(120, 'Plattform 1', 2);

-- Benutzer 2 ist an Inserat 100 interessiert.
-- Benutzer 5 ist an Inserat 110 und 120 interessiert.
INSERT INTO interessiert (entwickler, inserat) VALUES
	('Benutzer 2', 100),
	('Benutzer 5', 110),
	('Benutzer 5', 120);

-- Inserate 110 und 120 gehören zu Anwendung 1.
-- Inserat 130 gehört zu Anwendung 3.
INSERT INTO AnwendungInserat (inserat, anwendung) VALUES
	(110, 'Anwendung 1'),
	(120, 'Anwendung 1'),
	(130, 'Anwendung 3');

----------------
-- Kategorien --
----------------
-- Bildung   Spiele
--    \      /    \
--   Lernspiele   Geschicklichkeitsspiele
--       |
--   Quizspiele
INSERT INTO Kategorie (name) VALUES
	('Spiele'),
	('Bildung'),
	('Geschicklichkeitsspiele'),
	('Lernspiele'),
	('Quizspiele');

INSERT INTO Unterkategorie (name, beschreibung) VALUES
	('Geschicklichkeitsspiele', 'Spiele, die präzise Bedienung erfordern'),
	('Lernspiele', 'Spiele als Ergänzung des Unterrichts'),
	('Quizspiele', 'Spiele, die Allgemeinwissen vermitteln');

INSERT INTO untergeordnet (kategorie, unterkategorie) VALUES
	('Spiele', 'Geschicklichkeitsspiele'),
	('Spiele', 'Lernspiele'),
	('Bildung', 'Lernspiele'),
	('Lernspiele', 'Quizspiele');

-- Anwendung 1 ist eingeordnet als Quizspiel.
-- Anwendung 2 ist eingeordnet als Lernspiel und als Geschicklichkeitsspiel.
INSERT INTO eingeordnet (anwendung, kategorie) VALUES
	('Anwendung 1', 'Quizspiele'),
	('Anwendung 2', 'Lernspiele'),
	('Anwendung 2', 'Geschicklichkeitsspiele');
