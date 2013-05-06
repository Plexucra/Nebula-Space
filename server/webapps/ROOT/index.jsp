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
					Nebula-Space ist ein freies Online- Wirtschafts- und Weltraumsimmulationsspiel. 
					Die geringen Betriebskosten werden <b>spendenfinanziert</b>. An der Weiterentwicklung
					des Spiels kann jeder mitwirken der dies möchte.<br/><br/>
				</div>
				<div id="loginDiv">
					wird geladen..
				</div>
			</div>
			<div id="footDiv"><small>Diese Webseite wurde mit Chrome&trade; getestet.</small></div>
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