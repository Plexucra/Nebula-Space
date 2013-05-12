<%@ page pageEncoding="UTF-8"%><!doctype html>
<html lang="de">
<%
if(request.getParameter("key")==null)
{
%>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<link href="css/default_thema/main.css" rel="stylesheet">
	    <script src="js/jquery-1.9.1.js"></script>
	     <script src="js/index.js"></script>
	    <script src="https://apis.google.com/js/client.js?onload=handleClientLoad"></script>
   	</head>
	<body>
		<div class="page">
			<div id="headDiv"></div>
			<div id="viewDiv">
				<div>
					Nebula-Space ist ein freies / nicht kommerzielles Online- Wirtschafts- und Weltraumsimmulationsspiel.<br/>
					An der Weiterentwicklung des Spiels kann jeder mitwirken / sich beteiligen der dies möchte.<br/><br/>
				</div>
				<div id="loginDiv">
					wird geladen..<br/><br/>
					<b>Bitte warten Sie einen Augenblick.</b><br/><br/>
				</div>
				<h2>Über erzeugten Schlüssel einloggen</h2>
				<div class="loginOption">
					<input type="text" placeholder="Hier notierten Schlüssel eintragen" size="35" required="required" id="myKey"/> &nbsp;&nbsp;<button class='gbqfb' id="keyLogin">Einloggen</button>
					<br/><br/>
					<button class='gbqfb' id="generateKey">Schlüssel erzeugen</button>
				</div>
				<br/><br/><br/>
				<i>
					Hinweis: Aus Gründen des Datenschutzes werden von uns generell keine E-Mail-Adressen gespeichert.<br/>
					Der Google-Login dient lediglich der eindeutigen Identifizierung des Spieler-Accounts.
				</i>
					
			</div>
			<div id="footDiv"><small>Diese Webseite wurde mit Firefox und Chrome&trade; getestet. Von der Verwendung des Internet Explorers ist generell abzuraten.</small></div>
		</div>
	</body>
<%
}
else
{
%>
	<head>
		<script>
			location.replace("/beta/pages/login.jsp?key=<%=request.getParameter("key")%>");
		</script>
	</head>
	<body>
		wird geladen..
	</body>
<%
}
%>
</html>