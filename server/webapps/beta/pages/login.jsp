<%@page import="org.colony.data.Planet"%>
<%@page import="org.colony.service.PlanetService"%>
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
				$.getJSON('../json/insertNutzer.jsp?planetId='+$("select[name='planetId']").val()+'&key=<%= request.getParameter("key") %>&alias='+$('#aliasInput').val(), function(data2) 
				{
					if(data2["errorMessage"])
					{
						alert(data2["errorMessage"]);
					}
					else location.replace("karte.jsp");
				});
				
			});
			
			$.get('../ajax/planetDetail.jsp?planetId='+$("select[name='planetId']").val(), function(data2) 
			{
				$("."+ns+" .planetInfo").html(data2);
			});
			
			$("select[name='planetId']").change(function()
			{
				$.get('../ajax/planetDetail.jsp?planetId='+$("select[name='planetId']").val(), function(data2) 
				{
					$("."+ns+" .planetInfo").html(data2);
				});
			});
		});
	</script>
</head>
	<body class="${ns}">
	<div id="headDiv"></div>
	<div id="mainDiv">
		<div class="planetInfo"></div>
		<form>
			<h1>Planet festlegen</h1>
			<div class="cn_hinweise">
				Du meldest dich gerade zum ersten Mal am Spiel an.<br/>
				Falls du mit Freunden zusammen auf einen Heimatplanet spielen möchtest,
				könntest du hier noch den dir zugewiesenen Planeten ändern.<br/><br/>
				Hinweis:<br/>
				Du kannst den Planeten und dessen Spezies später nicht mehr ändern.
				<br/>
				<div class="dn_beispiel">Es wurde folgender Heimatplanet für dich ausgesucht:</div>
			</div>

			<select name="planetId">
				<%
				Planet min = null;
				int amin=0;
				for(Planet p : PlanetService.getPlaneten())
				{
					if(min==null)
					{
						amin=p.getAnzahlNutzer();
						min=p;
					}
					if(p.getAnzahlNutzer() < amin)
					{
						amin = p.getAnzahlNutzer();
						min = p;
					}
				}
				
				for(Planet p : PlanetService.getPlaneten())
					out.println("<option value=\""+p.getId()+"\" "+(p.getId()==min.getId()?"selected='selected'":"")+">Planet: "+p.getName()+(p.getId()==min.getId()?"(empfohlen)":"")+" - Spezies: "+p.getSpezies()+" - Firmen:"+p.getAnzahlNutzer()+"</option>");
				%>
			</select>

			<br/><br/>

			<h1>Alias festlegen</h1>
			<div class="cn_hinweise">
				Bitte lege deinen Spielernamen (max 15 Zeichen) fest.<br/>
				Nach dem Klick auf Speichern wird sowohl dein Heimatplent als auch dein <br/>
				Alias abgelegt. Dieser Dialog wird nicht wieder erscheinen.<br/>
				<div class="dn_beispiel">Beispiel: <i>Umbrella Inc.</i></div>
			</div>
			<input type="text" name="alias" id="aliasInput" maxlength="15"/>
			<input type="submit" value="Speichern"/>
		</form>
	</div>
</body>
</html>
<%
}%>