<%@ page pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.colony.lib.DbEngine"%>
<%
String sKey = request.getParameter("sektorKey");
if(sKey==null) sKey="0:0";

Connection c = DbEngine.getConnection();
try
{
	int x = 10;
	int y = 10;
	if(request.getParameter("x")!=null) x = Integer.parseInt(request.getParameter("x"));
	if(request.getParameter("y")!=null) y = Integer.parseInt(request.getParameter("y"));

	Map<String,String> map = new HashMap<String,String>();
	ResultSet rs = c.prepareStatement("	SELECT besitzerNutzerId, id, x, y FROM  flotte union select 0, id as id, x, y from planet where (x < "+(x+30)+") and ( x > "+(x-20)+" ) and (y < "+(y+15)+") and ( y > "+(y-8)+" )   ").executeQuery();
	
	StringBuffer sb = new StringBuffer(5000);
	if(rs!=null)
	{
		List<String> cNames = new ArrayList<String>();
		ResultSetMetaData meta = rs.getMetaData();
		for(int i=0; i<meta.getColumnCount(); i++)
		{
			cNames.add(meta.getColumnName(i+1));
		}
		boolean b1 = false;
		sb.append("[");
		while(rs.next())
		{
			if(b1) sb.append(",");
			sb.append("{");
			boolean b2 = false;
			
			String value = rs.getString("id");
			if(value!=null)
			{
				if(b2) sb.append(",");
				sb.append("\"id\":\"");
				sb.append(value);
				sb.append("\"");
				b2=true;
			}
			
			value = rs.getString("x");
			if(value!=null)
			{
				if(b2) sb.append(",");
				sb.append("\"x\":\"");
				sb.append(value);
				sb.append("\"");
				b2=true;
			}
			
			value = rs.getString("y");
			if(value!=null)
			{
				if(b2) sb.append(",");
				sb.append("\"y\":\"");
				sb.append(value);
				sb.append("\"");
				b2=true;
			}
			
			value = rs.getString("besitzerNutzerId");
			if(value!=null)
			{
				if(b2) sb.append(",");
				sb.append("\"besitzerNutzerId\":\"");
				sb.append(value);
				sb.append("\"");
				b2=true;
			}
			
			
			sb.append("}");
			b1=true;
		}
		sb.append("]");
	}
	out.println(sb.toString());
}
finally
{
	if(c!=null) c.close();
}
%>