<%@page import="org.colony.data.Typ"%>
<%@page import="org.colony.data.Modell"%>
<%@ page pageEncoding="UTF-8"%>
<%@page import="org.colony.lib.ContextListener"%>
<% request.setAttribute("ns", request.getServletPath().replaceAll("/", "_").replaceAll("\\.jsp", "")); %>
<div class="${ns}">
	<script>
	$(function()
	{
		$("._ajax_modellAuswahlDialog a").click(function(e)
		{
			$.getJSON('../json/saveGebaeude.jsp?modellId='+$(this).attr("data_id")+'&x=<%= request.getParameter("x") %>&y=<%= request.getParameter("y") %>', function(data2) 
			{
				if(data2 && data2["errorMessage"])
				{
					alert(data2["errorMessage"]);
				}
				else
				{
					draw();
					$( ".cn_dialogMessage" ).dialog( "close" );
				}
			});
		});
	});
	</script>
	Position: <%= request.getParameter("x") %> | <%= request.getParameter("y") %><br/>
	<%
	if("true".equals(request.getParameter("umbau")))
	{ %>
	<i>Da dieses Grundstück bereits Ihnen gehört, fallen keine zusätzlichen Bauplatzkosten an.</i><br/>
	<%
	}
	else
	{
	%>
	Bauplatzkosten: <%= ContextListener.getService().getNutzer(session).getBauplatzKosten() %><br/>
	<%
	}%>
	
		<%
		Typ lastTyp = null;
		for( Modell m : ContextListener.getService().getModellListe() )
		{
			if(m.getTyp()!=lastTyp)
			{
				if(lastTyp!=null)
					out.println("</div>");

				out.println("<div class='dn_modellAuswahlTyp'><h3>"+m.getTyp().getBezeichnung()+"</h3>");
			}
			lastTyp = m.getTyp();
			
			int kosten = m.getBaukosten()+ContextListener.getService().getNutzer(session).getBauplatzKosten();
			if("true".equals(request.getParameter("umbau")))
				kosten = m.getBaukosten();
			
// 			out.println("<br/>");
			out.println("<table><tr><td> <img src='../resources/modelle/"+m.getId()+"/thumbnail.gif'/></td><td>"+m.getBezeichnung()+"<br/>");
			out.println("Kapazität: "+m.getKapazitaet());
			out.println("<br/>Kosten:  <span class='" + (kosten < ContextListener.getService().getNutzer(session).getKontostand()?"dn_bezahlbar":"dn_unbezahlbar") + "'>"+kosten+"</span>");
			out.println(" <a href='javascript:;' data_id='"+m.getId()+"'> <br/>Hier bauen</a> ("+m.getStockwerke()+" x "+m.getBreite()+" x "+m.getTiefe()+") <br/>");
			out.println("<br/>");
			if(m.getProdukt()!=null)
			{
				out.println(""+m.getProdukt().getBezeichnung()+"<br/>");
			}
			else out.println("");
			out.println("</td></tr></table>");

		}
		
	%>
	</div>
	
	
<!-- 	<table> -->
<!-- 	<tr> -->
<!-- 		<th/> -->
<!-- 		<th>Baukosten</th> -->
<!-- 		<th>Kapazität</th> -->
<!-- 		<th>Typ</th> -->
<!-- 		<th>Bauplan</th> -->
<!-- 		<th>H x B x T</th> -->
<!-- 		<th>Produktion</th> -->
<!-- 	</tr> -->
	<%
// 		for( Modell m : ContextListener.getService().getModellListe() )
// 		{
// 			int kosten = m.getBaukosten()+ContextListener.getService().getNutzer(session).getBauplatzKosten();
// 			if("true".equals(request.getParameter("umbau")))
// 				kosten = m.getBaukosten();
// 			out.println("<tr class='" + (kosten < ContextListener.getService().getNutzer(session).getKontostand()?"dn_bezahlbar":"dn_unbezahlbar") + "'>");
// 			out.println("<td><a href='javascript:;' data_id='"+m.getId()+"'>Hier bauen</a></td>");
// 			out.println("<td>"+(kosten)+"</td>");
// 			out.println("<td>"+m.getKapazitaet()+"</td>");
// 			out.println("<td>"+m.getTyp().getBezeichnung()+"</td>");
// 			out.println("<td>"+m.getBezeichnung()+"</td>");
// 			out.println("<td>"+m.getStockwerke()+" x "+m.getBreite()+" x "+m.getTiefe()+"</td>");
// 			if(m.getProdukt()!=null)
// 			{
// 				out.println("<td>"+m.getProdukt().getBezeichnung()+"</td>");
// 			}
// 			else out.println("<td></td>");
// 			out.println("</tr>");

// 		}
%>
<!-- 	</table> -->
</div>