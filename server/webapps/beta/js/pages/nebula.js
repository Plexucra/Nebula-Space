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

$(function()
{
//	draw();
	$.get('../ajax/posDetail.jsp?x='+selPosX+'&y='+selPosY+'&selFlotteId='+selFlotteId, function(data2) 
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
		selPosX=x;//+vX;
		selPosY=y;//+vY;

		draw();
		$.get('../ajax/posDetail.jsp?x='+x+'&y='+y, function(data2) 
		{
			$("."+ns+" .sidebar").html(data2);
		});
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
var zoom = 20;
var vBorder = 2;

var imageObj = new Image();
imageObj.src = '../css/default_thema/images/nebula.png';
imageObj.onload = function() 
{
	draw();
};
function draw()
{
	
	vX = selPosX-14;
	vY = selPosY-7;
	var canvas = document.getElementById('map');
	if(canvas.getContext)
	{
		var ctx = canvas.getContext("2d");
		ctx.clearRect(0, 0, 1200, 1200);
		
//		3260 2487
//		css/default_thema/images/nebula.jpg
		ctx.drawImage(imageObj, -1500-(vX*zoom), -1500-(vY*zoom));
		$.getJSON('../json/getFlotten.jsp?x='+selPosX+'&y='+selPosY, function(data) 
		{
//			alert(vX*zoom);
			
			ctx.fillStyle = "rgba(0, 0, 200, 1)";
			ctx.beginPath();
			ctx.lineWidth=0.5;
			var tB=Math.round(vBorder/2);
//			Gitternetz zeichnen
			ctx.strokeStyle = "rgba(200, 200, 250, 0.5)";
//			for(var i=0; i<38; i++)
//			{
//				ctx.moveTo(i*zoom-tB,0);
//				ctx.lineTo(i*zoom-tB,1200);
//				ctx.moveTo(0,i*zoom-tB);
//				ctx.lineTo(1200,i*zoom-tB);
//			}
			ctx.closePath();
			ctx.stroke();
			grundstuecke = data;
			if(typeof selPosY !== 'undefined' )
			{
//				Gewähltes Grundstück markieren
				ctx.lineWidth=2;
				ctx.strokeStyle = "rgba(200, 200, 250, 0.9)";
				ctx.beginPath();
				ctx.arc( ( (selPosX-vX)*zoom+Math.round(zoom/2) )-1, ( (selPosY-vY)*zoom+Math.round(zoom/2) )-1, 7, 0, Math.PI * 2, true);
				ctx.closePath();
				ctx.stroke();
			}
			for(var i in data)
			{
				var t_x = (data[i].x-vX)*zoom+Math.round(zoom/2)-1;
				var t_y = (data[i].y-vY)*zoom+Math.round(zoom/2)-1;
				var grd=ctx.createRadialGradient(t_x,t_y,5,t_x,t_y,12);

				if(data[i].besitzerNutzerId <= 0)
				{
					ctx.fillStyle = "rgba(255, 155, 55, 1)";
					ctx.beginPath();
					ctx.arc( ( (data[i].x-vX)*zoom+Math.round(zoom/2) )-1, ( (data[i].y-vY)*zoom+Math.round(zoom/2) )-1, 3, 0, Math.PI * 2, true);
					ctx.closePath();
					ctx.fill();
				}
				else if(data[i].besitzerNutzerId==userId)
				{
//					Eigene Gebaeude markieren
					grd.addColorStop(0,"rgba(0, 255, 10, 0.5)");
					grd.addColorStop(1,"rgba(0, 255, 10, 0.0)");
					ctx.fillStyle = grd;
					ctx.fillRect ( (data[i].x-vX)*zoom-2, (data[i].y-vY)*zoom-2, zoom-vBorder+4, zoom-vBorder+4);
				}
				else
				{

					grd.addColorStop(0,"rgba(0, 150, 250, 0.5)");
					grd.addColorStop(1,"rgba(0, 150, 250, 0.0)");
					ctx.fillStyle = grd;
					ctx.fillRect ( (data[i].x-vX)*zoom-2, (data[i].y-vY)*zoom-2, zoom-vBorder+4, zoom-vBorder+4);
				}				

			}
		});
	}
}