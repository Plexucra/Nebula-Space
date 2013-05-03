<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="f" tagdir="/WEB-INF/tags/format" %> 
<%@page import="org.colony.lib.S"%>
<%
	S s = new S(request);
	request.setAttribute("s", s);
%>
<div class="${ns}">
