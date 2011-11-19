/* 1
Geben Sie die Namen ALLER Anwendungen aus, die jeweilige Gesamtanzahl der Downloads von allen Versionen der Anwendung zusammen genommen, sowie dem Umsatz durch die Käufe der jeweiligen Anwendung. Sortieren Sie die Ausgabe absteigend nach der Anzahl der Downloads. */

with downloads as (
	select anwendung, count(*) as downloads
	from public.download
	group by anwendung),
purchases as (
	select anwendung, count(*) as purchases
	from public.gekauft
	group by anwendung)
select a.name, coalesce(b.downloads, 0) as downloads, coalesce(c.purchases, 0) * a.preis as revenue
from public.anwendung a
	left outer join downloads b on a.name = b.anwendung
	left outer join purchases c on a.name = c.anwendung
order by 2 desc;

/* 2
Geben Sie die Namen jener Anwendungen aus, für die die Anzahl der Autoren mit einer auf ".com" endenden E-Mail-Adresse maximal ist. Geben Sie zugleich diese Anzahl aus. */

with counts as (
	select c.name, count(*) as com_authors
	from public.entwickler a
		inner join public.autor b on a.name = b.entwickler
		inner join public.anwendung c on b.anwendung = c.name
		inner join public.benutzer d on a.name = d.name
	where substring(d.mail from '.{4}$') = '.com'
	group by c.name)
select name, com_authors
from counts
where com_authors = (select max(com_authors) from counts);

/* 3
Geben Sie die Liste aller Anwendungsnamen aus, zusammen mit dem Namen irgendeines Autors der jeweiligen Anwendung. (Welcher gewählt wird, ist egal.) Jede Anwendung soll also genau einmal in der Liste aufscheinen.*/


select c.name, max(a.name) as author
from public.entwickler a
	right outer join public.autor b on a.name = b.entwickler
	right outer join public.anwendung c on b.anwendung = c.name
group by c.name;

/* 4
Wählen Sie per Hand eine Kategorie aus, die mindestens einer anderen Kategorie untergeordnet ist. Schreiben Sie eine Anfrage, die diese Kategorie ausgibt, sowie rekursiv alle übergeordneten Kategorien. Geben Sie für jede Kategorie den Namen und die Beschreibung aus. Wenn eine Kategorie keine Beschreibung besitzt, weil sie auf der obersten Ebene der Hierarchie liegt, geben Sie "keine Beschreibung" aus. (Beachten Sie, dass dazu möglicherweise Typumwandlungen notwendig sind.) Passen Sie die Tupel in Ihrer Datenbank so an, dass es zu der von Ihnen ausgewählten Kategorie mindestens zwei Ebenen übergeordneter Kategorien gibt. Achten Sie darauf, dass Ihre Daten keinen Zyklus enthalten und dass Ihre Anfrage allgemein formuliert ist (d. h. für beliebige Datenbankausprägungen funktioniert). */

with recursive cats as (
	select cast('Quizspiele' as text) as name
	union
	select a.kategorie
	from public.untergeordnet a inner join cats b on a.unterkategorie = b.name)
select a.name, coalesce(b.beschreibung, 'keine Beschreibung') as beschreibung
from cats a left outer join public.unterkategorie b on a.name = b.name;

/* 5
Schreiben Sie Befehle zum Erzeugen und Löschen einer View ("benutzer_statistik_view"), welche für JEDEN Benutzer ("name")

    die Anzahl der Anwendungen ausgibt, von denen er irgendwelche Versionen heruntergeladen hat, (Hinweis: Das Schlüsselwort für Duplikatelimination kann auch in Aggregatfunktionen verwendet werden.)
    die Anzahl der Anwendungen ausgibt, die er gekauft hat,
    sowie das Verhältnis von gekauften zu heruntergeladenen Anwendungen in Prozent (0 wenn nichts heruntergeladen wurde) als ganze Zahl ausgibt.

Sortieren Sie das Ergebnis nach der Anzahl der heruntergeladenen Anwendungen.  */

with downloads as (
	select a.name, count(distinct b.anwendung) as downloads
	from public.benutzer a
		left outer join public.download b on a.name = b.benutzer
	group by a.name),
purchases as (
	select a.name, count(distinct b.anwendung) as purchases
	from public.benutzer a
		left outer join public.gekauft b on a.name = b.benutzer
	group by a.name)
select a.name, a.downloads, b.purchases,
	case a.downloads when 0 then 0 else cast(b.purchases as numeric) / a.downloads end as ratio
from downloads a
	inner join purchases b on a.name = b.name
order by downloads;

/* vim: set noet ts=4 sw=4: */
