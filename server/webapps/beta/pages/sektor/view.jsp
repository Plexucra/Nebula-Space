<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.colony.lib.DbEngine"%>

<%@ include file="/pages/include/page-header.jsp" %>
<%

%>
<script>
$(function() 
{
// 	var kachel = {};
// 			var off = $("#mainDiv").offset();
// 			for(var x=0; x<30; x++)
// 			for(var y=0; y<30; y++)
// 			{
// 				var d=$("<div/>");
// // 				d=$(document.createElement('div'));
// 				d.appendTo($("#mainDiv"));
// 				d.addClass("grundstueckKachel")
// 				d.offset({top:off.top+x*20, left:off.left+y*20});
// // 				d.hide();
// // 				d.show("slide",{direction: "up"}, 1000);
// 				d.click( function() 
// 				{
// 					$(this).effect("highlight");
// 				});
// //				d.fadeIn("slow").slideToggle(300).slideToggle(300);
// 				kachel[x+":"+y]=d;
// 			}
</script>
<%

String userId = (String)session.getAttribute("userId");
if(userId==null) userId="1";
String sKey = request.getParameter("sektorKey");
if(sKey==null) sKey="0:0";

Connection c = DbEngine.getConnection();
try
{
	Map<String,String> map = new HashMap<String,String>();
	ResultSet rs = c.prepareStatement("			SELECT "+
	"		grundstueck.id, "+
	"	    typId, "+
	"	    grundstueck.x, "+
	"	    grundstueck.y, "+
	"		gebaeude.besitzerNutzerId"+
	"	FROM grundstueck "+
	"	join gebaeude on (gebaeude.id = grundstueck.gebaeudeId) "+
	"	join modell on (modell.id = gebaeude.modellId) "+
	"	where sektorKey = '0:0';").executeQuery();
	if(rs!=null) while(rs.next())
	{
		String classValue="dc_typ_"+rs.getString("typId");
		if(userId.equals(rs.getString("besitzerNutzerId")))
			classValue+=" dc_istEigenesGebaeude";
		map.put(rs.getString("x")+"_"+rs.getString("y"), classValue);
	}
	StringBuffer sb = new StringBuffer(5000);
	sb.append("<table class='sektorUebersicht'>");
	for(int x=0; x<30; x++)
	{
		sb.append("<tr>");
		for(int y=0; y<30; y++)
		{
			sb.append("<td");
			if(map.get(x+"_"+y)!=null)
			{
				sb.append(" class='");
				sb.append(map.get(x+"_"+y));
				sb.append("'");
			}
			sb.append("> &nbsp;</td>");
		}
		sb.append("</tr>");
	}
	sb.append("</table>");
	out.println(sb.toString());
//		{
//			var d=$("<div/>");
//// 				d=$(document.createElement('div'));
//			d.appendTo($("#mainDiv"));
//			d.addClass("grundstueckKachel")

	
//		out.println(rs.getString("typId")+"-<br/>");
		/*
		$(d).addClass("test01")
		    .html("blub")
		    .appendTo($("#mainDiv"))
		    .click(function(){
		        $(this).remove();
		    })
		    .hide()
		    .slideToggle(300)
		    .delay(2500)
		    .slideToggle(300)
		    .queue(function() {
		        $(this).remove();
		    });
    		*/
}
finally
{
	if(c!=null) c.close();
}
%>


<style>
table.sektorUebersicht td
{
	border: 1px solid #ddd;
	width:16px;
	height:16px;
	line-height:16px;
	background-color:#fee;
}
table.sektorUebersicht td.dc_typ_1 {	background-color:#f66; }
table.sektorUebersicht td.dc_typ_2 {	background-color:#6f6; }
table.sektorUebersicht td.dc_typ_3 {	background-color:#66f; }
table.sektorUebersicht td.dc_istEigenesGebaeude
{
	border: 1px solid #7b7;
	
}
</style>
<%@ include file="/pages/include/page-footer.jsp" %>