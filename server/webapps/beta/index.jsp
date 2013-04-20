<%

if(session.getAttribute("currentNutzerId")==null)
{
	%>
	<script>location.replace("/pages/start.jsp")</script>
	<%
}
else
{
	%>
	<script>location.replace("/pages/karte.jsp")</script>
	<%
}

%>