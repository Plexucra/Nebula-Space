<%@page import="org.colony.service.HandelService"%>
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

<c:choose>
	<c:when test="${param['action'] eq 'save' }">
		<%
		try
		{
			FlottenService.transferFlottenlager( s.getNutzer(), s.getInt("planetId"), s.getInt("flotteId"), s.getInt("ress1LagerBelegung"), s.getInt("ress2LagerBelegung"), s.getInt("ress3LagerBelegung"), s.getInt("ress4LagerBelegung"), s.getInt("ress5LagerBelegung") );
			out.println("Der Rohstofftransfer wurde durchgeführt.");
		}
		catch(Exception ex)
		{
			out.println("<div class='ui-state-error'>"+ex.getMessage()+"</div>");
		}
		%>
		<div><a href='${up}/pages/modules/handel/uebersicht.jsp'>Zurück</a></div>
	</c:when>
	<c:otherwise>
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
		$(".cn_button").button();
		$("#${ns}_form").submit(function(e)
		{
			e.preventDefault();
			if($("#${ns}_form font[color='red']").size()>0)
				alert( "Ihre Eingabe ist nicht zulässig.\nBitte überprüfen bzw. beheben Sie die rot hervorgehobenen Werte." );
			else
			{
				$("#${ns}_form").hide();
				location.replace("${up}/pages/modules/handel/frachttransfer.jsp?"+$("#${ns}_form").serialize()+"&action=save")
			}
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
		updateBelegung();
	});
	
	</script>
	
	
	
	<form id="${ns}_form">
		<table>
			<tr>
				<td><span class="cn_label">Planet:</span></td>
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
									flotte = f;
						}
						if(flotte==null)
							flotte = flist.get(0);
					}
					pageContext.setAttribute("geschwader", FlottenService.getGeschwader(flotte));
					Lager lager = NutzerService.getLager(s.getNutzer().getId(), p.getId());
					%>
					<c:forEach items="${ geschwader }" var="row"><c:if test="${ row.schiffsmodell.frachter }"><c:set var="frachterGeschwader" value="${ row }"/><c:set var="frachterAnzahl" value="${ row.anzahl }"/></c:if></c:forEach>
	
					<script>
						function getBelegung()
						{
							var belegung = 0;
							for(var i=1; i<=5; i++)
							{
								belegung+= parseInt( $("#ress"+i+"LagerBelegung").val() );
							}
							return belegung;
						}
						function updateBelegung()
						{
							var belegung = getBelegung();
							if(belegung > ${frachterGeschwader.fassungsvermoegen})
								$("#frachterBelegung").html("<font color='red'>"+belegung+"</font>");
							else
								$("#frachterBelegung").html(belegung);
						}
					</script>
					<tr>
						<td><span class="cn_label">Frachter-Flotte:</span></td>
						<td>
							<select required="required" name="flotteId">
								<c:forEach items="${ flist }" var="row">
									<option value="${ row.id }" ${ row.id eq param['flotteId']?'selected':'' }>Flotte ${ row.id } (enthält Frachter)</option>
								</c:forEach>
							</select>
						</td>
					</tr>
	
					<tr><td><br/></td></tr>
	
					<tr>
						<td><span class="cn_label">Fracher-Lager<br/>Auslastung:</span></td>
						<td>
							<span id="frachterBelegung">0</span> <span class="cn_label">von</span> ${frachterGeschwader.fassungsvermoegen}<br/>
							<br/>
							<a href="javascript:;" onclick="$('.ress-sliderDiv').slider('value',0);" class="cn_button">Alles Entladen</a>
						</td>
					</tr>
	
					<tr><td><br/></td></tr>
					<tr>
						<td><span class="cn_label">Transfer:</span></td>
						<td>
							<table class="dn_transfer">
								<colgroup>
									<col width="100px"/>
									<col width="100px"/>
									<col width="100px"/>
									<col width="200px"/>
								</colgroup>
								<tr>
									<th>Rohstoff-Lager:</th>
									<th align="right">Auf Planet</th>
									<th align="right">In Frachtern</th>
									<th>&nbsp;</th>
								</tr>
								<% 
								for(int ress=1; ress <=5; ress++)
								{
									%>
									<tr>
										<td><%= HandelService.getRessName(ress) %></td>
										<td id="planetLager<%=ress%>" align="right"><%= lager.getRess(ress) %></td>
										<td id="flotteLager<%=ress%>" align="right"><%= flotte.getRess(ress) %></td>
										<td class="ress-slider">
											<div  class="ress-sliderDiv" id="ress-slider<%= ress %>"></div>
											<script>
												$(function() 
												{
													$( "#ress-slider<%= ress %>" ).slider(
													{
														range: "min", value: <%= flotte.getRess(ress) %>, min: 0, max: ${frachterGeschwader.fassungsvermoegen},
														change: function( event, ui )
														{
															var t_pl = <%= lager.getRess(ress) %>-ui.value+<%= flotte.getRess(ress) %>;
															$("#planetLager<%=ress%>").html( t_pl<0?("<font color='red'>"+t_pl+"</font>"):t_pl );
															$("#flotteLager<%=ress%>").html( ui.value );
															$("#ress<%= ress %>LagerBelegung").val(ui.value);
															updateBelegung();
														},
														slide: function( event, ui )
														{
															var t_pl = <%= lager.getRess(ress) %>-ui.value+<%= flotte.getRess(ress) %>;
															$("#planetLager<%=ress%>").html( t_pl<0?("<font color='red'>"+t_pl+"</font>"):t_pl );
															$("#flotteLager<%=ress%>").html( ui.value );
															$("#ress<%= ress %>LagerBelegung").val(ui.value);
															updateBelegung();
														}
													});
	// 												$( "#ress1-amount" ).val( "$" + $( "#ress1-slider" ).slider( "value" ) );
												});
											</script>
											<input type="hidden" name="ress<%= ress %>LagerBelegung" id="ress<%= ress %>LagerBelegung" value="<%= flotte.getRess(ress) %>"/>
										</td>
										<td>
											&nbsp;&nbsp;&nbsp;<a href="javascript:;" onclick="$('.ress-sliderDiv').slider('value',0); $('#ress-slider<%= ress %>').slider('value',${frachterGeschwader.fassungsvermoegen});" class="cn_button">Max</a>
											&nbsp;&nbsp;&nbsp;<a href="javascript:;" onclick="var frei = ${frachterGeschwader.fassungsvermoegen}-getBelegung(); var tb = parseInt($('#ress<%= ress %>LagerBelegung').val())+frei; if(tb><%= lager.getRess(ress) %>) tb=<%= lager.getRess(ress) %>;  if(frei>0) $('#ress-slider<%= ress %>').slider('value',tb);" class="cn_button">Auffüllen</a>
										</td>
									</tr>
									<%
								}
								%>
							</table>
						</td>
					</tr>
					<tr>
						<td/>
						<td><input type="submit" value="Fracht transferieren"/>
					</tr>
				</c:otherwise>
			</c:choose>
		</table>
	</form>
	</c:otherwise>
</c:choose>