<div>
	<span class="cn_label">Ausgew�hlter Bauplan:</span>
	<div>
		<% request.setAttribute("t_modell",Cache.get().getModell( (Integer)session.getAttribute("selModellId")) );  %>
		<span class="cn_value">${t_modell.bezeichnung}</span><br/>
		<span class="cn_label">Kapazit�t:</span> <b>${t_modell.kapazitaet}</b><br/>

		<c:choose>
			<c:when test="${ g.besitzer.id != userId }">
				<span class="cn_label">Baukosten:</span>
				<span class="cn_value" title="Die Baukosten bestehen aus ${t_modell.baukosten} Kosten f�r die Geb�udeerrichtung zuz�glich ${s.nutzer.bauplatzKosten} f�r den Bauplatz.">
					<b>${t_modell.baukosten + s.nutzer.bauplatzKosten}</b>
				</span><br/>
					<span class="cn_label">Bauplatzkosten:</span>
					<span class="cn_value" title="Die Bauplatzkosten sind eine Abgabe an die Stadt welche h�her wird, je mehr Baupl�tze / Grundst�cke bebaut sind. Dadurch k�nnen Gro�grundbesitzer die mittelst�ndigen Firmen nicht ohne weiteres verdr�ngen.">
						${s.nutzer.bauplatzKosten}
					</span><br/>
				<br/>
			</c:when>
			<c:otherwise>
				<span title="Die Baukosten bestehen aus ${t_modell.baukosten} Kosten f�r die Geb�udeerrichtung. Da der Bauplatz bereits Ihnen geh�rt, fallen keine Bauplatzkosten an.">
					<span class="cn_label">Baukosten:</span> <b>${t_modell.baukosten}</b>
				</span><br/>
			</c:otherwise>
		</c:choose>
		<img class='dn_modell dn_modell_${t_modell.id}' src='../resources/modelle/${t_modell.id}/thumbnail.gif' title="Vorschau auf Geb�ude dieses Bauplans"/><br/>
		<span class="cn_label">Typ/Produkt:</span> <br/>
		${t_modell.typ.bezeichnung} <c:if test="${not empty t_modell.produkt}">	/ ${t_modell.produkt.bezeichnung} </c:if><br/><br/>
		<a href="javascript:;" class="dn_gebaeudeErrichten" title="Den ausgew�hlten Bauplan an dieser Stelle zum Bau beauftragen? Hierf�r fallen die oben aufgef�hrten Kosten an.">
			<%= g==null?"Bau":"Umbau" %> beauftragen
		</a><br/><br/>
		<a href="modell-auswahl.jsp" title="Wenn Sie einen anderes Geb�ude bauen m�chten als derzeit ausgew�hlt, k�nnen Sie hierf�r einen anderen Bauplan ausw�hlen.">
			Anderer Bauplan
		</a>
		<br/>
		<br/>

	</div>
</div>