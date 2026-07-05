package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.milkmitra.model.User;
import com.milkmitra.utils.DBConnection;

public class UserDaoImpl implements IUserDao {

	private static final String AUTH_QUERY =
			"SELECT u.user_id, u.username, u.password, " +
			"u.role_id, u.email, u.farmer_code, " +
			"r.role_name " +
			"FROM users u " +
			"INNER JOIN roles r ON u.role_id = r.role_id " +
			"WHERE BINARY u.username = ? " +
			"AND BINARY u.password = ?";

	private static final String INSERT_QUERY =
			"insert into users values(default,?,?,?,?,?)";

	public UserDaoImpl() {
		// No connection or PreparedStatement held here anymore.
		// Each method below borrows a connection from the pool for
		// just the duration of that one call, then returns it.
	}

	@Override
	public User authenticate(String username, String password) throws SQLException {
		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst1 = cn.prepareStatement(AUTH_QUERY)) {

			pst1.setString(1, username);
			pst1.setString(2, password);

			try (ResultSet rs = pst1.executeQuery()) {
				if (rs.next()) {
					User user = new User();
					user.setUserId(rs.getInt("user_id"));
					user.setUsername(rs.getString("username"));
					user.setRoleId(rs.getInt("role_id"));
					user.setRoleName(rs.getString("role_name"));
					user.setEmail(rs.getString("email"));
					user.setFarmerCode(rs.getString("farmer_code"));
					return user;
				}
			}
		}
		return null;
	}

	@Override
	public void createFarmerLogin(String mobile, String farmerCode, String email) throws SQLException {
		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst2 = cn.prepareStatement(INSERT_QUERY)) {

			pst2.setString(1, mobile);
			pst2.setString(2, farmerCode);
			pst2.setInt(3, 2);
			pst2.setString(4, email);
			pst2.setString(5, farmerCode);
			pst2.executeUpdate();
		}
	}

	public void cleanUp() {
		// No-op now: try-with-resources above closes each connection
		// immediately after use, so there's nothing left to clean up here.
		// Kept only so existing servlet calls to dao.cleanUp() don't break.
	}

}