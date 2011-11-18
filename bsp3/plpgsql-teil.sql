/* 6
Schreiben Sie einen Trigger, der vor dem Eintragen in die Tabelle "Download" überprüft, ob der Download überhaupt stattfinden darf. Ein Download darf genau dann stattfinden, wenn die Anwendung gratis ist, oder wenn der Benutzer die Anwendung gekauft hat (und zwar vor dem Download). Das Eintragen soll außerdem fehlschlagen, wenn die Version der Plattform, für die die Anwendung heruntergeladen wird, gar nicht von der jeweiligen Version der Anwendung unterstützt wird. Im Fall eines Fehlschlags wegen eines nicht vorher erfolgten Kaufs soll die Exception "nicht berechtigt" geworfen werden; falls die Plattform nicht unterstützt wird, "nicht unterstuetzt".
 */

drop function download_check()

create function download_check() returns trigger as $download_check$
declare 
	app_price numeric; -- the price of the app
	purchased int; -- 1 if the app has been purchased by user, else 0
	supported int; -- 1 if selected app version supports selected platform, else 0
begin
	select into app_price preis
	from dbo.application
	where name = new.application_name;

	purchased := (
		select count(*)
		from dbo.purchases
		where user_name = new.user_name
			and application_name = new.application_name);

	supported := (
		select count(*)
		from dbo.version_platform
		where application_name = new.application_name
			and version_vnr = new.version_vnr
			and platform_name = new.platform_name
			and platform_vnr = new.platform_vnr);

	if app_price > 0 and purchased = 0 then
		raise exception 'nicht berechtigt';
	end if;

	if supported = 0 then
		raise exception 'nicht unterstuetzt';
	end if;
	
	return new;
end;
$download_check$ language plpgsql;

create trigger download_check before insert on dbo.downloads
	for each row execute procedure download_check();
 
/* 7
Schreiben Sie eine Prozedur f_erhoehter_preis mit einem Anwendungsnamen als Parameter, die den Preis der Anwendung

    um 30% erhöht zurückgibt, wenn die durchschnittliche Bewertung 5 beträgt,
    um 20% erhöht zurückgibt, wenn die durchschnittliche Bewertung mindestens 4 und unter 5 ist,
    um 15% erhöht zurückgibt, wenn die durchschnittliche Bewertung mindestens 3 und unter 4 ist,
    um 10% erhöht zurückgibt, wenn die durchschnittliche Bewertung mindestens 2 und unter 3 ist,
    um 5% erhöht zurückgibt, wenn die durchschnittliche Bewertung mindestens 1 und unter 2 ist, und
    ansonsten unverändert zurückgibt.

Wenn die Anwendung nicht bewertet wurde, soll ihr unveränderter Preis zurückgegeben werden.
 */

/* TODO change datatype musterloesung */
create or replace function f_erhoehter_preis(app_name varchar(64)) returns numeric as $f_erhoehter_preis$
declare
	adjusted_price numeric;
	current_price numeric;
	avg_rating integer;
begin
	if (select count(*) from dbo.application where name = app_name) = 0 then
		raise exception 'application % does not exist', app_name;
	end if;

	current_price := (
		select preis
		from dbo.application
		where name = app_name);

	avg_rating := (
		select cast(avg(punkte) as int)
		from dbo.review
		where application_name = app_name);

	adjusted_price := (
		case avg_rating
		when 0 then current_price
		when 1 then current_price * 1.05
		when 2 then current_price * 1.10
		when 3 then current_price * 1.15
		when 4 then current_price * 1.20
		when 5 then current_price * 1.30
		end);

	return adjusted_price;
end;
$f_erhoehter_preis$ language plpgsql;
 
/* 8
Schreiben Sie eine Prozedur f_anwendungen_verteuern, die für alle Anwendungen mit mehr als einem Autor den Preis auf das jeweilige Ergebnis der Funktion "f_erhoehter_preis" setzt und Anwendungsnamen, alten und neuen Preis als Hinweise ausgibt, wenn der neue Preis sich vom alten Preis unterscheidet. Andernfalls soll keine Änderung und keine Ausgabe für die jeweilige Anwendung erfolgen.
 */

create or replace function f_anwendungen_verteuern () returns void as $$
declare
	curs refcursor;
	rowvar record;
	current_price numeric;
	adjusted_price numeric;
begin
	open curs for select name, preis from dbo.application a
		where (select count(*) from dbo.app_author b where b.application_name = a.name) > 1;
	fetch curs into rowvar;
	while found loop
		current_price := rowvar.preis;
		adjusted_price := f_erhoehter_preis(rowvar.name);

		if current_price != adjusted_price then
			raise notice '%: % -> %', rowvar.name, current_price, adjusted_price;

			update dbo.application
			set preis = adjusted_price
			where name = rowvar.name;
		end if;

		fetch curs into rowvar;
	end loop;
	close curs;
end;
$$ language plpgsql;
 
/* 9
Schreiben Sie eine Funktion f_benutzer_loeschen, die alle Benutzer löscht, die nichts gekauft und seit mindestens einem Jahr nichts heruntergeladen haben. Es soll die Anzahl der gelöschten Benutzer zurückgegeben werden und für jeden gelöschten Benutzer ein Hinweis mit dem Benutzernamen ausgegeben werden.
 */

 
create or replace function f_benutzer_loeschen () returns integer as $$
declare
	curs refcursor;
	rowvar record;
	one_year_ago timestamp := current_timestamp - interval '1 year';
begin
	create temporary table temp_deletion_candidates (name varchar(64) not null);

	/* users without purchases, with no dloads younger than 1 year and who aren't devs */
	insert into temp_deletion_candidates(name)
	select a.name
	from dbo.users a
	where (select count(*) from dbo.purchases b where b.user_name = a.name) = 0
		and one_year_ago > (select max(c.datum) from dbo.downloads c where c.user_name = a.name)
		and a.name not in (select name from dbo.developers);

	open curs for select name from temp_deletion_candidates;
	fetch curs into rowvar;
	while found loop
		raise notice 'deleting user %', rowvar.name;
		fetch curs into rowvar;
	end loop;
	close curs;

	delete from dbo.reviews a where a.user_name in (select name from temp_deletion_candidates);
	delete from dbo.downloads a where a.user_name in (select name from temp_deletion_candidates);
	delete from dbo.user a where a.name in (select name from temp_deletion_candidates);
end;
$$ language plpgsql;

/* vim: set noet ts=4 sw=4: */
