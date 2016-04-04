package org.wha.referrals.db.mysql;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
//import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Calendar;
import java.text.ParseException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@SuppressWarnings("serial")
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class CreateContact extends HttpServlet {
	
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
		
		Calendar cal = Calendar.getInstance();
       java.sql.Timestamp sqlDateTimeStamp = new java.sql.Timestamp(cal.getTimeInMillis());
		HttpSession httpSession = request.getSession();
		mySQLDBUtil dbUtil = new mySQLDBUtil();
		Integer contact_id = 0;
		
		if (httpSession.getAttribute("u_id") == null) {
			// no valid session data - clear the session and move to login page
			httpSession.invalidate();
			String redirectString = "pages/login";
			response.sendRedirect(redirectString);
		}
		else {
			
			InputStream inputStream = null;
			Part filePart = request.getPart("contact_photo");
			if (filePart != null) {
	            // prints out some information for debugging
	            System.out.println(filePart.getName());
	            System.out.println(filePart.getSize());
	            System.out.println(filePart.getContentType());
	             
	            // obtains input stream of the upload file
	            inputStream = filePart.getInputStream();
	        }
			
			//Insert Primary Contact Data
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO contacts (title, fname, lname, mnames, dob, " +
			"email, tel, mob, addr1, addr2, town, city, state, pcode, country, o_id, last_viewed, photo) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);");
			preparedStatement.setString(1, request.getParameter("contact_title"));
			preparedStatement.setString(2, request.getParameter("contact_fname"));
			preparedStatement.setString(3, request.getParameter("contact_lname"));
			preparedStatement.setString(4, request.getParameter("contact_mnames"));
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	        Date parsed = format.parse(request.getParameter("contact_dob"));
	        java.sql.Date dobDate = new java.sql.Date(parsed.getTime());
			preparedStatement.setDate(5, dobDate);
			preparedStatement.setString(6, request.getParameter("contact_email"));
			preparedStatement.setString(7, request.getParameter("contact_tel"));
			preparedStatement.setString(8, request.getParameter("contact_mob"));
			preparedStatement.setString(9, request.getParameter("contact_addr1"));
			preparedStatement.setString(10, request.getParameter("contact_addr2"));
			preparedStatement.setString(11, request.getParameter("contact_town"));
			preparedStatement.setString(12, request.getParameter("contact_city"));
			preparedStatement.setString(13, request.getParameter("contact_state"));
			preparedStatement.setString(14, request.getParameter("contact_pcode"));
			preparedStatement.setString(15, request.getParameter("contact_country"));
			preparedStatement.setInt(16, Integer.parseInt(request.getParameter("org_id")));
			java.sql.Date lastViewedDate = new java.sql.Date(new java.util.Date().getTime());
			preparedStatement.setDate(17, lastViewedDate);
			if (inputStream != null) {
                // fetches input stream of the upload file for the blob column
				preparedStatement.setBlob(18, inputStream);
            }
			preparedStatement.executeUpdate();
			// set the id of the newly created contact to be the active contact
			ResultSet resultset = preparedStatement.getGeneratedKeys();
			if (resultset.next()) {
				httpSession.setAttribute("current_contact_id", resultset.getInt(1));
				contact_id = resultset.getInt(1);
			}
			
			// Now need to create extended properties entries
			// First we need to get the list of ID's for each custom property for the CONTACT object
			preparedStatement = dbUtil.getPreparedStatement("SELECT id FROM ep_defs WHERE object = 'CONTACT' AND o_id = ?;");
			preparedStatement.setInt(1, Integer.parseInt(request.getParameter("org_id")));
			preparedStatement.execute();
			resultset = preparedStatement.getResultSet();
			
			//now move through each ID and look for a value in the request, if value found, insert into the store
			while (resultset.next()) {
				String paramValue = request.getParameter("extField_"+ Integer.toString(resultset.getInt("id")));
				if (paramValue!=null && !paramValue.isEmpty()) {
					preparedStatement = dbUtil.getPreparedStatement("INSERT INTO ep_data_store (co_id, ep_defs_id, value) VALUES (?,?,?);");
					preparedStatement.setInt(1,contact_id);
					preparedStatement.setInt(2,(resultset.getInt("id")));
					preparedStatement.setString(3,paramValue);
					preparedStatement.executeUpdate();
				}
				
			}
			
			httpSession.setAttribute("user_last_action", "contact_created");
			httpSession.setAttribute("system_message", "Contact" + request.getParameter("fname") + " " + request.getParameter("lname") + " successfully created");
			
			//insert activity history for contact
			preparedStatement = dbUtil.getPreparedStatement("INSERT INTO activity_history (co_id, activity, dateTimeStamp) VALUES (?,?,?);");
			preparedStatement.setInt(1, contact_id);
			preparedStatement.setString(2, "Contact Record Created by " + httpSession.getAttribute("dname"));
			preparedStatement.setTimestamp(3, sqlDateTimeStamp);
			preparedStatement.executeUpdate();
			preparedStatement.close();
			preparedStatement = null;
			String redirectString = "pages/contacts";
			response.sendRedirect(redirectString);
		}
	}
	

}

