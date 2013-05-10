<%@page import="org.colony.service.PlanetService"%>
<%@page import="org.colony.service.NutzerService"%>
<%@page import="org.colony.lib.Formater"%>
<%@page import="java.text.NumberFormat"%>
<%@ include file="/pages/include/init.jsp" %>
<%@page import="org.colony.lib.ContextListener"%>
<%@ page pageEncoding="UTF-8"%><!doctype html>
<html lang="de">
<head>
	<meta charset="utf-8">
	<title>Nebula-Space.de</title>
	<link href="${up}/css/default_thema/colony.css" rel="stylesheet">
	<script src="${up}/js/jquery-1.9.1.js"></script>
	<script src="${up}/js/jquery-ui-1.10.1.custom.js"></script>
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
							<%= NutzerService.getNutzer(session).getAlias() %>
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
							<%= Formater.formatCurrency(NutzerService.getNutzer(session).getKontostand()) %> 
							<%= Formater.formatDiffCurrency( NutzerService.getNutzer(session).getGewinn() * ((60*60*1000) / ContextListener.getTicker().getDuration()) ) %>
							<span> / h</span>
						</div>
						<div class="menuDiv_stage1">
							<a id="menuPunkt1_pages_nachrichten" href='${up}/pages/nachrichten.jsp'>Nachrichten</a>
							<a id="menuPunkt1_pages_nebula" href='${up}/pages/nebula.jsp'>Galaxie</a>
							<a id="menuPunkt1_pages_karte" href='${up}/pages/karte.jsp'>Kolonie</a>
							<a id="menuPunkt1_pages_forschung" href='${up}/pages/forschung.jsp'>Forschung</a>
							<a id="menuPunkt1_pages_modules_handel" href='${up}/pages/modules/handel/uebersicht.jsp'>Handel</a>
							<a id="menuPunkt1_pages_modules_statistik" href='${up}/pages/modules/statistik/nutzer.jsp'>Statistik</a>
							<a id="menuPunkt1_pages_einstellungen" href='${up}/pages/einstellungen.jsp'>Einstellungen</a>
						</div>
						<div class="menuDiv_stage2" ref="menuPunkt1_pages_karte">
							<a id="menuPunkt2_pages_karte" href='${up}/pages/karte.jsp' >Schematischer Stadtplan</a><span> | </span>
							<a id="menuPunkt2_pages_immobilien" href='${up}/pages/immobilien.jsp'>Meine Immobilien</a><span> | </span>
							<a id="menuPunkt2_pages_modell-auswahl" href='${up}/pages/modell-auswahl.jsp'>Bauplan auswählen</a><span> | </span>
						</div>
						<div class="menuDiv_stage2" ref="menuPunkt1_pages_nebula">
							<a id="menuPunkt2_pages_nebula" href='${up}/pages/nebula.jsp'>Nebula</a><span> | </span>
							<a id="menuPunkt2_pages_nebula_" href='${up}/pages/nebula.jsp?x=${s.nutzer.heimatPlanet.x}&y=${s.nutzer.heimatPlanet.y}'>
								<% request.setAttribute("plist",PlanetService.getPlaneten()); %>
								Springe zu:
							</a>
							<select onchange="location.replace('${up}/pages/nebula.jsp'+this.value)">
								<option>Bitte wählen</option>
								<c:forEach items="${ plist }" var="row">
									<option value="?x=${ row.x }&y=${ row.y }">${ row.name }</option>
								</c:forEach>
							</select>
							<span> | </span>
							<a id="menuPunkt2_pages_nebula-flotten" href='${up}/pages/nebula-flotten.jsp'>Meine Flotten</a>
						</div>
						<div class="menuDiv_stage2" ref="menuPunkt1_pages_nachrichten">
							<a id="menuPunkt2_pages_nachrichten" href='${up}/pages/nachrichten.jsp'>Neuigkeiten</a><span> | </span>
							<a id="menuPunkt2_pages_nachrichten-posteingang" href='${up}/pages/nachrichten-posteingang.jsp'>Posteingang</a><span> | </span>
							<a id="menuPunkt2_pages_nachrichten-postausgang" href='${up}/pages/nachrichten-postausgang.jsp'>Postausgang</a><span> | </span>
							<a id="menuPunkt2_pages_nachrichten-neue-nachricht" href='${up}/pages/nachrichten-neue-nachricht.jsp'>Neue Nachricht</a><span> | </span>
						</div>
						
						<div class="menuDiv_stage2" ref="menuPunkt1_pages_modules_statistik">
							<a id="menuPunkt2_pages_modules_statistik_nutzer" href='${up}/pages/modules/statistik/nutzer.jsp'>Firmen-Statistik</a><span> | </span>
							<a id="menuPunkt2_pages_modules_statistik_schlachtensimulator" href='${up}/pages/modules/statistik/schlachtensimulator.jsp'>Schlachtensimulator</a><span> | </span>
						</div>
						
						<div class="menuDiv_stage2" ref="menuPunkt1_pages_modules_handel">
							<a id="menuPunkt2_pages_modules_handel_uebersicht" href='${up}/pages/modules/handel/uebersicht.jsp'>Handelsplätze</a><span> | </span>
							<a id="menuPunkt2_pages_modules_handel_order" href='${up}/pages/modules/handel/order.jsp'>Order erstellen</a><span> | </span>
							<a id="menuPunkt2_pages_modules_handel_transaktionen" href='${up}/pages/modules/handel/transaktionen.jsp'>letzte Transaktionen</a><span> | </span>
							<a id="menuPunkt2_pages_modules_handel_frachttransfer" href='${up}/pages/modules/handel/frachttransfer.jsp'>Frachttransfer</a><span> | </span>
						</div>


					</div>
				</div>
			</td>
			</tr>
		</table>
		</div>
		<div id="mainDiv">
		