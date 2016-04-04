<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.util.Date,java.text.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../inc/sql.jsp"%>

<c:if test="${empty sessionScope.u_id}">
    <!-- There is not a user **attribute** in the session -->
    <c:set var="system_msg" value="Your session has expired" scope="session" />
	<c:redirect url="login"/>
</c:if>

<c:if test="${sessionScope.level > 0}">
    <!-- There is not a user **attribute** in the session -->
    <c:set var="system_msg" value="You need to be an Administrator to access this" scope="session" />
	<c:redirect url="login"/>
</c:if>  	
<c:set var="now" value="<%=new java.util.Date()%>" />

<!DOCTYPE html>
<html>
	<head>
	    <meta charset="utf-8">
	    <meta http-equiv="X-UA-Compatible" content="IE=edge">
	    <title>WHA-Referrals | List Management</title>
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
	    <link rel="stylesheet" href="../plugins/datatables/dataTables.bootstrap.css">
	    <!-- Theme style -->
	    <link rel="stylesheet" href="../dist/css/AdminLTE.min.css">
	    <!-- AdminLTE Skins. Choose a skin from the css/skins
	         folder instead of downloading all of them to reduce the load. -->
	    <link rel="stylesheet" href="../dist/css/skins/_all-skins.min.css">


	    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
	    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	    <!--[if lt IE 9]>
	        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
	        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	    <![endif]-->
	</head>
	
	<body class="hold-transition skin-blue sidebar-mini sidebar-collapse">
    
    	<div class="wrapper">
    
			<%@ include file="../inc/header.jsp"%>
			<%@ include file="../inc/aside.jsp"%>
      
			<!-- Content Wrapper. Contains page content -->
			<div class="content-wrapper">
				<!-- Content Header (Page header) -->
				<section class="content-header">
 					<h1>List Management
            			<small>Version 1.0 Beta</small>
          			</h1>
					<ol id="breadcrumbTarget" class="breadcrumb">
		            	<li><a href="dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
		            	<li class="active"><a href="#"><i class="fa fa-group"></i> List Management</a></li>
					</ol>
        		</section>
				
				<c:set var="user_last_action" value="LIST_MANAGEMENT" scope="session" />
				
				<c:set var="list" value="${param.list }" />
				<c:choose>
					<c:when test="${list == 'source_defs' }">
						<c:set var="list" value="source_defs" />
						<c:set var="dlist" value="Source of Referrals" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM source_defs;
						</sql:query>
					</c:when>
					<c:when test="${list == 'how_defs' }">
						<c:set var="list" value="how_defs" />
						<c:set var="dlist" value="How did you hear from us" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM how_defs;
						</sql:query>
					</c:when>
					<c:when test="${list == 'locality_defs' }">
						<c:set var="list" value="locality_defs" />
						<c:set var="dlist" value="Referring Locality" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM locality_defs;
						</sql:query>
					</c:when>
					<c:when test="${list == 'initial_means_defs' }">
						<c:set var="list" value="initial_means_defs" />
						<c:set var="dlist" value="Initial Means on Contact" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM initial_means_defs;
						</sql:query>
					</c:when>
					<c:when test="${list == 'current_situation_defs' }">
						<c:set var="list" value="current_situation_defs" />
						<c:set var="dlist" value="Current Situation" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM current_situation_defs;
						</sql:query>
					</c:when>
					<c:when test="${list == 'property_requirements' }">
						<c:set var="list" value="property_requirements" />
						<c:set var="dlist" value="Property Requirements" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM property_requirements;
						</sql:query>
					</c:when>
					<c:when test="${list == 'support_level_defs' }">
						<c:set var="list" value="support_level_defs" />
						<c:set var="dlist" value="Support Levels" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM support_level_defs;
						</sql:query>
					</c:when>
					<c:when test="${list == 'service_types' }">
						<c:set var="list" value="service_types" />
						<c:set var="dlist" value="Service Types" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM service_types;
						</sql:query>
					</c:when>
					<c:when test="${list == 'specific_need_defs' }">
						<c:set var="list" value="specific_need_defs" />
						<c:set var="dlist" value="Specific Needs/Behaviours" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM specific_need_defs;
						</sql:query>
					</c:when>
					<c:when test="${list == 'health_need_defs' }">
						<c:set var="list" value="health_need_defs" />
						<c:set var="dlist" value="Health/Medical Needs" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM health_need_defs;
						</sql:query>
					</c:when>
					<c:when test="${list == 'referral_status_defs' }">
						<c:set var="list" value="referral_status_defs" />
						<c:set var="dlist" value="Referral Status" />
						<sql:query dataSource="${snapshot}" var="list_defs">
							SELECT id, list_entry FROM referral_status_defs;
						</sql:query>
					</c:when>
				</c:choose>
				
				
				
				<%@ include file="../inc/debug.jsp"%>

				<!-- Default entry point -->
				<!-- Main content -->
				<section class="content">
					<div class="row">
						<div class="col-md-6">
							<div class="box box-primary">
								<div class="box-header">
									<h3 class="box-title"><c:out value="${dlist}"/></h3>
								</div>
								<div class="box-body table-responsive">
									<table id="roleDataTable" class="table table-bordered table-hover">
               							<thead>
               								<tr>
							                 	<th>Id</th>
							                  	<th>List Entry</th>
							                  	<th>Used In</th>
							                  	<th>Actions</th>
               								</tr>
               							</thead>
               							<tbody>
											<c:forEach var="list_def" items="${list_defs.rows}">
												<tr id="list_entry_row_<c:out value="${list_def.id}" />">
								                  	<td><c:out value="${list_def.id}" /></td>
									                <td><c:out value="${list_def.list_entry}" /></td>
									                <td></td>
									                <td>
									                	<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="Edit Entry" onclick="getListItemEditInlineForm(<c:out value="${list_def.id}" />,'<c:out value="${list}" />');">
							                				<i class="fa fa-edit"></i>
							                			</button>
									                </td>
									            </tr>
											</c:forEach>
               							</tbody>
               						</table>
								</div>
							</div>
						</div>
						<div class="col-md-6">
							<div class="box box-primary">
								<div class="box-header">
									<h3 class="box-title">Add new entry to: <c:out value="${dlist}"/></h3>
								</div>
								<div class="box-body table-responsive">
									<form action="../AddListDef" method="post" role="form" name="newListEntryForm">
										<div class="form-group">
	            							<label for="new_entry">New Entry</label>
	            							<input type="text" class="form-control" id="new_entry" name="new_entry" placeholder="Enter New List Entry">
	            						</div>
										<input type="hidden" name="list" value="<c:out value="${list}" />">
										<div class="box-footer">
				                    		<button type="submit" class="btn btn-primary">Create</button>
			                    		</div>
									</form>
								</div>
							</div>
						</div>
					</div>
					
				</section>
				
          	</div><!-- /.content-wrapper -->
 
		<%@ include file="../inc/footer.jsp"%>
		<%@ include file="../inc/control-panel.jsp"%>
	
	</div><!-- ./wrapper -->

    <!-- jQuery 2.1.4 -->
    <script src="../plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- Bootstrap 3.3.5 -->
    <script src="../bootstrap/js/bootstrap.min.js"></script>
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
     <script src="../plugins/datatables/jquery.dataTables.min.js"></script>
     <script src="../plugins/datatables/dataTables.bootstrap.min.js"></script>

    
