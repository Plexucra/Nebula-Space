<%@page import="org.colony.lib.S"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/page-header.jsp" %>
<script>
	<%
	int selPosX = NutzerService.getNutzer(session).getHeimatPlanet().getX();
	int selPosY = NutzerService.getNutzer(session).getHeimatPlanet().getY();
	if(session.getAttribute("selPosX")!=null) selPosX=(Integer)session.getAttribute("selPosX");
	if(session.getAttribute("selPosY")!=null) selPosY=(Integer)session.getAttribute("selPosY");
	if(request.getParameter("x")!=null) selPosX=Integer.parseInt(request.getParameter("x"));
	if(request.getParameter("y")!=null) selPosY=Integer.parseInt(request.getParameter("y"));
	%>
	var sektorId = <%= (request.getParameter("sektorId")!=null)?request.getParameter("sektorId"):"1" %>;
	var userId =  <%= session.getAttribute("userId") %>;
	var selPosX= <%= selPosX %>;
	var selPosY= <%= selPosY %>;
	var selFlotteId = false;
	<%
	if(request.getParameter("selFlotteId")!=null)
	{
		session.setAttribute("selFlotteId",Integer.parseInt(request.getParameter("selFlotteId")));
		%>
		selFlotteId="<%= request.getParameter("selFlotteId") %>";
		<%
	}
	%>
</script>
<script src="../js/pages/nebula.js"></script>
<div id="mapBox">
	<canvas id="map" width="1200" height="600"></canvas>
	<div class="sidebar">
	</div>
</div>


<%@ include file="include/page-footer.jsp" %>
