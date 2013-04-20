<%@page import="org.colony.lib.Formater"%>
<%@page import="java.text.NumberFormat"%>
<%@ include file="/pages/include/init.jsp" %>
<%@page import="org.colony.lib.ContextListener"%>
<%@ page pageEncoding="UTF-8"%><!doctype html>
<html lang="de">
<head>
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
				var d = $("<div/>");
				d.append( $("<a data='nebula.jsp'>Galaxie</a>") );
				d.append( $("<a data='karte.jsp'>Kolonie</a>") );
				d.append( $("<a data='forschung.jsp'>Forschung</a>") );
				d.append( $("<a data='handel.jsp'>Handel</a>") );
				d.append( $("<a data='statistik.jsp'>Statistik</a>") );
				d.append( $("<a data='einstellung.jsp'>Einstellung</a>") );
				d.append( $("<div/>"));
				d.children("div").html($("<span>Konto: </span><%= Formater.formatCurrency(ContextListener.getService().getNutzer(session).getKontostand()) %> <%=
				Formater.formatDiffCurrency( ContextListener.getService().getNutzer(session).getGewinn() * ((60*60*1000) / ContextListener.getTicker().getDuration()) ) %><span> / h</span>"));
				d.children("div").css("float","right");
				
				d.addClass("menuDiv_stage1");
				$("#menuLeftDiv").append(d);
				d.children("a[data='<%= request.getServletPath().replaceAll("/", "_").replaceAll("_pages_","") %>']").addClass("cn_aktive")
				d.children("a").each(function()
				{
					$(this).attr("href",$(this).attr("data"));
				})

				var d = $("<div/>");
				d.append( $("<a data='nebula.jsp'>Übersicht</a><span> | </span>") );
				d.append( $("<a data='karte.jsp' class='cn_aktive'>Karte</a><span> | </span>") );
				d.append( $("<a data='forschung.jsp'>Meine Immobilien</a><span> | </span>") );
				d.append( $("<a data='forschung.jsp'>Gebäude bauen</a><span> | </span>") );
				d.addClass("menuDiv_stage2");
				$("#menuLeftDiv").append(d);
				d.children("a").attr("href","#");
				d.hide();
// 				d.show();
				d.slideDown();

			});
		</script>
		<div id="menuDiv">
		<table>
			<tr>
			<td id="menuLeftDiv">
			</td>
			</tr>
		</table>
		</div>
		<div id="mainDiv">
		