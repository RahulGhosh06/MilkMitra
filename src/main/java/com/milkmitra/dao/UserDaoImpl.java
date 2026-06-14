package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.milkmitra.model.User;
import static com.milkmitra.utils.DBConnection.openConnection;

public class UserDaoImpl implements IUserDao {
	
	 private Connection cn;

	    private PreparedStatement pst1, pst2;
	    
	    private static final String AUTH_QUERY =
	    	    "SELECT u.user_id, u.username, u.password, " +
	    	    "u.role_id, u.email, u.farmer_code, " +
	    	    "r.role_name " +
	    	    "FROM users u " +
	    	    "INNER JOIN roles r ON u.role_id = r.role_id " +
	    	    "WHERE BINARY u.username = ? " +
	    	    "AND BINARY u.password = ?";
	    public UserDaoImpl() throws ClassNotFoundException, Exception
	    {
	        cn = openConnection();

	        pst1 = cn.prepareStatement(AUTH_QUERY);
	        
	        String sql ="insert into users values(default,?,?,?,?,?)";
	        pst2 = cn.prepareStatement(sql);
	        
	        System.out.println("User DAO Created...");       
	    }

	@Override
	public User authenticate(String username, String password) throws SQLException {
		pst1.setString(1, username);
    	pst1.setString(2, password);
    	
    	ResultSet rs = pst1.executeQuery();

    	if(rs.next())
    	{
    	    User user = new User();

    	    user.setUserId(rs.getInt("user_id"));
    	    user.setUsername(rs.getString("username"));
    	    user.setRoleId(rs.getInt("role_id"));
    	    user.setRoleName(rs.getString("role_name"));
    	    user.setEmail(rs.getString("email"));
    	    user.setFarmerCode(rs.getString("farmer_code"));

    	    return user;
    	}
        return null;
	}
	
	@Override
	public void createFarmerLogin(String mobile, String farmerCode, String email) throws SQLException
	{
		pst2.setString(1, mobile);
		pst2.setString(2, farmerCode);
		pst2.setInt(3, 2);      
		pst2.setString(4, email);
		pst2.setString(5, farmerCode);
	    pst2.executeUpdate();
	}


	public void cleanUp() throws SQLException {

		if(pst1 != null)
			pst1.close();
		if(pst2 != null)
			pst2.close();
		if(cn != null)
			cn.close();
	
		System.out.println("User dao cleaned up!!!!");
		
	}

}
