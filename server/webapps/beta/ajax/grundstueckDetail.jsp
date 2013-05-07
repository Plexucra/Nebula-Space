<%@page import="org.colony.lib.Cache"%>
<%@page import="org.colony.service.GebaeudeService"%>
<%@page import="java.util.List"%>
<%@ include file="include/ajax-header.jsp" %>
<%@ page pageEncoding="UTF-8"%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="org.colony.data.Gebaeude"%>
<%@page import="org.colony.data.Typ"%>
<%@page import="org.colony.data.Modell"%>
<%@page import="org.colony.lib.S"%>
<%
	Gebaeude g =GebaeudeService.getGebaeude(s.getNutzer().getHeimatPlanet(), s.getInt("x"), s.getInt("y"));
	session.setAttribute("selGrundstueckX",s.getInt("x"));
	session.setAttribute("selGrundstueckY",s.getInt("y"));
	request.setAttribute("g", g);
%>
	<script>
		$(function()
		{
			
			var lactive = 0;
			var i=0;
			$(".${ns} > div > h3").each(function()
			{
				if($(this).hasClass("dn_active"))
					lactive = i;
				i++;
			});
			$("span[title]").append($("<span class='ui-icon ui-icon-extlink'/>").css("display","inline-block"));
			
		    $( ".${ns} > div" ).accordion({ active:lactive, heightStyle: "content" });
		    $( ".${ns} a").button();
		    $( ".${ns}" ).tooltip();
			
			$("."+ns+" .sidebar .dn_folder > div").hide();
			$("."+ns+" .sidebar .dn_folder > h3").click(function(){ $(this).parent().children("div").toggle("slow"); });
			$("."+ns+" .sidebar .dn_abreissen").click(function(e)
			{
				$.getJSON('../json/destroyGebaeude.jsp?x=<%=s.getInt("x")%>&y=<%=s.getInt("y")%>', function(data2) 
				{
					if(data2 && data2["errorMessage"])
						alert(data2["errorMessage"]);
					else
					{
						draw();
						$("."+ns+" .sidebar").html("Gebäude wurde abgerissen.");
					}
				});
			});
			$(".${ns} .dn_gebaeudeErrichten").click(function(e)
			{
				$.getJSON('../json/saveGebaeude.jsp?modellId=${selModellId}&x=<%=s.getInt("x")%>&y=<%=s.getInt("y")%>', function(data2) 
				{
					if(data2 && data2["errorMessage"])
					{
						alert(data2["errorMessage"]);
					}
					else
					{
						location.replace("karte.jsp");
					}
				});
			});

// 			$("."+ns+" .sidebar .dn_bauen").click(function(e)
// 			{
// 				var tDialog = $("<div class='cn_dialogMessage' title='Bauplan für Gebäude auswählen'></div>");
// 				$(this).append( tDialog );
// 				$(tDialog).append("p").html("Wird geladen..");
<%-- 				$.get('../ajax/modellAuswahlDialog.jsp?umbau=true&x=<%=s.getInt("x")%>&y=<%=s.getInt("y")%>', function(data2)  --%>
// 				{
// 					$(tDialog).append("p").html(data2);
// 				});
// 				$(tDialog).dialog({ width: 1200, height: 600, modal: true, buttons: {  "Schließen": function() { $( this ).dialog( "close" ); } } });
// 			});
		});
	</script>
<div>

	
<c:if test="${ empty g }">
	<%
		Gebaeude g2 = new Gebaeude();
		g2.setGrundstueckX(s.getInt("x"));
		g2.setGrundstueckY(s.getInt("y"));
		g2.setPlanet(s.getNutzer().getHeimatPlanet());
		List<Gebaeude> gs = GebaeudeService.getRelevanteGebaeude(g2);
		boolean hatNachbarn = true;
		
// 		if(gs!=null) for(Gebaeude tg : gs)
// 		{
// 			if( Math.abs(g2.getGrundstueckX()-tg.getGrundstueckX())<2 && Math.abs(g2.getGrundstueckY()-tg.getGrundstueckY())<2)
// 				hatNachbarn=true;
// 		}
		if(hatNachbarn)
		{
			Modell bestM = null;
			float bestE=0;
			for(Modell m : Cache.get().getModelle().values())
			{
				if(bestM==null) bestM = m;
				g2.setModell(m);
				float ef = s.service().getEffizienz(g2, gs);
				if(ef > bestE)
				{
					bestM = m;
					bestE = ef;
				}
			}
			request.setAttribute("bestM",bestM);
			request.setAttribute("bestE",bestE);
			%>
				<h3>Hinweis</h3>
				<div>
					Um ein Gebäude zu errichten, muss zunächst ein Bauplan ausgewählt werden.<br/>
					<br/>
					<a href="modell-auswahl.jsp">Bauplan auswählen</a>
					<br/><br/>
				</div>
				
				<c:if test="${ param['selModellId'] eq 'false' or empty param['selModellId'] }">
					<h3>Bauvorschlag</h3>
					<div>
						<span class="cn_label">Bauplan:</span> ${bestM.bezeichnung}<br/>
						<img class='dn_modell dn_modell_${g.modell.id}' src='../resources/modelle/${bestM.id}/thumbnail.gif'/><br/>
						<span class="cn_label">Typ:</span> ${bestM.typ.bezeichnung}<br/>
						<span class="cn_label">Kapazität:</span> ${bestM.kapazitaet}<br/>
						<span class="cn_label">geschätzte Effizienz:</span>
						<fmt:formatNumber type="percent" value="${bestE}"/><br/><br/>
						<a href="karte.jsp?selModellId=${bestM.id}">Vorschlag verwenden</a><br/><br/>
					</div>
				</c:if>
			<%
		}
		else
		{
			%>
				<h3>Hinweis</h3>
				<div>
					<i>Hier kann nicht gebaut werden. Bitte wählen Sie ein Grundstück in direkter Nachbarschaft zu bestehenden Gebäuden.</i><br/>
					<br/>
					<span class="cn_label">Hinweis:</span>
					<br/>
					Gebäude können nur in direkter Nachbarschaft(auch diagonal) zu bereits bestehenden Gebäuden gebaut werden.
					Anderenfalls ist der Anschluss an die Versorgungsnetze nicht sichergestellt.
				</div>
			<%
		}
	%>

</c:if>
<c:if test="${ not empty g }">
	<%
		request.setAttribute("einfluesse", s.service().getEinfluesse(g, null));
		request.setAttribute("effizienz", s.service().getEffizienz(g, null));
	 %>
	<h3>Markiertes Gebäude</h3>
	<div>
		<img class='dn_modell dn_modell_${g.modell.id}' src='../resources/modelle/${g.modell.id}/thumbnail.gif'/><br/>
		${g.modell.bezeichnung}<br/>
		<div class='cn_zusatz'>${g.modell.typ.bezeichnung}</div><br/>
		<c:choose>
			<c:when test="${ g.alter < 0 }">
				<b>Gebäude wird gebaut..</b><br/><br/>
				<span class="cn_label">Fortschritt:</span> <%= Math.round(  (((float)g.getModell().getBauzeit()+(float)g.getAlter()) / (float)g.getModell().getBauzeit())*100f  )  %>%<br/>
				<span class="cn_label">Fertig in:</span> <%= g.getAlter()*-1 %> Ticks / <%= Math.round((g.getAlter()*-1)*s.getTicker().getDuration()/60000) %> min. <br/>
				<span class="cn_label">Fertig am:</span> <%= (new SimpleDateFormat("dd.MM.yy HH:mm")).format( new Date( System.currentTimeMillis()+(g.getAlter() * -1 * s.getTicker().getDuration() )))  %>
			</c:when>
			<c:otherwise>
				<span class="cn_label">Kapazität:</span>
				<span class="cn_value" title="Die Kapazität muss gut auf das Umfeld/Rahmenbedingungen abgestimmt sein. Überkapazitäten schmälern entscheidend den Gewinn.">${g.modell.kapazitaet}</span><br/>
				<span class="cn_label">Gewinn:</span>
				<span class="cn_value" title="Einnahmen - Ausgaben">${g.einnahmen - g.ausgaben}</span><br/>
				<span class="cn_label">Einnahmen:</span> ${g.einnahmen} <br/>
				<c:choose>
					<c:when test="${ g.modell.typ.id == 7 }">
						<span class="cn_label">Ausgaben:</span> ${g.ausgaben} <br/>
						<span class="cn_label">Schiff fertiggestellt:</span> <fmt:formatNumber type="percent" value="${g.auslastung/g.modell.kapazitaet}"/><br/>
						<span class="cn_label">Herstellungszeit:</span> <fmt:formatNumber value="${ (s.ticker.duration * g.modell.kapazitaet ) / 60000}"/> min
					</c:when>
					<c:when test="${ g.modell.typ.id == 3 }">
						<span class="cn_label">Ausgaben:</span> ${g.ausgaben} <br/>
						<span class="cn_label">Mieter:</span> ${g.auslastung} von max. ${g.modell.kapazitaet}<br/>
					</c:when>
					<c:when test="${ g.modell.typ.id == 2 }">
						<span class="cn_label">Ausgaben:</span>
						<span title="Instandhaltung: ${g.wartungskostenanteil}, Personalkosten: ${g.arbeitskostenanteil}, Produktion: ${g.auslastung}  Chargen"> ${g.ausgaben}</span>
						<br/>
					</c:when>
					<c:otherwise>
						<span class="cn_label">Ausgaben:</span> ${g.ausgaben} <br/>
					</c:otherwise>
				</c:choose>
		
				<span class="cn_label">${ g.modell.typ.id == 3 ?'Mietspiegel':'Produktivität'}:</span>
				<span class="cn_value" title="<c:forEach items="${ einfluesse }" var="row">
						<c:if test="${ row.currentEinfluss != 0 }">
						${ row.bBezeichnung }: ${ row.currentEinfluss>0?'+':'' }<fmt:formatNumber maxFractionDigits="1" value="${ row.currentEinfluss }"/>% |
						</c:if>
					</c:forEach>">
					<fmt:formatNumber type="percent" value="${ effizienz }"/>
				</span>
				<br/>
					
				
				<c:choose>
					<c:when test="${ g.besitzer.id == userId }">
						<br/><i>Dieses Gebäude ist Ihr Eigentum.</i><br/><br/>
						<a href='modell-auswahl.jsp' class='dn_modellAuswahl'>Gebäude ersetzen</a><br/><br/>
						<a href='javascript:;' class='dn_abreissen'>Gebäude abreißen</a><br/><br/>
					</c:when>
					<c:otherwise>
						Besitzer:<br/><i>${g.besitzer.alias}</i><br/><br/>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>


	</div>
</c:if>

<c:if test="${ not empty selModellId }">
	<h3 class="${  (param['selModellId'] ne 'false' and not empty param['selModellId'])?'dn_active':'' }">Ausgeählter Bauplan</h3>
	<div>
		<%@ include file="grundstueckDetail-fragment-bauplan.jsp" %>
	</div>
</c:if>





</div>
<%@ include file="include/ajax-footer.jsp" %>