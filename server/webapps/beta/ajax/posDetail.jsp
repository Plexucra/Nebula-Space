<%@page import="org.colony.data.Planet"%>
<%@page import="org.colony.service.FlottenService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ include file="/pages/include/ajax-header.jsp" %>
<%@ page pageEncoding="UTF-8"%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="org.colony.data.Gebaeude"%>
<%@page import="org.colony.data.Typ"%>
<%@page import="org.colony.data.Modell"%>
<%@page import="org.colony.lib.S"%>
<%
	session.setAttribute("selPosX",s.getInt("x"));
	session.setAttribute("selPosY",s.getInt("y"));
	request.setAttribute("flotten", FlottenService.getFlotten(s.getInt("x"), s.getInt("y")));
	if(request.getParameter("selFlotteId")!=null && request.getParameter("selFlotteId").trim().length()>0)
	{
		session.setAttribute("selFlotteId",request.getParameter("selFlotteId"));
	}
	if(session.getAttribute("selFlotteId")!=null)
	{
		String sids = (String)session.getAttribute("selFlotteId");
		if(sids.trim().length()>0 && !"false".equals( sids.trim()))
		{
			List<Integer> ids = new ArrayList<Integer>();
			for(String id : sids.split(","))
				ids.add(Integer.parseInt(id));
			if("sendeSelFlotte".equals(request.getParameter("action")))
			{
				session.setAttribute("sendeSelFlotte", null);
				FlottenService.updateFlotten(ids, s.getNutzer(), s.getInt("x"), s.getInt("y"));
			}
			else
			{
				request.setAttribute("selFlotte",FlottenService.getFlotten(ids, s.getNutzer()));
			}
		}
	}
%>
	<script>
		$(function()
		{
			
			var lactive = 0;
			var i=0;
			$(".${ns} > div > h3").each(function()
			{
				if($(this).hasClass("dn_active"))
					lactive = i;
				i++;
			});
			$("span[title]").append($("<span class='ui-icon ui-icon-extlink'/>").css("display","inline-block"));
			
		    $( ".${ns} > div" ).accordion({ active:lactive, heightStyle: "content" });
		    $( ".${ns} a.cn_button").button();
		    $( ".${ns}" ).tooltip();
			
			$("."+ns+" .sidebar .dn_folder > div").hide();
			$("."+ns+" .sidebar .dn_folder > h3").click(function(){ $(this).parent().children("div").toggle("slow"); });
			$(".${ns} .cn_aktionsleiste").hide();
// 			$(".${ns}_flottenliste").buttonset();
			$(".${ns}_flottenliste input").button({ icons: { primary: "ui-icon-check" }, text: false }).click(function() 
			{
				var count = 0;
				$(".${ns}_flottenliste input").each(function()
				{
					if($(this).prop('checked')) count++;
				});
				
				if(count==0)
				{
					$(".${ns} .cn_aktionsleiste").hide();
				}
				else
				{
					$(".${ns} .cn_aktionsleiste").fadeIn();
					if(count!=1) $(".${ns} .cn_aktionsleiste a.dn_teilen").button( "option", "disabled", true );
					if(count < 2) $(".${ns} .cn_aktionsleiste a.dn_vereinen").button( "option", "disabled", true );
				}
			});
			
			$(".${ns} .cn_aktionsleiste a.dn_senden").click(function()
			{
				var selIds = "";
				$(".${ns}_flottenliste input").each(function()
				{
					if($(this).prop('checked'))
					{
						if(selIds!="") selIds+",";
						selIds+=$(this).val();
					}
				});
				location.replace("nebula.jsp?selFlotteId=" + selIds);
			});
			
			
			$(".${ns} a.dn_versenden").click(function()
			{
				$.get('../ajax/posDetail.jsp?x=<%=s.getInt("x")%>&y=<%=s.getInt("y")%>&action=sendeSelFlotte', function(data2) 
				{
					$("."+ns+" .sidebar").html(data2);
				});
			});
			
			
		});
	</script>
