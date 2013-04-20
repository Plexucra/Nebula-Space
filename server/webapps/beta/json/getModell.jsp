<%@ include file="include/init.jsp" %>
<%@ page pageEncoding="UTF-8"%>
<%@page import="org.colony.data.Modell"%>
<%@page import="flexjson.JSONSerializer"%>
<%@page import="org.colony.lib.ContextListener"%>

<%
StringBuffer sb = null;
for(Modell m : ContextListener.getService().getModelle().values())
{
	if(sb==null) sb = new StringBuffer("[");
	else sb.append(",");
	sb.append(new JSONSerializer().deepSerialize(m));
}
out.println(sb);
out.println("]");
%>
