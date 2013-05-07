<%@page import="org.colony.service.NutzerService"%>
<%@page import="org.colony.lib.Cache"%>
<%@ page pageEncoding="UTF-8"%>
<%@page import="org.colony.data.Produkt"%>
<%@page import="org.colony.data.Typ"%>
<%@page import="org.colony.data.Modell"%>
<%@ include file="include/page-header.jsp" %>
<%@page import="org.colony.lib.ContextListener"%>
	<style>
	.dn_modellAuswahlTyp td
	{
		width: 120px;
	}
	</style>
	<%
	if("true".equals(request.getParameter("umbau")))
	{ %>
	<i>Da dieses Grundstück bereits Ihnen gehört, fallen keine zusätzlichen Bauplatzkosten an.</i><br/>
	<%
	}
	else
	{
	%>
	Bauplatzkosten: <%= NutzerService.getNutzer(session).getBauplatzKosten() %><br/>
	<%
	}%>
	
		<%
		Typ lastTyp = null;
		Produkt lastProdukt = null;
		for( Modell m : Cache.get().getModellListe() )
		{
			pageContext.setAttribute("t_m", m);
			if(m.getTyp()!=lastTyp || m.getProdukt()!=lastProdukt)
			{
				if(lastTyp!=null)
					out.println("</tr></table></div>");
				if(m.getProdukt()!=null)
					out.println("<div class='dn_modellAuswahlTyp'><h3>"+m.getProdukt().getBezeichnung()+" ("+m.getTyp().getBezeichnung()+")</h3><table><tr>");
				else
					out.println("<div class='dn_modellAuswahlTyp'><h3>"+m.getTyp().getBezeichnung()+"</h3><table><tr>");
					
			}
			lastTyp = m.getTyp();
			lastProdukt = m.getProdukt();			
			int kosten = m.getBaukosten()+NutzerService.getNutzer(session).getBauplatzKosten();
			if("true".equals(request.getParameter("umbau")))
				kosten = m.getBaukosten();
			
			out.println("<td><a href='karte.jsp?selModellId="+m.getId()+"'><img class='dn_modell' src='../resources/modelle/"+m.getId()+"/thumbnail.gif'/></a></td><td>"+m.getBezeichnung()+"<br/>");
			out.println("<span class='cn_label'>Kapazität:</span> "+m.getKapazitaet());
			out.println("<br/><span class='cn_label'>Kosten:</span>  <span class='" + (kosten < NutzerService.getNutzer(session).getKontostand()?"dn_bezahlbar":"dn_unbezahlbar") + "'>"+kosten+"</span>");
			%>
<%-- 				(${t_m.stockwerke} x ${t_m.breite} x ${t_m.tiefe})  --%>
				<br/>
				<a href="karte.jsp?selModellId=${t_m.id}"> Auswählen</a><br/>
			<%
// 			out.println(" <a href='karte.jsp?selModellId="+m.getId()+"' data_id='"+m.getId()+"'> <br/>Auswählen</a> ("+m.getStockwerke()+" x "+m.getBreite()+" x "+m.getTiefe()+") <br/>");
			out.println("<br/>");
			if(m.getProdukt()!=null)
			{
				out.println(""+m.getProdukt().getBezeichnung()+"<br/>");
			}
			else out.println("");
			out.println("</td>");

		}
		
	%>
	</tr></table></div>
	


<%@ include file="include/page-footer.jsp" %>
