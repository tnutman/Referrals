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
public class AddListDef extends HttpServlet {
	
	/**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        }
        catch (Exception ex) {
            Logger.getLogger(AddListDef.class.getName()).log(Level.SEVERE, null, ex);
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
		String fieldName = "";
		String redirectString;
		
		if (httpSession.getAttribute("u_id") == null) {
			// no valid session data - clear the session and move to login page
			httpSession.invalidate();
			redirectString = "pages/login";
			response.sendRedirect(redirectString);
		}
		else {
			
			if (request.getParameter("list").equals("locations")) {
				fieldName = "location";
				redirectString = "pages/manage_locations?list="+request.getParameter("list");
			}
			else if (request.getParameter("list").equals("welmede_locations")) {
				fieldName = "location";
				redirectString = "pages/manage_locations?list="+request.getParameter("list");
			}
			else {
				fieldName = "list_entry";
				redirectString = "pages/manage_list?list="+request.getParameter("list");
			}
			
			String sqlString = "INSERT INTO " + request.getParameter("list") + " (" + fieldName + ") VALUES ('" + request.getParameter("new_entry") + "');";
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement(sqlString);
			preparedStatement.executeUpdate();
			// set the id of the newly created org to be the active account
			httpSession.setAttribute("user_last_action", "entry add to: " + request.getParameter("list"));
			httpSession.setAttribute("system_message", "List Entry into:  " + request.getParameter("list") + " successfully added");
			preparedStatement.close();
			preparedStatement = null;
			
			response.sendRedirect(redirectString);
		}
	}
	

}
