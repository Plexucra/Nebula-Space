<%@page import="org.colony.data.Modell"%>
<%@ include file="/pages/include/ajax-header.jsp" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="org.colony.lib.Cache"%>
<%
	Modell modell = Cache.get().getModell(s.getInt("modellId"));
	pageContext.setAttribute("modell", modell);
	pageContext.setAttribute("list", Cache.get().getEinfluesse());
%>
<script>
$(function()
{
	$(".cn_dialog").dialog( "option", "width", "auto" );
	$(".cn_dialog").dialog( "option", "title", "Details - <%= modell.getBezeichnung() %>" );
});
</script>

<style>
.${ns} img { float:left; padding-right: 10px; max-width: 300px; }
.${ns} > div { width: 750px; }
.${ns} table td { border-top: 1px solid #333; }
.${ns} table th, .${ns} table td { padding-right: 15px; }
.${ns} table { border-collapse: collapse; width:720px; }
.${ns} td.dn_einfluss, .${ns} th.dn_einfluss { background-color: #222; }
.${ns} .cn_hinweis { font-style: italic; color:#777; }
</style>

<div>
	<img src='${up}/resources/modelle/<%= modell.getId() %>/thumbnail.gif'/>
	
	<%= modell.getBezeichnung() %><br/>
	<span class='cn_label'>Kapazität:</span> <%= modell.getKapazitaet() %><br/>
	<span class='cn_label'>Kosten:</span>  <span class='<%=modell.getBaukosten() <= s.getNutzer().getKontostand()?"dn_bezahlbar":"dn_unbezahlbar"%>'><%=modell.getBaukosten()%></span><br/>
	
	<span class='cn_label'>Kategorie:</span> <span class='cn_value'><%=modell.getTyp().getBezeichnung()%></span><br/>
	<span class='cn_label'>Weitere Infos zu dieser Gebäudekategorie:</span> <br/><span class='cn_value'><%=modell.getTyp().getBeschreibung()%></span><br/>
	
	<c:if test="${not empty modell.produkt }">
		<br/>
		<span class='cn_label'>Dieses Gebäude Produziert folgendes Produkt:</span> <span class='cn_value'>${modell.produkt.bezeichnung}</span><br/>
	</c:if>
	
	<table>
		<tr>
			<th colspan="4">
				<h2>Einflussfaktoren auf die Produktivität dieses Gebäudes:</h2>
			</th>
		</tr>
		<tr>
			<th>Wird beeinflusst durch folgende<br/>Gebäude abhängig ihrer Entfernung</th>
			<th align="right" class="dn_einfluss">*max. Einfluss<br/>&nbsp;pro Gebäude</th>
			<th align="right">*Einfluss<br/>Grenzwert insgesammt</th>
			<th align="right">*max. <br/>Einflussradius</th>
			
		</tr>
		<c:forEach items="${list}" var="row">
			<c:if test="${ row.aTyp.id == modell.typ.id  or ( not empty modell.produkt and row.aProdukt.id == modell.produkt.id ) }">
				<tr>
					<td>${ not empty row.bProdukt ? '<span class="cn_label">Fabriken folgenden Produktes:</span><br/>':'<span class="cn_label">Gebäude der Kategorie:</span><br/>'} ${ not empty row.bProdukt ? row.bProdukt.bezeichnung : row.bTyp.bezeichnung }</td>
					<td align="right" class="dn_einfluss">${ row.einfluss > 0 ?'+':'' }${ row.einfluss }%</td>
					<td align="right">
						<span class="cn_label">Max. Auswirkung:</span> 
						<c:if test="${ row.minEinfluss != 0}"> ${ row.minEinfluss }% </c:if>
						<c:if test="${ row.maxEinfluss != 0}"> </span> ${ row.maxEinfluss }% </c:if>
					</td>
					<td align="right">${ row.radius }</td>
					
				</tr>
			</c:if>
		</c:forEach>
	</table>
	<br/>
	<span class="cn_hinweis">
		*) Ohne positive oder negative Einflüsse beträgt die Produktivität eines Gebäudes 0%. Der Einfluss ist sowohl abhängig von der Entfernung zu dem jew. Gebäude welches dieses Gebäude beeinflusst, als auch von dessen Kapazität bzw. Auslastung.
		Sind mehrere beeinflussende Gebäude innerhalb des <u>max. Einflussradius</u> so addieren sich die Einflüsse (wieder jew. Abhängig von Entfernung/Kapazität/Auslastung).
		Die minimal- bzw. maximal-Werte die bei <u>Einfluss Grenzwert insgesammt</u> aufgelistet sind, können unabhängig davon wieviele beeinflussunde Gebäude ihren
		Einfluss auswirken, <b>nie</b> unter- bzw. überschritten werden.
	</span>
</div>

<%@ include file="/pages/include/ajax-footer.jsp" %>