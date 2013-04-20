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

String userId = (String)session.getAttribute("userId");
if(userId==null) userId="1";
String sKey = request.getParameter("sektorKey");
if(sKey==null) sKey="0:0";

Connection c = DbEngine.getConnection();
try
{
	Map<String,String> map = new HashMap<String,String>();
	ResultSet rs = c.prepareStatement((String)request.getAttribute("t_statement")).executeQuery();
	StringBuffer sb = new StringBuffer(5000);
	if(rs!=null)
	{
		List<String> cNames = new ArrayList<String>();
		ResultSetMetaData meta = rs.getMetaData();
		for(int i=0; i<meta.getColumnCount(); i++)
		{
			System.out.println(meta.getColumnName(i+1));
			cNames.add(meta.getColumnName(i+1));
		}
		boolean b1 = false;
		sb.append("[");
		while(rs.next())
		{
			if(b1) sb.append(",");
			sb.append("{");
			boolean b2 = false;
			for(String cn : cNames)
			{
				String value = rs.getString(cn);
				if(value!=null)
				{
					if(b2) sb.append(",");
					sb.append("\"");
					sb.append(cn);
					sb.append("\":\"");
					sb.append(value);
					sb.append("\"");
					b2=true;
				}
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