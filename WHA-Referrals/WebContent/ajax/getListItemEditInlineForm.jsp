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
	<c:when test="${list == 'source_defs' }">
		<c:set var="list" value="source_defs" />
		<c:set var="dlist" value="Source of Referrals" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM source_defs WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'how_defs' }">
		<c:set var="list" value="how_defs" />
		<c:set var="dlist" value="How did you hear from us" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM how_defs WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'locality_defs' }">
		<c:set var="list" value="locality_defs" />
		<c:set var="dlist" value="Referring Locality" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM locality_defs WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'initial_means_defs' }">
		<c:set var="list" value="initial_means_defs" />
		<c:set var="dlist" value="Initial Means on Contact" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM initial_means_defs WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'current_situation_defs' }">
		<c:set var="list" value="current_situation_defs" />
		<c:set var="dlist" value="Current Situation" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM current_situation_defs WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'property_requirements' }">
		<c:set var="list" value="property_requirements" />
		<c:set var="dlist" value="Property Requirements" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM property_requirements WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'support_level_defs' }">
		<c:set var="list" value="support_level_defs" />
		<c:set var="dlist" value="Support Levels" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM support_level_defs WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'service_types' }">
		<c:set var="list" value="service_types" />
		<c:set var="dlist" value="Service Types" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM service_types WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'specific_need_defs' }">
		<c:set var="list" value="specific_need_defs" />
		<c:set var="dlist" value="Specific Needs/Behaviours" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM specific_need_defs WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
	<c:when test="${list == 'health_need_defs' }">
		<c:set var="list" value="health_need_defs" />
		<c:set var="dlist" value="Health/Medical Needs" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM health_need_defs WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
		<c:when test="${list == 'referral_status_defs' }">
		<c:set var="list" value="referral_status_defs" />
		<c:set var="dlist" value="Referral Statuses" />
		<sql:query dataSource="${snapshot}" var="list_defs">
			SELECT id, list_entry FROM referral_status_defs WHERE id = ?;
			<sql:param value="${param.id}" />
		</sql:query>
	</c:when>
</c:choose>

<c:set var="user_last_action" value="VIEW_LIST_ITEM_INLINE_EDIT" scope="session" />

<td colspan="4">

<form action="../UpdateListDef" method="post">	
		<c:forEach var="list_def" items="${list_defs.rows}">
			<div class="col-md-12">
            	<div class="form-group">
	           		<input type="text" class="form-control" id="list_entry_id" name="tmp" value="<c:out value="${list_def.id}" />" DISABLED>
	            </div>

           		<div class="form-group">
	            	<input type="text" class="form-control" id="list_entry" name="list_entry" value="<c:out value="${list_def.list_entry}" />">
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

	