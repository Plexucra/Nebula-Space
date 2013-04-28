<%@page import="org.colony.data.Schiffsmodell"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="/pages/include/page-header.jsp" %>

<script>
$(function()
{
	$.get('schlachtensimulator-ajax.jsp', function(data2) 
	{
		$("#mainDiv").html(data2);
	});
});
</script>
