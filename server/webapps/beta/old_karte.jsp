<%@ page pageEncoding="UTF-8"%>
<!doctype html>
<html lang="de">
<head>
	<meta charset="utf-8">
	<title>jQuery UI Example Page</title>
	<link href="css/default_thema/jquery-ui-1.10.1.custom.css" rel="stylesheet">
	<link href="css/default_thema/colony.css" rel="stylesheet">
	<script src="js/jquery-1.9.1.js"></script>
	<script src="js/jquery-ui-1.10.1.custom.js"></script>
	<script>
	var zoom = 20;
	var vBorder = 4;
	var grundstuecke;
	var sektorId = <%= (request.getParameter("sektorId")!=null)?request.getParameter("sektorId"):"1" %>;

	$(function() 
	{
		$( "#tabs" ).tabs();
		draw();
		$( "#map" ).click(function(e)
		{
			var x = e.pageX - $(this).position().left- (vBorder*2);
			var y = e.pageY - $(this).position().top- (vBorder*2);
			x=Math.round(x/zoom);
			y=Math.round(y/zoom);

			var bebaut = false;
			for(var i in grundstuecke)
			{
				if( y==grundstuecke[i].y && x==grundstuecke[i].x)
				{
					bebaut=true;
// 					$("#tabs1 .sidebar").html("x:"+grundstuecke[i].y+" id:"+grundstuecke[i].id);
					$.getJSON('/json/getGrundstueckDetail.jsp?id='+grundstuecke[i].id, function(data) 
					{
						var tHtml ="";
						tHtml+="<h3>bebautes Grundstück</h4>";
						tHtml+="Besitzer:"+data[0].besitzerNutzerAlias+"<br/>";
						tHtml+="Bauplan:"+data[0].modellBezeichnung+"<br/>";
						tHtml+="Typ:"+data[0].typBezeichnung+"<br/>";
						if(data[0].produktBezeichnung)
							tHtml+="Produkt:"+data[0].produktBezeichnung+"<br/>";
						tHtml+="Kapazität:"+data[0].kapazitaet+"<br/>";
						tHtml+="Tiefe:"+data[0].tiefe+"<br/>";
						tHtml+="Breite:"+data[0].breite+"<br/>";
// 						tHtml+="Sektor:"+sektorId+"<br/>";
// 						tHtml+="<h3>Ihre Baupläne:</h3>";
						$("#tabs1 .sidebar").html(tHtml);
					});
				}
			}
			if(!bebaut)
			{
				$.getJSON('/json/getModell.jsp?besitzerNutzerId=1', function(data) 
				{
					var tHtml ="";
					tHtml+="<h3>unbebautes Grundstück</h4>";
					tHtml+="Position:"+x+"|"+y+"<br/>";
					tHtml+="Sektor:"+sektorId+"<br/>";
					tHtml+="<h3>Ihre Baupläne:</h3>";

					for(var i in data)
					{
						tHtml+="Kapazität: "+data[i].kapazitaet+"<br/>";
						tHtml+=data[i].typBezeichnung+":<br/><i>"+data[i].bezeichnung+"</i><br/>";
						tHtml+="<a href='#' class='baue_modell' data_modell_id='"+data[i].id+"' id='modell_"+data[i].id+"'>Hier bauen</a><hr/>";
// 						ctx.fillRect (data[i].x*zoom, data[i].y*zoom, zoom-vBorder, zoom-vBorder);
					}
					$("#tabs1 .sidebar").html(tHtml);
					$("#tabs1 .baue_modell").click(function(e)
					{
// 						alert(sektorId);
						$.getJSON('/json/saveGebaeude.jsp?modellId='+$(this).attr("data_modell_id")+"&sektorId="+sektorId+"&x="+x+"&y="+y, function(data2) 
						{
							if(data2["errorMessage"])
							{
								alert(data2["errorMessage"]);
							}
							else draw();
								
						});
					});
				});
			}

		});
	});

    function draw()
    {
		var canvas = document.getElementById('map');
		if(canvas.getContext)
		{
			var ctx = canvas.getContext("2d");
			ctx.clearRect(0, 0, canvas.width, canvas.height);
			ctx.fillStyle = "rgba(0, 0, 200, 0.5)";
			$.getJSON('/json/getGrundstuecke.jsp?sektorId='+sektorId, function(data) 
			{
				grundstuecke = data;
				for(var i in data)
				{
					ctx.fillStyle = "rgba(0, 0, 200, 0.5)";
					if(data[i].typId==1) ctx.fillStyle = "rgba(200, 0, 0, 0.5)";
					if(data[i].typId==2) ctx.fillStyle = "rgba(0, 200, 0, 0.5)";
					if(data[i].typId==3) ctx.fillStyle = "rgba(0, 0, 200, 0.5)";
					ctx.fillRect (data[i].x*zoom, data[i].y*zoom, zoom-vBorder, zoom-vBorder);
// 					alert(data[i]);
				}
			});
		}
	}
	</script>
</head>
<body>

<div id="tabs">
	<ul>
		<li><a href="#tabs1">Karte</a></li>
		<li><a href="#tabs2">Übersicht</a></li>
		<li><a href="#tabs3">Einstellungen</a></li>
	</ul>
	<div id="tabs1">
		<table>
			<tr>
				<td>d
					<canvas id="map" width="500" height="500"></canvas>
				</td>
				<td>d
					<div class="sidebar"> 
					</div>
				</td>
			</tr>
		</table>
		
	</div>
	<div id="tabs2">Phasellus mattis tincidunt nibh. Cras orci urna, blandit id, pretium vel, aliquet ornare, felis. Maecenas scelerisque sem non nisl. Fusce sed lorem in enim dictum bibendum.</div>
	<div id="tabs3">Nam dui erat, auctor a, dignissim quis, sollicitudin eu, felis. Pellentesque nisi urna, interdum eget, sagittis et, consequat vestibulum, lacus. Mauris porttitor ullamcorper augue.</div>
</div>

</body>
</html>