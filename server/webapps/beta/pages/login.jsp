<%@page import="org.colony.data.Nutzer"%>
<%@ page pageEncoding="UTF-8"%><%@page import="org.colony.lib.ContextListener"%><%
if(request.getParameter("key")==null) throw new Exception("Beim Anmeldeverfahren kam es zu einen Fehler in der Verarbeitung (fehlender Login-Key).");

Nutzer nutzer = ContextListener.getService().getNutzerByKey(request.getParameter("key"));
if(nutzer!=null)
	session.setAttribute("userId", nutzer.getId());

if(session.getAttribute("userId")!=null) response.sendRedirect("karte.jsp");
else
{
%>
<!doctype html>
<html lang="de">
<head>
	<% request.setAttribute("ns", request.getServletPath().replaceAll("/", "_").replaceAll("\\.jsp", "")); %>
	<meta charset="utf-8">
	<title>Login</title>
	<link href="../css/default_thema/colony.css" rel="stylesheet">
	<script src="../js/jquery-1.9.1.js"></script>
	<script src="../js/jquery-ui-1.10.1.custom.js"></script>
	<script>
		var ns = "${ns}";
		$(function()
		{
			$("form").submit(function(e)
			{
				e.preventDefault();
				$.getJSON('../json/insertNutzer.jsp?key=<%= request.getParameter("key") %>&alias='+$('#aliasInput').val(), function(data2) 
				{
					if(data2["errorMessage"])
					{
						alert(data2["errorMessage"]);
					}
					else location.replace("karte.jsp");
				});
				
			});
		});
	</script>
</head>
	<body class="${ns}">
	<div id="headDiv"></div>
	<div id="mainDiv">
		<h1>Alias festlegen</h1>
		<div class="cn_hinweise">
			Du meldest dich gerade zum ersten Mal am Spiel an.<br/>
			Bitte lege daher zunächst deinen Spielernamen (max 20 Zeichen) fest:<br/>
			<div class="dn_beispiel">Beispiel: <i>Umbrella Inc.</i></div>
		</div>
		<form>
			<input type="text" name="alias" id="aliasInput" maxlength="20"/>
			<input type="submit" value="Speichern"/>
		</form>
	</div>
</body>
</html>
<%
}%>