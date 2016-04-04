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
			<c:when test="${param.field_name == 'locations_to_avoid' }">
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
			<c:when test="${param.field_name == 'status' }">
				<c:set var="display_field" value="Current Status" />
			</c:when>
		</c:choose>
			<c:choose>
				<c:when test="${param.field == 'responsible_id' }">
					<b>Responsible Person</b>
                   	<a class="pull-right">
                   		<sql:query dataSource="${snapshot}" var="users">
						SELECT dname FROM users WHERE id = ?;
						<sql:param value="${row.responsible_id}" />
						</sql:query>
						<c:forEach var="user" items="${users.rows}">
							<c:out value="${user.dname}" />
						</c:forEach>
                   	</a>
				</c:when>
				<c:when test="${param.field == 'ssid' }">
					<b>SSID</b> <a class="pull-right"><c:out value="${row.ssid}" /></a>
				</c:when>
				<c:when test="${param.field == 'name_referrer' }">
					<b>Name of Referrer</b>
                   	<a class="pull-right">
                   		<sql:query dataSource="${snapshot}" var="referrers">
						SELECT name FROM contacts WHERE id = ?;
						<sql:param value="${row.name_referrer}" />
						</sql:query>
					<c:forEach var="referrer" items="${referrers.rows}">
						<c:out value="${referrer.name}" />
					</c:forEach>
                   	</a>
				</c:when>
				<c:when test="${param.field == 'person_being_referred' }">
					<b>Person being Referred</b> <a class="pull-right"><c:out value="${row.person_being_referred}" /></a>
				</c:when>
				<c:when test="${param.field == 'dob' }">
					<b>Date of Birth</b> <a class="pull-right"><fmt:formatDate type="date" dateStyle="long" value="${row.dob}" /></a>
				</c:when>
				<c:when test="${param.field == 'age_start' }">
					<b>Age at Start</b> <a class="pull-right"><c:out value="${row.age_start}" /></a>
				</c:when>
				<c:when test="${param.field == 'gender' }">
					<b>Gender</b> <a class="pull-right"><c:out value="${row.gender}" /></a>
				</c:when>
				<c:when test="${param.field == 'date_of_first_contact' }">
					<b>Date of First Contact</b> <a class="pull-right"><fmt:formatDate type="date" dateStyle="long" value="${row.date_of_first_contact}" /></a>
				</c:when>
				<c:when test="${param.field == 'practitioner' }">
					<b>Name of Practitioner</b>
                   	<a class="pull-right">
                   		<sql:query dataSource="${snapshot}" var="practitioners">
						SELECT name FROM contacts WHERE id = ?;
						<sql:param value="${row.practitioner}" />
					</sql:query>
					<c:forEach var="practitioner" items="${practitioners.rows}">
						<c:out value="${practitioner.name}" />
					</c:forEach>
                   	</a>
				</c:when>
				<c:when test="${param.field == 'ref_locality_id' }">
					<b>Referring Locality</b>
                    	<a class="pull-right">
                    		<sql:query dataSource="${snapshot}" var="locality_defs">
							SELECT list_entry FROM locality_defs WHERE id = ?;
							<sql:param value="${row.ref_locality_id}" />
						</sql:query>
						<c:forEach var="locality_def" items="${locality_defs.rows}">
							<c:out value="${locality_def.list_entry}" />
						</c:forEach>
                    	</a>
				</c:when>
				<c:when test="${param.field == 'source_id' }">
					<b>Source of Referral</b>
                	<a class="pull-right">
                		<sql:query dataSource="${snapshot}" var="source_defs">
							SELECT list_entry FROM source_defs WHERE id = ?;
							<sql:param value="${row.source_id}" />
						</sql:query>
						<c:forEach var="source_def" items="${source_defs.rows}">
							<c:out value="${source_def.list_entry}" />
						</c:forEach>
                	</a>
				</c:when>
				<c:when test="${param.field == 'how_id' }">
					<b>How did they hear about us?</b>
                   	<a class="pull-right">
                   		<sql:query dataSource="${snapshot}" var="how_defs">
							SELECT list_entry FROM how_defs WHERE id = ?;
							<sql:param value="${referral.how_id}" />
						</sql:query>
						<c:forEach var="how_def" items="${how_defs.rows}">
							<c:out value="${how_def.list_entry}" />
						</c:forEach>
                   	</a>
				</c:when>
				<c:when test="${param.field == 'initial_contact_id' }">
					<b>Initial Means of Contact</b>
                   	<a class="pull-right">
                   		<sql:query dataSource="${snapshot}" var="initial_means_defs">
							SELECT list_entry FROM initial_means_defs WHERE id = ?;
							<sql:param value="${row.initial_contact_id}" />
						</sql:query>
						<c:forEach var="initial_means_def" items="${initial_means_defs.rows}">
							<c:out value="${initial_means_def.list_entry}" />
						</c:forEach>
                   	</a>
				</c:when>
				<c:when test="${param.field == 'current_loc' }">
					<th width="50%">Current Location</th>
					<td><a class="pull-right"><c:out value="${row.current_loc}" /></a></td>
				</c:when>
				<c:when test="${param.field == 'current_situation_id' }">
					<th>Current Situation</th>
					<td>
						<sql:query dataSource="${snapshot}" var="current_situation_defs">
						SELECT list_entry FROM current_situation_defs WHERE id = ?;
						<sql:param value="${row.current_situation_id}" />
						</sql:query>
						<c:forEach var="current_situation_def" items="${current_situation_defs.rows}">
							<a class="pull-right"><c:out value="${current_situation_def.list_entry}" /></a>
						</c:forEach>
					</td>
				</c:when>
				<c:when test="${param.field == 'location_prefs' }">
				<th>Location Preferences</th>
				<td>
					<sql:query dataSource="${snapshot}" var="location_preferences">
                 				SELECT location_prefs.location_id, locations.location FROM location_prefs INNER JOIN locations ON location_prefs.location_id = locations.id WHERE location_prefs.referral_id = ?; 
                 				<sql:param value="${row.id}" />
                 				</sql:query>
                 				<c:forEach var="location_preference" items="${location_preferences.rows}" varStatus="loopIndex">
                 					<c:choose>
                 						<c:when test="${location_preferences.rowCount == 1}">
                 							<a class="pull-right"><c:out value="${location_preference.location}" /></a>
                 						</c:when>
                 						<c:when test="${location_preferences.rowCount == loopIndex.count}">
                 							<a class="pull-right"><c:out value="${location_preference.location}" /></a>
                 						</c:when>
                 						<c:otherwise>
                 							<a class="pull-right"><c:out value="${location_preference.location}" /></a><br/>
                 						</c:otherwise>
                 					</c:choose>
                 				</c:forEach>
				</td>
				</c:when>
				<c:when test="${param.field == 'locations_avoid' }">
					<th>Locations To Avoid</th>
					<td>
						<sql:query dataSource="${snapshot}" var="locations_avoid">
               				SELECT locations_avoid.location_id, locations.location FROM locations_avoid INNER JOIN locations ON locations_avoid.location_id = locations.id WHERE locations_avoid.referral_id = ?; 
               				<sql:param value="${row.id}" />
           				</sql:query>
           				<c:forEach var="location_to_avoid" items="${locations_avoid.rows}" varStatus="loopIndex">
           					<c:choose>
           						<c:when test="${locations_avoid.rowCount == 1}">
           							<a class="pull-right"><c:out value="${location_to_avoid.location}" /></a>
           						</c:when>
           						<c:when test="${locations_avoid.rowCount == loopIndex.count}">
           							<a class="pull-right"><c:out value="${location_to_avoid.location}" /></a>
           						</c:when>
           						<c:otherwise>
           							<a class="pull-right"><c:out value="${location_to_avoid.location}" /></a><br/>
           						</c:otherwise>
           					</c:choose>
           				</c:forEach>
					</td>
				</c:when>
				<c:when test="${param.field == 'locations_suggested' }">
					<th>Locations Suggested</th>
					<td>
						<sql:query dataSource="${snapshot}" var="locations_suggested">
               				SELECT locations_suggested.location_id, welmede_locations.location FROM locations_suggested INNER JOIN welmede_locations ON locations_suggested.location_id = welmede_locations.id WHERE locations_suggested.referral_id = ?; 
               				<sql:param value="${row.id}" />
           				</sql:query>
           				<c:forEach var="location_suggested" items="${locations_suggested.rows}" varStatus="loopIndex">
           					<c:choose>
           						<c:when test="${location_suggested.rowCount == 1}">
           							<a class="pull-right"><c:out value="${location_suggested.location}" /></a>
           						</c:when>
           						<c:when test="${location_suggested.rowCount == loopIndex.count}">
           							<a class="pull-right"><c:out value="${location_suggested.location}" /></a>
           						</c:when>
           						<c:otherwise>
           							<a class="pull-right"><c:out value="${location_suggested.location}" /></a><br/>
           						</c:otherwise>
           					</c:choose>
           				</c:forEach>
					</td>
				</c:when>
				<c:when test="${param.field == 'essential_requirements' }">
					<th>Essential Property Requirements</th>
					<td>
						<sql:query dataSource="${snapshot}" var="essential_requirments">
	          				SELECT essential_requirements.property_req_id, property_requirements.list_entry FROM essential_requirements INNER JOIN property_requirements ON essential_requirements.property_req_id = property_requirements.id WHERE essential_requirements.referral_id = ?; 
	          				<sql:param value="${row.id}" />
	      				</sql:query>
	      				<c:forEach var="essential_requirment" items="${essential_requirments.rows}" varStatus="loopIndex">
	      					<c:choose>
	      						<c:when test="${essential_requirment.rowCount == 1}">
	      							<a class="pull-right"><c:out value="${essential_requirment.list_entry}" /></a>
	      						</c:when>
	      						<c:when test="${essential_requirment.rowCount == loopIndex.count}">
	      							<a class="pull-right"><c:out value="${essential_requirment.list_entry}" /></a>
	      						</c:when>
	      						<c:otherwise>
	      							<a class="pull-right"><c:out value="${essential_requirment.list_entry}" /></a><br/>
	      						</c:otherwise>
	      					</c:choose>
	      				</c:forEach>
					</td>
				</c:when>
				<c:when test="${param.field == 'young_transition' }">
					<th>Young Transition</th>
					<td>
						<a class="pull-right">
							<c:choose>
								<c:when test="${row.young_transition == false }">No</c:when>
								<c:when test="${row.young_transition == true }">Yes</c:when>
								<c:otherwise>Not Specified</c:otherwise>
							</c:choose>
						</a>
					</td>
				</c:when>
				<c:when test="${param.field == 'support_level_id' }">
					<th width="50%">Level of Support</th>
					<td>
						<a class="pull-right">
							<sql:query dataSource="${snapshot}" var="support_levels">
								SELECT list_entry FROM support_level_defs WHERE id = ?;
								<sql:param value="${row.support_level_id}" />
							</sql:query>
							<c:forEach var="support_level" items="${support_levels.rows}">
								<c:out value="${support_level.list_entry}" />
							</c:forEach>
						</a>
					</td>
				</c:when>
				<c:when test="${param.field == 'service_types_required' }">
				<th>Services Required</th>
					<td>
						<sql:query dataSource="${snapshot}" var="service_types_required">
               				SELECT service_types_required.service_type_id, service_types.list_entry FROM service_types_required INNER JOIN service_types ON service_types_required.service_type_id = service_types.id WHERE service_types_required.referral_id = ?; 
               				<sql:param value="${row.id}" />
          				</sql:query>
          				<c:forEach var="service_type_required" items="${service_types_required.rows}" varStatus="loopIndex">
          					<c:choose>
          						<c:when test="${service_type_required.rowCount == 1}">
          							<a class="pull-right"><c:out value="${service_type_required.list_entry}" /></a>
          						</c:when>
          						<c:when test="${service_type_required.rowCount == loopIndex.count}">
          							<a class="pull-right"><c:out value="${service_type_required.list_entry}" /></a>
          						</c:when>
          						<c:otherwise>
          							<a class="pull-right"><c:out value="${service_type_required.list_entry}" /></a><br/>
          						</c:otherwise>
          					</c:choose>
          				</c:forEach>
					</td>
				</c:when>
				<c:when test="${param.field == 'waking_nights' }">
					<th width="50%">Waking Nights</th>
					<td><a class="pull-right"><c:out value="${row.waking_nights}" /></a></td>
				</c:when>
				<c:when test="${param.field == 'specific_needs_behaviours' }">
					<th>Specific Needs</th>
						<td>
							<sql:query dataSource="${snapshot}" var="specific_needs">
                   				SELECT specific_needs_behaviours.specific_need_id, specific_need_defs.list_entry FROM specific_needs_behaviours INNER JOIN specific_need_defs ON specific_needs_behaviours.specific_need_id = specific_need_defs.id WHERE specific_needs_behaviours.referral_id = ?; 
                   				<sql:param value="${row.id}" />
               				</sql:query>
               				<c:forEach var="specific_need" items="${specific_needs.rows}" varStatus="loopIndex">
               					<c:choose>
               						<c:when test="${specific_need.rowCount == 1}">
               							<a class="pull-right"><c:out value="${specific_need.list_entry}" /></a>
               						</c:when>
               						<c:when test="${specific_need.rowCount == loopIndex.count}">
               							<a class="pull-right"><c:out value="${specific_need.list_entry}" /></a>
               						</c:when>
               						<c:otherwise>
               							<a class="pull-right"><c:out value="${specific_need.list_entry}" /></a><br/>
               						</c:otherwise>
               					</c:choose>
               				</c:forEach>
						</td>
				</c:when>
				<c:when test="${param.field == 'health_medical_needs' }">
					<th>Specific Health Needs</th>
						<td>
							<sql:query dataSource="${snapshot}" var="specific_health_needs">
                  				SELECT health_medical_needs.health_need_id, health_need_defs.list_entry FROM health_medical_needs INNER JOIN health_need_defs ON health_medical_needs.health_need_id = health_need_defs.id WHERE health_medical_needs.referral_id = ?; 
                  				<sql:param value="${row.id}" />
               				</sql:query>
               				<c:forEach var="specific_health_need" items="${specific_health_needs.rows}" varStatus="loopIndex">
               					<c:choose>
               						<c:when test="${specific_health_need.rowCount == 1}">
               							<a class="pull-right"><c:out value="${specific_health_need.list_entry}" /></a>
               						</c:when>
               						<c:when test="${specific_health_need.rowCount == loopIndex.count}">
               							<a class="pull-right"><c:out value="${specific_health_need.list_entry}" /></a>
               						</c:when>
               						<c:otherwise>
               							<a class="pull-right"><c:out value="${specific_health_need.list_entry}" /></a><br/>
               						</c:otherwise>
               					</c:choose>
               				</c:forEach>
						</td>
				</c:when>
				<c:when test="${param.field == 'status_id' }">
					<b>Current Status</b>
							                     	<a class="pull-right">
							                     		<sql:query dataSource="${snapshot}" var="statuses">
															SELECT list_entry FROM referral_status_defs WHERE id = ?;
															<sql:param value="${row.status_id}" />
														</sql:query>
														<c:forEach var="status" items="${statuses.rows}">
															<c:out value="${status.list_entry}" />
															<c:set var="status_value" value="${status.list_entry}" />
														</c:forEach>
							                     	</a>
							                    </li>
							                    <c:if test="${status_value == 'Declined' }">
							                    	<li class="list-group-item">
							                    		<b>Declining Authority</b>
							                    		<a class="pull-right">
								                     		<sql:query dataSource="${snapshot}" var="users">
																SELECT dname FROM users WHERE id = ?;
																<sql:param value="${row.decling_auth}" />
															</sql:query>
															<c:forEach var="user" items="${users.rows}">
																<c:out value="${user.dname}" />
															</c:forEach>
								                     	</a>
							                    	</li>
							                    	<li>
							                    		<c:out value="${row.declined_notes}" />
							                    	</li>
							                    </c:if>
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
				<c:when  test="${param.field_name == 'locations_to_avoid' }">
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
							<input type="hidden" name="table_name" id="table_<c:out value='${param.field_name}'/>" value="health_needs_defs" >
							<input type="hidden" name="source_display_name" id="source_display_<c:out value='${param.field_name}'/>" value="list_entry" >
							<input type="hidden" name="type_<c:out value='${param.field_name}'/>" id="type_<c:out value='${param.field_name}'/>" value="LIST">
							<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="" data-original-title="Update Field">
						   		<i class="fa fa-save"></i>
						   	</button>
						</form>
						<script>$("#<c:out value='${param.field_name}' />").select2();</script>
					</td>
				</c:when>
				<c:when  test="${param.field_name == 'status' }">
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
             page_display: $("#page_display_<c:out value='${param.field_name}'/>").val()
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
         });
       });
     
</script>

