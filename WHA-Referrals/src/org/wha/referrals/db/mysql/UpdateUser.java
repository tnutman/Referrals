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
public class UpdateUser extends HttpServlet {
	
	/**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        }
        catch (Exception ex) {
            Logger.getLogger(UpdateUser.class.getName()).log(Level.SEVERE, null, ex);
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
			
			
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("UPDATE users SET dname = ?, debug = ?, email = ?, status = ?, region = ?  WHERE id = ?;");
			preparedStatement.setString(1,request.getParameter("user_dname"));
			preparedStatement.setInt(2, Integer.parseInt(request.getParameter("user_debug")));
			preparedStatement.setString(3,request.getParameter("user_email"));
			preparedStatement.setInt(4, Integer.parseInt(request.getParameter("user_status")));
			preparedStatement.setString(5,request.getParameter("user_region"));
			preparedStatement.setInt(6, Integer.parseInt(request.getParameter("user_id")));
			preparedStatement.executeUpdate();
			// set the id of the newly created org to be the active account
			httpSession.setAttribute("user_last_action", "USER_DETAILS_UPDATED");
			httpSession.setAttribute("system_message", "User ID:  " + request.getParameter("user_id") + " details updated");
			preparedStatement.close();
			preparedStatement = null;
			String redirectString = "pages/users";
			response.sendRedirect(redirectString);
		}
	}
	

}
