<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/page-header.jsp" %>
<script>
	<%
	int selGrundstueckX = 0;
	int selGrundstueckY = 0;
	if(session.getAttribute("selGrundstueckX")!=null) selGrundstueckX=(Integer)session.getAttribute("selGrundstueckX");
	if(session.getAttribute("selGrundstueckY")!=null) selGrundstueckY=(Integer)session.getAttribute("selGrundstueckY");
	if(request.getParameter("x")!=null) selGrundstueckX=Integer.parseInt(request.getParameter("x"));
	if(request.getParameter("y")!=null) selGrundstueckY=Integer.parseInt(request.getParameter("y"));
	%>
	var sektorId = <%= (request.getParameter("sektorId")!=null)?request.getParameter("sektorId"):"1" %>;
	var userId =  <%= session.getAttribute("userId") %>;
	var selGrundstueckX= <%= selGrundstueckX %>;
	var selGrundstueckY= <%= selGrundstueckY %>;
	var selModellId = false;
	<%
	if(request.getParameter("selModellId")!=null)
	{
		session.setAttribute("selModellId",Integer.parseInt(request.getParameter("selModellId")));
		%>
		selModellId="<%= request.getParameter("selModellId") %>";
		<%
	}
	%>
	selPosX = selGrundstueckX;
	selPosY = selGrundstueckY;
</script>
<script src="../js/pages/karte.js"></script>
<div id="mapBox">
	<canvas id="map" width="1200" height="600"></canvas>
	<div class="sidebar"></div>
	<div class="dn_kartenoptionen">
		Zeige:
		<input type="checkbox" name="showTyp" checked="checked" id="${ns}_showTyp"/><label for="${ns}_showTyp">Gebäudekategorie</label>
<%-- 		<input type="checkbox" name="showEffizienz" checked="checked" id="${ns}_showEffizienz"/><label for="${ns}_showEffizienz">Effizienz</label> --%>
		<input type="checkbox" name="showKapazitaet" id="${ns}_showKapazitaet"/><label for="${ns}_showKapazitaet">Kapazität</label>
		<input type="checkbox" name="showId" checked="checked" id="${ns}_showId"/><label for="${ns}_showId">Bauplan-Nr.</label>
	</div>
</div>


<%@ include file="include/page-footer.jsp" %>
