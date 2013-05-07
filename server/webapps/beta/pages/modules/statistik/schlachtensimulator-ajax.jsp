<%@page import="org.colony.lib.Cache"%>
<%@page import="org.colony.service.SchlachtService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.colony.data.Geschwader"%>
<%@page import="java.util.List"%>
<%@page import="org.colony.data.Schiffsmodell"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/pages/include/ajax-header.jsp" %>

<h1>Schlachtensimulator</h1>
<%!
	public List<Geschwader> getUeberlebende(int kampftick, List<Geschwader> angreifer, List<Geschwader> verteidiger)
	{
		return SchlachtService.getUeberlebende(kampftick, angreifer, verteidiger);
	}
%>

<%
	if(request.getParameter("start")!=null)
	{
		System.out.println("----------------------------------------------------------------");
		List<Geschwader> g1 = (List<Geschwader>)session.getAttribute(ns+"ge1");
		List<Geschwader> g2 = (List<Geschwader>)session.getAttribute(ns+"ge0");
		if(g1==null || g1.size()==0) out.println("<div class='ui-state-error'>Es wurden keine Angreifer-Geschwader spezifiziert</div>");
		else if(g2==null || g2.size()==0) out.println("<div class='ui-state-error'>Es wurden keine Verteidiger-Geschwader spezifiziert</div>");
		else
		{
			List<List<Geschwader>> angreiferListe = new ArrayList<List<Geschwader>>();
			List<List<Geschwader>> verteidigerListe = new ArrayList<List<Geschwader>>();
			
			angreiferListe.add(g1);
			verteidigerListe.add(g2);
			int lastIndex = 0;
			while(angreiferListe.get(lastIndex).size()>0 && verteidigerListe.get(lastIndex).size()>0)
			{
				System.out.println("angreiferListe.get(lastIndex).size():"+angreiferListe.get(lastIndex).size());
				angreiferListe.add(getUeberlebende(lastIndex, verteidigerListe.get(lastIndex), angreiferListe.get(lastIndex)));
				verteidigerListe.add(getUeberlebende(lastIndex, angreiferListe.get(lastIndex), verteidigerListe.get(lastIndex)));
				lastIndex = angreiferListe.size()-1;
			}
			
			request.setAttribute("angreiferSimListe",angreiferListe);
			request.setAttribute("verteidigerSimListe",verteidigerListe);
// 			List<Geschwader> g1Vorher = g1;
// 			List<Geschwader> g2Vorher = g2;
// 			List<Geschwader> g1Nacher = getUeberlebende(getUeberlebende(i, g1Vorher, g2Vorher));
// 			List<Geschwader> g2Nacher = getUeberlebende(getUeberlebende(i, g2Vorher, g1Vorher));
			
			/*
			double g1Anzahl=0;
			double g1Kadenz=0;
			double g1PanzerPunkte=0;
			double g1PanzerWaffenPunkte=0;
			double g1SchildPunkte=0;
			double g1SchildWaffenPunkte=0;
			for(Geschwader tg : g1)
			{
				g1Anzahl+=tg.getAnzahl();
				g1Kadenz+=tg.getAnzahl()*tg.getSchiffsmodell().getKadenz();
				g1PanzerPunkte+=tg.getAnzahl()*tg.getSchiffsmodell().getPanzerPunkte();
				g1PanzerWaffenPunkte+=tg.getAnzahl()*tg.getSchiffsmodell().getPanzerWaffenPunkte();
				g1SchildPunkte+=tg.getAnzahl()*tg.getSchiffsmodell().getSchildPunkte();
				g1SchildWaffenPunkte+=tg.getAnzahl()*tg.getSchiffsmodell().getSchildWaffenPunkte();
			}
			double g2Anzahl=0;
			double g2Kadenz=0;
			double g2PanzerPunkte=0;
			double g2PanzerWaffenPunkte=0;
			double g2SchildPunkte=0;
			double g2SchildWaffenPunkte=0;
			for(Geschwader tg : g2)
			{
				g2Anzahl+=tg.getAnzahl();
				g2Kadenz+=tg.getAnzahl()*tg.getSchiffsmodell().getKadenz();
				g2PanzerPunkte+=tg.getAnzahl()*tg.getSchiffsmodell().getPanzerPunkte();
				g2PanzerWaffenPunkte+=tg.getAnzahl()*tg.getSchiffsmodell().getPanzerWaffenPunkte();
				g2SchildPunkte+=tg.getAnzahl()*tg.getSchiffsmodell().getSchildPunkte();
				g2SchildWaffenPunkte+=tg.getAnzahl()*tg.getSchiffsmodell().getSchildWaffenPunkte();
			}

			for(Geschwader tg : g1)
			{
				double multi = ((double)(tg.getSchiffsmodell().getPanzerPunkte()*tg.getAnzahl()))/g1PanzerPunkte;
				double kadenzBonus = 1d + ( (g2Kadenz/g2Anzahl) / ((double)tg.getSchiffsmodell().getPanzerPunkte()) );
				double schildschaden = multi*kadenzBonus*g2SchildWaffenPunkte;
				double panzerschaden = multi*kadenzBonus*g2PanzerWaffenPunkte;
				schildschaden-=tg.getSchiffsmodell().getSchildPunkte()*tg.getAnzahl();
				panzerschaden+=schildschaden;
				out.println(
						" multi:"+multi+
						" kb: "+ kadenzBonus+
						" SS:"+(multi*kadenzBonus*g2SchildWaffenPunkte)+
						" PS:"+(multi*kadenzBonus*g2PanzerWaffenPunkte)+
						"::: ");

				out.println("Anteil an Gesamtflotte:"+kadenzBonus+" Verluste: "+ Math.round(panzerschaden/tg.getSchiffsmodell().getPanzerPunkte())+" "+tg.getSchiffsmodell().getBezeichnung()+"<br/>");
			}
			*/
		}

		
	}
	else if(request.getParameter("clear")!=null)
	{
		session.setAttribute(ns+"ge0", null);
		session.setAttribute(ns+"ge1", null);
	}
	else if(request.getParameter("schiffsmodellId")!=null)
	{
		String istAngreifer = request.getParameter("istAngreifer");
		List<Geschwader> ag = (List<Geschwader>)session.getAttribute(ns+"ge"+istAngreifer);
		if(ag==null) ag = new ArrayList<Geschwader>();
		
		Geschwader ge = new Geschwader(s.getInt("anzahl"), s.getInt("schiffsmodellId"));
		boolean vorhanden = false;
		for(Geschwader tg : ag) if(tg.getSchiffsmodellId() == ge.getSchiffsmodellId())
		{
			vorhanden = true;
			tg.setAnzahl(tg.getAnzahl()+ge.getAnzahl());
		}
		if(!vorhanden)
			ag.add(ge);
		session.setAttribute(ns+"ge"+istAngreifer, ag);
	}
	request.setAttribute("angreiferListe", 		session.getAttribute(ns+"ge1"));
	request.setAttribute("verteidigerListe", 	session.getAttribute(ns+"ge0"));
