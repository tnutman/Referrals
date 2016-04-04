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
<c:set var="table_item" value="false" />
<sql:query dataSource="${snapshot}" var="fields">
	SELECT * FROM referrals WHERE id = ?;
	<sql:param value="${param.referral_id}" />
</sql:query>

<c:forEach var="row" items="${fields.rows}">
	
		

		<c:choose>
			<c:when test="${param.field_name == 'responsible_id' }">
				<c:set var="display_field" value="Responsible Person" />
			</c:when>
			<c:when test="${param.field_name == 'ssid' }">
				<c:set var="display_field" value="SSID" />
			</c:when>
			<c:when test="${param.field_name == 'name_referrer' }">
				<c:set var="display_field" value="Name of Referrer" />
			</c:when>
			<c:when test="${param.field_name == 'person_being_referred' }">
				<c:set var="display_field" value="Person being Referred" />
			</c:when>
			<c:when test="${param.field_name == 'dob' }">
				<c:set var="display_field" value="Date of Birth" />
			</c:when>
			<c:when test="${param.field_name == 'age_start' }">
				<c:set var="display_field" value="Age at Start" />
			</c:when>
			<c:when test="${param.field_name == 'gender' }">
				<c:set var="display_field" value="Gender" />
			</c:when>
			<c:when test="${param.field_name == 'date_of_first_contact' }">
				<c:set var="display_field" value="Date of First Contact" />
			</c:when>
			<c:when test="${param.field_name == 'practitioner' }">
				<c:set var="display_field" value="Name of Practitioner" />
			</c:when>
			<c:when test="${param.field_name == 'ref_locality_id' }">
				<c:set var="display_field" value="Referring Locality" />
			</c:when>
			<c:when test="${param.field_name == 'source_id' }">
				<c:set var="display_field" value="Source of Referral" />
			</c:when>
			<c:when test="${param.field_name == 'how_id' }">
				<c:set var="display_field" value="How did they hear about us?" />
			</c:when>
			<c:when test="${param.field_name == 'initial_contact_id' }">
				<c:set var="display_field" value="Initial Means of Contact" />
			</c:when>
			<c:when test="${param.field_name == 'current_loc' }">
				<c:set var="display_field" value="Current Location" />
			</c:when>
			<c:when test="${param.field_name == 'current_situation' }">
				<c:set var="display_field" value="Current Situation" />
			</c:when>
			<c:when test="${param.field_name == 'location_prefs' }">
				<c:set var="display_field" value="Location Preferences" />
			</c:when>
			<c:when test="${param.field_name == 'locations_avoid' }">
				<c:set var="display_field" value="Locations to Avoid" />
			</c:when>
			<c:when test="${param.field_name == 'locations_suggested' }">
				<c:set var="display_field" value="Locations Suggested" />
			</c:when>
			<c:when test="${param.field_name == 'essential_requirements' }">
				<c:set var="display_field" value="Essential Property Requirements" />
			</c:when>
			<c:when test="${param.field_name == 'young_transition' }">
				<c:set var="display_field" value="Young Transition" />
			</c:when>
			<c:when test="${param.field_name == 'level_of_support' }">
				<c:set var="display_field" value="Level of Support" />
			</c:when>
			<c:when test="${param.field_name == 'services_required' }">
				<c:set var="display_field" value="Services Required" />
			</c:when>
			<c:when test="${param.field_name == 'waking_nights' }">
				<c:set var="display_field" value="Waking Nights" />
			</c:when>
			<c:when test="${param.field_name == 'specific_needs' }">
				<c:set var="display_field" value="Specific Needs" />
			</c:when>
			<c:when test="${param.field_name == 'specific_health_needs' }">
				<c:set var="display_field" value="Specific Health Needs" />
			</c:when>
			<c:when test="${param.field_name == 'status_id' }">
				<c:set var="display_field" value="Current Status" />
			</c:when>
		</c:choose>
			<c:choose>
				<c:when test="${param.field_name == 'responsible_id' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<sql:query dataSource="${snapshot}" var="users">
									SELECT * FROM users;
								</sql:query>
								<c:forEach var="user" items="${users.rows}">
									<option value="<c:out value="${user.id}" />" <c:if test="${user.id == rwo.responsible_id}">selected</c:if>><c:out value="${user.dname}" />
								</c:forEach>
							</select>
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="users" >
						<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="dname" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
						<input type="hidden" name="page_display_<c:out value='${param.field_name}'/>" id="page_display_<c:out value='${param.field_name}'/>" value='${param.page_display}'>
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
					<script>$("#<c:out value='${param.field_name}' />").select2();</script>
				</c:when>
				<c:when test="${param.field_name == 'name_referrer' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<sql:query dataSource="${snapshot}" var="contacts">
									SELECT * FROM contacts;
								</sql:query>
								<c:forEach var="contact" items="${contacts.rows}">
									<option value="<c:out value="${contact.id}" />" <c:if test="${contact.id == row.name_referrer}">selected</c:if>><c:out value="${contact.name}" />
								</c:forEach>
							</select>
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="contacts" >
						<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="name" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
					<script>$("#<c:out value='${param.field_name}' />").select2();</script>
				</c:when>
				<c:when test="${param.field_name == 'dob' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<input type="date" class="form-control" id="${param.field_name}" name="${param.field_name}" value="<c:out value="${row[param.field_name]}" />">
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="referrals" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="DATE">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
				</c:when>
				<c:when test="${param.field_name == 'gender' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
						<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<option value="Not Known" <c:if test="${row.gender == 'Not Known'}">selected</c:if>>Not Known</option>
								<option value="Male" <c:if test="${row.gender == 'Male'}">selected</c:if>>Male</option>
								<option value="Female" <c:if test="${row.gender == 'Female'}">selected</c:if>>Female</option>
							</select>
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="referrals" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="STRING">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
				</c:when>
				<c:when test="${param.field_name == 'date_of_first_contact' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<input type="date" class="form-control" id="${param.field_name}" name="${param.field_name}" value="<c:out value="${row[param.field_name]}" />">
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="referrals" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="DATE">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
				</c:when>
				<c:when test="${param.field_name == 'practitioner' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<sql:query dataSource="${snapshot}" var="contacts">
									SELECT * FROM contacts;
								</sql:query>
								<c:forEach var="contact" items="${contacts.rows}">
									<option value="<c:out value="${contact.id}" />" <c:if test="${contact.id == row.practitioner}">selected</c:if>><c:out value="${contact.name}" />
								</c:forEach>
							</select>
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="contacts" >
						<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="name" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
					<script>$("#<c:out value='${param.field_name}' />").select2();</script>
				</c:when>
				<c:when test="${param.field_name == 'ref_locality_id' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<sql:query dataSource="${snapshot}" var="locality_defs">
									SELECT * FROM locality_defs;
								</sql:query>
								<c:forEach var="locality_def" items="${locality_defs.rows}">
									<option value="<c:out value="${locality_def.id}" />" <c:if test="${locality_def.id == row.ref_locality_id}">selected</c:if>><c:out value="${locality_def.list_entry}" />
								</c:forEach>
							</select>
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="locality_defs" >
						<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="list_entry" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
					<script>$("#<c:out value='${param.field_name}' />").select2();</script>
				</c:when>
				<c:when test="${param.field_name == 'source_id' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<sql:query dataSource="${snapshot}" var="source_defs">
									SELECT * FROM source_defs;
								</sql:query>
								<c:forEach var="source_def" items="${source_defs.rows}">
									<option value="<c:out value="${source_def.id}" />" <c:if test="${source_def.id == row.source_id}">selected</c:if>><c:out value="${source_def.list_entry}" />
								</c:forEach>
							</select>
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="source_defs" >
						<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="list_entry" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
					<script>$("#<c:out value='${param.field_name}' />").select2();</script>
				</c:when>
				<c:when test="${param.field_name == 'how_id' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<sql:query dataSource="${snapshot}" var="how_defs">
									SELECT * FROM how_defs;
								</sql:query>
								<c:forEach var="how_def" items="${how_defs.rows}">
									<option value="<c:out value="${how_def.id}" />" <c:if test="${how_def.id == row.how_id}">selected</c:if>><c:out value="${how_def.list_entry}" />
								</c:forEach>
							</select>
							</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="how_defs" >
						<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="list_entry" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
					<script>$("#<c:out value='${param.field_name}' />").select2();</script>
				</c:when>
				<c:when test="${param.field_name == 'initial_contact_id' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<sql:query dataSource="${snapshot}" var="initial_means_defs">
									SELECT * FROM initial_means_defs;
								</sql:query>
								<c:forEach var="initial_means_def" items="${initial_means_defs.rows}">
									<option value="<c:out value="${initial_means_def.id}" />" <c:if test="${initial_means_def.id == row.initial_contact_id}">selected</c:if>><c:out value="${initial_means_def.list_entry}" />
								</c:forEach>
							</select>
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="initial_means_defs" >
						<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="list_entry" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
					<script>$("#<c:out value='${param.field_name}' />").select2();</script>
				</c:when>
				<c:when  test="${param.field_name == 'current_loc' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<input type="text" class="form-control" id="${param.field_name}" name="${param.field_name}" value="<c:out value="${row[param.field_name]}" />">
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="referrals" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="STRING">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'current_situation_id' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<sql:query dataSource="${snapshot}" var="current_situation_defs">
									SELECT * FROM current_situation_defs;
								</sql:query>
								<c:forEach var="current_situation_def" items="${current_situation_defs.rows}">
									<option value="<c:out value="${current_situation_def.id}" />" <c:if test="${current_situation_def.id == row.current_situation_id}">selected</c:if>><c:out value="${current_situation_def.list_entry}" />
								</c:forEach>
							</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="current_situation_defs" >
							<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="list_entry" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'location_prefs' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}" multiple="multiple">
									<sql:query dataSource="${snapshot}" var="referral_locations">
										SELECT location_id FROM location_prefs WHERE referral_id = ?;
										<sql:param value="${param.referral_id }" />
									</sql:query>
									<sql:query dataSource="${snapshot}" var="locations">
										SELECT id, location FROM locations;
									</sql:query>
									<c:forEach var="location" items="${locations.rows}">
										<option value="<c:out value="${location.id}" />" <c:forEach var="referral_location" items="${referral_locations.rows}"><c:if test="${location.id == referral_location.location_id}">selected</c:if></c:forEach>  >
											<c:out value="${location.location}" />
										</option>
									</c:forEach>
								</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="attribute_name_<c:out value='${param.field_name}'/>" id="attribute_name_<c:out value='${param.field_name}'/>" value="location_id" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="locations" >
							<input type="hidden" name="source_display_name" id="source_display_<c:out value='${param.field_name}'/>" value="location" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="LIST">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
						<script>$("#<c:out value='${param.field_name}' />").select2({tags: true});</script>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'locations_avoid' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}" multiple="multiple">
									<sql:query dataSource="${snapshot}" var="referral_locations">
										SELECT location_id FROM locations_avoid WHERE referral_id = ?;
										<sql:param value="${param.referral_id }" />
									</sql:query>
									<sql:query dataSource="${snapshot}" var="locations">
										SELECT id, location FROM locations;
									</sql:query>
									<c:forEach var="location" items="${locations.rows}">
										<option value="<c:out value="${location.id}" />" <c:forEach var="referral_location" items="${referral_locations.rows}"><c:if test="${location.id == referral_location.location_id}">selected</c:if></c:forEach>  >
											<c:out value="${location.location}" />
										</option>
									</c:forEach>
								</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="attribute_name_<c:out value='${param.field_name}'/>" id="attribute_name_<c:out value='${param.field_name}'/>" value="location_id" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="locations" >
							<input type="hidden" name="source_display_name" id="source_display_<c:out value='${param.field_name}'/>" value="location" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="LIST">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
						<script>$("#<c:out value='${param.field_name}' />").select2({tags: true});</script>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'locations_suggested' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}" multiple="multiple">
									<sql:query dataSource="${snapshot}" var="locations_suggested">
										SELECT location_id FROM locations_suggested WHERE referral_id = ?;
										<sql:param value="${param.referral_id }" />
									</sql:query>
									<sql:query dataSource="${snapshot}" var="locations">
										SELECT id, location FROM welmede_locations;
									</sql:query>
									<c:forEach var="location" items="${locations.rows}">
										<option value="<c:out value="${location.id}" />" <c:forEach var="location_suggested" items="${locations_suggested.rows}"><c:if test="${location.id == location_suggested.location_id}">selected</c:if></c:forEach>  >
											<c:out value="${location.location}" />
										</option>
									</c:forEach>
								</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="attribute_name_<c:out value='${param.field_name}'/>" id="attribute_name_<c:out value='${param.field_name}'/>" value="location_id" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="welmede_locations" >
							<input type="hidden" name="source_display_name" id="source_display_<c:out value='${param.field_name}'/>" value="location" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="LIST">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
						<script>$("#<c:out value='${param.field_name}' />").select2();</script>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'essential_requirements' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}" multiple="multiple">
									<sql:query dataSource="${snapshot}" var="essential_requirements">
										SELECT property_req_id FROM essential_requirements WHERE referral_id = ?;
										<sql:param value="${param.referral_id }" />
									</sql:query>
									<sql:query dataSource="${snapshot}" var="property_requirements">
										SELECT id, list_entry FROM property_requirements;
									</sql:query>
									<c:forEach var="property_requirement" items="${property_requirements.rows}">
										<option value="<c:out value="${property_requirement.id}" />" <c:forEach var="essential_requirement" items="${essential_requirements.rows}"><c:if test="${property_requirement.id == essential_requirement.property_req_id}">selected</c:if></c:forEach>  >
											<c:out value="${property_requirement.list_entry}" />
										</option>
									</c:forEach>
								</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="attribute_name_<c:out value='${param.field_name}'/>" id="attribute_name_<c:out value='${param.field_name}'/>" value="property_req_id" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="property_requiremetns" >
							<input type="hidden" name="source_display_name" id="source_display_<c:out value='${param.field_name}'/>" value="list_entry" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="LIST">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
						<script>$("#<c:out value='${param.field_name}' />").select2();</script>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'young_transition' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}">
									<option value="false" <c:if test="${row.young_transition == 'false'}">selected</c:if>>No</option>
									<option value="true" <c:if test="${row.young_transition == 'true'}">selected</c:if>>Yes</option>
								</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="referrals" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="BOOLEAN">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'support_level_id' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}" >
								<sql:query dataSource="${snapshot}" var="support_level_defs">
									SELECT * FROM support_level_defs;
								</sql:query>
								<c:forEach var="support_level_def" items="${support_level_defs.rows}">
									<option value="<c:out value="${support_level_def.id}" />" <c:if test="${support_level_def.id == row.support_level_id}">selected</c:if>><c:out value="${support_level_def.list_entry}" />
								</c:forEach>
							</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="support_level_defs" >
							<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="list_entry" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'service_types_required' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}" multiple="multiple">
									<sql:query dataSource="${snapshot}" var="service_types_required">
										SELECT service_type_id FROM service_types_required WHERE referral_id = ?;
										<sql:param value="${param.referral_id }" />
									</sql:query>
									<sql:query dataSource="${snapshot}" var="service_types">
										SELECT id, list_entry FROM service_types;
									</sql:query>
									<c:forEach var="service_type" items="${service_types.rows}">
										<option value="<c:out value="${service_type.id}" />" <c:forEach var="service_type_required" items="${service_types_required.rows}"><c:if test="${service_type.id == service_type_required.service_type_id}">selected</c:if></c:forEach>  >
											<c:out value="${service_type.list_entry}" />
										</option>
									</c:forEach>
								</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="service_types" >
							<input type="hidden" name="attribute_name_<c:out value='${param.field_name}'/>" id="attribute_name_<c:out value='${param.field_name}'/>" value="service_type_id" >
							<input type="hidden" name="source_display_name" id="source_display_<c:out value='${param.field_name}'/>" value="list_entry" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="LIST">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
						<script>$("#<c:out value='${param.field_name}' />").select2();</script>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'waking_nights' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}">
									<option value="WAKING" <c:if test="${row.waking_nights == 'WAKING'}">selected</c:if>>Waking Nights</option>
    								<option value="SLEEP-IN" <c:if test="${row.waking_nights == 'SLEEP-IN'}">selected</c:if>>Sleep In</option>
									<option value="NA" <c:if test="${row.waking_nights == 'NA'}">selected</c:if>>Not Applicable</option>
								</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="referrals" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="STRING">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'specific_needs_behaviours' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}" multiple="multiple">
									<sql:query dataSource="${snapshot}" var="specific_needs_behaviours">
										SELECT specific_need_id FROM specific_needs_behaviours WHERE referral_id = ?;
										<sql:param value="${param.referral_id }" />
									</sql:query>
									<sql:query dataSource="${snapshot}" var="specific_need_defs">
										SELECT id, list_entry FROM specific_need_defs;
									</sql:query>
									<c:forEach var="specific_need_def" items="${specific_need_defs.rows}">
										<option value="<c:out value="${specific_need_def.id}" />" <c:forEach var="specific_need_behaviour" items="${specific_needs_behaviours.rows}"><c:if test="${specific_need_def.id == specific_need_behaviour.specific_need_id}">selected</c:if></c:forEach>  >
											<c:out value="${specific_need_def.list_entry}" />
										</option>
									</c:forEach>
								</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="specific_need_defs" >
							<input type="hidden" name="attribute_name_<c:out value='${param.field_name}'/>" id="attribute_name_<c:out value='${param.field_name}'/>" value="specific_need_id" >
							<input type="hidden" name="source_display_name" id="source_display_<c:out value='${param.field_name}'/>" value="list_entry" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="LIST">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
						<script>$("#<c:out value='${param.field_name}' />").select2();</script>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'health_medical_needs' }">
					<td colspan="2">
						<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
							<div class="form-group">
								<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
								<select class="form-control" id="${param.field_name}" name="${param.field_name}" multiple="multiple">
									<sql:query dataSource="${snapshot}" var="health_medical_needs">
										SELECT health_need_id FROM health_medical_needs WHERE referral_id = ?;
										<sql:param value="${param.referral_id }" />
									</sql:query>
									<sql:query dataSource="${snapshot}" var="health_need_defs">
										SELECT id, list_entry FROM health_need_defs;
									</sql:query>
									<c:forEach var="health_need_def" items="${health_need_defs.rows}">
										<option value="<c:out value="${health_need_def.id}" />" <c:forEach var="health_medical_need" items="${health_medical_needs.rows}"><c:if test="${health_need_def.id == health_medical_need.health_need_id}">selected</c:if></c:forEach>  >
											<c:out value="${health_need_def.list_entry}" />
										</option>
									</c:forEach>
								</select>
							</div>
							<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
							<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="health_need_defs" >
							<input type="hidden" name="attribute_name_<c:out value='${param.field_name}'/>" id="attribute_name_<c:out value='${param.field_name}'/>" value="health_need_id" >
							<input type="hidden" name="source_display_name" id="source_display_<c:out value='${param.field_name}'/>" value="list_entry" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="LIST">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
						<script>$("#<c:out value='${param.field_name}' />").select2();</script>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'status_id' }">
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<div class="form-group">
							<label for="<c:out value="${param.field_name}" />"><c:out value="${display_field}" /></label>
							<select class="form-control" id="${param.field_name}" name="${param.field_name}" onChange="status_decline_check();">
								<sql:query dataSource="${snapshot}" var="referral_status_defs">
									SELECT * FROM referral_status_defs;
								</sql:query>
								<c:forEach var="referral_status_def" items="${referral_status_defs.rows}">
									<option value="<c:out value="${referral_status_def.id}" />" <c:if test="${referral_status_def.id == row.status_id}">selected</c:if>><c:out value="${referral_status_def.list_entry}" />
								</c:forEach>
							</select>
						</div>
						<div class="form-group" id="decline_authority" style="display:none !important;">
						 	<label for="status_decline_authority">Declining Authority</label>
						 	<select class="form-control" id="${param.field_name}_decline_auth" name="${param.field_name}_decline_auth" >
								<sql:query dataSource="${snapshot}" var="users">
									SELECT * FROM users;
								</sql:query>
								<c:forEach var="user" items="${users.rows}">
									<option value="<c:out value="${user.id}" />" <c:if test="${user.id == row.decling_auth}">selected</c:if>><c:out value="${user.dname}" />
								</c:forEach>
							</select>
						</div>
						<div class="form-group" id="decline_reasons" style="visibility:hidden !important;">
						 	<label for="status_decline_reasons">Reasons for Declining</label>
						 	<select class="form-control" id="${param.field_name}_decline_reasons" name="${param.field_name}_decline_reasons" multiple="multiple">
						 		<sql:query dataSource="${snapshot}" var="reasons_for_declining">
										SELECT decline_id FROM reasons_for_declining WHERE referral_id = ?;
										<sql:param value="${param.referral_id }" />
									</sql:query>
									<sql:query dataSource="${snapshot}" var="decline_reason_defs">
										SELECT id, list_entry FROM decline_reason_defs;
									</sql:query>
									<c:forEach var="decline_reason_def" items="${decline_reason_defs.rows}">
										<option value="<c:out value="${decline_reason_def.id}" />" <c:forEach var="reason_for_declining" items="${reasons_for_declining.rows}"><c:if test="${decline_reason_def.id == reason_for_declining.decline_id}">selected</c:if></c:forEach>  >
											<c:out value="${decline_reason_def.list_entry}" />
										</option>
									</c:forEach>
						 	</select>
						</div>
						<div class="form-group" id="decline_notes" style="display:none !important;">
						 	<label for="status_decline_notes">Comments</label>
						 	<textarea id="status_decline_notes" class="form-control" name="${param.field_name}_decline_notes">
						 		<c:out value="${row.declined_notes}" />
						 	</textarea>
						</div>
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="referral_status_defs" >
						<input type="hidden" name="display_name" id="display_<c:out value='${param.field_name}'/>" value="list_entry" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="INT">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
					<script>
						$("#<c:out value='${param.field_name}_decline_reasons' />").select2();
						function status_decline_check(){
							var e = document.getElementById("<c:out value="${param.field_name}"/>");
							var statusText = e.options[e.selectedIndex].text;
							if (statusText == "Declined") {
								document.getElementById("decline_authority").style.display = "block";
								document.getElementById("decline_reasons").style.visibility = "visible";
								document.getElementById("decline_notes").style.display = "block";
								
							}
							else {
								var d1 = document.getElementById("decline_authority").style.display = "none";
								var d1 = document.getElementById("decline_reasons").style.visibility = "hidden";
								var d1 = document.getElementById("decline_notes").style.display = "none";
							}
						}
					</script>
				</c:when>
				<c:otherwise>
					<form action="../UpdateField" method="post" id="std_items_form_<c:out value='${param.field_name}' />">
						<input type="text" class="form-control" id="${param.field_name}" name="${param.field_name}" value="<c:out value="${row[param.field_name]}" />">
						<input type="hidden" name="referral_id" id="referral_id" value="${param.referral_id}" >
						<input type="hidden" name="field_name" id="field_name" value="<c:out value='${param.field_name}'/>" >
						<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="STRING">
						<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
					   		<i class="fa fa-save"></i>
					   	</button>
					</form>
				</c:otherwise>
			</c:choose>


