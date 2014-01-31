# tranzfiction-backend

**tranzfiction ist ein Travian-Klon, basierend auf Ruby on Rails im Backend und JavaScript im Frontend.**

*Das Spiel kann hier gespielt werden: http://tranzfiction.com. Das in diesem Repository enthaltene Backend läuft auf einem einfachen Heroku-Server und kann hier aufgerufen werden: http://api.tranzfiction.com.*

tranzfiction ist ein einfaches Browserspiel, das als Anwendungsbeispiel für eine datenbankorientierte Ruby-on-Rails-API dient. Es wird Gegenstand meiner Seminararbeit sein, die, sobald fertiggestellt, hier verlinkt werden wird.

Wer Travian gespielt hat, kann sich das grundlegende Modell vorstellen:
Es gibt Spieler (`User`). Diese besitzen Siedlungen/Städte (`City`). Diese wiederum enthalten Gebäude (`Building`) unterschiedlichster Art. Um Gebäude etc. zu bauen, werden Rohstoffe (`Resources`) benötigt, welche durch ein `ResourceBuilding` abgebaut werden. Außerdem ist `Energy` zum Betrieb von Gebäuden notwendig (Versorgung erfolgt durch das `EnergyBuilding`).

Als Punktemodell ist zunächst eine einfache Bepunktung vorgesehen, die auf Anzahl und Art der Gebäude und Rohstoffe basiert. (Falls zeitlich möglich, wären auch noch Gameplay-Elemente wie Handel oder Kampf denkbar.)

All diese Funktionen sind über das Backend zugänglich. So kann man ein neues Gebäude durch diesen einfachen Aufruf bauen (Authentifizierung vorausgesetzt):
```
http://api.tranzfiction.com/city/<City-ID>/building/create?building[type]=<Gebäudetyp>
```
Diese API wird dann vom Frontend genutzt, welches in HTML, CSS und JavaScript programmiert ist und letztendlich die Schnittstelle zum Spieler darstellt.

*Randnotiz:* Die API ist bewusst nicht RESTful gehalten (denn alle API-Aufrufe finden mit der HTTP-Methode `GET` statt): Ohne REST lassen sich die API-Aufrufe viel einfacher im Browser testen (bei REST müsste der obige Aufruf mit `POST` erfolgen). Aus demselben Grund werden die Parameter für den jeweiligen Aufruf als `GET`-Parameter übermittelt. Dadurch wird die API anschaulicher und kann auch beispielhaft erläutert und ausprobiert werden. (In einer produktiven Web-Anwendung sollte man natürlich auf REST zurückgreifen.)

Dieses Repository soll dabei helfen, den tranzfiction-Programmcode anzusehen und nachzuvollziehen. Die wichtigen Stellen sind kommentiert. Am besten fängt man mit der Datei `config/routes.rb` an, diese gibt einen groben Überblick, wie das Backend strukturiert ist. Außerdem sind dort alle API-Aufrufe enthalten und beschrieben. Im `Gemfile` gibt es Informationen, von welchen externen Bibliotheken das Backend abhängt. Wie bei Rails üblich, liegt im Verzeichnis `app` der eigentliche Code, hier sind vor allem die `models` interessant. (Die `controllers` enthalten vor allem Boilerplate-Code zur Benutzung der API und die `views` bestehen vor allem aus Login- und Registrierungsformularen und dergleichen.) Oben wurden bereits die groben Abhängigkeiten zwischen den Models `User`, `City` und `Building` aufgezeigt, die entsprechenden `models/*.rb`-Dateien enthalten die konkrete Implementation.

Zugleich stellt das Repository aber auch den eigentlichen Programmcode dar, sodass man auch einen eigenen tranzfiction-Server aufsetzen kann. Dafür gebe ich allerdings keinen Support und auch keine Anleitung.

(Kleiner Hinweis: Damit das Spiel richtig funktioniert, muss ein Cronjob eingerichtet werden, der regelmäßig diese API-Funktion aufruft: `http://dein-server.de/gain/<passwort>`. Das hier eingesetzte Passwort muss per `heroku config:set WORKER_PASSWORD=<passwort>` gesetzt werden.)
  
(Und noch ein Hinweis: Das Spiel ist für den Produktivbetrieb mit Heroku geschrieben. Andere Plattformen sind wahrscheinlich möglich, allerdings nicht ohne den Code anzupassen.)

*Rechtliches:* Da tranzfiction vor allem ein Beispiel ("showcase") einer Rails-Applikation für meine Facharbeit sein soll, ist das Projekt nicht Open Source. Der Code darf gelesen und auch für einen Testserver, nicht aber einen öffentlich zugänglichen Server genutzt werden. Veränderungen am Code in geringem Maße sind erlaubt (Konfiguration etc.), aber keine größeren Änderungen an der Architektur, API oder den Features. Das Projekt darf nicht kommerziell genutzt werden.