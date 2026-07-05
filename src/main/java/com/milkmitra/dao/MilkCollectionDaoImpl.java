package com.milkmitra.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.milkmitra.model.Collection;
import com.milkmitra.utils.DBConnection;

public class MilkCollectionDaoImpl implements IMilkCollectionDao {

	private static final String INSERT_SQL =
			"insert into milkcollection "
			+ "(farmerCode, farmer_id, collectionDate, shift, milkType, "
			+ "quantity, fat, snf, amount, ratePerLtr, isActive) "
			+ "values (?, (select farmer_id from farmers where farmer_code = ?), "
			+ "?, ?, ?, ?, ?, ?, ?, ?, ?)";

	public MilkCollectionDaoImpl() {
		// Nothing held here now — addCollection() below borrows its own
		// connection from the pool for just the duration of that call.
	}

	@Override
	public String addCollection(Collection collection) throws SQLException {

		try (Connection cn = DBConnection.getConnection();
			 PreparedStatement pst1 = cn.prepareStatement(INSERT_SQL)) {

			pst1.setString(1, collection.getFarmerCode());
			pst1.setString(2, collection.getFarmerCode()); // used by the subquery lookup
			pst1.setDate(3, Date.valueOf(collection.getCollectionDate()));
			pst1.setString(4, collection.getShift());
			pst1.setString(5, collection.getMilkType());
			pst1.setDouble(6, collection.getQuantity());
			pst1.setDouble(7, collection.getFat());
			pst1.setDouble(8, collection.getSnf());
			pst1.setDouble(9, collection.getAmount());
			pst1.setDouble(10, collection.getRatePerLtr());
			pst1.setBoolean(11, collection.isActive());

			int updateCount = pst1.executeUpdate();

			if (updateCount == 1) {
				return "Collection Saved Successfully";
			}
			return null;
		}
	}

	public void cleanUp() {
		// No-op now: try-with-resources closes the connection immediately
		// after addCollection() finishes. Kept so existing servlet calls
		// to dao.cleanUp() don't break.
	}

}