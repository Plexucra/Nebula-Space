<%@ page pageEncoding="UTF-8"%>
<%@page import="org.colony.service.SchlachtService"%>
<%@page import="org.colony.service.NutzerService"%>
<%@page import="org.colony.data.Kampf"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="/pages/include/page-header.jsp" %>

<h1>Schlachtbericht</h1>
<%
List<Kampf> kaempfe = SchlachtService.getKaempfe(s.getInt("id"));
int p1 = -1;
int p2 = -1;

List<Kampf> kaempfe1 = new ArrayList<Kampf>();
List<Kampf> kaempfe2 = new ArrayList<Kampf>();

boolean berechtigt = false;
for(Kampf k : kaempfe)
{
	int hp = NutzerService.getById(k.getNutzerId()).getAllianzId();
	if(p1 == -1)
		p1 = hp;
	else if(p2==-1)
		p2=hp;
	
	if(hp == s.getNutzer().getAllianzId())
		berechtigt= true;
	
	if(hp==p1)
		kaempfe1.add(k);
	else
		kaempfe2.add(k);
}
if(berechtigt)
{
	request.setAttribute("kaempfe1",kaempfe1);
	request.setAttribute("kaempfe2",kaempfe2);
}
%>

<table>
	<tr>
		<c:set var="lastTick" value=""/>
		<c:forEach items="${ kaempfe1 }" var="row">
			<c:if test="${ lastTick ne row.tick }">
				<c:if test="${ not empty lastTick }"></td></c:if>
				<td>
			</c:if>
			<div class="dn_${ row.anzahlUeberlebend > 0 ? 'alive':'dead'  }">${row.anzahlAufgebot } -> ${row.anzahlUeberlebend } - ${row.schiffsmodell.bezeichnung} - ${row.nutzer.alias}</div>
			<c:set var="lastTick" value="${ row.tick }"/>
		</c:forEach>
		</td>
	</tr>
	<tr>
		<c:set var="lastTick" value=""/>
		<c:forEach items="${ kaempfe2 }" var="row">
			<c:if test="${ lastTick ne row.tick }">
				<c:if test="${ not empty lastTick }"></td></c:if>
				<td>
			</c:if>
			<div class="dn_${ row.anzahlUeberlebend > 0 ? 'alive':'dead'  }">${row.anzahlAufgebot } -> ${row.anzahlUeberlebend } - ${row.schiffsmodell.bezeichnung} - ${row.nutzer.alias}</div>
			<c:set var="lastTick" value="${ row.tick }"/>
		</c:forEach>
		</td>
	</tr>
</table>