<script>


function getListItemEditInlineForm(list_item_id, list_name) {
	$.ajax({
		type: 'POST',
		url: '../ajax/getListItemEditInlineForm.jsp',
		data: "id="+list_item_id+"&list="+list_name,
		success: function(data) {
			$('#list_entry_row_'+list_item_id).html(data);
		}
	});	
}

function checkPass()
{
    //Store the password field objects into variables ...
    var pass1 = document.getElementById('user_pword');
    var pass2 = document.getElementById('c_user_pword');
    //Store the Confimation Message Object ...
    //var message = document.getElementById('confirmMessage');
    //Set the colors we will be using ...
    var goodColor = "#66cc66";
    var badColor = "#ff6666";
    //Compare the values in the password field 
    //and the confirmation field
    if(pass1.value == pass2.value){
        //The passwords match. 
        //Set the color to the good color and inform
        //the user that they have entered the correct password 
        pass2.style.backgroundColor = goodColor;
        //message.style.color = goodColor;
        //message.innerHTML = "Passwords Match!"
    }else{
        //The passwords do not match.
        //Set the color to the bad color and
        //notify the user.
        pass2.style.backgroundColor = badColor;
        //message.style.color = badColor;
        //message.innerHTML = "Passwords Do Not Match!"
    }
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
