<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.Date,java.text.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../inc/sql.jsp"%>

<!-- Test to see whether we have a valid session -->
<c:if test="${empty sessionScope.u_id}">
    <!-- There is not a user **attribute** in the session -->
    <c:set var="system_msg" value="Your session has expired" scope="session" />
	<c:redirect url="login"/>
</c:if>

<c:set var="now" value="<%=new java.util.Date()%>" />

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>WHA-Referrals | Referral Management</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="../bootstrap/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <!-- <link rel="stylesheet" href="../dist/css/font-awesome.min.css"> -->
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <!--<link rel="stylesheet" href="../dist/css/ionicons.min.css">-->
    <!-- jvectormap -->
    <link rel="stylesheet" href="../plugins/jvectormap/jquery-jvectormap-1.2.2.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="../dist/css/skins/_all-skins.min.css">
    <link rel="stylesheet" href="../plugins/datatables/dataTables.bootstrap.css">
	<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.2-rc.1/css/select2.min.css" rel="stylesheet" />
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    <style>
    
    select2 select2-container select2-container--default {
    	width: 100%;
    	height: 34px;
    }
    .select2-container .select2-selection--single {
    	height: 34px;
    }
    select2-selection select2-selection--single {
    	height: 34px;
    }
    .select2-container
    .select2-selection--multiple {
    	border-color: #d2d6de;
    }
    .select2-container
    .select2-selection--single {
    	border-color: #d2d6de;
    }
    .select2-container
    .select2-selection--multiple
    .select2-selection__choice {
    	background-color: #00a65a;
    	border: 1px solid transparent;
    }
    .select2-container
    .select2-selection--single
    .select2-selection__choice {
    	background-color: #00a65a;
    	border: 1px solid transparent;
    }
    </style>
  </head>
  <body class="hold-transition skin-blue sidebar-mini sidebar-collapse">
    <div class="wrapper">
    
		<%@ include file="../inc/header.jsp"%>
		<%@ include file="../inc/aside.jsp"%>
      
      

      <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
            Referrals
            <small>Version 1.0 Beta</small>
          </h1>
          
          <ol id="breadcrumbTarget" class="breadcrumb">
            <li><a href="dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
            <li class="active"><a href="#"><i class="fa fa-dashboard"></i> Referrals</a></li>
          </ol>
          
        </section>


		<%@ include file="../inc/debug.jsp"%>

		<!-- Where is the referral ID - is it in the session ie, mid-wizard, or via a parameter from the dashboard -->
		<c:choose>
			<c:when test="${empty param.referral_id}">
				<c:if test="${empty sessionScope.new_referral_id}">
					<!-- no referral id specified -->
				</c:if>
			</c:when>
			<c:when test="${not empty param.referral_id}">
				<c:set var="referral_id" value="${param.referral_id }" />
				<c:set var="new_referral_id" value="${param.referral_id}" scope="session"/>
			</c:when>
			<c:when test="${not empty sessionScope.new_referral_id}">
				<c:set var="referral_id" value="${sessionScope.new_referral_id }" />
			</c:when>
		</c:choose>

        <!-- Main content -->
        <section class="content">
        
		<c:choose>
			<c:when test="${empty param.newReferral}">
				<sql:query dataSource="${snapshot}" var="referrals">
					SELECT * FROM referrals WHERE id = ?;
					<sql:param value="${referral_id}" />
				</sql:query>
				<c:forEach var="referral" items="${referrals.rows }">
					<div class="row">
						<div class="col-lg-3">
							<div class="box box-primary">
								<div class="box-header">
									<i class="fa fa-folder-open"></i>
									<h3 class="box-title">Referral Ref: <c:out value="${referral.id}" /></h3><br>
								</div>
								<div class="box-body box-profile">
									<ul class="list-group list-group-unbordered">
										<li id="responsible_li_item" class="list-group-item" ondblclick="showStandardEdit('responsible_li_item',<c:out value="${referral.id}"/>,'responsible_id','list_item');">
					                     	<b>Responsible Person</b>
					                     	<a class="pull-right">
					                     		<sql:query dataSource="${snapshot}" var="users">
													SELECT dname FROM users WHERE id = ?;
													<sql:param value="${referral.responsible_id}" />
												</sql:query>
												<c:forEach var="user" items="${users.rows}">
													<c:out value="${user.dname}" />
												</c:forEach>
					                     	</a>
					                    </li>
					                    <li id="ssid_li_item" class="list-group-item" ondblclick="showStandardEdit('ssid_li_item',<c:out value="${referral.id}"/>,'ssid');">
					                     	<b>SSID</b> <a class="pull-right"><c:out value="${referral.ssid}" /></a>
					                    </li>
				                    	<li id="name_li_item" class="list-group-item" ondblclick="showStandardEdit('name_li_item',<c:out value="${referral.id}"/>,'name_referrer');">
					                     	<b>Name of Referrer</b>
					                     	<a class="pull-right">
					                     		<sql:query dataSource="${snapshot}" var="referrers">
													SELECT name FROM contacts WHERE id = ?;
													<sql:param value="${referral.name_referrer}" />
												</sql:query>
												<c:forEach var="referrer" items="${referrers.rows}">
													<c:out value="${referrer.name}" />
												</c:forEach>
					                     	</a>
					                    </li>
					                    <li id="person_li_item" class="list-group-item" ondblclick="showStandardEdit('person_li_item',<c:out value="${referral.id}"/>,'person_being_referred');">
					                     	<b>Person being Referred</b> <a class="pull-right"><c:out value="${referral.person_being_referred}" /></a>
					                    </li>
					                    <li id="dob_li_item" class="list-group-item" ondblclick="showStandardEdit('dob_li_item',<c:out value="${referral.id}"/>,'dob');">
					                     	<b>Date of Birth</b> <a class="pull-right"><fmt:formatDate type="date" dateStyle="long" value="${referral.dob}" /></a>
					                    </li>
					                    <li id="age_li_item" class="list-group-item" ondblclick="showStandardEdit('age_li_item',<c:out value="${referral.id}"/>,'age_start');">
					                     	<b>Age at Start</b> <a class="pull-right"><c:out value="${referral.age_start}" /></a>
					                    </li>
					                    <li id="gender_li_item" class="list-group-item" ondblclick="showStandardEdit('gender_li_item',<c:out value="${referral.id}"/>,'gender');">
					                     	<b>Gender</b> <a class="pull-right"><c:out value="${referral.gender}" /></a>
					                    </li>
					                    <li id="firstContact_li_item" class="list-group-item" ondblclick="showStandardEdit('firstContact_li_item',<c:out value="${referral.id}"/>,'date_of_first_contact');">
					                     	<b>Date of First Contact</b> <a class="pull-right"><fmt:formatDate type="date" dateStyle="long" value="${referral.date_of_first_contact}" /></a>
					                    </li>
					                    <li id="practitioner_li_item" class="list-group-item" ondblclick="showStandardEdit('practitioner_li_item',<c:out value="${referral.id}"/>,'practitioner');">
					                     	<b>Name of Practitioner</b>
					                     	<a class="pull-right">
					                     		<sql:query dataSource="${snapshot}" var="practitioners">
													SELECT name FROM contacts WHERE id = ?;
													<sql:param value="${referral.practitioner}" />
												</sql:query>
												<c:forEach var="practitioner" items="${practitioners.rows}">
													<c:out value="${practitioner.name}" />
												</c:forEach>
					                     	</a>
					                    </li>
					                    <li id="locality_li_item" class="list-group-item" ondblclick="showStandardEdit('locality_li_item',<c:out value="${referral.id}"/>,'ref_locality_id');">
					                     	<b>Referring Locality</b>
					                     	<a class="pull-right">
					                     		<sql:query dataSource="${snapshot}" var="locality_defs">
													SELECT list_entry FROM locality_defs WHERE id = ?;
													<sql:param value="${referral.ref_locality_id}" />
												</sql:query>
												<c:forEach var="locality_def" items="${locality_defs.rows}">
													<c:out value="${locality_def.list_entry}" />
												</c:forEach>
					                     	</a>
					                    </li>
					                    <li id="source_li_item" class="list-group-item" ondblclick="showStandardEdit('source_li_item',<c:out value="${referral.id}"/>,'source_id');">
					                     	<b>Source of Referral</b>
					                     	<a class="pull-right">
					                     		<sql:query dataSource="${snapshot}" var="source_defs">
													SELECT list_entry FROM source_defs WHERE id = ?;
													<sql:param value="${referral.source_id}" />
												</sql:query>
												<c:forEach var="source_def" items="${source_defs.rows}">
													<c:out value="${source_def.list_entry}" />
												</c:forEach>
					                     	</a>
					                    </li>
					                    <li id="how_li_item" class="list-group-item" ondblclick="showStandardEdit('how_li_item',<c:out value="${referral.id}"/>,'how_id');">
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
					                    </li>
					                     <li id="initial_means_li_item" class="list-group-item" ondblclick="showStandardEdit('initial_means_li_item',<c:out value="${referral.id}"/>,'initial_contact_id');">
					                     	<b>Initial Means of Contact</b>
					                     	<a class="pull-right">
					                     		<sql:query dataSource="${snapshot}" var="initial_means_defs">
													SELECT list_entry FROM initial_means_defs WHERE id = ?;
													<sql:param value="${referral.initial_contact_id}" />
												</sql:query>
												<c:forEach var="initial_means_def" items="${initial_means_defs.rows}">
													<c:out value="${initial_means_def.list_entry}" />
												</c:forEach>
					                     	</a>
					                    </li>
				                 	</ul>
								</div>
							</div>
						</div>
						<div class="col-lg-9">
							<div class="row">
								<div class="col-lg-8">
									<div class="box box-primary">
										<div class="box-header">
											<h3 class="box-title"></h3><br>
										</div>
										<div class="box-body">
											<div class="row">
												<div class="col-md-6">
													<table class="table table-bordered table-hover">
														<tr id="current_loc_li_item" ondblclick="showStandardEdit('current_loc_li_item',<c:out value="${referral.id}"/>,'current_loc');">
															<th width="50%">Current Location</th>
															<td><a class="pull-right"><c:out value="${referral.current_loc}" /></a></td>
														</tr>
														<tr id="current_sitation_li_item" ondblclick="showStandardEdit('current_sitation_li_item',<c:out value="${referral.id}"/>,'current_situation_id');">
															<th>Current Situation</th>
															<td>
																<sql:query dataSource="${snapshot}" var="current_situation_defs">
																SELECT list_entry FROM current_situation_defs WHERE id = ?;
																<sql:param value="${referral.current_situation_id}" />
																</sql:query>
																<c:forEach var="current_situation_def" items="${current_situation_defs.rows}">
																	<a class="pull-right"><c:out value="${current_situation_def.list_entry}" /></a>
																</c:forEach>
															</td>
														</tr>
														<tr id="location_prefs_li_item" ondblclick="showStandardEdit('location_prefs_li_item',<c:out value="${referral.id}"/>,'location_prefs');">
															<th>Location Preferences</th>
															<td>
																<sql:query dataSource="${snapshot}" var="location_preferences">
							                     				SELECT location_prefs.location_id, locations.location FROM location_prefs INNER JOIN locations ON location_prefs.location_id = locations.id WHERE location_prefs.referral_id = ?; 
							                     				<sql:param value="${referral.id}" />
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
														</tr>
														<tr id="location_avoids_li_item" ondblclick="showStandardEdit('location_avoids_li_item',<c:out value="${referral.id}"/>,'locations_avoid');">
															<th>Locations To Avoid</th>
															<td>
																<sql:query dataSource="${snapshot}" var="locations_avoid">
							                     				SELECT locations_avoid.location_id, locations.location FROM locations_avoid INNER JOIN locations ON locations_avoid.location_id = locations.id WHERE locations_avoid.referral_id = ?; 
							                     				<sql:param value="${referral.id}" />
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
														</tr>
														<tr id="locations_suggested_li_item" ondblclick="showStandardEdit('locations_suggested_li_item',<c:out value="${referral.id}"/>,'locations_suggested');">
															<th>Locations Suggested</th>
															<td>
																<sql:query dataSource="${snapshot}" var="locations_suggested">
							                     				SELECT locations_suggested.location_id, welmede_locations.location FROM locations_suggested INNER JOIN welmede_locations ON locations_suggested.location_id = welmede_locations.id WHERE locations_suggested.referral_id = ?; 
							                     				<sql:param value="${referral.id}" />
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
														</tr>
														<tr id="essential_requirements_li_item" ondblclick="showStandardEdit('essential_requirements_li_item',<c:out value="${referral.id}"/>,'essential_requirements');">
															<th>Essential Property Requirements</th>
															<td>
																<sql:query dataSource="${snapshot}" var="essential_requirments">
							                     				SELECT essential_requirements.property_req_id, property_requirements.list_entry FROM essential_requirements INNER JOIN property_requirements ON essential_requirements.property_req_id = property_requirements.id WHERE essential_requirements.referral_id = ?; 
							                     				<sql:param value="${referral.id}" />
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
														</tr>
														<tr id="young_transition_li_item" ondblclick="showStandardEdit('young_transition_li_item',<c:out value="${referral.id}"/>,'young_transition');">
															<th>Young Transition</th>
															<td>
																<a class="pull-right">
																	<c:choose>
																		<c:when test="${referral.young_transition == false }">No</c:when>
																		<c:when test="${referral.young_transition == true }">Yes</c:when>
																		<c:otherwise>Not Specified</c:otherwise>
																	</c:choose>
																</a>
															</td>
														</tr>
													</table>
												</div>
												<div class="col-md-6">
													<table class="table table-bordered table-hover">
														<tr id="level_of_support_li_item" ondblclick="showStandardEdit('level_of_support_li_item',<c:out value="${referral.id}"/>,'support_level_id');">
															<th width="50%">Level of Support</th>
															<td>
																<a class="pull-right">
																	<sql:query dataSource="${snapshot}" var="support_levels">
																		SELECT list_entry FROM support_level_defs WHERE id = ?;
																		<sql:param value="${referral.support_level_id}" />
																	</sql:query>
																	<c:forEach var="support_level" items="${support_levels.rows}">
																		<c:out value="${support_level.list_entry}" />
																	</c:forEach>
																</a>
															</td>
														</tr>
														<tr id="services_required_li_item" ondblclick="showStandardEdit('services_required_li_item',<c:out value="${referral.id}"/>,'service_types_required');">
															<th>Services Required</th>
															<td>
																<sql:query dataSource="${snapshot}" var="service_types_required">
							                     				SELECT service_types_required.service_type_id, service_types.list_entry FROM service_types_required INNER JOIN service_types ON service_types_required.service_type_id = service_types.id WHERE service_types_required.referral_id = ?; 
							                     				<sql:param value="${referral.id}" />
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
														</tr>
														<tr id="waking_nights_li_item" ondblclick="showStandardEdit('waking_nights_li_item',<c:out value="${referral.id}"/>,'waking_nights');">
															<th width="50%">Waking Nights</th>
															<td><a class="pull-right"><c:out value="${referral.waking_nights}" /></a></td>
														</tr>
														<tr id="specific_needs_li_item" ondblclick="showStandardEdit('specific_needs_li_item',<c:out value="${referral.id}"/>,'specific_needs_behaviours');">
															<th>Specific Needs</th>
															<td>
																<sql:query dataSource="${snapshot}" var="specific_needs">
							                     				SELECT specific_needs_behaviours.specific_need_id, specific_need_defs.list_entry FROM specific_needs_behaviours INNER JOIN specific_need_defs ON specific_needs_behaviours.specific_need_id = specific_need_defs.id WHERE specific_needs_behaviours.referral_id = ?; 
							                     				<sql:param value="${referral.id}" />
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
														</tr>
														<tr id="specific_health_needs_li_item" ondblclick="showStandardEdit('specific_health_needs_li_item',<c:out value="${referral.id}"/>,'health_medical_needs');">
															<th>Specific Health Needs</th>
															<td>
																<sql:query dataSource="${snapshot}" var="specific_health_needs">
							                     				SELECT health_medical_needs.health_need_id, health_need_defs.list_entry FROM health_medical_needs INNER JOIN health_need_defs ON health_medical_needs.health_need_id = health_need_defs.id WHERE health_medical_needs.referral_id = ?; 
							                     				<sql:param value="${referral.id}" />
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
														</tr>
													</table>
												</div>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-4">
									<div class="box box-primary">
										<div class="box-header">
											<h3 class="box-title">Status</h3><br>
										</div>
										<div class="box-body box-profile">
											<ul class="list-group list-group-unbordered">
												<li id="status_li_item" class="list-group-item" ondblclick="showStandardEdit('status_li_item',<c:out value="${referral.id}"/>,'status_id');">
							                     	<b>Current Status</b>
							                     	<a class="pull-right">
							                     		<sql:query dataSource="${snapshot}" var="statuses">
															SELECT list_entry FROM referral_status_defs WHERE id = ?;
															<sql:param value="${referral.status_id}" />
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
																<sql:param value="${referral.decling_auth}" />
															</sql:query>
															<c:forEach var="user" items="${users.rows}">
																<c:out value="${user.dname}" />
															</c:forEach>
								                     	</a>
							                    	</li>
							                    	<li class="list-group-item">
							                    		<b>Notes</b>
							                    		<a class="pull-right">
							                    			<c:out value="${referral.declined_notes}" />
							                    		</a>
							                    	</li>
							                    </c:if>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="box box-warning">
								<div class="box-header with-border">
									<h3 class="box-title">Audit</h3>
									<div class="box-tools pull-right">
										<button class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
									</div><!-- /.box-tools -->
								</div><!-- /.box-header -->
								<div class="box-body" style="display: block;">
									<sql:query dataSource="${snapshot}" var="audit_entries">
										SELECT audit_log.event, audit_log.datetime, audit_log.details, users.dname FROM audit_log INNER JOIN users ON audit_log.user = users.id WHERE referral_id = ? ORDER BY audit_log.datetime DESC;
										<sql:param value="${referral_id}" />
									</sql:query>
									<div id="audit_table">
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
									</div>
								</div><!-- /.box-body -->
							</div>
						</div>
					</div>
				</c:forEach>
			</c:when>
			<c:when test="${param.newReferral == 1}" >
				<div class="row">
            		<div class="col-md-9">
            			<div class="box box-success">
            				<form action="../CreateReferral" role="form" name="newReferralForm" method="post" >
	            				<div class="box-body">
			            			<div class="nav-tabs-custom">
				            			<ul class="nav nav-tabs pull-right">
				            				<li><a href="#tab_3-2" data-toggle="tab">Health and Behavioral Needs</a></li>
											<li><a href="#tab_2-2" data-toggle="tab">Situation and Location Requirements</a></li>
											<li class="active"><a href="#tab_1-1" data-toggle="tab">General Details</a></li>
											<li class="pull-left header"><i class="fa fa-th"></i> New Referral</li>
						                </ul>
						                <div class="tab-content">
											<div class="tab-pane active" id="tab_1-1">
												<div class="row">
				           							<div class="col-md-4">
				           								<div class="form-group">
				            								<label for="nr_dateFirstContact">Date of First Contact</label>
				            								<input type="date" class="form-control" id="nr_dateFirstContact" name="nr_dateFirstContact" REQUIRED>
				            							</div>
				            							<div class="form-group">
				            								<label for="nr_referralSource">Source of Referral</label>
				            								<sql:query dataSource="${snapshot}" var="source_defs">
																SELECT id, list_entry FROM source_defs;
															</sql:query>
				            								<select class="form-control" id="nr_referralSource" name="nr_referralSource">
				            									<c:forEach var="source_def" items="${source_defs.rows}">
				           											<option value="<c:out value='${source_def.id}' />" <c:if test="${source_def.list_entry == 'Not Specified'}">SELECTED</c:if>><c:out value='${source_def.list_entry}' /></option>
				           										</c:forEach>
				            								</select>
				            							</div>
				            							<div class="form-group">
				            								<label for="nr_howHeard">How did they hear about us?</label>
				            								<sql:query dataSource="${snapshot}" var="how_defs">
																SELECT id, list_entry FROM how_defs;
															</sql:query>
				            								<select class="form-control" id="nr_howHeard" name="nr_howHeard">
				            									<c:forEach var="how" items="${how_defs.rows}">
				           											<option value="<c:out value='${how.id}' />" <c:if test="${how.list_entry == 'Not Specified'}">SELECTED</c:if>><c:out value='${how.list_entry}' /></option>
				           										</c:forEach>
				            								</select>
				            							</div>
				            							<div class="form-group">
				            								<label for="nr_referringLocality">Referring Locality</label>
				            								<sql:query dataSource="${snapshot}" var="locality_defs">
																SELECT id, list_entry FROM locality_defs;
															</sql:query>
				            								<select class="form-control" id="nr_referringLocality" name="nr_referringLocality">
				            									<c:forEach var="locality" items="${locality_defs.rows}">
				           											<option value="<c:out value='${locality.id}' />" <c:if test="${locality.list_entry == 'Not Specified'}">SELECTED</c:if>><c:out value='${locality.list_entry}' /></option>
				           										</c:forEach>
				            								</select>
				            							</div>
				           							</div>
				           							<div class="col-md-4">
				           								<div class="form-group">
				            								<label for="nr_personBeingReferred">Person Being Referred</label>				            								
															<input type="text" class="form-control" name="nr_personBeingReferred" id="nr_personBeingReferred" />
				            							</div>
				           								<div class="form-group">
				            								<label for="nr_nameOfReferrer">Name of Referrer</label>
				            								<sql:query dataSource="${snapshot}" var="contacts">
																SELECT id, name FROM contacts;
															</sql:query>
															<select class="form-control" name="nr_nameOfReferrer" id="nr_nameOfReferrer" REQUIRED>
																<c:forEach var="contact" items="${contacts.rows}">
					           										<option value="<c:out value='${contact.id}' />"><c:out value='${contact.name}' /></option>
					           									</c:forEach>
				           									</select>
				            							</div>
				           								<div class="form-group">
				            								<label for="nr_meansContact">Initial Means of Contact</label>
				            								<sql:query dataSource="${snapshot}" var="initial_means_defs">
																SELECT id, list_entry FROM initial_means_defs;
															</sql:query>
				            								<select class="form-control" id="nr_meansContact" name="nr_meansContact">
				            									<c:forEach var="initial_means" items="${initial_means_defs.rows}">
				           											<option value="<c:out value='${initial_means.id}' />" <c:if test="${initial_means.list_entry == 'Not Specified'}">SELECTED</c:if>><c:out value='${initial_means.list_entry}' /></option>
				           										</c:forEach>
				            								</select>
				            							</div>
				            							<div class="form-group">
				            								<label for="nr_nameOfPractioner">Name of Practitioner</label>
				            								<sql:query dataSource="${snapshot}" var="contacts">
																SELECT id, name FROM contacts;
															</sql:query>
															<select class="form-control" name="nr_nameOfPractioner" id="nr_nameOfPractioner" REQUIRED>
																<c:forEach var="contact" items="${contacts.rows}">
					           										<option value="<c:out value='${contact.id}' />"><c:out value='${contact.name}' /></option>
					           									</c:forEach>
				           									</select>
				            							</div>
				           							</div>
				           							<div class="col-md-4">
				           								<div class="form-group">
				            								<label for="nr_responsiblePersonDummyEntry">Responsible Person</label>
				            								<sql:query dataSource="${snapshot}" var="responsiblePersons">
																SELECT dname FROM users WHERE id = ?;
																<sql:param value="${sessionScope.u_id}" />
															</sql:query>
															<c:forEach var="responsiblePerson" items="${responsiblePersons.rows}">
				           										<input type="text" class="form-control" id="nr_responsiblePersonDummyEntry" name="nr_responsiblePersonDummyEntry" value="<c:out value='${responsiblePerson.dname}' />" DISABLED>
				           									</c:forEach>
				            								<input type="hidden" class="form-control" id="nr_responsiblePerson" name="nr_responsiblePerson" value="<c:out value='${sessionScope.u_id}' />">
				            							</div>
				            							<div class="form-group">
				            								<label for="nr_whaRef">Our (WHA) Reference</label>
				            								<input type="text" class="form-control" id="nr_whaRef" name="nr_whaRef" DISABLED>
				            							</div>
				            							<div class="form-group">
				            								<label for="nr_SSID">SSID</label>
				            								<input type="text" class="form-control" id="nr_SSID" name="nr_SSID" >
				            							</div>
				           							</div>
				           						</div>
				                  			</div><!-- /.tab-pane -->
				                  			<div class="tab-pane" id="tab_2-2">
				                  				<div class="row">
			            							<div class="col-md-4">
			            								<div class="form-group">
				            								<label for="nr_dateOfBirth">Date of Birth</label>
				            								<input type="date" class="form-control" id="nr_dateOfBirth" name="nr_dateOfBirth">
				            							</div>
				            							<div class="form-group">
				            								<label for="nr_ageAtStart">Age at Start</label>
				            								<input type="text" class="form-control" id="nr_ageAtStart" name="nr_ageAtStart">
				            							</div>
				            							<div class="form-group">
					            							<label for="nr_gender">Gender</label>
				            								<select class="form-control" id="nr_gender" name="nr_gender">
				           										<option value="Not Known" selected>Not Known</option>
				           										<option value="Male">Male</option>
				           										<option value="Female">Female</option>
				            								</select>
				            							</div>
				            							<div class="form-group">
				            								<label for="nr_currentLocation">Current Location</label>
				            								<input type="text" class="form-control" id="nr_currentLocation" name="nr_currentLocation" >
				            							</div>
			            							</div>
			            							<div class="col-md-4">
			            								<div class="form-group">
				            								<label for="nr_currentSituation">Current Situation</label>
				            								<sql:query dataSource="${snapshot}" var="current_situation_defs">
																SELECT id, list_entry FROM current_situation_defs;
															</sql:query>
				            								<select class="form-control" id="nr_currentSituation" name="nr_currentSituation">
				            									<c:forEach var="current_situation" items="${current_situation_defs.rows}">
			            											<option value="<c:out value='${current_situation.id}' />" <c:if test="${current_situation.list_entry == 'Not Specified'}">SELECTED</c:if>><c:out value='${current_situation.list_entry}' /></option>
			            										</c:forEach>
				            								</select>
				            							</div>
				            							<div class="form-group">
					            							<sql:query dataSource="${snapshot}" var="locations">
																SELECT id, location FROM locations;
															</sql:query>
															<label for="nr_locationPreferences">Location Preferences</label>
						           							<select class="form-control" id="nr_locationPreferences" name="nr_locationPreferences" multiple="multiple">
					            								<c:forEach var="location" items="${locations.rows}">
					            									<option value="<c:out value='${location.id}' />"><c:out value='${location.location}' /></option>
					            								</c:forEach>
					            							</select>
						           						</div>
						           						<div class="form-group">
					            							<sql:query dataSource="${snapshot}" var="locations">
																SELECT id, location FROM locations;
															</sql:query>
															<label for="nr_locationsToAvoid">Locations To Avoid</label>
						           							<select class="form-control" id="nr_locationsToAvoid" name="nr_locationsToAvoid" multiple="multiple">
					            								<c:forEach var="location" items="${locations.rows}">
					            									<option value="<c:out value='${location.id}' />"><c:out value='${location.location}' /></option>
					            								</c:forEach>
					            							</select>
						           						</div>
			            							</div>
			            							<div class="col-md-4">
			            								<div class="form-group">
					            							<sql:query dataSource="${snapshot}" var="locations">
																SELECT id, location FROM welmede_locations;
															</sql:query>
															<label for="nr_locationsSuggested">Locations Suggested</label>
						           							<select class="form-control" id="nr_locationsSuggested" name="nr_locationsSuggested" multiple="multiple">
					            								<c:forEach var="location" items="${locations.rows}">
					            									<option value="<c:out value='${location.id}' />"><c:out value='${location.location}' /></option>
					            								</c:forEach>
					            							</select>
						           						</div>
			            								<div class="form-group">
					            							<sql:query dataSource="${snapshot}" var="property_requirements">
																SELECT id, list_entry FROM property_requirements;
															</sql:query>
															<label for="nr_PropertyRequirements">Essential Requirements for Property</label>
						           							<select class="form-control" id="nr_PropertyRequirements" name="nr_PropertyRequirements" multiple="multiple">
					            								<c:forEach var="property_requirement" items="${property_requirements.rows}">
					            									<option value="<c:out value='${property_requirement.id}' />"><c:out value='${property_requirement.list_entry}' /></option>
					            								</c:forEach>
					            							</select>
						           						</div>
						           						<div class="form-group">
															<label for="nr_YoungTransition">Young Transition?</label>
						           							<select class="form-control" id="nr_YoungTransition" name="nr_YoungTransition">
					            								<option value="False" selected>No</option>
					            								<option value="True">Yes</option>
					            							</select>
						           						</div>
			            							</div>
			            						</div>
				                 			</div><!-- /.tab-pane -->
				                  			<div class="tab-pane" id="tab_3-2">
				                  				<div class="row">
				            						<div class="col-md-4">
				            							<div class="form-group">
					            							<sql:query dataSource="${snapshot}" var="support_levels">
																SELECT id, list_entry FROM support_level_defs;
															</sql:query>
															<label for="nr_SupportLevels">Level of Support</label>
						           							<select class="form-control" id="nr_SupportLevels" name="nr_SupportLevels">
					            								<c:forEach var="support_level" items="${support_levels.rows}">
					            									<option value="<c:out value='${support_level.id}' />"><c:out value='${support_level.list_entry}' /></option>
					            								</c:forEach>
					            							</select>
						           						</div>
						           						<div class="form-group">
					            							<sql:query dataSource="${snapshot}" var="service_types">
																SELECT id, list_entry FROM service_types;
															</sql:query>
															<label for="nr_ServiceTypesRequired">Service Types Required</label>
						           							<select class="form-control" id="nr_ServiceTypesRequired" name="nr_ServiceTypesRequired" multiple="multiple">
					            								<c:forEach var="service_type" items="${service_types.rows}">
					            									<option value="<c:out value='${service_type.id}' />"><c:out value='${service_type.list_entry}' /></option>
					            								</c:forEach>
					            							</select>
							           					</div>
							           					<div class="form-group">
															<label for="nr_WakingNights">Waking Nights / Sleep-In</label>
						           							<select class="form-control" id="nr_WakingNights" name="nr_WakingNights">
					            								<option value="WAKING">Waking Nights</option>
					            								<option value="SLEEP-IN">Sleep In</option>
					            								<option value="NA" selected>Not Applicable</option>
					            							</select>
							           					</div>
				            						</div>
				            						<div class="col-md-4">
				            							<div class="form-group">
					            							<sql:query dataSource="${snapshot}" var="specific_needs">
																SELECT id, list_entry FROM specific_need_defs;
															</sql:query>
															<label for="nr_SpecificNeeds">Specific Needs / Behaviors</label>
						           							<select class="form-control" id="nr_SpecificNeeds" name="nr_SpecificNeeds" multiple="multiple">
					            								<c:forEach var="specific_need" items="${specific_needs.rows}">
					            									<option value="<c:out value='${specific_need.id}' />"><c:out value='${specific_need.list_entry}' /></option>
					            								</c:forEach>
					            							</select>
						           						</div>
						           						<div class="form-group">
					            							<sql:query dataSource="${snapshot}" var="health_needs">
																SELECT id, list_entry FROM health_need_defs;
															</sql:query>
															<label for="nr_HealthNeeds">Specific Health Needs</label>
						           							<select class="form-control" id="nr_HealthNeeds" name="nr_HealthNeeds" multiple="multiple">
					            								<c:forEach var="health_need" items="${health_needs.rows}">
					            									<option value="<c:out value='${health_need.id}' />"><c:out value='${health_need.list_entry}' /></option>
					            								</c:forEach>
					            							</select>
							           					</div>
				            						</div>
				            					</div>
				                  			</div><!-- /.tab-pane -->
				                		</div>
	                				</div>
	                			</div>
	                			<div class="box-footer">
	                				<sql:query dataSource="${snapshot}" var="newStatusDefs">
										SELECT id FROM referral_status_defs WHERE upper(list_entry) = upper('new');
									</sql:query>
									<c:forEach var="newStatusDef" items="${newStatusDefs.rows}">
            							<input type="hidden" class="form-control" id="nr_newStatusID" name="nr_newStatusID" value="<c:out value='${newStatusDef.id}' />">
            						</c:forEach>
	                				<button type="submit" class="btn btn-primary">Create New Referral</button>
	                			</div>
                			</form>
                		</div>
            		</div>
            		<div class="col-md-3">
            			<div class="callout callout-info">
                    		<h4>Supporting Notes</h4>
                    		<dl class="dl-horizontal">
                    			<dt>Label</dt>
			                    <dd>Term</dd>
							</dl>
                 		</div>
            		</div>
          		</div><!-- /.row -->
			</c:when>
		</c:choose>
          

          
        </section><!-- /.content -->
      </div><!-- /.content-wrapper -->
      


      
	<%@ include file="../inc/footer.jsp"%>
	<%@ include file="../inc/control-panel.jsp"%>

    </div><!-- ./wrapper -->

    <!-- jQuery 2.1.4 -->
    <script src="../plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- Bootstrap 3.3.5 -->
    <script src="../bootstrap/js/bootstrap.min.js"></script>
    <script src="../plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="../plugins/datatables/dataTables.bootstrap.min.js"></script>
    <!-- FastClick -->
    <script src="../plugins/fastclick/fastclick.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/app.min.js"></script>
    <!-- Sparkline -->
    <script src="../plugins/sparkline/jquery.sparkline.min.js"></script>
    <!-- jvectormap -->
    <script src="../plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
    <script src="../plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- SlimScroll 1.3.0 -->
    <script src="../plugins/slimScroll/jquery.slimscroll.min.js"></script>
    <!-- ChartJS 1.0.1 -->
    <script src="../plugins/chartjs/Chart.min.js"></script>
    <!-- AdminLTE dashboard demo (This is only for demo purposes) -->
    <script src="../dist/js/pages/dashboard2.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="../dist/js/demo.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.2-rc.1/js/select2.min.js"></script>
    <script type="text/javascript">
    	$("#nr_nameOfReferrer").select2({tags: true});
    	$("#nr_nameOfPractioner").select2({tags: true});
    	$("#nr_locationPreferences").select2({tags: true});
		$("#nr_locationsToAvoid").select2({tags: true});
		$("#nr_locationsSuggested").select2();
		$("#nr_PropertyRequirements").select2();
		$("#nr_ServiceTypesRequired").select2();
		$("#nr_SpecificNeeds").select2();
		$("#nr_HealthNeeds").select2();
		
		
		$(".select2-container").attr("style","width:100%;");
	</script>
    
    
    <script>
    
    //$('#active_contacts').DataTable();
        
    function showStandardEdit(elem_id, referral_id, field_name, display){
		$.ajax({
			type: 'POST',
			url: '../ajax/showStandardEdit.jsp',
			data: '&referral_id='+referral_id+'&field_name='+field_name+'&elem_id='+elem_id+'&page_display='+display,
			success: function(data) {
				$('#'+elem_id).html(data);
			}
		});
	}
    
      function newContactForm(){
			
		$.ajax({
			type: 'POST',
			url: '../ajax/newContactForm.jsp',
			//data: ,
			success: function(data) {
				$('#menuTarget1').html(data);
			}
		});
		
		}
      
      function newUserForm(){
			
  		$.ajax({
  			type: 'POST',
  			url: '../ajax/newUserForm.jsp',
  			//data: ,
  			success: function(data) {
  				$('#menuTarget1').html(data);
  			}
  		});
  		
  		}
      
      function runGlobalSearch(){
			
  		$.ajax({
  			type: 'POST',
  			url: '../ajax/globalSearch.jsp',
  			data: "q="+$('#q').val(),
  			success: function(data) {
  				$('#menuTarget1').html(data);
  				$('#breadcrumbTarget').html('<li><a href="dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li><li class="active"><a href="#"><i class="fa fa-search"></i> Search</a></li>');
  			}
  		});
  		
  		
  		
  		}
      
      function updateDebugInfo() {
    	  $.ajax({
    			type: 'POST',
    			url: '../ajax/getDebugInfo.jsp',
    			success: function(data) {
    				$('#debugModalBody').html(data);
    			}
    		});
      }
    
      function timeStamp() {
    	// Create a date object with the current time
    	  var now = new Date();

    	// Create an array with the current month, day and time
    	  var date = [ now.getMonth() + 1, now.getDate(), now.getFullYear() ];

    	// Create an array with the current hour, minute and second
    	  var time = [ now.getHours(), now.getMinutes(), now.getSeconds() ];

    	// Determine AM or PM suffix based on the hour
    	  var suffix = ( time[0] < 12 ) ? "AM" : "PM";

    	// Convert hour from military time
    	  time[0] = ( time[0] < 12 ) ? time[0] : time[0] - 12;

    	// If hour is 0, set it to 12
    	  time[0] = time[0] || 12;

    	// If seconds and minutes are less than 10, add a zero
    	  for ( var i = 1; i < 3; i++ ) {
    	    if ( time[i] < 10 ) {
    	      time[i] = "0" + time[i];
    	    }
    	  }

    	// Return the formatted string
    	  return date.join("/") + " " + time.join(":") + " " + suffix;
    	}

    </script>
    
  </body>
</html>
