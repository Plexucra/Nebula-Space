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
	
	$(function()
	{
		
		var d = $("<div/>");
		d.append( $("<a data='nebula.jsp'>Übersicht</a><span> | </span>") );
		d.append( $("<a data='karte.jsp' class='cn_aktive'>Karte</a><span> | </span>") );
		d.append( $("<a data='forschung.jsp'>Meine Immobilien</a><span> | </span>") );
		d.append( $("<a data='forschung.jsp'>Gebäude bauen</a><span> | </span>") );
		d.addClass("menuDiv_stage2");
		$("#menuLeftDiv").append(d);
		d.children("a").attr("href","#");
		d.hide();
	//		d.show();
		d.slideDown();
	});

</script>
<script src="../js/pages/karte.js"></script>
<div id="mapBox">
	<canvas id="map" width="1200" height="600"></canvas>
	<div class="sidebar">
	</div>
</div>


<%@ include file="include/page-footer.jsp" %>
