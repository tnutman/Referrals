<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="../inc/sql.jsp"%>

<!-- Test to see whether we have a valid session -->
<c:if test="${empty sessionScope.u_id}">
    <!-- There is not a user **attribute** in the session -->
	<c:redirect url="../pages/login.jsp"/>
</c:if>

<c:set var="list" value="${param.list }" />
<c:choose>
	<c:when test="${list == 'welmede_locations' }">
		<c:set var="list" value="welmede_locations" />
		<c:set var="dlist" value="Welmede Locations" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, location FROM welmede_locations WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'locations' }">
		<c:set var="list" value="locations" />
		<c:set var="dlist" value="Locations" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, location FROM locations WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
</c:choose>

<c:set var="user_last_action" value="VIEW_LIST_ITEM_INLINE_EDIT" scope="session" />

<td colspan="4">

<form action="../UpdateLocationDef" method="post">	
		<c:forEach var="list_def" items="${list_defs.rows}">
			<div class="col-md-12">
            	<div class="form-group">
	           		<input type="text" class="form-control" id="list_entry_id" name="tmp" value="<c:out value="${list_def.id}" />" DISABLED>
	            </div>

           		<div class="form-group">
	            	<input type="text" class="form-control" id="list_entry" name="list_entry" value="<c:out value="${list_def.location}" />">
	            </div>
	            <input type="hidden" name="list" value="<c:out value="${list}" />">
	            <input type="hidden" name="list_entry_id" value="<c:out value="${list_def.id}" />">
				<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="Update User Details">
   					<i class="fa fa-save"></i>
   				</button>
			</div>
		</c:forEach>
	</form>	
</td>

	