</c:forEach>

<script>

	


              
     $("#std_items_form_<c:out value='${param.field_name}' />").submit(function(event) {

         /* stop form from submitting normally */
         event.preventDefault();
         var $form = $( this ),
         url = $form.attr( 'action' );
         var foo = [];
         $('#<c:out value='${param.field_name}' /> :selected').each(function(i, selected) { foo[i] = $(selected).text();});
        	 var posting = $.post( url, {
        	 new_value: $('#<c:out value='${param.field_name}' />').val(),
             referral_id: $('#referral_id').val(),
             field_name: "<c:out value='${param.field_name}' />",
             table: $("#table_<c:out value='${param.field_name}'/>").val(),
        	 display: $("#display_<c:out value='${param.field_name}'/>").val(),
        	 source_display: $("#source_display_<c:out value='${param.field_name}'/>").val(),
             type: $("#type_<c:out value='${param.field_name}' />").val(),
             page_display: $("#page_display_<c:out value='${param.field_name}'/>").val(),
             attribute_name: $("#attribute_name_<c:out value='${param.field_name}'/>").val()
             });
        	 
         
         

         /* Alerts the results */
         posting.done(function( data ) {
           //alert(data);
           $.ajax({
       			type: 'POST',
       			url: '../ajax/refreshReferralItemDisplay.jsp',
       			data: '&referral_id=<c:out value="${param.referral_id}"/>&field=<c:out value='${param.field_name}'/>',
       			success: function(data) {
       				$('#<c:out value="${param.elem_id}"/>').html(data);
       			}
       		});
           $.ajax({
      			type: 'POST',
      			url: '../ajax/refreshAuditTable.jsp',
      			data: '&referral_id=<c:out value="${param.referral_id}"/>',
      			success: function(data) {
      				$('#audit_table').html(data);
      			}
      		});
           
         });
       });
     
</script>

