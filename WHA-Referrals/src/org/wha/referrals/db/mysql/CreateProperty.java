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
public class CreateProperty extends HttpServlet {
	
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
			
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO ep_defs (type, o_id, name, object, list_type, notes) VALUES (?,?,?,?,?,?);");
			preparedStatement.setString(1, request.getParameter("prop_type"));
			preparedStatement.setInt(2, Integer.parseInt(request.getParameter("prop_org_id")));
			preparedStatement.setString(3, request.getParameter("prop_name"));
			preparedStatement.setString(4, request.getParameter("prop_object"));
			preparedStatement.setString(5, request.getParameter("prop_list_type"));
			preparedStatement.setString(6, request.getParameter("prop_notes"));
			preparedStatement.executeUpdate();
			// set the id of the newly created org to be the active account
			ResultSet resultset = preparedStatement.getGeneratedKeys();
			if (resultset.next()) {
				httpSession.setAttribute("current_prop_def_id", resultset.getInt(1));
			}
			httpSession.setAttribute("user_last_action", "prop_type_created");
			httpSession.setAttribute("system_message", "Property " + request.getParameter("prop_name") + " successfully created");
			preparedStatement.close();
			preparedStatement = null;
			
			//test of LIST type and process name/value pairs
			if (request.getParameter("prop_type").equals("LIST")) {
				String[] pairs = request.getParameter("list_item_defs").split(";");
				for (int i=0; i < pairs.length; i = i+1) {
					String[] parts = pairs[i].toString().split("=");
					preparedStatement = dbUtil.getPreparedStatement("INSERT INTO ep_list_item_defs (dname, value, ep_defs_id) VALUES (?,?,?);");
					preparedStatement.setString(1, parts[0]);
					preparedStatement.setString(2, parts[1]);
					preparedStatement.setInt(3, (int) httpSession.getAttribute("current_prop_def_id"));
					preparedStatement.executeUpdate();
				}
				
			}
			
			
			
			String redirectString = "pages/properties";
			response.sendRedirect(redirectString);
		}
	}
	

}

