package org.wha.referrals.db.mysql;

import java.io.Console;
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
public class UpdateOrg extends HttpServlet {
	
	/**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        }
        catch (Exception ex) {
            Logger.getLogger(CreateOrg.class.getName()).log(Level.SEVERE, null, ex);
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
			
			if (new String(request.getParameter("updateType")).equals("ONE_CONNECTION")) {
				PreparedStatement preparedStatement = dbUtil.getPreparedStatement("UPDATE orgs SET one_url = ?, one_api_user = ?, one_key = ?, one_secret = ? WHERE id = ?;");
				preparedStatement.setString(1, request.getParameter("org_url"));
				preparedStatement.setString(2, request.getParameter("org_api_user"));
				preparedStatement.setString(3, request.getParameter("org_key"));
				preparedStatement.setString(4, request.getParameter("org_secret"));
				preparedStatement.setInt(5, Integer.parseInt((String) httpSession.getAttribute("active_org")));
				preparedStatement.executeUpdate();
				httpSession.setAttribute("user_last_action", "org_updated_one_details");
				httpSession.setAttribute("system_message", "Org " + request.getParameter("name") + " ONE Connection details successfully updated");
				preparedStatement.close();
				preparedStatement = null;
				String redirectString = "pages/orgs?org_id="+ httpSession.getAttribute("active_org");
				response.sendRedirect(redirectString);
			}
			
			if (new String(request.getParameter("updateType")).equals("NOTES")) {
				PreparedStatement preparedStatement = dbUtil.getPreparedStatement("UPDATE orgs SET notes = ? WHERE id = ?;");
				preparedStatement.setString(1, request.getParameter("org_notes"));
				preparedStatement.setInt(2, Integer.parseInt((String) httpSession.getAttribute("active_org")));
				preparedStatement.executeUpdate();
				httpSession.setAttribute("user_last_action", "org_updated_notes");
				httpSession.setAttribute("system_message", "Org " + request.getParameter("name") + " Notes successfully updated");
				preparedStatement.close();
				preparedStatement = null;
				String redirectString = "pages/orgs?org_id="+ httpSession.getAttribute("active_org");
				response.sendRedirect(redirectString);
			}
		}
	}
	

}

