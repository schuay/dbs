import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.Statement;

import org.postgresql.ds.PGSimpleDataSource;
import org.postgresql.Driver;

public class AppStoreVerwaltung {

	private final static String schema = "public";
	
	private Connection conn = null;
	
	/**
	 * Die Methode dbConnect() soll eine JDBC-Verbindung zur
	 * Datenbank herstellen und AUTOCOMMIT ausschalten.
	 */
	public void dbConnect() throws SQLException {

		final String host = "localhost";
		final int port = 5432;
		final String user = "u0203440";
		final String databaseName = "u0203440";

		DriverManager.registerDriver(new Driver());
		PGSimpleDataSource ds = new PGSimpleDataSource();
		ds.setServerName(host);
		ds.setPortNumber(port);
		ds.setUser(user);
		ds.setDatabaseName(databaseName);

		conn = ds.getConnection();
		conn.setAutoCommit(false);

		debug("connected successfully");
	}
	
	/**
	 * Methode "druckeAnwendungen()", die ALLE Anwendungen (Name, Preis)
	 * sortiert nach dem Anwendungsnamen ausgibt zusammen mit dem erhöhten Preis
	 * und der Anzahl der Downloads aller Versionen der jeweiligen Anwendung
	 * zusammengenommen. Verwenden Sie zum Ermitteln des erhöhten Preises die
	 * Funktion "f_erhoehter_preis" aus Punkt 7. Die Ausgabe soll als
	 * Comma-Separated List erfolgen, d. h.: eine Bildschirm-Zeile pro Zeile der
	 * Tabelle; die Spaltenwerte werden einfach nacheinander ausgegeben und
	 * mittels "," getrennt.
	 */
	public void druckeAnwendungen() throws SQLException {
		
		Statement stmt = null;
		ResultSet rs = null;
		
		final String query = String.format(
			"select a.name, a.preis, f_erhoehter_preis(a.name) as adjusted_price, " + 
			"	(select count(*) from %s.download b where b.anwendung = a.name) as downloads " +
			"from %s.anwendung a " +
			"order by a.name;", schema, schema);
		
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);
			
