<%@page import="org.colony.lib.S"%>
<%@page import="org.colony.lib.Formater"%>
<%@page import="java.text.NumberFormat"%>
<%@ include file="/pages/include/init.jsp" %>
<%@page import="org.colony.lib.ContextListener"%>
<%@ page pageEncoding="UTF-8"%><!doctype html>
<html lang="de">
<head>
	<%
		S s = new S(request);
		request.setAttribute("s", s);
	%>
	<% request.setAttribute("ns", request.getServletPath().replaceAll("/", "_").replaceAll("\\.jsp", "")); %>
	<meta charset="utf-8">
	<title>Colony 0.1</title>
	<link href="../css/default_thema/colony.css" rel="stylesheet">
	<script src="../js/jquery-1.9.1.js"></script>
	<script src="../js/jquery-ui-1.10.1.custom.js"></script>
<!-- 	<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" /> -->
	<script>
		var ns = "${ns}";
		var tickDuration = <%=ContextListener.getTicker().getDuration()%>;
	</script>
</head>
	<body class="${ns}">
		<div id="headDiv">
			<table>
			<tr>
				<td class="banner">Colony</td>
				<td class="info">
					<%
					
						long timeToNextTick = Math.round((float)(ContextListener.getTicker().getDuration() - (System.currentTimeMillis()-ContextListener.getTicker().getDtLastTick()))/1000f);
					%>

					<table width="100%">
						<tr><td>Angemeldet als:</td>
						<td>
							<%= ContextListener.getService().getNutzer(session).getAlias() %>
						</td>
						<td class="dn_tickInfo" align="right"> - Tick: in <span class="dn_tickTimeInfo"><%= timeToNextTick %> Sek.</span> </td>
						</tr>
					</table>
					
				</td>
			</tr>
			</table>
		</div>
		<script type="text/javascript">
			function update_tickTimeInfo(tTime)
			{
				if(tTime<=0)
				{
					$(".dn_tickTimeInfo").html("-");
					return;
				}
				$(".dn_tickTimeInfo").html(tTime+" Sek.");
				tTime--;
				setTimeout("update_tickTimeInfo("+tTime+");", 1000);
			}
			$(function()
			{
				update_tickTimeInfo(<%= timeToNextTick %>)
			});

			$(function()
			{
				$("#menuDiv .menuDiv_stage2").hide();
// 				$("#menuDiv #menuPunkt1${ns}").addClass("cn_aktive");
				$("#menuDiv #menuPunkt2${ns}").addClass("cn_aktive").parent().slideDown();
				var t_id = $("#menuDiv #menuPunkt2${ns}").addClass("cn_aktive").parent().attr("ref");
				$("#menuDiv #"+t_id).addClass("cn_aktive")
			});
		</script>
		<div id="menuDiv">
		<table>
			<tr>
			<td id="menuLeftDiv">
				<div>
					<div>
						<div style="float:right">
							<span>Konto: </span>
							<%= Formater.formatCurrency(ContextListener.getService().getNutzer(session).getKontostand()) %> 
							<%= Formater.formatDiffCurrency( ContextListener.getService().getNutzer(session).getGewinn() * ((60*60*1000) / ContextListener.getTicker().getDuration()) ) %>
							<span> / h</span>
						</div>
						<div class="menuDiv_stage1">
							<a id="menuPunkt1_pages_nachrichten" href='nachrichten.jsp'>Nachrichten</a>
							<a id="menuPunkt1_pages_nebula" href='nebula.jsp'>Galaxie</a>
							<a id="menuPunkt1_pages_karte" href='karte.jsp'>Kolonie</a>
							<a id="menuPunkt1_pages_forschung" href='forschung.jsp'>Forschung</a>
							<a id="menuPunkt1_pages_handel" href='handel.jsp'>Handel</a>
							<a id="menuPunkt1_pages_statistik" href='statistik.jsp'>Statistik</a>
							<a id="menuPunkt1_pages_einstellungen" href='einstellungen.jsp'>Einstellungen</a>
						</div>
						<div class="menuDiv_stage2" ref="menuPunkt1_pages_karte">
							<a id="menuPunkt2_pages_karte" href='karte.jsp' >Karte</a><span> | </span>
							<a id="menuPunkt2_pages_immobilien" href='immobilien.jsp'>Meine Immobilien</a><span> | </span>
							<a id="menuPunkt2_pages_modell-auswahl" href='modell-auswahl.jsp'>Bauplan auswählen</a><span> | </span>
						</div>
						<div class="menuDiv_stage2" ref="menuPunkt1_pages_nebula">
							<a id="menuPunkt2_pages_nebula" href='nebula.jsp'>Nebula</a><span> | </span>
							<a id="menuPunkt2_pages_nebula_" href='nebula.jsp?x=${s.nutzer.heimatPlanet.x}&y=${s.nutzer.heimatPlanet.y}'>Springe zum Heimatplanet</a><span> | </span>
							<a id="menuPunkt2_pages_nebula-flotten" href='nebula-flotten.jsp'>Meine Flotten</a>
						</div>
						<div class="menuDiv_stage2" ref="menuPunkt1_pages_nachrichten">
							<a id="menuPunkt2_pages_nachrichten" href='nachrichten.jsp'>Neuigkeiten</a><span> | </span>
							<a id="menuPunkt2_pages_nachrichten-posteingang" href='nachrichten-posteingang.jsp'>Posteingang</a><span> | </span>
							<a id="menuPunkt2_pages_nachrichten-postausgang" href='nachrichten-postausgang.jsp'>Postausgang</a><span> | </span>
							<a id="menuPunkt2_pages_nachrichten-neue-nachricht" href='nachrichten-neue-nachricht.jsp'>Neue Nachricht</a><span> | </span>
						</div>


					</div>
				</div>
			</td>
			</tr>
		</table>
		</div>
		<div id="mainDiv">
		