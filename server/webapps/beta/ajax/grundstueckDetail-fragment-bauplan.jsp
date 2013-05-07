<div>
	<span class="cn_label">Ausgewählter Bauplan:</span>
	<div>
		<% request.setAttribute("t_modell",Cache.get().getModell( (Integer)session.getAttribute("selModellId")) );  %>
		<span class="cn_value">${t_modell.bezeichnung}</span><br/>
		<span class="cn_label">Kapazität:</span> <b>${t_modell.kapazitaet}</b><br/>

		<c:choose>
			<c:when test="${ g.besitzer.id != userId }">
				<span class="cn_label">Baukosten:</span>
				<span class="cn_value" title="Die Baukosten bestehen aus ${t_modell.baukosten} Kosten für die Gebäudeerrichtung zuzüglich ${s.nutzer.bauplatzKosten} für den Bauplatz.">
					<b>${t_modell.baukosten + s.nutzer.bauplatzKosten}</b>
				</span><br/>
					<span class="cn_label">Bauplatzkosten:</span>
					<span class="cn_value" title="Die Bauplatzkosten sind eine Abgabe an die Stadt welche höher wird, je mehr Bauplätze / Grundstücke bebaut sind. Dadurch können Großgrundbesitzer die mittelständigen Firmen nicht ohne weiteres verdrängen.">
						${s.nutzer.bauplatzKosten}
					</span><br/>
				<br/>
			</c:when>
			<c:otherwise>
				<span title="Die Baukosten bestehen aus ${t_modell.baukosten} Kosten für die Gebäudeerrichtung. Da der Bauplatz bereits Ihnen gehört, fallen keine Bauplatzkosten an.">
					<span class="cn_label">Baukosten:</span> <b>${t_modell.baukosten}</b>
				</span><br/>
			</c:otherwise>
		</c:choose>
		<img class='dn_modell dn_modell_${t_modell.id}' src='../resources/modelle/${t_modell.id}/thumbnail.gif' title="Vorschau auf Gebäude dieses Bauplans"/><br/>
		<span class="cn_label">Typ/Produkt:</span> <br/>
		${t_modell.typ.bezeichnung} <c:if test="${not empty t_modell.produkt}">	/ ${t_modell.produkt.bezeichnung} </c:if><br/><br/>
		<a href="javascript:;" class="dn_gebaeudeErrichten" title="Den ausgewählten Bauplan an dieser Stelle zum Bau beauftragen? Hierfür fallen die oben aufgeführten Kosten an.">
			<%= g==null?"Bau":"Umbau" %> beauftragen
		</a><br/><br/>
		<a href="modell-auswahl.jsp" title="Wenn Sie einen anderes Gebäude bauen möchten als derzeit ausgewählt, können Sie hierfür einen anderen Bauplan auswählen.">
			Anderer Bauplan
		</a>
		<br/>
		<br/>

	</div>
</div>