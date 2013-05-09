<%@page import="org.colony.data.Lager"%>
<%@page import="org.colony.service.HandelService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.colony.data.Planet"%>
<%@page import="java.util.List"%>
<%@page import="org.colony.service.PlanetService"%>
<%@page import="org.colony.data.Schiffsmodell"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/pages/include/page-header.jsp" %>
<c:choose>
	<c:when test="${param['action'] eq 'delete' }">
		<%
		try
		{
			HandelService.deleteOrder( s.getNutzer(), s.getInt("id") );
			out.println("Ihre Order wurde gelöscht bzw. zurück genommen.");
		}
		catch(Exception ex)
		{
			out.println("<div class='ui-state-error'>"+ex.getMessage()+"</div>");
		}
		%>
		<div><a href='${up}/pages/modules/handel/uebersicht.jsp'>Zurück</a></div>
	</c:when>
	<c:when test="${param['action'] eq 'save' }">
		<%
		try
		{
			HandelService.insertOrder( s.getNutzer(), s.getBoolean("kauf"), Float.parseFloat(s.getString("kurs").replaceAll(",",".")), s.getInt("volumen"), s.getInt("ress"), s.getInt("planetId"));
			out.println("Ihre Order wurde gespeichert.");
		}
		catch(Exception ex)
		{
			out.println("<div class='ui-state-error'>"+ex.getMessage()+"</div>");
		}
		%>
		<div><a href='${up}/pages/modules/handel/uebersicht.jsp'>Zurück</a></div>
	</c:when>
	<c:otherwise>
		<script>
		$(function()
		{
			$("#${ns}_form").submit(function(e)
			{
				e.preventDefault();
				$("#${ns}_form select").hide();
				location.replace("${up}/pages/modules/handel/order.jsp?"+$("#${ns}_form").serialize()+"&action=save")
				return false;
			});
			$("#${ns}_form select, #${ns}_form input[type='radio']").change(function(e)
			{
				$("#${ns}_form select").hide();
				location.replace("${up}/pages/modules/handel/order.jsp?"+$("#${ns}_form").serialize())
			});
			$("#${ns}_form input[name='volumen'], #${ns}_form input[name='kurs']").keyup(function(e)
			{
				showKosten();
			});
			showKosten();
		});
		function showKosten()
		{
			if($("#${ns}_form input[name='volumen']").val()!='' && $("#${ns}_form input[name='kurs']").val()!='')
			{
				var kosten = Math.ceil( parseFloat($("#${ns}_form input[name='volumen']").val())*parseFloat( $("#${ns}_form input[name='kurs']").val().replace(/,/,'.') ));
				var html=""+kosten;
				<c:if test="${ param['kauf'] eq '0'}">
					html="Erlös: "+html;
				</c:if>
				<c:if test="${ param['kauf'] ne '0'}">
					html="Kosten: "+html;
					if( kosten > ${s.nutzer.kontostand} ) html="<font color='red'>"+html+"</font>";
				</c:if>
				$("#${ns}_kosten").html( html   );
			}
		}
		
		</script>
		<h1>Order erstellen</h1>
		<form id="${ns}_form">
			<table>
				<tr>
					<td/>
					<td>
						<input type="radio" name="kauf" value="1" ${ param['kauf'] ne '0'?'checked':''} id="${ns}_field_kauf1"/><label for="${ns}_field_kauf1">Kauforder</label><br/>
						<input type="radio" name="kauf" value="0" ${ param['kauf'] eq '0'?'checked':''} id="${ns}_field_kauf0"/><label for="${ns}_field_kauf0">Verkauforder</label><br/>
					</td>
				</tr>
				<tr>
					<td>Handelsplatz:</td>
					<td>
						<% request.setAttribute("plist",PlanetService.getPlaneten()); %>
						<select required="required" name="planetId">
							<option></option>
							<c:forEach items="${ plist }" var="row">
								<c:if test="${ row.allianz.id eq s.allianz.id }">
									<option value="${ row.id }" ${ row.id eq param['planetId']?'selected':'' }>${ row.name }</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td>Ressource:</td>
					<td>
						<select required="required" name="ress">
							<option value="1" ${ '1' eq param['ress']?'selected':'' }><%= HandelService.ress1Name %></option>
							<option value="2" ${ '2' eq param['ress']?'selected':'' }><%= HandelService.ress2Name %></option>
							<option value="3" ${ '3' eq param['ress']?'selected':'' }><%= HandelService.ress3Name %></option>
							<option value="4" ${ '4' eq param['ress']?'selected':'' }><%= HandelService.ress4Name %></option>
							<option value="5" ${ '5' eq param['ress']?'selected':'' }><%= HandelService.ress5Name %></option>
						</select>
					</td>
				</tr>
				<tr>
					<td>Kurs:</td>
					<td><input required="required" type="number" name="kurs" value="${ param['kurs'] }" placeholder="0,00"/></td>
					<td><span id="${ns}_kosten"></span></td>
				</tr>
				<tr>
					<td>Volumen:</td>
					<td><input required="required" type="number" name="volumen" value="${ param['volumen'] }" title="Bitte nur Ganzzahlen eingeben" placeholder="0"/></td>
					<td>
						<c:if test="${ not empty param['planetId'] and not empty param['ress'] and param['kauf'] eq '0'}">
							<%
							Lager l = NutzerService.getLager(s.getNutzer().getId(), s.getInt("planetId"));
							if(l!=null)
							{
								out.println("<span class='cn_label'>Derzeit im Lager: </span>");
								if(s.getInt("ress")==1) out.println(l.getRess1());
								else if(s.getInt("ress")==2) out.println(l.getRess2());
								else if(s.getInt("ress")==3) out.println(l.getRess3());
								else if(s.getInt("ress")==4) out.println(l.getRess4());
								else if(s.getInt("ress")==5) out.println(l.getRess5());
							}
							%>
						</c:if>
					</td>
				</tr>
				<tr>
					<td/>
					<td><input type="submit" value="${ param['kauf'] ne '0'?'Kauforder erstellen':'Verkauforder erstellen' }"/>
				</tr>
			</table>
		</form>
	</c:otherwise>
</c:choose>
