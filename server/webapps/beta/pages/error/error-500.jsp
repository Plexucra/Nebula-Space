<%@ page isErrorPage="true"%>

Ein Fehler ist aufgetreten:<br/>
<%
String error = exception.getLocalizedMessage();
if(error!=null)
{
	if(error.indexOf("Exception:")>-1) error=error.substring(error.lastIndexOf("Exception:")+10);
	out.println("<font color='red'>"+error+"</font>");
	
}
%>
<br/>
<br/>
> <a href="/">zur Startseite</a>
<%-- <% exception.printStackTrace(); %> --%>