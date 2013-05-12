<%@page import="org.colony.service.NutzerService"%>
<%@page import="org.colony.lib.Cache"%>
<%@ page pageEncoding="UTF-8"%>
<%@page import="org.colony.data.Produkt"%>
<%@page import="org.colony.data.Typ"%>
<%@page import="org.colony.data.Modell"%>
<%@ include file="include/page-header.jsp" %>
<%@page import="org.colony.lib.ContextListener"%>


	<script>
		$(function()
		{
			$(".dn_modellAuswahlTyp > table").hide();
			$(".dn_modellAuswahlTyp > h3").css("cursor","pointer").click( function()
			{
				$(this).parent().children("table").toggle();
			});
		});
	</script>

	<style>
	.dn_modellAuswahlTyp td
	{
		width: 120px;
	}
	</style>
	
	<i>
		Bitte klicken Sie auf eine der Überschriften um den jew. Bereich aufzuklappen:
	</i><br/><br/>
	
	<%
	if("true".equals(request.getParameter("umbau")))
	{ %>
	<i>Da dieses Grundstück bereits Ihnen gehört, fallen keine zusätzlichen Bauplatzkosten an.</i><br/>
	<%
	}
	else
	{
	%>
<%-- 	Bauplatzkosten: <%= NutzerService.getNutzer(session).getBauplatzKosten() %><br/> --%>
	<%
	}%>
	
		<%
		Typ lastTyp = null;
		Produkt lastProdukt = null;
		int spaltencounter = 0;
		for( Modell m : Cache.get().getModellListe() )
		{
			spaltencounter++;
			pageContext.setAttribute("t_m", m);
			if(m.getTyp()!=lastTyp || m.getProdukt()!=lastProdukt)
			{
				spaltencounter = 0;
				if(lastTyp!=null)
					out.println("</tr></table></div>");
				if(m.getProdukt()!=null)
					out.println("<div class='dn_modellAuswahlTyp'><h3>"+m.getProdukt().getBezeichnung()+" <span class='cn_label'>("+m.getTyp().getBezeichnung()+")</span></h3><table><tr>");
				else
					out.println("<div class='dn_modellAuswahlTyp'><h3>"+m.getTyp().getBezeichnung()+"</h3><table><tr>");
			}
			if(spaltencounter >= 3)
			{
				out.println("</tr><tr>");
				spaltencounter = 0;
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
				<a class="cn_forward" href="javascript:;" onclick="showAjaxDialog('${up}/ajax/modellInfoDialog.jsp?modellId=<%= m.getId() %>')">Mehr Infos</a><br/>
				<a class="cn_forward" href="karte.jsp?selModellId=${t_m.id}"> Auswählen</a><br/>
			<%
// 			out.println(" <a href='karte.jsp?selModellId="+m.getId()+"' data_id='"+m.getId()+"'> <br/>Auswählen</a> ("+m.getStockwerke()+" x "+m.getBreite()+" x "+m.getTiefe()+") <br/>");
			out.println("<br/>");
// 			if(m.getProdukt()!=null)
// 			{
// 				out.println(""+m.getProdukt().getBezeichnung()+"<br/>");
// 			}
// 			else out.println("");
			out.println("</td>");

		}
		
	%>
	</tr></table></div>
	


<%@ include file="include/page-footer.jsp" %>