<div>
	<h3>Positionsinfo</h3>
	<div>
		<span class="cn_label">Position:</span>
		<span class="cn_value">${param['x']}:${param['y']}</span>

		<%
		{
			int posX = s.getInt("x");
			int posY = s.getInt("y");
			for(Planet p : S.s().getPlaneten().values())
			{
				if(posX==p.getX() && posY==p.getY())
				{
					%>
					<br/>
					<img src="${up}/css/default_thema/images/spezies/planet<%= p.getId() %>.jpg"/><br/>
					<span class="cn_label">Planet:</span> <span class="cn_value"><%= p.getName() %></span><br/>
					<span class="cn_label">Spezies:</span> <span class="cn_value"><%= p.getSpezies() %></span><br/>
					<%
				}
			}
		}
		%>

		<c:if test="${ not empty flotten  }">
			<br/>
			<span class="cn_label">Flotten:</span><br/>
		</c:if>
		<div class="cn_aktionsleiste">
			<span class="cn_label">Optionen für Auswahl:</span>
			<a class="dn_senden cn_button" href="javascript:;" title="Flotte(n) vormerken, um sie nach klick auf andere Koordinaten verschicken zu können.">Flotte(n) vormerken</a>
			<a class="dn_teilen cn_button" href="modell-auswahl.jsp" title="Die ausgewählte Flotte aufteilen / neue/weitere Flotte aus dieser abspalten..">Flotte aufteilen</a>
			<a class="dn_vereinen cn_button" href="modell-auswahl.jsp" title="Die ausgewählten Flotten werden zu einer einzigen großen Flotte zusammengefügt">Flotten vereinen</a>
		</div>

		<div class="${ns}_flottenliste">
			<table>

				<c:forEach items="${ flotten }" var="row">
					<tr>
						<td>
							<c:if test="${userId eq row.besitzer.id}">
								<input type="checkbox" value="${row.id}" id="flottenchecker${row.id}"/>
								<label for="flottenchecker${row.id}">Diese Flotte für weitere Optionen auswählen..</label>
							</c:if>
						</td>
						<td>${row.besitzer.alias}'s Flotte ${row.id}</td>
					</tr>
					<c:if test="${userId eq row.besitzer.id}">
						<c:if test="${row.sprungAufladung != -1}">
							<tr>
								<td colspan="2">
									Sprung in: <f:time ticks="${row.sprungAufladung}"/><br/>
									Flugziel: <a href="nebula.jsp?x=${row.zielX}&y=${row.zielY}">${row.zielX}:${row.zielY}</a></td>
							</tr>
						</c:if>
						
						<c:forEach items="${ row.geschwader }" var="geschwader">
							<tr>
								<td colspan="2">
									${ geschwader.anzahl } 
									${ geschwader.schiffsmodell.bezeichnung }
									
								</td>
							</tr>
						</c:forEach>
					</c:if>
				</c:forEach>
			</table>
		</div>
	</div>

	<c:if test="${ not empty selFlotte }">
		<h3>Ausgewählte Flotten</h3>
		<div>
			<div class="${ns}_flottenliste">
				<table>
					<tr>
						<th>Besitzer</th>
						<th>Ziel</th>
						<th><span title="Sprung erfolgt in .. Ticks">S</span></th>
					</tr>
					<c:forEach items="${ selFlotte }" var="row">
						<tr>
							<td>${row.besitzer.alias}</td>
							<td>${row.zielX}:${row.zielY}</td>
							<td>${row.sprungAufladung}</td>
						</tr>
						<c:forEach items="${ row.geschwader }" var="geschwader">
							<tr>
								<td colspan="4">
									${ geschwader.anzahl } 
									${ geschwader.schiffsmodell.bezeichnung }
								</td>
							</tr>
						</c:forEach>
					</c:forEach>
				</table>
			</div>
			<br/>
			<a class="dn_versenden cn_button" href="javascript:;" title="Die ausgewählten Flotten versenden..">hierhin versenden</a>
			<br/>
			<br/>
		</div>
	</c:if>

</div>
<%@ include file="include/ajax-footer.jsp" %>