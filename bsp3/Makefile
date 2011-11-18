JAVAC = javac
CFLAGS = -g -classpath ".:/usr/share/java/postgresql-jdbc/*"
JAVA = java
JFLAGS = -classpath ".:/usr/share/java/postgresql-jdbc/*"
SOURCES = AppStoreVerwaltung.java
CLASSES = $(SOURCES:.java=.class)
TARGET = AppStoreVerwaltung

all: $(TARGET)

$(TARGET): $(CLASSES)

%.class: %.java
	$(JAVAC) $(CFLAGS) $<

test: $(TARGET)
	$(JAVA) $(JFLAGS) $(TARGET)

clean:
	rm -f $(CLASSES)
