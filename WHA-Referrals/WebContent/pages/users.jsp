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
	    <title>WHA-Referrals | Users</title>
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
 					<h1>Users
            			<small>Version 1.0 Beta</small>
          			</h1>
					<ol id="breadcrumbTarget" class="breadcrumb">
		            	<li><a href="dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
		            	<li class="active"><a href="#"><i class="fa fa-group"></i> Users</a></li>
					</ol>
        		</section>
				
				<c:set var="user_last_action" value="VIEW_SYSTEM_USERS" scope="session" />
				
				<%@ include file="../inc/debug.jsp"%>

				<!-- Default entry point -->
				<!-- Main content -->
				<section class="content">
					<div class="row">
						<div class="col-md-8">
							<div class="box box-primary">
								<div class="box-header">
									<h3 class="box-title">Users</h3>
								</div>
								<div class="box-body table-responsive">
									<table id="roleDataTable" class="table table-bordered table-hover">
               							<thead>
               								<tr>
							                 	<th>Id</th>
							                  	<th>User Name</th>
							                  	<th>Display Name</th>
							                  	<th>Email</th>
							                  	<th>Role</th>
							                  	<th>Active</th>
							                  	<th>Actions</th>
               								</tr>
               							</thead>
               							<tbody>
               								<sql:query dataSource="${snapshot}" var="users">
											SELECT id, uname, dname, email, level, active FROM users;
											</sql:query>
											
											<c:forEach var="user" items="${users.rows}">
												<tr id="user_row_<c:out value="${user.id}" />">
								                  	<td><c:out value="${user.id}" /></td>
									                <td><c:out value="${user.uname}" /></td>
									                <td><c:out value="${user.dname}" /></td>
									                <td><c:out value="${user.email}" /></td>
									                <td>
									                	<c:choose>
									                		<c:when test="${user.level == 0 }" >
									                			Administrator
									                		</c:when>
									                		<c:otherwise>
									                			User
									                		</c:otherwise>
									                	</c:choose>
									                </td>
									                <td>
									                	<c:choose>
									                		<c:when test="${user.active == true }" >
									                			ACTIVE
									                		</c:when>
									                		<c:otherwise>
									                			INACTIVE
									                		</c:otherwise>
									                	</c:choose>
									                </td>
									                <td>
									                	<button class="btn btn-sm btn-primary" data-toggle="tooltip" title="Edit User" onclick="getUserEditInlineForm(<c:out value="${user.id}" />);">
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
						<div class="col-md-4">
							<div class="box box-solid">
								
									<div class="callout callout-info">
										<h4>System Users</h4>
										<p>Edit and amend system users</p>
										<p>Could place chart widget with most frequently logged in users</p>
									</div>
								
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="box box-primary">
								<div class="box-header">
									<h3 class="box-title">Add New User</h3>
								</div>
								<div class="box-body">
									<form action="../CreateUser" role="form" name="newUserForm" method="post" enctype="multipart/form-data">
										<div class="row">
											<div class="col-md-3">
           										<div class="box-body">
	            									<div class="form-group">
	            										<label for="user_name">User Name</label>
	            										<input type="text" class="form-control" id="user_name" name="user_name" placeholder="User Email Address Form">
	            									</div>
	            									<div class="form-group">
	            										<label for="user_dname">Display Name</label>
	            										<input type="text" class="form-control" id="user_dname" name="user_dname" placeholder="Provide a display name">
	            									</div>
	            								</div>
           									</div>
           									<div class="col-md-3">
           										<div class="box-body">
	            									<div class="form-group">
	            										<label for="user_email">Email</label>
	            										<input type="text" class="form-control" id="user_email" name="user_email" placeholder="Enter Email Address">
	            									</div>
	            									<div class="form-group">
	            										<label for="user_role">Role</label>
	            										<select class="form-control" id="user_region" name="user_role">
	            											<option value="0">Administrator</option>
	            											<option value="1">User</option>
	            										</select>
	            									</div>
	            								</div>
           									</div>
           									<div class="col-md-3">
           										<div class="box-body">
	            									<div class="form-group">
	            										<label for="user_active">Active</label>
	            										<select class="form-control" id="user_region" name="user_active">
	            											<option value="true">Active</option>
	            											<option value="false">Inactive</option>
	            										</select>
	            									</div>
	            									<div class="form-group">
							                    		<label for="exampleInputFile">User Image</label>
							                    		<input type="file" class="form-control" id="org_picture" name="user_image" accept=".png">
							                    		<p class="help-block">Upload User Photo (PNG format only)</p>
						                    		</div>
	            								</div>
           									</div>
           									<div class="col-md-3">
           										<div class="box-body">
	            									<div class="form-group">
	            										<label for="user_pword">Password</label>
	            										<input type="password" class="form-control" id="user_pword" name="user_pword" placeholder="Please enter a password">
	            									</div>
	            									<div class="form-group">
	            										<label for="c_user_pword">Confirm Password</label>
	            										<input type="password" class="form-control" id="c_user_pword" name="c_user_pword" placeholder="Please re-enter the password" onkeyup="checkPass(); return false;">
	            									</div>
	            								</div>
           									</div>
										</div>
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


function getUserEditInlineForm(u_id) {
	$.ajax({
		type: 'POST',
		url: '../ajax/getUserInlineEditForm.jsp',
		data: "u_id="+u_id,
		success: function(data) {
			$('#user_row_'+u_id).html(data);
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
