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

import java.security.SecureRandom;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.SecretKeyFactory;
import java.math.BigInteger;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

@SuppressWarnings("serial")
@MultipartConfig(maxFileSize = 16177215)    // upload file's size up to 16MB
public class CreateUser extends HttpServlet {

	public static final String PBKDF2_ALGORITHM = "PBKDF2WithHmacSHA1";

    // The following constants may be changed without breaking existing hashes.
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
		

			
			// Need to generate SALT and HASH for supplied Pword
			SecureRandom random = new SecureRandom();
	        byte[] salt = new byte[SALT_BYTE_SIZE];
	        random.nextBytes(salt);
	        PBEKeySpec spec = new PBEKeySpec(request.getParameter("user_pword").toCharArray(), salt, PBKDF2_ITERATIONS, HASH_BYTE_SIZE * 8);
	        SecretKeyFactory skf = SecretKeyFactory.getInstance(PBKDF2_ALGORITHM);
	        byte[] hash = skf.generateSecret(spec).getEncoded();
	        
	        InputStream inputStream = null;
			Part filePart = request.getPart("user_image");
			if (filePart != null) {
	            // prints out some information for debugging
	            System.out.println(filePart.getName());
	            System.out.println(filePart.getSize());
	            System.out.println(filePart.getContentType());
	             
	            // obtains input stream of the upload file
	            inputStream = filePart.getInputStream();
			}
			
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO users (uname, dname, email, level, active, pw_hash, pw_salt, photo) VALUES (?,?,?,?,?,?,?,?);");
			preparedStatement.setString(1, request.getParameter("user_name"));
			preparedStatement.setString(2, request.getParameter("user_dname"));
			preparedStatement.setString(3, request.getParameter("user_email"));
			preparedStatement.setInt(4, Integer.parseInt(request.getParameter("user_role")));
			preparedStatement.setBoolean(5, Boolean.parseBoolean(request.getParameter("user_active")));
			preparedStatement.setString(6, toHex(hash));
			preparedStatement.setString(7, toHex(salt));
			if (inputStream != null) {
                // fetches input stream of the upload file for the blob column
				preparedStatement.setBlob(8, inputStream);
            }
			preparedStatement.executeUpdate();
			// set the id of the newly created org to be the active account
			ResultSet resultset = preparedStatement.getGeneratedKeys();
			if (resultset.next()) {
				httpSession.setAttribute("new_user_id", resultset.getInt(1));
			}
			httpSession.setAttribute("user_last_action", "user_created");
			httpSession.setAttribute("system_message", "User " + request.getParameter("user_dname") + " successfully created");
			preparedStatement.close();
			preparedStatement = null;
			String redirectString = "pages/users";
			response.sendRedirect(redirectString);
		}
	
	
	private static String toHex(byte[] array)
    {
        BigInteger bi = new BigInteger(1, array);
        String hex = bi.toString(16);
        int paddingLength = (array.length * 2) - hex.length();
        if(paddingLength > 0)
            return String.format("%0" + paddingLength + "d", 0) + hex;
        else
            return hex;
    }
}

