package org.wha.referrals.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
//import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class CreateReferral extends HttpServlet {

	
	
	/**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        }
        catch (Exception ex) {
            Logger.getLogger(CreateReferral.class.getName()).log(Level.SEVERE, null, ex);
            int errorCode = 500;
            if (ex instanceof FileNotFoundException) {
                errorCode = 404;
            }
            response.sendError(errorCode, ex.getMessage());
        }
    }

	private void processRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Calendar cal = Calendar.getInstance();
        java.sql.Timestamp sqlDate = new java.sql.Timestamp(cal.getTimeInMillis());
		HttpSession httpSession = request.getSession();
		mySQLDBUtil dbUtil = new mySQLDBUtil();
		Integer location_id = 0;
		Integer requirement_id = 0;
		Integer referral_id = 0;
		Integer name_referrer_id = 0;
		Integer practitioner_id = 0;
		ResultSet resultset = null;

			// first step in the wizard process
			// create and prepare the SQL statement
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO referrals (date_of_first_contact, source_id, how_id, ref_locality_id, name_referrer, initial_contact_id, practitioner, responsible_id, wha_ref, ssid, status_id, int_dt_created, int_dt_updated, person_being_referred) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?);");
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	        Date parsed = format.parse(request.getParameter("nr_dateFirstContact"));
	        java.sql.Date nr_dateFirstContact = new java.sql.Date(parsed.getTime());
	        preparedStatement.setDate(1, nr_dateFirstContact);
	        preparedStatement.setInt(2, Integer.parseInt(request.getParameter("nr_referralSource")));
	        preparedStatement.setInt(3, Integer.parseInt(request.getParameter("nr_howHeard")));
	        preparedStatement.setInt(4, Integer.parseInt(request.getParameter("nr_referringLocality")));
	        
	        
	        try {
	        	name_referrer_id = Integer.parseInt(request.getParameter("nr_nameOfReferrer"));
			}
			catch (NumberFormatException n) {
				PreparedStatement contactStatement = dbUtil.getPreparedStatement("INSERT INTO contacts (name) VALUES (?);");
				contactStatement.setString(1,request.getParameter("nr_nameOfReferrer"));
				contactStatement.execute();
				resultset = contactStatement.getGeneratedKeys();
				if (resultset.next()) {
					name_referrer_id = resultset.getInt(1);
				}
				
			}
	        
	        preparedStatement.setInt(5, name_referrer_id);
	        preparedStatement.setInt(6, Integer.parseInt(request.getParameter("nr_meansContact")));
	        
	        try {
	        	practitioner_id = Integer.parseInt(request.getParameter("nr_nameOfPractioner"));
			}
			catch (NumberFormatException n) {
				PreparedStatement contactStatement = dbUtil.getPreparedStatement("INSERT INTO contacts (name) VALUES (?);");
				contactStatement.setString(1,request.getParameter("nr_nameOfPractioner"));
				contactStatement.execute();
				resultset = contactStatement.getGeneratedKeys();
				if (resultset.next()) {
					practitioner_id = resultset.getInt(1);
				}
				contactStatement.close();
				contactStatement = null;
			}
	        
	        
	        preparedStatement.setInt(7, practitioner_id);
	        preparedStatement.setInt(8, Integer.parseInt(request.getParameter("nr_responsiblePerson")));
	        preparedStatement.setString(9, request.getParameter("nr_whaRef"));
	        preparedStatement.setString(10, request.getParameter("nr_SSID"));
	        preparedStatement.setInt(11, Integer.parseInt(request.getParameter("nr_newStatusID")));
	        preparedStatement.setTimestamp(12, sqlDate);
	        preparedStatement.setTimestamp(13, sqlDate);
	        preparedStatement.setString(14, request.getParameter("nr_personBeingReferred"));
	        preparedStatement.executeUpdate();
	        
			//execute and obtain the id created
			//set the id and the step in the session
	        resultset = preparedStatement.getGeneratedKeys();
			if (resultset.next()) {
				httpSession.setAttribute("new_referral_id", resultset.getInt(1));
				referral_id = resultset.getInt(1);
			}
			
			preparedStatement = dbUtil.getPreparedStatement("UPDATE referrals set dob=?, age_start=?, gender=?, current_loc=?, current_situation_id=?, young_transition=?, int_dt_updated=? WHERE id = ?;");
			if (request.getParameter("nr_dateOfBirth") == null || request.getParameter("nr_dateOfBirth").toString() == "" ) {
				preparedStatement.setDate(1, null);
			}
			else {
				parsed = format.parse(request.getParameter("nr_dateOfBirth"));
				java.sql.Date dobDate = new java.sql.Date(parsed.getTime());
				preparedStatement.setDate(1, dobDate);
			}
			if (request.getParameter("nr_ageAtStart") == null || request.getParameter("nr_ageAtStart").toString() == "" ) {
				preparedStatement.setDate(2, null);
			}
			else {
				preparedStatement.setInt(2,Integer.parseInt(request.getParameter("nr_ageAtStart")));
			}
			preparedStatement.setString(3, request.getParameter("nr_gender"));
			preparedStatement.setString(4, request.getParameter("nr_currentLocation"));
			preparedStatement.setInt(5,Integer.parseInt(request.getParameter("nr_currentSituation")));
			preparedStatement.setBoolean(6,Boolean.parseBoolean(request.getParameter("nr_YoungTransition")));
			preparedStatement.setTimestamp(7, sqlDate);
			preparedStatement.setInt(8,referral_id);
			preparedStatement.executeUpdate();
			
			// create joining table records for each multi-select field
			
			//Location Preferences
			
			if (request.getParameterValues("nr_locationPreferences") != null){
				String[] location_preferences = request.getParameterValues("nr_locationPreferences");
				
				for(int i = 0; i < location_preferences.length; i++) {
					String location = location_preferences[i].toString();
					
					try {
						location_id = Integer.parseInt(location);
					}
					catch (NumberFormatException n) {
						// we need to use the String literal to set up a location_def and then set location_id to the new ID
						preparedStatement = dbUtil.getPreparedStatement("INSERT INTO locations (location) VALUES (?);");
						preparedStatement.setString(1, location);
						preparedStatement.executeUpdate();
						resultset = preparedStatement.getGeneratedKeys();
						if (resultset.next()) {
							location_id = resultset.getInt(1);
						}
						resultset.close();
						resultset = null;
						preparedStatement.close();
						preparedStatement = null;
						
					}
					preparedStatement = dbUtil.getPreparedStatement("INSERT INTO location_prefs (referral_id, location_id, loc_order) VALUES (?,?,?);");
					preparedStatement.setInt(1, referral_id);
					preparedStatement.setInt(2, location_id);
					preparedStatement.setInt(3, i+1);
					preparedStatement.executeUpdate();
					preparedStatement.close();
					preparedStatement = null;
				}
				location_preferences = null;
			}
			
			
			// Locations to avoid
			if (request.getParameterValues("nr_locationsToAvoid") != null) {
				String[] locations_toAvoid = request.getParameterValues("nr_locationsToAvoid");
				
				for(int i = 0; i < locations_toAvoid.length; i++) {
					String location = locations_toAvoid[i].toString();
					
					try {
						location_id = Integer.parseInt(location);
					}
					catch (NumberFormatException n) {
						// we need to use the String literal to set up a location_def and then set location_id to the new ID
						preparedStatement = dbUtil.getPreparedStatement("INSERT INTO locations (location) VALUES (?);");
						preparedStatement.setString(1, location);
						preparedStatement.executeUpdate();
						resultset = preparedStatement.getGeneratedKeys();
						if (resultset.next()) {
							location_id = resultset.getInt(1);
						}
						resultset.close();
						resultset = null;
						preparedStatement.close();
						preparedStatement = null;
						
					}
					preparedStatement = dbUtil.getPreparedStatement("INSERT INTO locations_avoid (referral_id, location_id) VALUES (?,?);");
					preparedStatement.setInt(1, referral_id);
					preparedStatement.setInt(2, location_id);
					preparedStatement.executeUpdate();
					preparedStatement.close();
					preparedStatement = null;
				}
				locations_toAvoid = null;
			}
			
			
			// locations suggested (no user supplied values)
			if (request.getParameterValues("nr_locationsSuggested") != null){
				String[] locations_Suggested = request.getParameterValues("nr_locationsSuggested");
				
				for(int i = 0; i < locations_Suggested.length; i++) {
					String location = locations_Suggested[i].toString();
					try {
						location_id = Integer.parseInt(location);
					}
					catch (NumberFormatException n) {
						// nothing to do here as there are no user supplied values - ignored
					}
					preparedStatement = dbUtil.getPreparedStatement("INSERT INTO locations_suggested (referral_id, location_id, loc_order) VALUES (?,?,?);");
					preparedStatement.setInt(1, referral_id);
					preparedStatement.setInt(2, location_id);
					preparedStatement.setInt(3, i+1);
					preparedStatement.executeUpdate();
					preparedStatement.close();
					preparedStatement = null;
				}
				locations_Suggested = null;
			}
			
			
			// Essential Requirements
			
			if (request.getParameterValues("nr_PropertyRequirements") != null){
				String[] essential_requirements = request.getParameterValues("nr_PropertyRequirements");
				
				for(int i = 0; i < essential_requirements.length; i++) {
					String requirement = essential_requirements[i].toString();
					try {
						requirement_id = Integer.parseInt(requirement);
					}
					catch (NumberFormatException n) {
						// nothing to do here as there are no user supplied values - ignored
					}
					preparedStatement = dbUtil.getPreparedStatement("INSERT INTO essential_requirements (referral_id, property_req_id) VALUES (?,?);");
					preparedStatement.setInt(1, referral_id);
					preparedStatement.setInt(2, requirement_id);
					preparedStatement.executeUpdate();
					preparedStatement.close();
					preparedStatement = null;
				}
				essential_requirements = null;
			}

			
			preparedStatement = dbUtil.getPreparedStatement("UPDATE referrals set support_level_id=?, waking_nights=?, int_dt_updated=? WHERE id = ?;");
			preparedStatement.setInt(1, Integer.parseInt(request.getParameter("nr_SupportLevels")));
			preparedStatement.setString(2,  request.getParameter("nr_WakingNights"));
			preparedStatement.setTimestamp(3, sqlDate);
			preparedStatement.setInt(4,referral_id);
			preparedStatement.executeUpdate();
			
			// create joining table records for each multi-select field
			
			if (request.getParameterValues("nr_ServiceTypesRequired") != null) {
				String[] required_service_types = request.getParameterValues("nr_ServiceTypesRequired");
				
				for(int i = 0; i < required_service_types.length; i++) {
					String required_service = required_service_types[i].toString();
					try {
						requirement_id = Integer.parseInt(required_service);
					}
					catch (NumberFormatException n) {
						// nothing to do here as there are no user supplied values - ignored
					}
					preparedStatement = dbUtil.getPreparedStatement("INSERT INTO service_types_required (referral_id, service_type_id) VALUES (?,?);");
					preparedStatement.setInt(1, referral_id);
					preparedStatement.setInt(2, requirement_id);
					preparedStatement.executeUpdate();
					preparedStatement.close();
					preparedStatement = null;
				}
				required_service_types = null;
			}
			
			
			if (request.getParameterValues("nr_SpecificNeeds") != null) {
				String[] specific_needs = request.getParameterValues("nr_SpecificNeeds");
				
				for(int i = 0; i < specific_needs.length; i++) {
					String specific_need = specific_needs[i].toString();
					try {
						requirement_id = Integer.parseInt(specific_need);
					}
					catch (NumberFormatException n) {
						// nothing to do here as there are no user supplied values - ignored
					}
					preparedStatement = dbUtil.getPreparedStatement("INSERT INTO specific_needs_behaviours (referral_id, specific_need_id) VALUES (?,?);");
					preparedStatement.setInt(1, referral_id);
					preparedStatement.setInt(2, requirement_id);
					preparedStatement.executeUpdate();
					preparedStatement.close();
					preparedStatement = null;
				}
				specific_needs = null;
			}
			
			
			if (request.getParameterValues("nr_HealthNeeds") != null) {
				String[] health_needs = request.getParameterValues("nr_HealthNeeds");
				
				for(int i = 0; i < health_needs.length; i++) {
					String health_need = health_needs[i].toString();
					try {
						requirement_id = Integer.parseInt(health_need);
					}
					catch (NumberFormatException n) {
						// nothing to do here as there are no user supplied values - ignored
					}
					preparedStatement = dbUtil.getPreparedStatement("INSERT INTO health_medical_needs (referral_id, health_need_id) VALUES (?,?);");
					preparedStatement.setInt(1, referral_id);
					preparedStatement.setInt(2, requirement_id);
					preparedStatement.executeUpdate();
					preparedStatement.close();
					preparedStatement = null;
				}
				health_needs = null;
			}

			
			Audit auditEvent = new Audit();
			auditEvent.registerReferralEvent(auditEvent.CREATE,
					(Integer) httpSession.getAttribute("u_id"),
					"New Referral Created: Status: New",referral_id);
			
			auditEvent = null;
			
			preparedStatement = null;
			dbUtil.db_close();
			dbUtil = null;

			httpSession.setAttribute("new_referral_id",referral_id);
			response.sendRedirect("pages/referrals");
			
			

		
		

		}
	
	
	
}

