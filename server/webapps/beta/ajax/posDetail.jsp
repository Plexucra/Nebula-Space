<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ include file="include/ajax-header.jsp" %>
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
	request.setAttribute("flotten", s.service().getFlotten(s.getInt("x"), s.getInt("y")));
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
				s.service().updateFlotten(ids, s.getNutzer(), s.getInt("x"), s.getInt("y"));
			}
			else
			{
				request.setAttribute("selFlotte",s.service().getFlotten(ids, s.getNutzer()));
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
		    $( ".${ns} a").button();
		    $( ".${ns}" ).tooltip();
			
			$("."+ns+" .sidebar .dn_folder > div").hide();
			$("."+ns+" .sidebar .dn_folder > h3").click(function(){ $(this).parent().children("div").toggle("slow"); });
			$(".${ns} .cn_aktionsleiste").hide();
			$(".${ns}_flottenliste").buttonset();
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
				alert("d");
				$.get('../ajax/posDetail.jsp?x=<%=s.getInt("x")%>&y=<%=s.getInt("y")%>&action=sendeSelFlotte', function(data2) 
				{
					$("."+ns+" .sidebar").html(data2);
				});
			});
			
			
		});
	</script>
<div>
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
			<a class="dn_versenden" href="javascript:;" title="Die ausgewählten Flotten versenden..">hierhin versenden</a>
			<br/>
			<br/>
		</div>
	</c:if>


	<h3>Flotten</h3>
	<div>
		<span class="cn_label">Position:</span>
		<span class="cn_value">${param['x']}:${param['y']}</span>

		<div class="cn_aktionsleiste">
			<span class="cn_label">Optionen für Auswahl:</span>
			<a class="dn_senden" href="javascript:;" title="Flotte(n) vormerken, um sie nach klick auf andere Koordinaten verschicken zu können.">Flotte(n) vormerken</a>
			<a class="dn_teilen" href="modell-auswahl.jsp" title="Die ausgewählte Flotte aufteilen / neue/weitere Flotte aus dieser abspalten..">Flotte aufteilen</a>
			<a class="dn_vereinen" href="modell-auswahl.jsp" title="Die ausgewählten Flotten werden zu einer einzigen großen Flotte zusammengefügt">Flotten vereinen</a>
		</div>

		<div class="${ns}_flottenliste">
			<table>
				<tr>
					<th></th>
					<th>Besitzer</th>
					<th>Ziel</th>
					<th><span title="Sprung erfolgt in .. Ticks">S</span></th>
				</tr>
				<c:forEach items="${ flotten }" var="row">
					<tr>
						<td>
							<input type="checkbox" value="${row.id}" id="flottenchecker${row.id}"/>
							<label for="flottenchecker${row.id}">Diese Flotte für weitere Optionen auswählen..</label>
						</td>
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
	</div>
</div>
<%@ include file="include/ajax-footer.jsp" %>