%>
<script>
$(function()
{
	$("#mainDiv button").button();
	$("input").tooltip();
	$("#mainDiv form").submit(function(e)
	{
		e.preventDefault();
		$.get('schlachtensimulator-ajax.jsp?'+$(this).serialize(), function(data2) { $("#mainDiv").html(data2); });
		
	});
	$("#mainDiv button.dn_clear").click(function(e)
	{
		e.preventDefault();
		$.get('schlachtensimulator-ajax.jsp?clear=1', function(data2) { $("#mainDiv").html(data2); });
		
	});
	$("#mainDiv button.dn_start").click(function(e)
	{
		e.preventDefault();
		$.get('schlachtensimulator-ajax.jsp?start=1', function(data2) { $("#mainDiv").html(data2); });
		
	});
	
});
</script>


<table>
	<tr>
		<th>Angreifer-Geschwader</th>
		<th>Verteidiger-Geschwader</th>
	</tr>
	<tr>
		<td>
			<table>
				<tr>
					<td>Anzahl</td>
					<td>Schiffsmodellbezeichnung</td>
					<td>Masse</td>
				</tr>
				<c:forEach items="${angreiferListe}" var="row">
					<tr>
						<td>
							${row.anzahl}
						</td>
						<td>
							${row.schiffsmodell.bezeichnung}
						</td>
						<td>
							${row.schiffsmodell.masse}
						</td>
					</tr>
				</c:forEach>
			</table>
		</td>
		<td>
			<table>
				<tr>
					<td>Anzahl</td>
					<td>Schiffsmodellbezeichnung</td>
					<td>Masse</td>
				</tr>
				<c:forEach items="${verteidigerListe}" var="row">
					<tr>
						<td>
							${row.anzahl}
						</td>
						<td>
							${row.schiffsmodell.bezeichnung}
						</td>
						<td>
							${row.schiffsmodell.masse}
						</td>
					</tr>
				</c:forEach>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<form id="${ns}_angreiferErgaenzung">
				<input type="hidden" name="istAngreifer" value="1"/>
				<input type="text" name="anzahl" size="5" placeholder="Anzahl" title="Bitte hier die Anzahl eingeben"/>
				<select name="schiffsmodellId">
					<%
						for(Schiffsmodell sm : Cache.get().getSchiffsmodelle().values())
							out.println("<option value=\""+sm.getId()+"\">"+sm.getBezeichnung()+"</option>");
					%>
				</select>
				<button>Hinzufügen</button>
			</form>
		</td>
		<td>
			<form id="${ns}_verteidigerErgaenzung">
				<input type="hidden" name="istAngreifer" value="0"/>
				<input type="text" name="anzahl" size="5" placeholder="Anzahl" title="Bitte hier die Anzahl eingeben"/>
				<select name="schiffsmodellId">
					<%
						for(Schiffsmodell sm : Cache.get().getSchiffsmodelle().values())
							out.println("<option value=\""+sm.getId()+"\">"+sm.getBezeichnung()+"</option>");
					%>
				</select>
				<button>Hinzufügen</button>
			</form>
		</td>
	</tr>
