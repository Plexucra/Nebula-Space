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
			<%--
			$("."+ns+" .sidebar .dn_abreissen").click(function(e)
			{
				$.getJSON('../json/destroyGebaeude.jsp?x=<%=s.getInt("x")%>&y=<%=s.getInt("y")%>', function(data2) 
				{
					if(data2 && data2["errorMessage"])
						alert(data2["errorMessage"]);
					else
					{
						draw();
						$("."+ns+" .sidebar").html("Gebäude wurde abgerissen.");
					}
				});
			});
			$(".${ns} .dn_gebaeudeErrichten").click(function(e)
			{
				$.getJSON('../json/saveGebaeude.jsp?modellId=${selModellId}&x=<%=s.getInt("x")%>&y=<%=s.getInt("y")%>', function(data2) 
				{
					if(data2 && data2["errorMessage"])
					{
						alert(data2["errorMessage"]);
					}
					else
					{
						location.replace("karte.jsp");
					}
				});
			});

// 			$("."+ns+" .sidebar .dn_bauen").click(function(e)
// 			{
// 				var tDialog = $("<div class='cn_dialogMessage' title='Bauplan für Gebäude auswählen'></div>");
// 				$(this).append( tDialog );
// 				$(tDialog).append("p").html("Wird geladen..");
// 				{
// 					$(tDialog).append("p").html(data2);
// 				});
// 				$(tDialog).dialog({ width: 1200, height: 600, modal: true, buttons: {  "Schließen": function() { $( this ).dialog( "close" ); } } });
// 			});
	--%>
	
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
// 				alert(count);

// 				if(  $(this).prop('checked')   )
			});
		});
	</script>
<div>
	<h3>Flotten</h3>
	<div>
		<span class="cn_label">Position:</span>
		<span class="cn_value">${param['x']}:${param['y']}</span>

		<div class="cn_aktionsleiste">
			<span class="cn_label">Optionen für Auswahl:</span>
			<a class="dn_senden" href="modell-auswahl.jsp" title="Die ausgewählten Flotten versenden..">Flotte(n) versenden</a>
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
				</c:forEach>
			</table>
		</div>
	</div>
</div>
<%@ include file="include/ajax-footer.jsp" %>