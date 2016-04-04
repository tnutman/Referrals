package org.wha.referrals.db.mysql;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
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
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 * Servlet implementation class ImageServlet
 */
@WebServlet("/ImageServlet")
public class ImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ImageServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
   protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
    	
    	HttpSession httpSession = request.getSession();
		mySQLDBUtil dbUtil = new mySQLDBUtil();
		byte[] imageContent = null;
		
		if (httpSession.getAttribute("u_id") == null) {
			// no valid session data - clear the session and move to login page
			httpSession.invalidate();
			String redirectString = "pages/login";
			response.sendRedirect(redirectString);
		}
		else {
			String table = "";
			if (request.getParameter("type").equals("org")) {
				table = "orgs";
			}
			else if (request.getParameter("type").equals("user")) {
				table = "users";
			}
			else {
				table = "contacts";
			}
			
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("SELECT photo FROM " + table + " WHERE id = ?");
			preparedStatement.setString(1, request.getParameter("id"));
			ResultSet resultset = preparedStatement.executeQuery();
			if (resultset.next()){
				if (resultset.getBytes("photo")!=null)
					imageContent = resultset.getBytes("photo");
				else {
					File fi = new File(getServletContext().getRealPath("/pages/resources/default_org_thumb.png"));
					imageContent = Files.readAllBytes(fi.toPath());
					
				}
			}
			response.setContentType("image/png");
			response.setContentLength(imageContent.length);
			response.getOutputStream().write(imageContent);
			response.flushBuffer();
		}
    	
    	
    }

}
