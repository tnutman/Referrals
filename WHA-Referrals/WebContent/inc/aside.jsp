<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Left side column. contains the logo and sidebar -->
      <aside class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">
          <!-- search form -->
          <form id="globalSearch" action="../ajax/globalSearch.jsp" method="post" class="sidebar-form">
            <div class="input-group">
              <input type="text" name="q" id="q" class="form-control" placeholder="Search..." onchange="runGlobalSearch();">
              <span class="input-group-btn">
                <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i></button>
              </span>
            </div>
          </form>
          <!-- /.search form -->
          <!-- sidebar menu: : style can be found in sidebar.less -->
          <ul class="sidebar-menu">
          
          	<c:if test="${sessionScope.level <= 1}" >
          	<li class="treeview">
          		<a href="#">
	                <i class="fa fa-gears"></i>
	                <span>Admin</span>
	                <i class="fa fa-angle-left pull-right"></i>
            	</a>
                <ul class="treeview-menu">
                	<li><a href="users"><i class="fa fa-user"></i>Users</a></li>
                </ul>
          	</li>
          	<li class="treeview">
          		<a href="#">
	                <i class="fa fa-list-ul"></i>
	                <span>List Definitions</span>
	                <i class="fa fa-angle-left pull-right"></i>
            	</a>
                <ul class="treeview-menu">
                	<li><a href="manage_list?list=source_defs"><i class="fa fa-list-ul"></i>Source of Referrals</a></li>
                	<li><a href="manage_list?list=how_defs"><i class="fa fa-list-ul"></i>How did you hear of us</a></li>
                	<li><a href="manage_list?list=locality_defs"><i class="fa fa-list-ul"></i>Referring Locality</a></li>
                	<li><a href="manage_list?list=initial_means_defs"><i class="fa fa-list-ul"></i>Initial Means of Contact</a></li>
                	<li><a href="manage_list?list=current_situation_defs"><i class="fa fa-list-ul"></i>Current Situation</a></li>
                	<li><a href="manage_list?list=property_requirements"><i class="fa fa-list-ul"></i>Property Requirements</a></li>
                	<li><a href="manage_list?list=support_level_defs"><i class="fa fa-list-ul"></i>Support Levels</a></li>
                	<li><a href="manage_list?list=service_types"><i class="fa fa-list-ul"></i>Service Types</a></li>
                	<li><a href="manage_list?list=specific_need_defs"><i class="fa fa-list-ul"></i>Specific Needs</a></li>
                	<li><a href="manage_list?list=health_need_defs"><i class="fa fa-list-ul"></i>Health/Medical Needs</a></li>
                	<li><a href="manage_list?list=referral_status_defs"><i class="fa fa-list-ul"></i>Referral Status</a></li>
              	</ul>
          	</li>
          	<li class="treeview">
             	<a href="#">
	                <i class="fa fa-map-marker"></i>
	                <span>Manage Locations</span>
	                <i class="fa fa-angle-left pull-right"></i>
            	</a>
            	<ul class="treeview-menu">
                	<li><a href="manage_locations?list=welmede_locations"><i class="fa fa-map-marker"></i>Welmede Properties</a></li>
                	<li><a href="manage_locations?list=locations"><i class="fa fa-map-marker"></i>General Locations</a></li>
              	</ul>
            </li>
          	</c:if>
          	<li class="treeview">
          		<a href="#">
	                <i class="fa fa-list-ul"></i>
	                <span>Referrals</span>
	                <i class="fa fa-angle-left pull-right"></i>
            	</a>
            	<ul class="treeview-menu">
            		<li><a href="referrals?newReferral=1"><i class="fa fa-list-ul"></i>Create New Referral</a></li>
            	</ul>
            </li>
          </ul>
        </section>
        <!-- /.sidebar -->
      </aside>