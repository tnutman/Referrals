package org.wha.referrals.security;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Calendar;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.wha.referrals.db.mysql.*;

import java.security.SecureRandom;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.SecretKeyFactory;
import java.math.BigInteger;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

@SuppressWarnings("serial")
public class Login extends HttpServlet {
	
	public static final String PBKDF2_ALGORITHM = "PBKDF2WithHmacSHA1";
	public static final int SALT_BYTE_SIZE = 24;
    public static final int HASH_BYTE_SIZE = 24;
    public static final int PBKDF2_ITERATIONS = 1000;

    public static final int ITERATION_INDEX = 0;
    public static final int SALT_INDEX = 1;
    public static final int PBKDF2_INDEX = 2;
    
	/**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        }
        catch (Exception ex) {
            Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
            int errorCode = 500;
            if (ex instanceof FileNotFoundException) {
                errorCode = 404;
            }
            response.sendError(errorCode, ex.getMessage());
        }
    }

	private void processRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Simple login servlet - use uname and pword to identify row.
		// retrieve salt for supplied email address.
		// if salt not found then return error.
		// 
		// If row found, copy value to session, if not - send invalid message/signal and write audit entry
		Calendar cal = Calendar.getInstance();
        java.sql.Timestamp sqlDate = new java.sql.Timestamp(cal.getTimeInMillis());
		HttpSession httpSession = request.getSession();
		mySQLDBUtil dbUtil = new mySQLDBUtil();
		String redirectString = "";
		String userCountSQL = "SELECT id, active, pw_salt, pw_hash FROM users " +
							"where uname='" + request.getParameter("uname") + "'";
		try {
	    	ResultSet resultSet = dbUtil.getResultSet(userCountSQL);
	    		if (resultSet.first()) {
	    			// we have a row matched on uname
	    			byte[] hash = fromHex(resultSet.getString("pw_hash"));
	    			byte[] salt = fromHex(resultSet.getString("pw_salt"));
	    			int u_id = resultSet.getInt("id");
	    			boolean u_active = resultSet.getBoolean("active");
	    	        PBEKeySpec spec = new PBEKeySpec(request.getParameter("pword").toCharArray(), salt, PBKDF2_ITERATIONS, HASH_BYTE_SIZE * 8);
	    	        SecretKeyFactory skf = SecretKeyFactory.getInstance(PBKDF2_ALGORITHM);
	    	        byte[] testHash = skf.generateSecret(spec).getEncoded();
	    	        
	    	        if (slowEquals(hash, testHash) && u_active) {
	    	        	String userDetailsSQL = "SELECT id, dname, active, email, level FROM users " +
		    					"where id=" + u_id;
		    	    	ResultSet resultSet2 = dbUtil.getResultSet(userDetailsSQL);
		    	    	while (resultSet2.next()) {		
		    	    		httpSession.setAttribute("u_id", resultSet2.getInt("id"));
		    	    		httpSession.setAttribute("dname", resultSet2.getString("dname"));
		    	    		httpSession.setAttribute("email", resultSet2.getString("email"));
		    	    		httpSession.setAttribute("active", resultSet2.getBoolean("active"));
		    	    		httpSession.setAttribute("level", resultSet2.getInt("level"));
		    	    		httpSession.setAttribute("user_last_action", "LOGIN_SUCCESS");

		            	}
		    	    	resultSet2 = null;
		    	    	redirectString = "pages/dashboard";
	    	        }
	    	        else {
	    	        	String user_last_action = "LOGIN_FAILED";
	    	        	String system_msg = "";
	    	        	String audit_event = "";
	    	        	if (u_active) {
	    	        		audit_event = "INCORRECT PASSWORD";
	    	        		system_msg = "Incorrect Password";
	    	        	}
	    	        	else {
	    	        		audit_event = "ACCOUNT INACTIVE";
	    	        		system_msg = "Your account is inactive";
	    	        	}
	    	        	PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO audit_log (event, user, datetime, details) VALUES " + 
		    					"('" + user_last_action + "', " + u_id + ", ?, '" + audit_event + "');");
		    			preparedStatement.setTimestamp(1, sqlDate);
		    			preparedStatement.executeUpdate();
		    			httpSession.setAttribute("user_last_action", user_last_action);
		    			httpSession.setAttribute("system_msg", system_msg);
		    			preparedStatement = null;
		    			redirectString = "pages/login";
	    	        }
	    	        resultSet = null;
	    		}
	    		
	    		else {
	    			// user not locate
	    			// need to redirect to the login page with a failed login message
	    			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO audit_log (event, datetime, details) VALUES " + 
	    					"('LOGIN_FAILED', ?, 'NO USERNAME MATCH for supplied username: " + request.getParameter("uname") + "');");
	    			preparedStatement.setTimestamp(1, sqlDate);
	    			preparedStatement.executeUpdate();
	    			httpSession.setAttribute("user_last_action", "LOGIN_FAILED");
	    			httpSession.setAttribute("system_msg", "Username does not exist");
	    			preparedStatement = null;
	    			redirectString = "pages/login";
	    		}
	    		
	    	}
	    	catch (Exception e) {
	    		throw e;
	    	}
	    	finally {
	    		
	    	}
		
		dbUtil.db_close();
		
		response.sendRedirect(redirectString);
		
	}
	
	 private static byte[] fromHex(String hex)
	    {
	        byte[] binary = new byte[hex.length() / 2];
	        for(int i = 0; i < binary.length; i++)
	        {
	            binary[i] = (byte)Integer.parseInt(hex.substring(2*i, 2*i+2), 16);
	        }
	        return binary;
	    }
	 
	 private static boolean slowEquals(byte[] a, byte[] b)
	    {
	        int diff = a.length ^ b.length;
	        for(int i = 0; i < a.length && i < b.length; i++)
	            diff |= a[i] ^ b[i];
	        return diff == 0;
	    }
}
