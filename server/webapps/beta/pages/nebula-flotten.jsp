<%@page import="org.colony.lib.S"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/page-header.jsp" %>
<script>
	<%
	request.setAttribute("s", new S(request));
	%>
	$(function()
	{
		$("#menuDiv a[data='nebula']").addClass("cn_aktive");
		var d = $("<div/>");
		d.append( $("<a href='nebula.jsp'>Nebula</a><span> | </span>") );
		d.append( $("<a href='nebula.jsp?x=${s.nutzer.heimatPlanet.x}&y=${s.nutzer.heimatPlanet.y}'>Springe zum Heimatplanet</a><span> | </span>") );
		d.append( $("<a href='nebula-flotten.jsp' class='cn_aktive'>Meine Flotten</a>") );
		d.addClass("menuDiv_stage2");
		$("#menuLeftDiv").append(d);
		d.hide();
		d.slideDown();
	});
</script>

<div>
	<h3>Flottenübersicht:</h3>
	<%
	request.setAttribute("flotten",S.s().getFlotten(S.s().getNutzer(session)));
	%>
	<div class="${ns}_flottenliste">
		<table>
			<tr>
				<th>Position</th>
				<th>Ziel</th>
				<th>Zeit bis Sprung</th>
				<th>Flottengeschwader</th>
			</tr>
			<c:forEach items="${ flotten }" var="row">
				<tr>
					<td><a href="nebula.jsp?x=${row.x}&y=${row.y}">${row.x}:${row.y}</a></td>
					<td>
						<c:if test="${row.zielX!=row.x or row.zielY!=row.y}">
							<a href="nebula.jsp?x=${row.zielX}&y=${row.zielY}">${row.zielX}:${row.zielY}</a>
						</c:if>
					</td>
					<td><c:if test="${row.sprungAufladung >= 0}">${(s.ticker.duration * row.sprungAufladung)/1000} Sek.</c:if></td>
					<td>
						<c:forEach items="${ row.geschwader }" var="geschwader">
							${ geschwader.anzahl } 
							${ geschwader.schiffsmodell.bezeichnung }
						</c:forEach>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>	
</div>

<%@ include file="include/page-footer.jsp" %>
