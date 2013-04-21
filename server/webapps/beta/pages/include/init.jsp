<%@ page pageEncoding="UTF-8"%><%
if(session.getAttribute("userId")==null)
	throw new Exception("Sie sind nicht (mehr) am Spiel angemeldet. Bitte erneut anmelden.");
%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
