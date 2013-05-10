<%@page import="org.colony.data.Flotte"%>
<%@page import="org.colony.service.FlottenService"%>
<%@page import="org.colony.data.Lager"%>
<%@page import="org.colony.lib.Cache"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.colony.data.Planet"%>
<%@page import="java.util.List"%>
<%@page import="org.colony.service.PlanetService"%>
<%@page import="org.colony.data.Schiffsmodell"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/pages/include/page-header.jsp" %>

<%
Planet p = null;
if(!s.has("planetId"))
	p=s.getNutzer().getHeimatPlanet();
else
	p=Cache.get().getPlanet(s.getInt("planetId"));
pageContext.setAttribute("planet",p);

if(p.getAllianzId() != s.getAllianz().getId()) throw new Exception("Auf diesen Planeten ist ein Handelsembargo verhängt.");

%>
<h1>Frachttransfer auf ${planet.name }</h1>



<script>
$(function()
{
	$("#${ns}_form").submit(function(e)
	{
		e.preventDefault();
		$("#${ns}_form select").hide();
		location.replace("${up}/pages/modules/handel/frachttransfer.jsp?"+$("#${ns}_form").serialize()+"&action=save")
		return false;
	});
	$("#${ns}_form select").change(function(e)
	{
		$("#${ns}_form").hide();
		location.replace("${up}/pages/modules/handel/frachttransfer.jsp?"+$("#${ns}_form").serialize())
	});
// 	$("#${ns}_form input[name='volumen'], #${ns}_form input[name='kurs']").keyup(function(e)
// 	{
// 		showKosten();
// 	});
// 	showKosten();
});
</script>

<form id="${ns}_form">
	<table>
		<tr>
			<td>Planet:</td>
			<td>
				<% request.setAttribute("plist",PlanetService.getPlaneten()); %>
				<select required="required" name="planetId">
					<c:forEach items="${ plist }" var="row">
						<c:if test="${ row.allianz.id eq s.allianz.id }">
							<option value="${ row.id }" ${ row.id eq planet.id ?'selected':'' }>${ row.name }</option>
						</c:if>
					</c:forEach>
				</select>
			</td>
		</tr>

		<%
		List<Flotte> flist = FlottenService.getNutzerFrachterFlotten(p.getX(), p.getY(), s.getNutzer());
		request.setAttribute("flist", flist);
		%>
		<c:choose>
			<c:when test="${empty flist}">
				<tr><td/><td>Es befindet sich keines ihrer Frachtschiffe im Orbit von ${planet.name}</td>
			</c:when>
			<c:otherwise>
				<%
				Flotte flotte = null;
				if(flist!=null && flist.size()>0)
				{
					if(s.has("flotteId"))
					{
						for(Flotte f : flist)
							if(f.getId()==s.getInt("flotteId"))
								flotte = flist.get(0);
					}
					if(flotte==null)
						flotte = flist.get(0);
				}
				%>
				<tr>
					<td>Frachter-Flotte:</td>
					<td>
						<select required="required" name="flotteId">
							<c:forEach items="${ flist }" var="row">
								<option value="${ row.id }">Flotte ${ row.id } (enthält Frachter)</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td>Geschwader:</td>
					<td>
						<% pageContext.setAttribute("geschwader", FlottenService.getGeschwader(flotte)); %>
						<c:forEach items="${ geschwader }" var="row">
							${ row.schiffsmodell.bezeichnung } <br/>
						</c:forEach>
					</td>
					<td>
						<script>
							$(function() 
							{
								$( "#ress1-slider" ).slider({ range: "min", value: 37, min: 1, max: 700, slide: function( event, ui )
								{
									$( "#ress1-amount" ).val( "$" + ui.value );
								}});
								$( "#ress1-amount" ).val( "$" + $( "#ress1-slider" ).slider( "value" ) );
							});
						</script>
						<input type="text" id="ress1-amount"/>
<!-- 						<div id="ress1-amount"></div> -->
						<div id="ress1-slider"></div>
					</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
</form>