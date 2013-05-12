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
	$(".${ns}").tooltip();
});
</script>

<style>
.${ns} img { float:left; padding-right: 10px; max-width: 300px; }
.${ns} > div { width: 900px; }
.${ns} table td { border-top: 1px solid #333; }
.${ns} table th, .${ns} table td { padding-right: 15px; }
.${ns} table { border-collapse: collapse; width:890px; }
.${ns} td.dn_einfluss, .${ns} th.dn_einfluss { background-color: #222; }
.${ns} .cn_hinweis { font-style: italic; color:#777; }
.${ns} .cn_label, .${ns} th { white-space: nowrap; }

</style>

<c:set var="hinweis">
	*) Ohne positive oder negative Einflüsse beträgt die Produktivität eines Gebäudes 0%. Der Einfluss ist sowohl abhängig von der Entfernung zu dem jew. Gebäude welches dieses Gebäude beeinflusst, als auch von dessen Kapazität bzw. Auslastung.
	Sind mehrere beeinflussende Gebäude innerhalb des max. Einflussradius so addieren sich die Einflüsse (wieder jew. Abhängig von Entfernung/Kapazität/Auslastung).
	Die minimal- bzw. maximal-Werte die bei 'Einfluss Grenzwert insgesammt' aufgelistet sind, können unabhängig davon wieviele beeinflussunde Gebäude ihren
	Einfluss auswirken, nie unter- bzw. überschritten werden.
</c:set>

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

	<c:set var="t_wirdBeeinflusst" value="false"/>
	<c:forEach items="${list}" var="row">
		<c:if test="${ row.aTyp.id == modell.typ.id  or ( not empty modell.produkt and row.aProdukt.id == modell.produkt.id ) }">
			<c:set var="t_wirdBeeinflusst" value="true"/>
		</c:if>
	</c:forEach>
			
	<c:if test="${ t_wirdBeeinflusst eq 'true' }">
		<table>
			<tr>
				<th colspan="5">
					<h2>Gebäude, die die Produktivität dieses Gebäudes beeinflussen:</h2>
				</th>
			</tr>
			<tr>
				<th>Wird beeinflusst durch folgende<br/>Gebäude abhängig ihrer Entfernung</th>
				<th align="right" class="dn_einfluss" title="${hinweis}"><nobr>*max. Einfluss<br/>&nbsp;pro Gebäude</nobr></th>
				<th align="right" title="${hinweis}">*Einfluss<br/>Grenzwert insgesammt</th>
				<th align="right" title="${hinweis}">*max. <br/>Einfluss-<br/>radius</th>
				<th><br/><br/>Hinweis</th>
				
			</tr>
			<c:forEach items="${list}" var="row">
				<c:if test="${ row.aTyp.id == modell.typ.id  or ( not empty modell.produkt and row.aProdukt.id == modell.produkt.id ) }">
					<tr>
						<td>${ not empty row.bProdukt ? '<span class="cn_label">Alle Fabriken folgenden Produktes:</span><br/>':'<span class="cn_label">Alle Gebäude der Kategorie:</span><br/>'} ${ not empty row.bProdukt ? row.bProdukt.bezeichnung : row.bTyp.bezeichnung }</td>
						<td align="right" class="dn_einfluss">${ row.einfluss > 0 ?'+':'' }${ row.einfluss }% ${row.id}</td>
						<td align="right">
							<span class="cn_label">Max. Auswirkung:</span> 
							<c:if test="${ row.minEinfluss != 0}"> ${ row.minEinfluss }% </c:if>
							<c:if test="${ row.maxEinfluss != 0}"> </span> ${ row.maxEinfluss }% </c:if>
						</td>
						<td align="right">${ row.radius }</td>
						<td>${ row.beschreibung }</td>
					</tr>
				</c:if>
			</c:forEach>
		</table>
		<br/>
	</c:if>
	
	
	
	
	
	
	
	
	

	<c:set var="t_beeinflusstAndere" value="false"/>
	<c:forEach items="${list}" var="row">
		<c:if test="${ row.bTyp.id == modell.typ.id  or ( not empty modell.produkt and row.bProdukt.id == modell.produkt.id ) }">
			<c:set var="t_beeinflusstAndere" value="true"/>
		</c:if>
	</c:forEach>
			
	<c:if test="${ t_beeinflusstAndere eq 'true' }">
		<table>
			<tr>
				<th colspan="5">
					<h2>Gebäude, dessen Produktivität durch dieses Gebäudes beeinflusst wird:</h2>
				</th>
			</tr>
			<tr>
				<th>Gebäude welche von diesem <br/>beeinflusst werden, abhängig<br/> ihrer Entfernung</th>
				<th align="right" class="dn_einfluss" title="${hinweis}">*max. Einfluss<br/>&nbsp;pro Gebäude</th>
				<th align="right" title="${hinweis}">*Einfluss<br/>Grenzwert insgesammt</th>
				<th align="right" title="${hinweis}">*max. <br/>Einfluss-<br/>radius</th>
				<th><br/><br/>Hinweis</th>
			</tr>
			<c:forEach items="${list}" var="row">
				<c:if test="${ row.bTyp.id == modell.typ.id  or ( not empty modell.produkt and not empty row.bProdukt.id and row.bProdukt.id == modell.produkt.id ) }">
					<tr>
						<td>${ not empty row.aProdukt ? '<span class="cn_label">Alle Fabriken folgenden Produktes:</span><br/>':'<span class="cn_label">Alle Gebäude der Kategorie:</span><br/>'} ${ not empty row.aProdukt ? row.aProdukt.bezeichnung : row.aTyp.bezeichnung }</td>
						<td align="right" class="dn_einfluss">${ row.einfluss > 0 ?'+':'' }${ row.einfluss }% ${row.id}</td>
						<td align="right">
							<span class="cn_label">Max. Auswirkung:</span> 
							<c:if test="${ row.minEinfluss != 0}"> ${ row.minEinfluss }% </c:if>
							<c:if test="${ row.maxEinfluss != 0}"> </span> ${ row.maxEinfluss }% </c:if>
						</td>
						<td align="right">${ row.radius }</td>
						<td>${ row.beschreibung }</td>
					</tr>
				</c:if>
			</c:forEach>
		</table>
		<br/>
	</c:if>
	
	
	

	
</div>

<%@ include file="/pages/include/ajax-footer.jsp" %>