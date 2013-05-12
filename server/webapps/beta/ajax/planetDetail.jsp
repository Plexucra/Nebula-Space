<%@page import="org.colony.service.HandelService"%>
<%@page import="org.colony.lib.Cache"%>
<%@ include file="include/ajax-header.jsp" %>
<%@ page pageEncoding="UTF-8"%>

<% pageContext.setAttribute("planet", Cache.get().getPlanet(s.getInt("planetId"))  ); %>

<h1>Ihr Heimatplanet ${planet.name}</h1>
<img src="../css/default_thema/images/spezies/planet${planet.id}.jpg" class="cn_left"/>

<span class="cn_label">Zugehörigkeit des Planets:</span>
<br/>${planet.allianz.bezeichnung}<br/><br/>
<span class="cn_label">Ressourcenvorkommen:</span><br/><br/>
<table>
	<tr><td><%= HandelService.getRessName(1)  %>:</td><td>${ planet.ress1Vorkommen } Tonnen / Hektar</td></tr>
	<tr><td><%= HandelService.getRessName(2)  %>:</td><td>${ planet.ress2Vorkommen } Tonnen / Hektar</td></tr>
	<tr><td><%= HandelService.getRessName(3)  %>:</td><td>${ planet.ress3Vorkommen } Tonnen / Hektar</td></tr>
	<tr><td><%= HandelService.getRessName(4)  %>:</td><td>${ planet.ress4Vorkommen } Tonnen / Hektar</td></tr>
	<tr><td><%= HandelService.getRessName(5)  %>:</td><td>${ planet.ress5Vorkommen } Tonnen / Hektar</td></tr>
</table>

<c:choose>
<c:when test="${ param['planetId'] eq '1' }">

	<h1>Spezies: Drasi</h1>
	Die Drazi sind eine menschenähnliche Spezies, doch ihre Haut ist bedeckt mit farbigen Hornplatten, welche von Purpur bis Grün gefärbt sind. Auffälligstes Merkmal ist eine große Hornplatte an ihrer Stirn, welche vermutlich früher zu Zweikämpfen benutzt wurde. Des Weiteren befinden sich die Geschlechtsorgane der männlichen Drazi an den Oberarmen.
	Drazi ernähren sich ausschließlich von lebenden Meerestieren wie Tintenschnecken oder Muscheln.
	<img src="../css/default_thema/images/spezies/spezies1.jpg" class="cn_right"/>
	Die Sprache der Drazi ist beschreibend aufgebaut, da sie es für umständlich halten, jedem Gegenstand einen Namen zu geben. Aus diesem Grund gestaltet sich die Kommunikation gelegentlich schwierig. Drazi sind zwar fähig, die Sprachen anderer Völker zu erlernen, doch wenden sie auch dann ihre eigenen Sprachgewohnheiten an.
	Die Regierung der Drazi bildet eine von zwei Parteien. Die Zugehörigkeit zu einer Partei wird durch Zufall bestimmt. Alle fünf Drazi-Jahre wird die Parteienzugehörigkeit neu ausgelost. Durch Kampf der beiden Parteien gegeneinander wird die regierende Partei bestimmt.
	Die Drazi verfügen über Technologie, die sie hauptsächlich von anderen Völkern erwerben. 
</c:when>
<c:when test="${ param['planetId'] eq '2' }">
	<h1>Spezies: Andorianer</h1>
	Andorianer sind eine humanoide Spezies, die auf Andoria beheimatet ist.
	Andorianer haben eine hell- bis dunkelblaue Hautfarbe und weißes bis weißblondes Haar. Auffallendes Merkmal sind ihre Fühler, die vom Vor- oder Hinterkopf ausgehen. Mit ihren Fühlern drücken Andorianer ungewollt Emotionen aus. Bei zum Beispiel Wut legen sich die Fühler flach an den Kopf, bei Trauer gehen sie etwas auseinander und begegnen sie ihrer großen Liebe, richten sich die Fühler senkrecht nach oben (falls die Fühler nicht vollständig nach oben ausgerichtet sind). Als Kinder und Teenager sind Andorianer grünhäutig, dann wechselt ihre Hautfarbe. (TNG: Datas Nachkomme)
	Es gibt mehrere Rassen beziehungsweise Typen, die sich durch die Form ihrer Fühler unterscheiden: von sehr lang, starr und dünn über vorne am Kopf angebracht bis kurz und sehr beweglich. Ihr Blut ist Blau und beinhaltet Substanzen, die den Gefrierpunkt im Vergleich zu Wasser stark absenken. ([Quelle fehlt])
	<img src="../css/default_thema/images/spezies/spezies2.jpg" class="cn_right"/>
	
	Des weiteren verfügt der andorianische Körper über ein Exoskelett aus direkt unter der Hautoberfläche liegenden Knochenplatten, welche den gesamten Oberkörper bedecken. Eine Ausnahme bilden hierbei die Frauen, bei welchen der Bauchraum ungeschützt ist, um im Falle einer Schwangerschaft das Wachstum des Fötus nicht zu behindern. (ENT: Vereinigt)
	
	Es gibt wie bei den meisten Humanoiden weibliche und männliche Geschlechter, die sich genauso durch äußere Merkmale wie Körperform oder Brüste unterscheiden.
	
	Die Fühler bilden eine Art von Sinnesorgan. Sie erkennen Hindernisse, wie zum Beispiel niedrig liegende Deckenverstrebungen, und biegen sich dementsprechend nach hinten. Sie dienen den Andorianern auch als instinktives Ausdrucksmittel ihrer Emotionen. So stellen sie sich beispielsweise bei Ärger in gestreckter Position langsam nach hinten. (ENT: Testgebiet)
	Falls einer der beiden Fühler abgetrennt wird, bekommt die verletzte Person leichte Gleichgewichtsprobleme. Der Fühler wächst unter normalen Umständen innerhalb von neun Monaten nach. Dieser Prozess kann jedoch durch Stimulanz auf die Hälfte der Zeit beschleunigt werden. (ENT: Vereinigt, Die Aenar)
	
	Subspezies Aenar Bearbeiten
	Unter den Andorianern existiert noch eine Subspezies, die Aenar. Lange Zeit ist dieses sehr zurückgezogen und pazifistisch lebende Volk eine reine Legende; nur wenige Andorianer haben je wirklich einen gesehen. Äußerlich gleichen sie den Andorianern. Der einzige Unterschied liegt in ihrer blasseren Hautfarbe, die nur einen sehr hellblauen Schimmer besitzt und fast ins Schneeweiße tendiert. Entgegen den Andorianern sind die Aenar Telepathen, dafür jedoch blind.
</c:when>
</c:choose>