</table>
<br/>
Bitte ergänze so lange auf beiden Seiten die jeweiligen Geschwader bis die gewünschte Konstellation fertig ist.<br/>
Anschließend kannst du den virtuellen Kampf simulieren:<br/><br/>
<button class="dn_start">Kampfsimulation starten</button>
<br/>
<br/>
Oder leere alle Angaben und beginne von neuem:<br/><br/>
<button class="dn_clear">Kampfszenario leeren</button>
<br/>
<br/>
<br/>














<c:if test="${ not empty angreiferSimListe }">
	<div class="dn_simulationsergebnis">
		<h1>Simulationsergebnis</h1>
		<table class="dn_simulationsergebnis">
			<tr>
				<th/>
				<c:forEach items="${angreiferSimListe}" var="block" varStatus="varStatus">
					<th>Kampftick ${varStatus.count }</th>
				</c:forEach>
			</tr>
			<tr>
				<td>Angreifer:</td>
				<c:forEach items="${angreiferSimListe}" var="block" varStatus="varStatus">
					<td>
						<c:forEach items="${block}" var="row">
							${row.anzahl} &nbsp; ${row.schiffsmodell.bezeichnung}<br/>
						</c:forEach>
					</td>
				</c:forEach>
			</tr>
			<tr>
				<td>Verteidiger:</td>
				<c:forEach items="${verteidigerSimListe}" var="block">
					<td>
						<c:forEach items="${block}" var="row">
							${row.anzahl} &nbsp; ${row.schiffsmodell.bezeichnung}<br/>
						</c:forEach>
					</td>
				</c:forEach>
			</tr>
		</table>
	</div>
	<br/>
	<br/>
	<br/>
	<br/><br/>
</c:if>















*) S = Schildpunkte, P = Panzerung, SS = Schildschaden/Angriff pro Schiff, PS = Schaden gegen Panzerungen/Angriff pro Schiff, FR = Feuerrate pro Schiff und Tick





<%@ include file="/pages/include/ajax-footer.jsp" %>
