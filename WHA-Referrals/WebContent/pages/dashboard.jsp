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
    <title>WHA-Referrals | Dashboard</title>
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
				<h1>
					Dashboard <small>Version 1.0 Beta</small>
				</h1>

				<ol id="breadcrumbTarget" class="breadcrumb">
					<li class="active"><a href="dashboard"><i
							class="fa fa-dashboard"></i> Dashboard</a></li>
				</ol>

			</section>


			<%@ include file="../inc/debug.jsp"%>

			<sql:query dataSource="${snapshot}" var="incompleteStatusDefs">
				SELECT id FROM referral_status_defs WHERE upper(list_entry) = upper('incomplete');
			</sql:query>
			<c:forEach var="incompleteStatusDef" items="${incompleteStatusDefs.rows}">
				<c:set var="incompleteStatusID" value="${incompleteStatusDef.id}" />
			</c:forEach>
			<!-- Main content -->
			<section class="content">


				<!-- Info boxes -->
				<div class="row">
					<div class="col-md-6">
						<div class="box">
							<div class="box-header">
								<h3 class="box-title">All Active Referrals (including Declined)</h3>
								<div class="box-tools pull-right">
									<button class="btn btn-box-tool" data-widget="collapse">
										<i class="fa fa-minus"></i>
									</button>
								</div>
							</div>
							<div class="box-body table-responsive">
								<table id="allActiveReferrals" class="table table-bordered">
									<tr>
										<th>Ref</th>
										<th>Responsible</th>
										<th>Created</th>
										<th>Updated</th>
										<th>Status</th>
										<th>Actions</th>
									</tr>
									<sql:query dataSource="${snapshot}" var="active_referrals">
										SELECT id, wha_ref, dname, responsible_id, int_dt_created, int_dt_updated, status_name, status_id, int_step FROM referral_details ORDER BY int_dt_created DESC;
									</sql:query>
									<c:forEach var="active_referral" items="${active_referrals.rows}">
										<tr>
											<td><c:out value="${active_referral.wha_ref}" /></td>
											<td><c:out value="${active_referral.dname}" /></td>
											<td><c:out value="${active_referral.int_dt_created}" /></td>
											<td><c:out value="${active_referral.int_dt_updated}" /></td>
											<td><c:out value="${active_referral.status_name}" /></td>
											<td>
												<form action="referrals" method="post">
													<input type="hidden" name="referral_id" value="${active_referral.id}">
													<button type="submit" class="btn-xs btn-primary" data-toggle="tooltip" data-original-title="Edit">
														<i class="fa fa-edit"></i>
													</button>
												</form>
											</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="box">
							<div class="box-header">
								<h3 class="box-title">All Incomplete Referrals (will be for System Admin / Devon)</h3>
								<div class="box-tools pull-right">
									<button class="btn btn-box-tool" data-widget="collapse">
										<i class="fa fa-minus"></i>
									</button>
								</div>
							</div>
							<div class="box-body table-responsive">
								<table id="allIncompleteReferrals" class="table table-bordered">
									<tr>
										<th>Ref</th>
										<th>Responsible</th>
										<th>Created</th>
										<th>Status</th>
										<th>Actions</th>
									</tr>
									<sql:query dataSource="${snapshot}" var="incomplete_referrals">
										SELECT id, wha_ref, dname, responsible_id, int_dt_created, status_name, status_id, int_step FROM referral_details WHERE status_id = ? ORDER BY int_dt_created DESC;
									<sql:param value="${incompleteStatusID}" />
									</sql:query>
									<c:forEach var="incomplete_referral" items="${incomplete_referrals.rows}">
										<tr>
											<td><c:out value="${incomplete_referral.wha_ref}" /></td>
											<td><c:out value="${incomplete_referral.dname}" /></td>
											<td><c:out value="${incomplete_referral.int_dt_created}" /></td>
											<td><c:out value="${incomplete_referral.status_name}" /></td>
											<td>
												<c:choose>
													<c:when test="${incomplete_referral.int_step == 1}">
														<form action="referrals?step=2" method="post">
															<input type="hidden" name="referral_id" value="${incomplete_referral.id}">
															<button type="submit" class="btn-xs btn-primary" data-toggle="tooltip" data-original-title="Edit">
																<i class="fa fa-edit"></i>
															</button>
														</form>
													</c:when>
													<c:when test="${incomplete_referral.int_step == 2}">
														<form action="referrals?step=3" method="post">
															<input type="hidden" name="referral_id" value="${incomplete_referral.id}">
															<button type="submit" class="btn-xs btn-primary" data-toggle="tooltip" data-original-title="Edit">
																<i class="fa fa-edit"></i>
															</button>
														</form>
													</c:when>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
								</table>
							</div>
						</div>
					</div>
				</div>
				<!-- /.row -->

			</section>
			<!-- /.content -->
		</div>
		<!-- /.content-wrapper -->




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
    
    <script>
    
    //$('#active_contacts').DataTable();
        
    
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
