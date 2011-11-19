/* 10
Überlegen Sie sich eine sinnvolle Testabdeckung für die PL/pgSQL-Programmteile laut Punkt 6 - 9, z.B.: Erweiterung der Testdaten vom 2. Übungsbeispiel, Aufruf der zu testenden PL/pgSQL-Programmteile mit entsprechenden Ausgaben, so dass sich die erfolgreiche Durchführung der Tests überprüfen lässt. Stellen Sie in Ihrem Abgabe-Verzeichnis die SQL-Dateien mit den zusätzlichen INSERT-Befehlen und den "Testtreibern" in der Datei test.sql bereit. Sie müssen in der Lage sein, diese SQL-Dateien und PL/pgSQL-Dateien im Rahmen des Abgabegesprächs ablaufen zu lassen. 
 */

select * from download;
select * from anwendung; -- nicht gratis: Anwendung 2, 3, 4 */
select * from benutzer; 
select * from entwickler; 
select * from gekauft;	-- nicht gekauft: Benutzer 2 Anwendung 3
select * from plattform;
select * from unterstuetzt;

/* -- 6 -- */

/* exception: nicht berechtigt */
insert into public.download (datum, benutzer, plattform_name, plattform_vnr, anwendung, vnr)
values (current_timestamp, 'Benutzer 2', 'Plattform 1', 1, 'Anwendung 3', 1);

/* exception: nicht unterstuetzt */
insert into public.download (datum, benutzer, plattform_name, plattform_vnr, anwendung, vnr)
values (current_timestamp, 'Benutzer 2', 'Plattform 1', 1, 'Anwendung 5', 1);

/* anwendung gratis */
insert into public.download (datum, benutzer, plattform_name, plattform_vnr, anwendung, vnr)
values (current_timestamp, 'Benutzer 2', 'Plattform 1', 1, 'Anwendung 1', 1);

/* anwendung gekauft */
insert into public.download (datum, benutzer, plattform_name, plattform_vnr, anwendung, vnr)
values (current_timestamp, 'Benutzer 2', 'Plattform 2', 1, 'Anwendung 2', 1);

/* -- 7 -- */

/* abgedeckt: nicht bewertet (0%), [2-3[ (10%), 5 (30%) */
with pts as (
	select anwendung, avg(punkte) as punkte
	from public.bewertung
	group by anwendung)
select a.name, b.punkte, preis, f_erhoehter_preis(a.name),
	case preis when 0 then 0 else f_erhoehter_preis(a.name) / preis end
from public.anwendung a left outer join pts b on a.name = b.anwendung;

insert into public.bewertung (id, punkte, kommentar, rezensent, anwendung, vnr)
values (nextval('seq_bewertung'), 0, '', 'Benutzer 1', 'Anwendung 3', 1),
       (nextval('seq_bewertung'), 5, '', 'Benutzer 1', 'Anwendung 2', 1),
       (nextval('seq_bewertung'), 3, '', 'Benutzer 1', 'Anwendung 4', 1),
       (nextval('seq_bewertung'), 1, '', 'Benutzer 1', 'Anwendung 2', 1);
       
insert into public.bewertung (id, punkte, kommentar, rezensent, anwendung, vnr)
values (nextval('seq_bewertung'), 3, '', 'Benutzer 1', 'Anwendung 2', 1),
       (nextval('seq_bewertung'), 5, '', 'Benutzer 1', 'Anwendung 2', 1);
       
/* abgedeckt: [0, 1[ (0%), [4-5[ (20%), [3-4[ (15%) */
with pts as (
	select anwendung, avg(punkte) as punkte
	from public.bewertung
	group by anwendung)
select a.name, b.punkte, preis, public.f_erhoehter_preis(a.name),
	case preis when 0 then 0 else public.f_erhoehter_preis(a.name) / preis end
from public.anwendung a left outer join pts b on a.name = b.anwendung;

insert into public.bewertung (id, punkte, kommentar, rezensent, anwendung, vnr)
values (nextval('seq_bewertung'), 3, '', 'Benutzer 1', 'Anwendung 3', 1);

/* abgedeckt: [1, 2[ (5%) */
with pts as (
	select anwendung, avg(punkte) as punkte
	from public.bewertung
	group by anwendung)
select a.name, b.punkte, preis, public.f_erhoehter_preis(a.name),
	case preis when 0 then 0 else public.f_erhoehter_preis(a.name) / preis end
from public.anwendung a left outer join pts b on a.name = b.anwendung;

/* -- 8 -- */

insert into public.autor (entwickler, anwendung)
values ('Benutzer 1', 'Anwendung 2');

select name, preis from public.anwendung a
where (select count(*) from public.autor b where b.anwendung = a.name) > 1;

/* outputs
NOTICE:  Anwendung 2: 0.99 -> 1.1385
NOTICE:  Anwendung 4: 1.00 -> 1.2000 */
select public.f_anwendungen_verteuern();

/* -- 9 -- */

select a.name
from public.benutzer a
where (select count(*) from public.gekauft b where b.benutzer = a.name) = 0
	and current_timestamp - interval '1 year' > (select coalesce(max(c.datum), '1900-01-01') from public.download c where c.benutzer = a.name)
	and a.name not in (select name from public.entwickler);

/* none are deleted: 1, 2, 5 are devs, 3 bought and dled something, 4 bought something */
select public.f_benutzer_loeschen();

/* make sure f_benutzer_loeschen deletes (only) benutzer 4 */
delete from public.gekauft where benutzer = 'Benutzer 4';
delete from public.gekauft where benutzer = 'Benutzer 3';

/* remove benutzer 5 as entwickler and remove his purchases;
   he has a download but it's older than 1 year */
delete from public.interessiert where entwickler = 'Benutzer 5';
delete from public.entwickler where name = 'Benutzer 5';
delete from public.gekauft where benutzer = 'Benutzer 5';

/* 4 and 5 are deleted: 1, 2, 5 are devs, 3 downloaded something less than 1 year ago */
select public.f_benutzer_loeschen();

/* vim: set noet ts=4 sw=4: */
