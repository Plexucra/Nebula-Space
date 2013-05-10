<%@page import="org.colony.data.Transaktion"%>
<%@page import="org.colony.data.Lager"%>
<%@page import="org.colony.data.Order"%>
<%@page import="org.colony.service.HandelService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.colony.data.Planet"%>
<%@page import="java.util.List"%>
<%@page import="org.colony.service.PlanetService"%>
<%@page import="org.colony.data.Schiffsmodell"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/pages/include/page-header.jsp" %>

<%
request.setAttribute("plist",PlanetService.getPlaneten()); 
List<Order> orders = HandelService.getNutzerOrders(s.getNutzer());
%>
<table>
<c:forEach items="${ plist }" var="row">
	<c:if test="${ row.allianz.id eq s.allianz.id }">
		<tr>
			<td>
				<br/>
				<br/>
				<span class="cn_label">Handelsplatz:</span>
			</td>
			<td colspan="5">
				<h1>${ row.name } ${ row.id eq s.nutzer.heimatPlanetId?' (Heimatplanet)':'' }</h1>
			</td>
		</tr>
		<tr>
			<td>
				<span class="cn_label">Rohstofftransfer:</span>
			</td>
			<td colspan="5">
				<a href="${up}/pages/modules/handel/frachttransfer.jsp?planetId=${row.id}">Frachter im Orbit von ${ row.name } be- oder entladen</a>
			</td>
		</tr>
		<tr>
			<th/>
			<th><%= HandelService.ress1Name %></th>
			<th><%= HandelService.ress2Name %></th>
			<th><%= HandelService.ress3Name %></th>
			<th><%= HandelService.ress4Name %></th>
			<th><%= HandelService.ress5Name %></th>
		</tr>

		<%
			Planet p = (Planet) pageContext.getAttribute("row");
			Lager l = NutzerService.getLager(s.getNutzer().getId(), p.getId());
			List<Transaktion> tList = HandelService.getLetzteTransaktionen(p.getId());
		%>
		<tr class="${ row.allianz.id ne s.allianz.id ? 'cn_disabled':'' }">
			<td><span class="cn_label">Rohstoffförderung <br/>durch Staatskonzerne:</span></td>
			<td><fmt:formatNumber><%=  Math.round( (3600f / ((float)s.getTicker().getDuration()/1000f))*p.getRess1Vorkommen() ) %></fmt:formatNumber>/h</td>
			<td><fmt:formatNumber><%=  Math.round( (3600f / ((float)s.getTicker().getDuration()/1000f))*p.getRess2Vorkommen() ) %></fmt:formatNumber>/h</td>
			<td><fmt:formatNumber><%=  Math.round( (3600f / ((float)s.getTicker().getDuration()/1000f))*p.getRess3Vorkommen() ) %></fmt:formatNumber>/h</td>
			<td><fmt:formatNumber><%=  Math.round( (3600f / ((float)s.getTicker().getDuration()/1000f))*p.getRess4Vorkommen() ) %></fmt:formatNumber>/h</td>
			<td><fmt:formatNumber><%=  Math.round( (3600f / ((float)s.getTicker().getDuration()/1000f))*p.getRess5Vorkommen() ) %></fmt:formatNumber>/h</td>
		</tr>
		<tr class="${ row.allianz.id ne s.allianz.id ? 'cn_disabled':'' }">
			<td><span class="cn_label">Letzter Kurs (Vol.):</span></td>
			<td><% if(tList!=null) for(Transaktion t : tList) if(t.getRess()==1) out.print(t.getKurs()+" ("+t.getVolumen()+")"); %></td>
			<td><% if(tList!=null) for(Transaktion t : tList) if(t.getRess()==2) out.print(t.getKurs()+" ("+t.getVolumen()+")"); %></td>
			<td><% if(tList!=null) for(Transaktion t : tList) if(t.getRess()==3) out.print(t.getKurs()+" ("+t.getVolumen()+")"); %></td>
			<td><% if(tList!=null) for(Transaktion t : tList) if(t.getRess()==4) out.print(t.getKurs()+" ("+t.getVolumen()+")"); %></td>
			<td><% if(tList!=null) for(Transaktion t : tList) if(t.getRess()==5) out.print(t.getKurs()+" ("+t.getVolumen()+")"); %></td>
		</tr>
		<tr class="${ row.allianz.id ne s.allianz.id ? 'cn_disabled':'' }">
			<td><span class="cn_label">Ihr Lagerstand:</span></td>
			<% for(int ress=1; ress<=5; ress++) {%> <td><fmt:formatNumber><%=l.getRess(ress) %></fmt:formatNumber></td> <%} %>
		</tr>
		
		<tr class="${ row.allianz.id ne s.allianz.id ? 'cn_disabled':'' }">
			<td><span class="cn_label">Ihre aktuellen Orders:</span></td>
			<%
				for(int ress = 1; ress<=5; ress++)
				{
					%>
					<td>
						<table>
							<tr><th></th><th><span class="cn_label">Typ</span></th><th><span class="cn_label">Kurs</span></th><th><span class="cn_label">Volumen</span></th></tr>
							<% 
							for(Order o : orders)
							{
								if(o.getPlanetId() == ((Planet) pageContext.getAttribute("row")).getId() && o.getRess()==ress)
								{
									%>
									<tr>
										<td><a class="cn_delete" href="${up}/pages/modules/handel/order.jsp?action=delete&id=<%=o.getId()%>">X</a></td>
										<td><%= o.isKauf()?"Kauforder":"Verkauforder" %></td>
										<td align="right"><%= o.getKurs() %></td>
										<td align="right"><%= o.getVolumen() %></td>
									</tr>
									<%  
								}
							}
							%>
						</table>
					</td>
					<%
				}
			%>
		</tr>
		<tr>
			<td><span class="cn_label">Aktionen:</span></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=1">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=1">Verkauforder erstellen</a> </c:if></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=2">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=2">Verkauforder erstellen</a> </c:if></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=3">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=3">Verkauforder erstellen</a> </c:if></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=4">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=4">Verkauforder erstellen</a> </c:if></td>
			<td><c:if test="${ row.allianz.id eq s.allianz.id }"><a href="${up}/pages/modules/handel/order.jsp?kauf=1&planetId=${row.id}&ress=5">Kauforder erstellen</a>  <br/><a href="${up}/pages/modules/handel/order.jsp?kauf=0&planetId=${row.id}&ress=5">Verkauforder erstellen</a> </c:if></td>
		</tr>
		<tr>
			<td/>
			<td colspan="5"><hr/></td>
		</tr>
	</c:if>
</c:forEach>
</table>