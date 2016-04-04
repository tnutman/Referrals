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
public class CreateOrg extends HttpServlet {
	
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
			
			InputStream inputStream = null;
			Part filePart = request.getPart("org_image");
			if (filePart != null) {
	            // prints out some information for debugging
	            System.out.println(filePart.getName());
	            System.out.println(filePart.getSize());
	            System.out.println(filePart.getContentType());
	             
	            // obtains input stream of the upload file
	            inputStream = filePart.getInputStream();
	        }
			
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO orgs (name, u_id, photo) VALUES (?,?,?);");
			preparedStatement.setString(1, request.getParameter("org_name"));
			preparedStatement.setInt(2, (int) httpSession.getAttribute("u_id"));
			if (inputStream != null) {
                // fetches input stream of the upload file for the blob column
				preparedStatement.setBlob(3, inputStream);
            }
			preparedStatement.executeUpdate();
			// set the id of the newly created org to be the active account
			ResultSet resultset = preparedStatement.getGeneratedKeys();
			if (resultset.next()) {
				httpSession.setAttribute("current_org_id", resultset.getInt(1));
			}
			httpSession.setAttribute("user_last_action", "org_created");
			httpSession.setAttribute("system_message", "Org " + request.getParameter("name") + " successfully created");
			preparedStatement.close();
			preparedStatement = null;
			String redirectString = "pages/orgs";
			response.sendRedirect(redirectString);
		}
	}
	

}

