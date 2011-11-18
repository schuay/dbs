import java.sql.SQLException;

public class AppStoreVerwaltung {
	
	/**
	 * Die Methode dbConnect() soll eine JDBC-Verbindung zur
	 * Datenbank herstellen und AUTOCOMMIT ausschalten.
	 */
	public void dbConnect() throws SQLException {
		//TODO
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
	public void druckeAnwendungen() {
		//TODO
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
	public void erhoehePreise() {
		//TODO
	}
	
	/**
	 * Methode "entferneDownloads()", die alle Einträge in der Tabelle
	 * "Downloads" entfernt, die mindestens ein Jahr alt sind. Die Methode soll
	 * auf der Konsole ausgeben, wieviele Datensätze gelöscht wurden.
	 */
	public void entferneDownloads() {
		//TODO
	}
	
	/**
	 * Methode "dbDisconnect()", die die bestehende JDBC-Verbindung wieder schließt.
	 */
	public void dbDisconnect() {
		//TODO
	}
	
	/**
	 * Überlegen Sie sich eine sinnvolle Testabdeckung der Java-Klasse
	 * "AppStoreVerwaltung". Legen Sie dazu eine weitere Methode
	 * "testAppStoreVerwaltung()" an, die die anderen Methoden aufruft und
	 * entsprechende Ausgaben erzeugt, so dass sich die erfolgreiche
	 * Durchführung der Tests überprüfen lässt. Sie müssen in der Lage sein,
	 * diese Tests im Rahmen des Abgabegesprächs ablaufen zu lassen.
	 */
	public void testAppStoreVerwaltung() {
		//TODO
	}
	
	public static void main(String[] args) {
		try {
			AppStoreVerwaltung ev = new AppStoreVerwaltung();
			ev.dbConnect();
			ev.testAppStoreVerwaltung();
			ev.dbDisconnect();
		} catch (SQLException e) {
			while (e != null) {
				System.err.println("Code: " + e.getErrorCode());
				System.err.println("Message: " + e.getMessage());
				System.err.println("State: " + e.getSQLState());
				e = e.getNextException();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

/* vim: set noet ts=4 sw=4: */
