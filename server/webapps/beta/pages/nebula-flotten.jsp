<%@page import="org.colony.service.FlottenService"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/page-header.jsp" %>
<div>
	<h3>Flottenübersicht:</h3>
	<%
	request.setAttribute("flotten",FlottenService.getFlotten(S.s().getNutzer(session)));
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
							${ geschwader.schiffsmodell.bezeichnung }<br/>
						</c:forEach>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>	
</div>

<%@ include file="include/page-footer.jsp" %>