			while (rs.next()) {
				System.out.printf("%s, %f, %f, %d%n",
						rs.getString(1),
						rs.getBigDecimal(2),
						rs.getBigDecimal(3),
						rs.getInt(4));
			}
			
		} finally {
			if (rs != null) {
				rs.close();
			}
			if (stmt != null) {
				stmt.close();
			}
		}
	}
	
	/**
	 * Methode "erhoehePreise()", die exakt die Funktionalität der
	 * PL/pgSQL-Prozedur von Punkt 8 bereitstellt (aber nichts ausgibt).
	 * Beachten Sie bei der Erstellung dieser Methode folgende Punkte:
	 * 
	 * - Verwenden Sie in "erhoehePreise()" eine SELECT-Abfrage, um die zu
	 * verteuernden Anwendungen auszuwählen, über die iteriert werden soll.
	 * Verwenden Sie Prepared Statements.
	 * 
	 * - "erhoehePreise()" soll die Funktion "f_erhoehter_preis" aus Punkt 7
	 * verwenden. Ansonsten dürfen keine weiteren Benutzer-definierten
	 * Funktionen oder Prozeduren verwendet werden. Insbesonders darf nicht
	 * einfach die Prozedur aus Punkt 8 aufgerufen werden.
	 * 
	 * - Stellen Sie durch entsprechende Transaction Control Kommandos sicher,
	 * dass die Methode "erhoehePreise()" entweder die vorgesehene Änderung
	 * erfolgreich durchführt (und festschreibt) oder die Datenbank unverändert
	 * lässt.
	 * 
	 * - Vermeiden Sie in der Java-Methode die Verwendung von "*" in
	 * SELECT-Anweisungen. Listen Sie statt dessen in jeder SELECT Anweisung
	 * explizit die Spalten auf, die Sie auslesen (oder verändern) möchten, z.
	 * B.: In der Uni-DB würden Sie
	 * "SELECT MatrNr, Name, Semester FROM Studenten" statt
	 * "SELECT * FROM Studenten" schreiben. Und wenn das Semester in der
	 * Programmlogik keine Rolle spielt, würden Sie
	 * "SELECT MatrNr, Name FROM Studenten" schreiben.
	 */
	public void erhoehePreise() throws Exception {

		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		/* author count > 1, adjusted price != price */
		final String query = String.format(
			"select a.name, f_erhoehter_preis(a.name) " +
			"from %s.anwendung a " +
			"where (select count(*) from %s.autor b where b.anwendung = a.name) > 1 " +
			"	and f_erhoehter_preis(a.name) != preis;", schema, schema);

		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);

			final String s =
					String.format("update %s.anwendung set preis = ? where name = ?;", schema);
			pstmt = conn.prepareStatement(s);

			while (rs.next()) {
				pstmt.setBigDecimal(1, rs.getBigDecimal(2));
				pstmt.setString(2, rs.getString(1));
				pstmt.executeUpdate();
				debug(String.format("updated %s: %f", rs.getString(1), rs.getBigDecimal(2)));
			}

			conn.commit();
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
			}
			throw e;
		} finally {

			if (rs != null) {
				rs.close();
			}
			if (stmt != null) {
				stmt.close();
			}
			if (pstmt != null) {
				pstmt.close();
			}
		}
	}
	
	/**
	 * Methode "entferneDownloads()", die alle Einträge in der Tabelle
	 * "Downloads" entfernt, die mindestens ein Jahr alt sind. Die Methode soll
	 * auf der Konsole ausgeben, wieviele Datensätze gelöscht wurden.
	 */
	public void entferneDownloads() throws Exception {
		
		Statement stmt = null;
		
		final String query = String.format(
				"delete from %s.download where datum < current_timestamp - interval '1 year'",
				schema);
		
		try {
			stmt = conn.createStatement();
			final int rows = stmt.executeUpdate(query);
			
			System.out.printf("deleted %d rows%n", rows);
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
			}
			throw e;
		} finally {
			if (stmt != null) {
				stmt.close();
			}
		}
	}
	
	private void printState() throws Exception {
		Statement stmt = null;
		ResultSet rs = null;
		
		final String query = String.format(
				"select datum, benutzer, anwendung " +
				"from %s.download;", schema);
		
		try {
			stmt = conn.createStatement();
			rs = stmt.executeQuery(query);
			
			while (rs.next()) {
				System.out.printf("%tF, %s, %s%n",
						rs.getDate(1),
						rs.getString(2),
						rs.getString(3));
			}
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
			}
			throw e;
		} finally {
			if (rs != null) {
				rs.close();
			}
			if (stmt != null) {
				stmt.close();
			}
		}
		
	}
	
	/**
	 * Methode "dbDisconnect()", die die bestehende JDBC-Verbindung wieder schließt.
	 */
	public void dbDisconnect() {
		try {
			if (conn != null) {
				conn.close();
				conn = null;
				debug("connection closed");
			}
		} catch (Exception e) {
			debug(e.getMessage());
		}
	}
	
	/**
	 * Überlegen Sie sich eine sinnvolle Testabdeckung der Java-Klasse
	 * "AppStoreVerwaltung". Legen Sie dazu eine weitere Methode
	 * "testAppStoreVerwaltung()" an, die die anderen Methoden aufruft und
	 * entsprechende Ausgaben erzeugt, so dass sich die erfolgreiche
	 * Durchführung der Tests überprüfen lässt. Sie müssen in der Lage sein,
	 * diese Tests im Rahmen des Abgabegesprächs ablaufen zu lassen.
	 */
	public void testAppStoreVerwaltung() throws Exception {
		System.out.printf("%n------------%ninitial state%n------------%n%n");
		System.out.printf("download (datum, benutzer, anwendung)%n");
		printState();
		System.out.printf("%napplications (name, current price, adjusted price, dl count)%n");
		druckeAnwendungen();
		
		erhoehePreise();
		System.out.printf("%n------------%nafter erhoehePreise()%n------------%n%n");
		System.out.printf("download (datum, benutzer, anwendung)%n");
		printState();
		System.out.printf("%napplications (name, current price, adjusted price, dl count)%n");
		druckeAnwendungen();
		
		entferneDownloads();
		System.out.printf("%n------------%nafter entferneDownloads()%n------------%n%n");
		System.out.printf("download (datum, benutzer, anwendung)%n");
		printState();
		System.out.printf("%napplications (name, current price, adjusted price, dl count)%n");
		druckeAnwendungen();
	}
	
	public static void main(String[] args) {
		AppStoreVerwaltung ev = new AppStoreVerwaltung();
		try {
			ev.dbConnect();
			ev.testAppStoreVerwaltung();
		} catch (SQLException e) {
			while (e != null) {
				System.err.println("Code: " + e.getErrorCode());
				System.err.println("Message: " + e.getMessage());
				System.err.println("State: " + e.getSQLState());
				e = e.getNextException();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ev.dbDisconnect();
		}
	}

	private static void debug(String message) {
		System.err.println(message);
	}
}

/* vim: set noet ts=4 sw=4: */
