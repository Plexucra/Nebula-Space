<%@page import="org.colony.lib.S"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/page-header.jsp" %>
<script>
	<%
	request.setAttribute("s", new S(request));
	int selPosX = S.s().getNutzer(session).getHeimatPlanet().getX();
	int selPosY = S.s().getNutzer(session).getHeimatPlanet().getY();
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
	
	$(function()
	{
		$("#menuDiv a[data='nebula']").addClass("cn_aktive");
		var d = $("<div/>");
		d.append( $("<a href='nebula.jsp' class='cn_aktive'>Nebula</a><span> | </span>") );
		d.append( $("<a href='nebula.jsp?x=${s.nutzer.heimatPlanet.x}&y=${s.nutzer.heimatPlanet.y}'>Springe zum Heimatplanet</a><span> | </span>") );
		d.append( $("<a href='nebula-flotten.jsp'>Meine Flotten</a>") );
		d.addClass("menuDiv_stage2");
		$("#menuLeftDiv").append(d);
		d.hide();
		d.slideDown();
	});
</script>
<script src="../js/pages/nebula.js"></script>
<div id="mapBox">
	<canvas id="map" width="1200" height="600"></canvas>
	<div class="sidebar">
	</div>
</div>


<%@ include file="include/page-footer.jsp" %>
