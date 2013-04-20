<%@ page pageEncoding="UTF-8"%><%
if(session.getAttribute("userId")==null)
	throw new Exception("Sie sind nicht (mehr) am Spiel angemeldet. Bitte erneut anmelden.");
%>