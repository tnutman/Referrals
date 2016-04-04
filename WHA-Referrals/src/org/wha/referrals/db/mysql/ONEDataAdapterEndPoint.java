package org.wha.referrals.db.mysql;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.*;

import java.sql.*;
 
@SuppressWarnings("serial")
public class ONEDataAdapterEndPoint extends HttpServlet {
 
  private class RestRequest {
    // Accommodate two requests, one for all resources, another for a specific resource
    private Pattern regExAllPattern = Pattern.compile("/customer");
    private Pattern regExIdPattern = Pattern.compile("/customer/([0-9]*)");
 
    private Integer id;
 
    public RestRequest(String pathInfo) throws ServletException {
      // regex parse pathInfo
      Matcher matcher;
 
      // Check for ID case first, since the All pattern would also match
      matcher = regExIdPattern.matcher(pathInfo);
      if (matcher.find()) {
        id = Integer.parseInt(matcher.group(1));
        return;
      }
 
      matcher = regExAllPattern.matcher(pathInfo);
      if (matcher.find()) return;
 
      throw new ServletException("Invalid URI");
    }
 
    public Integer getId() {
      return id;
    }
 
    @SuppressWarnings("unused")
	public void setId(Integer id) {
      this.id = id;
    }
  }
 
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    PrintWriter out = response.getWriter();
    response.setContentType("application/json");
    //out.println("GET request handling");
    //out.println(request.getPathInfo());
    //out.println(request.getParameterMap());
    try {
      RestRequest resourceValues = new RestRequest(request.getPathInfo());
      //out.println(resourceValues.getId());
     out.println(getJSONFromResultSet("one-demo-crm-contact",resourceValues.getId()));
    } catch (ServletException e) {
      response.setStatus(400);
      response.resetBuffer();
      e.printStackTrace();
      out.println(e.toString());
    } catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    out.close();
  }
 
  // implement remaining HTTP actions here

@SuppressWarnings("unchecked")
public String getJSONFromResultSet(String keyName, int ck) throws Exception {
	JSONObject object = new JSONObject();
    
    //System.out.println(org.json.simple.JSONValue.toJSONString(object));
	
    @SuppressWarnings("rawtypes")
	List list = new ArrayList();
    @SuppressWarnings("rawtypes")
	List list2 = new ArrayList();
    @SuppressWarnings("rawtypes")
	List list3 = new ArrayList();
    @SuppressWarnings("rawtypes")
	List list4 = new ArrayList();
    @SuppressWarnings("rawtypes")
	List list5 = new ArrayList();
    Map<String,Object> columnMap1 = new LinkedHashMap<String, Object>();
    Map<String,Object> columnMap2 = new LinkedHashMap<String, Object>();
    Map<String,Object> columnMap3 = new LinkedHashMap<String, Object>();
    Map<String,Object> columnMap4 = new LinkedHashMap<String, Object>();
    Map<String,Object> columnMap5 = new LinkedHashMap<String, Object>();
    
    String sqlString = "SELECT id, title, fname, mnames, lname, dob, tel, mob, email, addr1, addr2, town, city, state, country, pcode, o_id FROM contacts WHERE id = " + ck;
	mySQLDBUtil dbUtil = new mySQLDBUtil();
	ResultSet rs = dbUtil.getResultSet(sqlString);
	int o_id = 0;
    if(rs!=null)
    {
        try {
            
            
            while(rs.next())
            {
            	
            	columnMap1.put("customer_key", rs.getString("id"));
            	columnMap1.put("first_name", rs.getString("fname"));
            	columnMap1.put("last_name", rs.getString("lname"));
            	columnMap1.put("salutation", rs.getString("title"));
            	columnMap1.put("middle_names", rs.getString("mnames"));
            	columnMap1.put("address1", rs.getString("addr1"));
            	columnMap1.put("address2", rs.getString("addr2"));
            	columnMap1.put("date-of-birth", rs.getString("dob"));
            	columnMap1.put("town", rs.getString("town"));
            	columnMap1.put("city", rs.getString("city"));
            	columnMap1.put("state", rs.getString("state"));
            	columnMap1.put("country", rs.getString("country"));
            	columnMap1.put("post_code", rs.getString("pcode"));
            	columnMap1.put("mobile", rs.getString("mob"));
            	columnMap1.put("telephone", rs.getString("tel"));
            	columnMap1.put("email", rs.getString("email"));
            	o_id = rs.getInt("o_id");
                /*
            	for(int columnIndex=1;columnIndex<=metaData.getColumnCount();columnIndex++)
                {
                    if(rs.getString(metaData.getColumnName(columnIndex))!=null)
                        columnMap.put(metaData.getColumnLabel(columnIndex),     rs.getString(metaData.getColumnName(columnIndex)));
                    else
                        columnMap.put(metaData.getColumnLabel(columnIndex), "");
                }
                */
            }
            //list.add(columnMap);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //json.put("contact-data", list);
       
     }
    sqlString = "SELECT name, value, type, list_type FROM ep_data_view_contacts WHERE co_id = " + ck;
    rs = dbUtil.getResultSet(sqlString);
    
    if(rs!=null)
    {
        try {
            
            
            while(rs.next())
            {
                
            	if (rs.getString("type").equals("STRING")) {
            		columnMap2.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getString("value"));
            	}
            	else if (rs.getString("type").equals("INT")) {
            		columnMap2.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getInt("value"));	
				}
            	else if (rs.getString("type").equals("FLOAT")) {
            		columnMap2.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getFloat("value"));	
				}
            	else if (rs.getString("type").equals("BOOLEAN")) {
            		columnMap2.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getBoolean("value"));
				}
            	else if (rs.getString("type").equals("DATE")) {
            		columnMap2.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getString("value"));
				}
            	else if (rs.getString("type").equals("LIST")) {
            		if (rs.getString("list_type").equals("INT")) {
            			columnMap2.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getInt("value"));
            		}
            		else if (rs.getString("list_type").equals("FLOAT")) {
                		columnMap2.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getFloat("value"));	
    				}
                	else if (rs.getString("list_type").equals("BOOLEAN")) {
                		columnMap2.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getBoolean("value"));
    				}
                	else if (rs.getString("list_type").equals("STRING")) {
                		columnMap2.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getString("value"));
                	}
            		
				}
                //columnMap.put(rs.getString("name").replaceAll(" ", "_").toLowerCase(), rs.getString("attr_value"));
                /*
                for(int columnIndex=1;columnIndex<=metaData.getColumnCount();columnIndex++)
                {
                    if(rs.getString(metaData.getColumnName(columnIndex))!=null)
                        columnMap.put(metaData.getColumnLabel(columnIndex),     rs.getString(metaData.getColumnName(columnIndex)));
                    else
                        columnMap.put(metaData.getColumnLabel(columnIndex), "");
                }
                */
                
            }
            //list2.add(columnMap);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        //json2.put("extended-attrs", list2);
        
     }
    
    
        
        
      
    
    
    Map<String,Object> finalColumnMap = new LinkedHashMap<String, Object>();
    Map<String,Object> OEHColumnMap = new LinkedHashMap<String, Object>();
    finalColumnMap.put("contact_data", columnMap1);
    finalColumnMap.put("extended_attributes", columnMap2);
    OEHColumnMap.put("customer_data", finalColumnMap);
    dbUtil.db_close();
     return org.json.simple.JSONValue.toJSONString(OEHColumnMap);
     
}


}