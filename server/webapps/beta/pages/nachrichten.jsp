<%@page import="org.colony.service.NachrichtService"%>
<%@ page pageEncoding="UTF-8"%>
<%@ include file="include/page-header.jsp" %>

<script>
$(function ()
{
	$(".dn_sysNachrichten td").each(function()
	{
		var schlachtid = $(this).children("span").attr("data_schlachtid");
		if(schlachtid && schlachtid>0)
		{
			$(this).append($("<span> | <a href='${up}/pages/modules/statistik/schlachtbericht.jsp?id="+schlachtid+"'>zum Schlachtbericht</a></span>").html());
			$(this).append($("<span> | <a href='${up}/pages/nebula.jsp?x="+$(this).children("span").attr("data_x")+"&y="+$(this).children("span").attr("data_y")+"'>zur Position</a></span>").html());
// 			alert(schlachtid);
		}
	});
});
</script>
<div>
	<% request.setAttribute("sysNachrichten",NachrichtService.getUngeleseneSystemNachrichten(s.getNutzer().getId())); %>
	<table class="dn_sysNachrichten">
		<tr><th>Systemnachricht</th></tr>	
		<c:forEach items="${ sysNachrichten }" var="row">
			<tr>
				<td>
					<fmt:formatDate value="${ row.datumGesendet }" type="BOTH"/> Uhr - 
<%-- 				 ${ row.datumGesendet } --%>
				 </td>
				<td>${ row.text }</td>
			</tr>	
		</c:forEach>
	</table>
</div>