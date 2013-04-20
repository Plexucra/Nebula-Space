<%@ taglib prefix="fmt"	uri="http://java.sun.com/jsp/jstl/fmt" 
%><%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" 
%><%@ attribute name="value"%><% jspContext.setAttribute("t_value", value); 
%><fmt:formatNumber maxFractionDigits="1" value="${t_value}"/>