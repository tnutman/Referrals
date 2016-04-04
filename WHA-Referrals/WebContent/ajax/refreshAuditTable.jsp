<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../inc/sql.jsp"%>

<!-- Test to see whether we have a valid session -->
<c:if test="${empty sessionScope.u_id}">
    <!-- There is not a user **attribute** in the session -->
	<c:redirect url="../pages/login.jsp"/>
</c:if>

<sql:query dataSource="${snapshot}" var="audit_entries">
	SELECT audit_log.event, audit_log.datetime, audit_log.details, users.dname FROM audit_log INNER JOIN users ON audit_log.user = users.id WHERE referral_id = ? ORDER BY audit_log.datetime DESC;
	<sql:param value="${param.referral_id}" />
</sql:query>
<table class="table table-striped">
	<tr>
		<th>Date/Time</th>
		<th>Event</th>
		<th>User</th>
		<th>Details</th>
	</tr>
	<c:forEach var="audit_entry" items="${audit_entries.rows}">
		<tr>
			<td><c:out value="${audit_entry.datetime}" /></td>
			<td><c:out value="${audit_entry.event}" /></td>
			<td><c:out value="${audit_entry.dname}" /></td>
			<td><c:out value="${audit_entry.details}" /></td>
		</tr>
	</c:forEach> 
</table>


