package org.wha.referrals.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
//import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;



@SuppressWarnings("serial")
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class UpdateField extends HttpServlet {


	
	
	/**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        }
        catch (Exception ex) {
            Logger.getLogger(UpdateOrg.class.getName()).log(Level.SEVERE, null, ex);
            int errorCode = 500;
            if (ex instanceof FileNotFoundException) {
                errorCode = 404;
            }
            response.sendError(errorCode, ex.getMessage());
        }
    }

	private void processRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
        //java.sql.Timestamp sqlDate = new java.sql.Timestamp(cal.getTimeInMillis());
		HttpSession httpSession = request.getSession();
		mySQLDBUtil dbUtil = new mySQLDBUtil();
		
		if (httpSession.getAttribute("u_id") == null) {
			// no valid session data - clear the session and move to login page
			httpSession.invalidate();
			String redirectString = "pages/login";
			response.sendRedirect(redirectString);
		}
		else {
			
			// test the type - if LIST then we are dealing with a joining table and so the steps are more complex
			
			if (request.getParameter("type").equals("LIST")) {
				
				String[] list_values = request.getParameterValues("new_value[]");
				
				for(int i = 0; i < list_values.length; i++) {
					int list_value_id = Integer.parseInt(list_values[i]);
					PreparedStatement preparedStatement = dbUtil.getPreparedStatement("SELECT " + request.getParameter("attribute_name") + " FROM " + request.getParameter("field_name") + " WHERE referral_id = ?");
					preparedStatement.setInt(1, Integer.parseInt(request.getParameter("referral_id")));
					ResultSet resultSet = preparedStatement.executeQuery();
					
					boolean match = false;
					while (resultSet.next()) {
						
						match = false;
						if (resultSet.getInt(request.getParameter("attribute_name")) == list_value_id) {
							//the supplied entry already exists in the current data
							match = true;
							break;
						}
						else {
							match = false;
						}
					}
					// looped through all items current in the database.
					// If match, then we don't need to anything
					// If not match, then the supplied list_value_id does not exist in the current database and we need to insert.
					if (!match) {
						preparedStatement = dbUtil.getPreparedStatement("INSERT INTO " + request.getParameter("field_name") + " (referral_id, " + request.getParameter("attribute_name") + ") VALUES (?,?)");
						preparedStatement.setInt(1, Integer.parseInt(request.getParameter("referral_id")));
						preparedStatement.setInt(2, list_value_id);
						preparedStatement.executeUpdate();
						
						//Audit entry to add new item
						Audit auditEvent = new Audit();
						auditEvent.registerReferralEventWithLookup(
								auditEvent.UPDATE,
								(Integer) httpSession.getAttribute("u_id"),
								request.getParameter("field_name"), "",
								Integer.parseInt(request.getParameter("referral_id")),
								0,
								Integer.parseInt(request.getParameter("new_value[]")),
								request.getParameter("table"),
								request.getParameter("source_display"));
						
						auditEvent = null;
						
					}
				}
				//dealing with a joining table and array of values
				// select all the records in the correct joining table for the field_name
				// create an array for supplied values
				// loop through array
				PreparedStatement preparedStatement = dbUtil.getPreparedStatement("SELECT " + request.getParameter("attribute_name") + " FROM " + request.getParameter("field_name") + " WHERE referral_id = ?");
				preparedStatement.setInt(1, Integer.parseInt(request.getParameter("referral_id")));
				ResultSet resultSet = preparedStatement.executeQuery();
				boolean match = false;
				while (resultSet.next()) {
					for(int i = 0; i < list_values.length; i++) {
						if (resultSet.getInt(request.getParameter("attribute_name")) == Integer.parseInt(list_values[i])) {
							match = true;
							break;
						}
						else {
							match = false;
						}
					}
					// looped through all items current in the database.
					// If match, then we don't need to anything
					// If not match, then the supplied result set item does not exist in the supplied data and we need to delete.
					if (!match) {
						preparedStatement = dbUtil.getPreparedStatement("DELETE FROM " + request.getParameter("field_name") + " WHERE referral_id = ? AND " + request.getParameter("attribute_name") + " = ?");
						preparedStatement.setInt(1, Integer.parseInt(request.getParameter("referral_id")));
						preparedStatement.setInt(2, resultSet.getInt(request.getParameter("attribute_name")));
						preparedStatement.executeUpdate();
						
						//Audit entry to remove item
						Audit auditEvent = new Audit();
						auditEvent.registerReferralEventWithLookup(
								auditEvent.DELETE,
								(Integer) httpSession.getAttribute("u_id"),
								request.getParameter("field_name"), "",
								Integer.parseInt(request.getParameter("referral_id")),
								0,
								resultSet.getInt(request.getParameter("attribute_name")),
								request.getParameter("table"),
								request.getParameter("source_display"));
						
						auditEvent = null;
					}
				}
				
				
				
			}
			else {
				//dealing with value directly in the referral record
				
				// get the old value - use type value to assist with storing correct data type
				PreparedStatement preparedStatement = dbUtil.getPreparedStatement("SELECT " + request.getParameter("field_name") + " FROM referrals WHERE id = ?");
				PreparedStatement pStmtUpdate = dbUtil.getPreparedStatement("UPDATE referrals SET " + request.getParameter("field_name") + "= ? WHERE id = ?");
				preparedStatement.setInt(1, Integer.parseInt(request.getParameter("referral_id")));
				pStmtUpdate.setInt(2, Integer.parseInt(request.getParameter("referral_id")));
				
				
				
				if (request.getParameter("type").equals("INT")) {
					int old_value = 0;
					ResultSet resultset = preparedStatement.executeQuery();
					if (resultset.next()) {
						old_value = resultset.getInt(request.getParameter("field_name"));
					}
					pStmtUpdate.setInt(1, Integer.parseInt(request.getParameter("new_value")));
					pStmtUpdate.executeUpdate();
					
					/* Audit auditEvent = new Audit();
					auditEvent.registerReferralEvent(auditEvent.UPDATE,
							(Integer) httpSession.getAttribute("u_id"),
							"Updated " + request.getParameter("field_name") + " from old value: " + old_value + " to: " + request.getParameter("new_value"),
							Integer.parseInt(request.getParameter("referral_id")));
					
					auditEvent = null;
					*/
					
					
					
					Audit auditEvent = new Audit();
					auditEvent.registerReferralEventWithLookup(
							auditEvent.UPDATE,
							(Integer) httpSession.getAttribute("u_id"),
							request.getParameter("field_name"), "",
							Integer.parseInt(request.getParameter("referral_id")),
							old_value,
							Integer.parseInt(request.getParameter("new_value")),
							request.getParameter("table"),
							request.getParameter("display"));
					
					auditEvent = null;
					preparedStatement = null;
					pStmtUpdate = null;
					resultset = null;
					dbUtil.db_close();
					dbUtil = null;
				}
				if (request.getParameter("type").equals("STRING")) {
					ResultSet resultset = preparedStatement.executeQuery();
					String old_value = "";
					if (resultset.next()) {
						old_value = resultset.getString(request.getParameter("field_name"));
					}
					pStmtUpdate.setString(1, request.getParameter("new_value"));
					pStmtUpdate.executeUpdate();
					
					Audit auditEvent = new Audit();
					auditEvent.registerReferralEvent(auditEvent.UPDATE,
							(Integer) httpSession.getAttribute("u_id"),
							"Updated " + request.getParameter("field_name") + " from old value: " + old_value + " to: " + request.getParameter("new_value"),
							Integer.parseInt(request.getParameter("referral_id")));
					
					auditEvent = null;
					
					preparedStatement = null;
					pStmtUpdate = null;
					resultset = null;
					dbUtil.db_close();
					dbUtil = null;
				}
				if (request.getParameter("type").equals("DATE")) {
					ResultSet resultset = preparedStatement.executeQuery();
					Date old_value =  null;
					if (resultset.next()) {
						old_value = resultset.getDate(request.getParameter("field_name"));
					}
					SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			        Date parsed = format.parse(request.getParameter("new_value"));
			        java.sql.Date new_value = new java.sql.Date(parsed.getTime());
					pStmtUpdate.setDate(1, new_value);
					pStmtUpdate.executeUpdate();
					
					Audit auditEvent = new Audit();
					auditEvent.registerReferralEvent(auditEvent.UPDATE,
							(Integer) httpSession.getAttribute("u_id"),
							"Updated " + request.getParameter("field_name") + " from old value: " + old_value + " to: " + request.getParameter("new_value"),
							Integer.parseInt(request.getParameter("referral_id")));
					
					auditEvent = null;
					
					preparedStatement = null;
					pStmtUpdate = null;
					resultset = null;
					dbUtil.db_close();
					dbUtil = null;
				}
				if (request.getParameter("type").equals("BOOLEAN")) {
					ResultSet resultset = preparedStatement.executeQuery();
					Boolean	 old_value =  null;
					if (resultset.next()) {
						old_value = resultset.getBoolean(request.getParameter("field_name"));
					}
					pStmtUpdate.setBoolean(1, Boolean.parseBoolean(request.getParameter("new_value")));
					pStmtUpdate.executeUpdate();
					
					Audit auditEvent = new Audit();
					auditEvent.registerReferralEvent(auditEvent.UPDATE,
							(Integer) httpSession.getAttribute("u_id"),
							"Updated " + request.getParameter("field_name") + " from old value: " + old_value + " to: " + request.getParameter("new_value"),
							Integer.parseInt(request.getParameter("referral_id")));
					
					auditEvent = null;
					
					preparedStatement = null;
					pStmtUpdate = null;
					resultset = null;
					dbUtil.db_close();
					dbUtil = null;
				}
				
				
				
			}
			
			// should return an error back to JSP to handle.....
			
			
			
			
		}
	}
	
	public static String toTitleCase(String input) {
	    StringBuilder titleCase = new StringBuilder();
	    boolean nextTitleCase = true;

	    for (char c : input.toCharArray()) {
	        if (Character.isSpaceChar(c)) {
	            nextTitleCase = true;
	        } else if (nextTitleCase) {
	            c = Character.toTitleCase(c);
	            nextTitleCase = false;
	        }

	        titleCase.append(c);
	    }

	    return titleCase.toString();
	}

}

