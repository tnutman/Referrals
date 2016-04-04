package org.wha.referrals.db.mysql;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Calendar;

public class Audit {
	
	public final String CREATE = "CREATE";
	public final String UPDATE = "UPDATE";
	public final String DELETE = "DELETE";
	
	Calendar cal = Calendar.getInstance();
    java.sql.Timestamp sqlDate = new java.sql.Timestamp(cal.getTimeInMillis());
	mySQLDBUtil dbUtil = new mySQLDBUtil();

	public boolean registerReferralEvent(String event, int user_id, String details, int referral_id) throws Exception {
		try {
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO audit_log (event, user, datetime, details, referral_id) VALUES (?,?,?,?,?);");
			preparedStatement.setString(1, event);
			preparedStatement.setInt(2, user_id);
			preparedStatement.setTimestamp(3, sqlDate);
			preparedStatement.setString(4, details);
			preparedStatement.setInt(5, referral_id);
			preparedStatement.execute();
			preparedStatement.close();
			
			preparedStatement = dbUtil.getPreparedStatement("UPDATE referrals SET int_dt_updated = ? WHERE id = ?");
			preparedStatement.setTimestamp(1, sqlDate);
			preparedStatement.setInt(2, referral_id);
			preparedStatement.execute();
			preparedStatement.close();
			preparedStatement = null;
			dbUtil.db_close();
			dbUtil = null;
			return true;
		}
		catch (Exception e) {
			System.out.print(e);
			return false;
		}
		
		
	}
	
	public boolean registerReferralEventWithLookup(String event, int user_id, String update_field, String details, int referral_id, int old_index, int new_index, String table, String field) throws Exception {
		try {
			//Create audit message (was details) by retrieving old and new data values.
			String old_val = "";
			String new_val = "";
			if (old_index == 0) {
				//list entry audit trail (no old value)
				PreparedStatement preparedStatement = dbUtil.getPreparedStatement("SELECT " + field + " FROM " + table + " WHERE id=?");
				preparedStatement.setInt(1, new_index);
				ResultSet rs = preparedStatement.executeQuery();
				while (rs.next()) {
					new_val = rs.getString(field);
				}
				if (event == DELETE) {
					details = event + ": entry " + new_index + " (" + new_val + ") removed from " + update_field;
				}
				else if (event == UPDATE) {
					details = event + ": entry " + new_index + " (" + new_val + ") added to " + update_field;
				}
				preparedStatement = dbUtil.getPreparedStatement("INSERT INTO audit_log (event, user, datetime, details, referral_id) VALUES (?,?,?,?,?);");
				preparedStatement.setString(1, event);
				preparedStatement.setInt(2, user_id);
				preparedStatement.setTimestamp(3, sqlDate);
				preparedStatement.setString(4, details);
				preparedStatement.setInt(5, referral_id);
				preparedStatement.execute();
				preparedStatement.close();
				preparedStatement = dbUtil.getPreparedStatement("UPDATE referrals SET int_dt_updated = ? WHERE id = ?");
				preparedStatement.setTimestamp(1, sqlDate);
				preparedStatement.setInt(2, referral_id);
				preparedStatement.execute();
				preparedStatement.close();
				preparedStatement = null;
				rs = null;
				dbUtil.db_close();
				dbUtil = null;
				
			}
			else {
				PreparedStatement preparedStatement = dbUtil.getPreparedStatement("SELECT " + field + " FROM " + table + " WHERE id=?");
				preparedStatement.setInt(1, old_index);
				ResultSet rs = preparedStatement.executeQuery();
				while (rs.next()) {
					old_val = rs.getString(field);
				}
				preparedStatement = dbUtil.getPreparedStatement("SELECT " + field + " FROM " + table + " WHERE id=?");
				preparedStatement.setInt(1, new_index);
				rs = preparedStatement.executeQuery();
				while (rs.next()) {
					new_val = rs.getString(field);
				}
				details = event + " to " + update_field + " from old value " + old_index + " (" + old_val + ") to new value " + new_index + " (" + new_val + ")";
				preparedStatement = dbUtil.getPreparedStatement("INSERT INTO audit_log (event, user, datetime, details, referral_id) VALUES (?,?,?,?,?);");
				preparedStatement.setString(1, event);
				preparedStatement.setInt(2, user_id);
				preparedStatement.setTimestamp(3, sqlDate);
				preparedStatement.setString(4, details);
				preparedStatement.setInt(5, referral_id);
				preparedStatement.execute();
				preparedStatement.close();
				preparedStatement = dbUtil.getPreparedStatement("UPDATE referrals SET int_dt_updated = ? WHERE id = ?");
				preparedStatement.setTimestamp(1, sqlDate);
				preparedStatement.setInt(2, referral_id);
				preparedStatement.execute();
				preparedStatement.close();
				preparedStatement = null;
				rs = null;
				dbUtil.db_close();
				dbUtil = null;
				
			}
			return true;
		}
		catch (Exception e) {
			System.out.print(e);
			return false;
		}
		
		
	}
	
	public boolean registerEvent(String event, int user_id, String details) throws Exception {
		try {
			PreparedStatement preparedStatement = dbUtil.getPreparedStatement("INSERT INTO AUDIT (event, user, datetime, details) VALUES (?,?,?,?);");
			preparedStatement.setString(1, event);
			preparedStatement.setInt(2, user_id);
			preparedStatement.setTimestamp(3, sqlDate);
			preparedStatement.setString(4, details);
			preparedStatement.execute();
			preparedStatement.close();
			
			preparedStatement = null;
			dbUtil.db_close();
			dbUtil = null;
			return true;
		}
		catch (Exception e) {
			System.out.print(e);
			return false;
		}
		
		
	}
}
