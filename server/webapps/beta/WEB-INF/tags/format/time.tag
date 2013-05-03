<%@tag import="org.colony.lib.Formater"%>
<%@ taglib prefix="fmt"	uri="http://java.sun.com/jsp/jstl/fmt" 
%><%@ taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" 
%><%@ attribute name="ticks" type="java.lang.Integer"%><% if(ticks!=null) out.print(Formater.tickToTime(ticks));%>