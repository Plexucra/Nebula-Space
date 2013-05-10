function getPosition(e)
{
    var targ;
    if (!e)
        e = window.event;
    if (e.target)
        targ = e.target;
    else if (e.srcElement)
        targ = e.srcElement;
    if (targ.nodeType == 3) // defeat Safari bug
        targ = targ.parentNode;
    var x = e.pageX - $(targ).offset().left;
    var y = e.pageY - $(targ).offset().top;
    return {"x": x, "y": y};
};

var kartenoptionen = {showKapazitaet:false, showId:true, showTyp:true, showEffizienz:false}

$(function()
{
//	draw();
	$("#"+ns+"_showTyp").click(function() { kartenoptionen.showTyp = $(this).prop("checked"); draw(); });
	$("#"+ns+"_showEffizienz").click(function() { kartenoptionen.showEffizienz = $(this).prop("checked"); draw(); });
	$("#"+ns+"_showKapazitaet").click(function() { kartenoptionen.showKapazitaet = $(this).prop("checked"); draw(); });
	$("#"+ns+"_showId").click(function() { kartenoptionen.showId = $(this).prop("checked"); draw(); });
	$.get('../ajax/grundstueckDetail.jsp?x='+selGrundstueckX+'&y='+selGrundstueckY+'&selModellId='+selModellId, function(data2) 
	{
		$("."+ns+" .sidebar").html(data2);
	});

	
	$( "#map" ).click(function(e)
	{
		var tPos = getPosition(e);
		var x = tPos.x- (vBorder*2);
		var y = tPos.y- (vBorder*2);
		x=Math.round(x/zoom)+vX;
		y=Math.round(y/zoom)+vY;
		selGrundstueckX=x;//+vX;
		selGrundstueckY=y;//+vY;

		$.get('../ajax/grundstueckDetail.jsp?x='+x+'&y='+y, function(data2) 
		{
			$("."+ns+" .sidebar").html(data2);
		});

		
		var bebaut = false;
		bebaut=true;
		if(false) for(var i in grundstuecke)
		{
			if( y==grundstuecke[i].y && x==grundstuecke[i].x)
			{
				bebaut=true;
				$.getJSON('../json/getGrundstueckFullDetail.jsp?id='+grundstuecke[i].gebaeudeId, function(data)
				{
					var tHtml ="";
					tHtml+="<img class='dn_modell dn_modell_"+data.gebaeude.modell.id+"' src='../resources/modelle/"+data.gebaeude.modell.id+"/thumbnail.gif'/>"
					tHtml+="<h3>"+data.gebaeude.modell.bezeichnung+"</h3> <div class='cn_zusatz'>"+data.gebaeude.modell.typ.bezeichnung+"</div><br/>";
					if(data.gebaeude.alter<0)
					{
						tHtml+="<b>Gebäude wird gebaut..</b><br/><br/>";
						tHtml+="Fortschritt: "+ Math.round(((data.gebaeude.modell.bauzeit+data.gebaeude.alter)/data.gebaeude.modell.bauzeit)*100) +"%<br/>";
						tHtml+="Fertig in: "+(data.gebaeude.alter*-1)+" Ticks / "+Math.round((data.gebaeude.alter*-1)*tickDuration/60000)+ " min. <br/>";
						var ms = new Date().getTime();
						ms+=((data.gebaeude.alter*-1)*tickDuration);
						tHtml+="Fertig am: "+(new Date(ms)).toLocaleString()+"<br/>";
					}
					else
					{
						tHtml+="<div class='dn_folder'>";
						if(data.gebaeude.modell.typ.id=="3")
						{
							tHtml+="<h3>Gewinn: "+formatDiffValue(data.gebaeude.einnahmen-data.gebaeude.ausgaben)+"</h3>";
							tHtml+="<div>";
							tHtml+="Einnahmen: "+data.gebaeude.einnahmen+"<br/>";
							tHtml+="Ausgaben: "+data.gebaeude.ausgaben+"<br/>";
							tHtml+="Mieter: "+data.gebaeude.auslastung+" von max. "+data.gebaeude.modell.kapazitaet+"<br/>";
							tHtml+="</div>";
						}
						else if(data.gebaeude.modell.typ.id=="2")
						{
							tHtml+="<h3>Gewinn: "+formatDiffValue(data.gebaeude.einnahmen-data.gebaeude.ausgaben)+"</h3>";
							tHtml+="<div>";
							tHtml+="Einnahmen: "+data.gebaeude.einnahmen+"<br/>";
							tHtml+="Ausgaben: "+data.gebaeude.ausgaben+"<br/>";
							tHtml+="- Instandhaltung: "+data.gebaeude.wartungskostenanteil+"<br/>";
							tHtml+="- Personalkosten: "+data.gebaeude.arbeitskostenanteil+"<br/>";
							tHtml+="Produktion: "+data.gebaeude.auslastung+" Chargen<br/>";
							tHtml+="Basis-Kapazität: "+data.gebaeude.modell.kapazitaet+" Chargen<br/>";
							tHtml+="</div>";
						}
						else
						{
							tHtml+="<h3>Gewinn: "+formatDiffValue(data.gebaeude.einnahmen-data.gebaeude.ausgaben)+"</h3>";
							tHtml+="<div>";
							tHtml+="Einnahmen: "+data.gebaeude.einnahmen+"<br/>";
							tHtml+="Ausgaben: "+data.gebaeude.ausgaben+"<br/>";
							tHtml+="Kapazität: "+data.gebaeude.modell.kapazitaet+"<br/>";
							tHtml+="</div>";
						}
						tHtml+="</div>";

						var te = 0;
						tHtml+="<div class='dn_folder'>";
						if(data.gebaeude.modell.typ.id=="3")
							tHtml+="<h3>Mietspiegel: "+Math.round(data.effizienz*100)+"%</h3>";
						else
							tHtml+="<h3>Produktivität: "+Math.round(data.effizienz*100)+"%</h3>";
						tHtml+="<div>";
						tHtml+="<ul>";
						for(var s in data.einfluesse)
						{
							te+=data.einfluesse[s].currentEinfluss;
							tHtml+="<li> "+data.einfluesse[s].bBezeichnung+": "+formatDiffValue(data.einfluesse[s].currentEinfluss)+"%</li>";
						}
						tHtml+="</ul>";
						tHtml+="</div>";
						tHtml+="</div>";

						
						if(data.gebaeude.besitzer.id == userId)
						{
							tHtml+="<br/><i>Dieses Gebäude ist Ihr Eigentum.</i><br/><br/>";
							tHtml+="<a href='javascript:;' class='dn_bauen'>Gebäude ersetzen</a><br/><br/>";
							tHtml+="<a href='javascript:;' class='dn_abreissen'>Gebäude abreißen</a><br/>";
						}
						else
						{
							tHtml+="<br/>Besitzer:<br/><i>"+data.gebaeude.besitzer+"</i><br/><br/>";
						}
					}
					$("."+ns+" .sidebar").html(tHtml);
					$("."+ns+" .sidebar .dn_folder > div").hide();
					$("."+ns+" .sidebar .dn_folder > h3").click(function(){ $(this).parent().children("div").toggle("slow"); });

					$("."+ns+" .sidebar .dn_abreissen").click(function(e)
					{
						$.getJSON('../json/destroyGebaeude.jsp?x='+x+'&y='+y, function(data2) 
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
					$("."+ns+" .sidebar .dn_bauen").click(function(e)
					{
						var tDialog = $("<div class='cn_dialogMessage' title='Bauplan für Gebäude auswählen'></div>");
						$(this).append( tDialog );
						$(tDialog).append("p").html("Wird geladen..");
						$.get('../ajax/modellAuswahlDialog.jsp?umbau=true&x='+x+'&y='+y, function(data2) 
						{
							$(tDialog).append("p").html(data2);
						});
						$(tDialog).dialog({ width: 1200, height: 600, modal: true, buttons: {  "Schließen": function() { $( this ).dialog( "close" ); } } });
					});
				});
			}
		}
		if(!bebaut)
		{
			var hatNachbarn = false;
			for(var i2 in grundstuecke)
			{
				if( Math.abs(y-grundstuecke[i2].y)<2 && Math.abs(x-grundstuecke[i2].x)<2)
					hatNachbarn=true;
			}
			if(hatNachbarn)
			{
				var tHtml ="";
				tHtml+="<h3>Bebaubares Grundstück</h4>";
				tHtml+="<small>Position:"+x+"|"+y+"</small><br/>";
//				tHtml+="Sektor:"+sektorId+"<br/>";
				tHtml+="<a href='javascript:;' class='dn_bauen'>Bauplan auswählen</a><br/>";
				$.getJSON('../json/getEffizienz.jsp?x='+x+'&y='+y, function(data2) 
				{
					if(data2 && data2["errorMessage"])
						alert(data2["errorMessage"]);
					else
					{
						var th = "";
						th+="<br/><h3>Bauplan vorschlag:</h3><br/> ";
						th+="<b>"+data2.modell.typ.bezeichnung+"</b><br/>";
						th+=""+data2.modell.bezeichnung+"<br/>";
						th+="Vorraussichtliche Effizienz: "+(data2.effizienz*100)+"%<br/>";
						$("."+ns+" .sidebar").append($(th));

					}
				});

				
				$("."+ns+" .sidebar").html(tHtml);
				$("."+ns+" .sidebar .dn_bauen").click(function(e)
				{
					var tDialog = $("<div class='cn_dialogMessage' title='Bauplan für Gebäude auswählen'></div>");
					$(this).append( tDialog );
					$(tDialog).append("p").html("Wird geladen..");
					$.get('../ajax/modellAuswahlDialog.jsp?x='+x+'&y='+y, function(data2) 
					{
						$(tDialog).append("p").html(data2);
					});
					$(tDialog).dialog({ width: 1000, height: 600, modal: true, buttons: {  "Schließen": function() { $( this ).dialog( "close" ); } } });
				});
			}
			else
			{
				$("."+ns+" .sidebar").html("Neue Grundstücke können nur in direkter Nachbarschaft von bereits existierenden Gebäuden gebaut werden. Sonst ist kein Anschluss an das Versorgungsnetz gewährleistet.");
			}
		}
		draw();
	});
});

function formatDiffValue(s)
{
	s=Math.round(s);
	return "<span class='cn_"+(s>=0?"positiv":"negativ")+"'>"+(s>0?"+":"")+s+"</span>";
//	if(s>0)
}


var vX;
var vY;
var grundstuecke;
var zoom = 33;
var vBorder = 4;


var imageObj = new Image();
imageObj.src = '../css/default_thema/images/gebaeudeschema.png';
imageObj.onload = function() 
{
	draw();
};



function draw()
{
	vX = selGrundstueckX-14;
	vY = selGrundstueckY-7;
	var canvas = document.getElementById('map');
	if(canvas.getContext)
	{
		$.getJSON('../json/getGrundstuecke.jsp?x='+selGrundstueckX+'&y='+selGrundstueckY, function(data) 
		{
			var halfZoom=Math.round(zoom/2);
			var ctx = canvas.getContext("2d");
			ctx.font="10px Arial";
			ctx.clearRect(0, 0, 1200, 1200);
			ctx.fillStyle = "rgba(0, 0, 200, 1)";
			ctx.beginPath();
			ctx.lineWidth=0.5;
			var tB=Math.round(vBorder/2);
//			Gitternetz zeichnen
//			ctx.strokeStyle = "rgba(200, 200, 250, 0.5)";
//			for(var i=0; i<38; i++)
//			{
//				ctx.moveTo(i*zoom-tB,0);
//				ctx.lineTo(i*zoom-tB,1200);
//				ctx.moveTo(0,i*zoom-tB);
//				ctx.lineTo(1200,i*zoom-tB);
//			}
//			ctx.closePath();
//			ctx.stroke();
			grundstuecke = data;

			for(var i in data)
			{
				var tx = (data[i].x-vX)*zoom;
				var ty = (data[i].y-vY)*zoom;
				ctx.drawImage(imageObj, tx-2, ty-2);

				if(data[i].besitzerNutzerId==userId)
				{
//					Eigene Gebaeude markieren
					ctx.lineWidth=2;
					ctx.fillStyle = "rgba(250, 250, 250, 0.9)";
					ctx.beginPath();
					ctx.arc( tx+halfZoom+1, ty+halfZoom-12, 3, 0, Math.PI * 2, true);
					ctx.closePath();
					ctx.fill();
				}
				ctx.fillStyle = "rgba(0, 150, 250, 0.2)";
				if(data[i].typId==1 || data[i].typId==5 || data[i].typId==6 ) ctx.fillStyle = "rgba(250, 90, 90, 0.2)";
				if(data[i].typId==2) ctx.fillStyle = "rgba(90, 250, 90, 0.2)";
				if(data[i].typId==3) ctx.fillStyle = "rgba(90, 90, 250, 0.2)";
				if(kartenoptionen.showTyp)
					ctx.fillRect ( tx-3, ty-3, zoom, zoom);
				ctx.fillStyle = "rgba(255, 255, 255, 0.5)";
				if(kartenoptionen.showId)
					ctx.fillText(data[i].modellId, 						tx+halfZoom-17, ty+8);
				if(kartenoptionen.showKapazitaet)
					ctx.fillText(data[i].a <= 0 ? "Bau...":data[i].k,	tx+halfZoom-17, ty+22);
				if(kartenoptionen.showEffizienz)
					ctx.fillText(data[i].a <= 0 ? "Bau...":(Math.round(data[i].e)),	tx+halfZoom-17, ty+22);
				
				

			}
			if(typeof selGrundstueckY !== 'undefined' )
			{
				var tx = (selGrundstueckX-vX)*zoom-4;
				var ty = (selGrundstueckY-vY)*zoom-4;
				var tBreite = zoom;
				var tw = Math.round(tBreite / 4)
//				Gewähltes Grundstück markieren
				ctx.lineWidth=2;
				ctx.strokeStyle = "rgba(250, 250, 250, 1)";
				ctx.beginPath();
//				
//			
				ctx.moveTo(tx, ty+tw);
				ctx.lineTo(tx, ty);
				ctx.lineTo(tx+tw, ty);
				ctx.moveTo(tx+tBreite-tw, ty);
				ctx.lineTo(tx+tBreite, ty);
				ctx.lineTo(tx+tBreite, ty+tw);
				ctx.moveTo(tx+tBreite, ty+tBreite-tw);
				ctx.lineTo(tx+tBreite, ty+tBreite);
				ctx.lineTo(tx+tBreite-tw, ty+tBreite);
				ctx.moveTo(tx+tw, ty+tBreite);
				ctx.lineTo(tx, ty+tBreite);
				ctx.lineTo(tx, ty+tBreite-tw);
				ctx.moveTo(tx, ty+tw);
				

				
//				ctx.arc( ( (selGrundstueckX-vX)*zoom+Math.round(zoom/2) )-2, ( (selGrundstueckY-vY)*zoom+Math.round(zoom/2) )-2, 9, 0, Math.PI * 2, true);
				ctx.closePath();
				ctx.stroke();
			}
		});
	}
}