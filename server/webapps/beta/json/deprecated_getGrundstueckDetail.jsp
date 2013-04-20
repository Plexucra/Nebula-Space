<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/init.jsp" %>
<% request.setAttribute("t_statement", "SELECT * from v_grundstueck_detail where id = "+request.getParameter("id")); %>
<%@ include file="include/genericSelect.jsp" %>
