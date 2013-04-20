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
	draw();
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

		$.get('../ajax/posDetail.jsp?x='+x+'&y='+y, function(data2) 
		{
			$("."+ns+" .sidebar").html(data2);
		});
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

function draw()
{
	vX = selPosX-14;
	vY = selPosY-7;
	var canvas = document.getElementById('map');
	if(canvas.getContext)
	{
		$.getJSON('../json/getFlotten.jsp?x='+selPosX+'&y='+selPosY, function(data) 
		{
			var ctx = canvas.getContext("2d");
			ctx.clearRect(0, 0, 1200, 1200);
			ctx.fillStyle = "rgba(0, 0, 200, 1)";
			ctx.beginPath();
			ctx.lineWidth=0.5;
			var tB=Math.round(vBorder/2);
//			Gitternetz zeichnen
			ctx.strokeStyle = "rgba(200, 200, 250, 0.5)";
			for(var i=0; i<38; i++)
			{
				ctx.moveTo(i*zoom-tB,0);
				ctx.lineTo(i*zoom-tB,1200);
				ctx.moveTo(0,i*zoom-tB);
				ctx.lineTo(1200,i*zoom-tB);
			}
			ctx.closePath();
			ctx.stroke();
			grundstuecke = data;
			if(typeof selPosY !== 'undefined' )
			{
//				Gewähltes Grundstück markieren
				ctx.lineWidth=2;
				ctx.strokeStyle = "rgba(200, 200, 250, 0.9)";
				ctx.beginPath();
				ctx.arc( ( (selPosX-vX)*zoom+Math.round(zoom/2) )-2, ( (selPosY-vY)*zoom+Math.round(zoom/2) )-2, 9, 0, Math.PI * 2, true);
				ctx.closePath();
				ctx.stroke();
			}
			for(var i in data)
			{
				if(data[i].besitzerNutzerId==userId)
				{
//					Eigene Gebaeude markieren
					ctx.lineWidth=2;
					ctx.fillStyle = "rgba(250, 250, 250, 0.5)";
					ctx.beginPath();
					ctx.arc( ( (data[i].x-vX)*zoom+Math.round(zoom/2) )-2, ( (data[i].y-vY)*zoom+Math.round(zoom/2) )-2, 5, 0, Math.PI * 2, true);
					ctx.closePath();
					ctx.fill();
				}
				ctx.fillStyle = "rgba(0, 150, 250, 0.3)";
				if(data[i].id < 0)
					ctx.fillStyle = "rgba(100, 50, 50, 0.5)";
				ctx.fillRect ( (data[i].x-vX)*zoom, (data[i].y-vY)*zoom, zoom-vBorder, zoom-vBorder);

			}
		});
	}
}