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

<sql:query dataSource="${snapshot}" var="users">
	SELECT id, uname, dname, email, level, active FROM users WHERE id = ?;
	<sql:param value="${u_id}"/>
</sql:query>

<c:set var="user_last_action" value="VIEW_USER_INLINE_EDIT" scope="session" />

<td colspan="8">

<form action="../UpdateUser" method="post">	
		<c:forEach var="user" items="${users.rows}">
			<div class="col-md-6">
            	<div class="form-group">
	           		<input type="text" class="form-control" id="user_name" name="user_name" value="<c:out value="${user.uname}" />" DISABLED>
	            </div>

           		<div class="form-group">
	            	<input type="text" class="form-control" id="user_dname" name="user_dname" value="<c:out value="${user.dname}" />">
	            </div>

           		<div class="form-group">
           			<input type="text" class="form-control" id="user_email" name="user_email" value="<c:out value="${user.email}" />">
           		</div>
			</div>
			<div class="col-md-6">
           		<div class="form-group">
	            	<select class="form-control" id="user_region" name="user_region">
						<option value="UK" <c:if test="${user.region == 'UK'}"><c:out value="selected" /></c:if>>UK</option>
						<option value="EURO" <c:if test="${user.region == 'EURO'}"><c:out value="selected" /></c:if>>EURO</option>
						<option value="US" <c:if test="${user.region == 'US'}"><c:out value="selected" /></c:if>>US</option>
						<option value="ANZ" <c:if test="${user.region == 'ANZ'}"><c:out value="selected" /></c:if>>ANZ</option>
	            	</select>
	        	</div>

           		<div class="form-group">
	            	<select class="form-control" id="user_debug" name="user_debug">
						<option value="0" <c:if test="${user.debug == false}"><c:out value="selected" /></c:if>>None</option>
						<option value="1" <c:if test="${user.debug == true}"><c:out value="selected" /></c:if>>Session Data</option>
					</select>
	        	</div>

           		<div class="form-group">				
					<select class="form-control" id="user_status" name="user_status">
						<option value="0" <c:if test="${user.status == 0}"><c:out value="selected" /></c:if>>INACTIVE</option>
						<option value="1" <c:if test="${user.status == 1}"><c:out value="selected" /></c:if>>ACTIVE</option>
					</select>
	            </div>

           		<input type="hidden" class="form-control" id="user_id" name="user_id" value="${param.u_id}">
				<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="Update User Details">
   					<i class="fa fa-save"></i>
   				</button>
			</div>
		</c:forEach>
	</form>	
</td>

	