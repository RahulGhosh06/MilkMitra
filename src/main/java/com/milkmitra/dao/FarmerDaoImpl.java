package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.milkmitra.model.Farmer;
import com.milkmitra.utils.DBConnection;

public class FarmerDaoImpl implements IFarmerDao {

	private static final String INSERT_FARMER_SQL =
			"insert into farmers values(default,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
	private static final String UPDATE_FARMER_CODE_SQL =
			"update farmers set farmer_code=? where farmer_id=?";
	private static final String DEACTIVATE_SQL =
			"update farmers set is_active = 0 where farmer_code = ? and is_active = 1";
	private static final String GET_ALL_SQL =
			"select farmer_code, farmer_name, mobile, joining_date, is_active from farmers";
	private static final String GET_DETAILS_SQL =
			"select * from farmers where farmer_code = ?";
	private static final String EDIT_SQL =
			"update farmers set farmer_name=?, mobile=?,email=?,address=?,account_holder_name=?,bank_account_no=?,ifsc_code=?,bank_name=?,  andhar_number=? where farmer_code = ?";
	private static final String REACTIVATE_SQL =
			"update farmers set is_active = 1 where farmer_code = ? and is_active = 0";

	public FarmerDaoImpl() {
		// Nothing held here now — each method below borrows its own
		// connection from the pool for just the duration of that call.
	}

	@Override
	public String addFarmer(Farmer farmer) throws SQLException {
		// Insert + code update are related, so they share ONE connection
		// borrowed for this single method call.
		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst1 = cn.prepareStatement(INSERT_FARMER_SQL, Statement.RETURN_GENERATED_KEYS)) {

			pst1.setString(1, farmer.getMppCode());
			pst1.setNull(2, java.sql.Types.VARCHAR);
			pst1.setString(3, farmer.getFarmerName());
			pst1.setString(4, farmer.getMobile());
			pst1.setString(5, farmer.getEmail());
			pst1.setString(6, farmer.getAddress());
			pst1.setString(7, farmer.getAccountHolderName());
			pst1.setString(8, farmer.getAccountNo());
			pst1.setString(9, farmer.getIfscCode());
			pst1.setString(10, farmer.getBankName());
			pst1.setString(11, farmer.getAndharNo());
			pst1.setDate(12, Date.valueOf(farmer.getJoiningDate()));
			pst1.setBoolean(13, farmer.isActive());

			int updateCount = pst1.executeUpdate();

			if (updateCount == 1) {
				try (ResultSet rs = pst1.getGeneratedKeys()) {
					if (rs.next()) {
						int farmerId = rs.getInt(1);
						System.out.println("Generated Farmer Id = " + farmerId);

						String farmerCode = String.format("F%03d", farmerId);
						farmer.setFarmerCode(farmerCode);

						try (PreparedStatement pst2 = cn.prepareStatement(UPDATE_FARMER_CODE_SQL)) {
							pst2.setString(1, farmerCode);
							pst2.setInt(2, farmerId);

							int count = pst2.executeUpdate();
							if (count == 1) {
								return farmerCode;
							}
						}
					}
				}
			}
		}
		return null;
	}

	@Override
	public int deactivateFarmer(String farmerCode) throws SQLException {
		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst3 = cn.prepareStatement(DEACTIVATE_SQL)) {

			pst3.setString(1, farmerCode);
			int updateCount = pst3.executeUpdate();
			return updateCount == 1 ? 1 : 0;
		}
	}

	@Override
	public List<Farmer> getAllFarmers() throws SQLException {
		List<Farmer> farmers = new ArrayList<>();

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst4 = cn.prepareStatement(GET_ALL_SQL);
			 ResultSet rst = pst4.executeQuery()) {

			while (rst.next()) {
				farmers.add(new Farmer(rst.getString(1), rst.getString(2), rst.getString(3),
						rst.getDate(4).toLocalDate(), rst.getBoolean(5)));
			}
		}

		return farmers;
	}

	@Override
	public Farmer getFarmerDetails(String farmerCode) throws SQLException {
		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst5 = cn.prepareStatement(GET_DETAILS_SQL)) {

			pst5.setString(1, farmerCode);

			try (ResultSet rs = pst5.executeQuery()) {
				if (rs.next()) {
					Farmer farmer = new Farmer();
					farmer.setFarmerId(rs.getInt("farmer_id"));
					farmer.setMppCode(rs.getString("mpp_code"));
					farmer.setFarmerCode(rs.getString("farmer_code"));
					farmer.setFarmerName(rs.getString("farmer_name"));
					farmer.setMobile(rs.getString("mobile"));
					farmer.setEmail(rs.getString("email"));
					farmer.setAddress(rs.getString("address"));
					farmer.setAccountHolderName(rs.getString("account_holder_name"));
					farmer.setAccountNo(rs.getString("bank_account_no"));
					farmer.setIfscCode(rs.getString("ifsc_code"));
					farmer.setBankName(rs.getString("bank_name"));
					farmer.setAndharNo(rs.getString("andhar_number"));
					farmer.setJoiningDate(rs.getDate("joining_date").toLocalDate());
					farmer.setActive(rs.getBoolean("is_active"));
					return farmer;
				}
			}
		}
		return null;
	}

	@Override
	public int editFarmerDetails(Farmer farmer) throws SQLException {
		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst6 = cn.prepareStatement(EDIT_SQL)) {

			pst6.setString(1, farmer.getFarmerName());
			pst6.setString(2, farmer.getMobile());
			pst6.setString(3, farmer.getEmail());
			pst6.setString(4, farmer.getAddress());
			pst6.setString(5, farmer.getAccountHolderName());
			pst6.setString(6, farmer.getAccountNo());
			pst6.setString(7, farmer.getIfscCode());
			pst6.setString(8, farmer.getBankName());
			pst6.setString(9, farmer.getAndharNo());
			pst6.setString(10, farmer.getFarmerCode());

			int updateCount = pst6.executeUpdate();

			if (updateCount == 1) {
				System.out.println("Farmer Details Updated Sucessfully..");
				return 1;
			}
			return 0;
		}
	}

	@Override
	public int reactivateFarmer(String farmerCode) throws SQLException {
		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst7 = cn.prepareStatement(REACTIVATE_SQL)) {

			pst7.setString(1, farmerCode);
			int updateCount = pst7.executeUpdate();

			if (updateCount == 1) {
				System.out.println("Farmer Reactivated Sucessfully");
				return 1;
			}
			return 0;
		}
	}

	public void cleanUp() {
		// No-op now: try-with-resources closes everything immediately
		// after each method call. Kept so existing servlet calls don't break.
	}

}