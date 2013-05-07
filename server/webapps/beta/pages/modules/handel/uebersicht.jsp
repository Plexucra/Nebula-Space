<%@page import="org.colony.data.Order"%>
<%@page import="org.colony.service.HandelService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.colony.data.Planet"%>
<%@page import="java.util.List"%>
<%@page import="org.colony.service.PlanetService"%>
<%@page import="org.colony.data.Schiffsmodell"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/pages/include/page-header.jsp" %>

<h1>Handelsplätze</h1>
<% request.setAttribute("plist",PlanetService.getPlaneten()); %>

<%
List<Order> orders = HandelService.getNutzerOrders(s.getNutzer());
%>
<table>
	<tr>
		<th/>
		<th><%= HandelService.ress1Name %></th>
		<th><%= HandelService.ress2Name %></th>
		<th><%= HandelService.ress3Name %></th>
		<th><%= HandelService.ress4Name %></th>
		<th><%= HandelService.ress5Name %></th>
	</tr>
<c:forEach items="${ plist }" var="row">
	<tr>
		<td><span class="cn_label">Handelsplatz:</span></td>
		<td colspan="5">
			<c:choose>
				<c:when test="${ row.allianz.id ne s.allianz.id }">
					<span class="cn_label">${ row.name } </span><br/>
					<span class="cn_label">(gesperrt durch Handelsembargo von ${ row.allianz.bezeichnung})</span>
				</c:when>
				<c:otherwise>
					${ row.name }
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<c:if test="${ row.allianz.id eq s.allianz.id }">
		<tr class="${ row.allianz.id ne s.allianz.id ? 'cn_disabled':'' }">
			<td><span class="cn_label">Fördermenge:</span></td>
			<td>${row.ress1Vorkommen}</td>
			<td>${row.ress2Vorkommen}</td>
			<td>${row.ress3Vorkommen}</td>
			<td>${row.ress4Vorkommen}</td>
			<td>${row.ress5Vorkommen}</td>
		</tr>
		<tr class="${ row.allianz.id ne s.allianz.id ? 'cn_disabled':'' }">
			<td><span class="cn_label">Letzter Kurs:</span></td>
			<td>${row.ress1Vorkommen}</td>
			<td>${row.ress2Vorkommen}</td>
			<td>${row.ress3Vorkommen}</td>
			<td>${row.ress4Vorkommen}</td>
			<td>${row.ress5Vorkommen}</td>
		</tr>
		<tr class="${ row.allianz.id ne s.allianz.id ? 'cn_disabled':'' }">
			<td><span class="cn_label">Ihre aktuellen Orders:</span></td>
			<td><table> <tr><th>Typ</th><th>Kurs</th><th>Volumen</th></tr><% for(Order o : orders) if(o.getPlanetId() == ((Planet) pageContext.getAttribute("row")).getId() && o.getRess()==1) { %><tr> <td><%= o.isKauf()?"Kauforder":"Verkauforder" %></td> <td align="right"><%= o.getKurs() %></td> <td align="right"><%= o.getVolumen() %></td> </tr> <%  } %></table> </td>
			<td><table> <tr><th>Typ</th><th>Kurs</th><th>Volumen</th></tr><% for(Order o : orders) if(o.getPlanetId() == ((Planet) pageContext.getAttribute("row")).getId() && o.getRess()==2) { %><tr> <td><%= o.isKauf()?"Kauforder":"Verkauforder" %></td> <td align="right"><%= o.getKurs() %></td> <td align="right"><%= o.getVolumen() %></td> </tr> <%  } %></table> </td>
			<td><table> <tr><th>Typ</th><th>Kurs</th><th>Volumen</th></tr><% for(Order o : orders) if(o.getPlanetId() == ((Planet) pageContext.getAttribute("row")).getId() && o.getRess()==3) { %><tr> <td><%= o.isKauf()?"Kauforder":"Verkauforder" %></td> <td align="right"><%= o.getKurs() %></td> <td align="right"><%= o.getVolumen() %></td> </tr> <%  } %></table> </td>
			<td><table> <tr><th>Typ</th><th>Kurs</th><th>Volumen</th></tr><% for(Order o : orders) if(o.getPlanetId() == ((Planet) pageContext.getAttribute("row")).getId() && o.getRess()==4) { %><tr> <td><%= o.isKauf()?"Kauforder":"Verkauforder" %></td> <td align="right"><%= o.getKurs() %></td> <td align="right"><%= o.getVolumen() %></td> </tr> <%  } %></table> </td>
			<td><table> <tr><th>Typ</th><th>Kurs</th><th>Volumen</th></tr><% for(Order o : orders) if(o.getPlanetId() == ((Planet) pageContext.getAttribute("row")).getId() && o.getRess()==5) { %><tr> <td><%= o.isKauf()?"Kauforder":"Verkauforder" %></td> <td align="right"><%= o.getKurs() %></td> <td align="right"><%= o.getVolumen() %></td> </tr> <%  } %></table> </td>
		</tr>
		<tr>
			<td><span class="cn_label">Aktionen:</span></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=1">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=1">Verkauforder erstellen</a> </c:if></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=2">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=2">Verkauforder erstellen</a> </c:if></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=3">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=3">Verkauforder erstellen</a> </c:if></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=4">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=4">Verkauforder erstellen</a> </c:if></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=5">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=5">Verkauforder erstellen</a> </c:if></td>
		</tr>
	</c:if>
	<tr><td colspan="6"><hr/></td></tr>
</c:forEach>
</table>