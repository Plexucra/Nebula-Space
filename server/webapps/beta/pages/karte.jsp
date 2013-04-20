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
// 		alert("Zum Bauen eines Gebäudes auf Grundlage des gewählten Bauplanes wählen Sie nun bitte ein unbebautes Grundstück aus, welches direkt an ein bebautes angrenzt und klicken anschließend auf 'Gebäude hier errichten'.")
		<%
	}
	%>
</script>
<script src="../js/pages/karte.js"></script>
<div id="mapBox">
	<canvas id="map" width="1200" height="600"></canvas>
	<div class="sidebar">
	</div>
</div>


<%@ include file="include/page-footer.jsp" %>
