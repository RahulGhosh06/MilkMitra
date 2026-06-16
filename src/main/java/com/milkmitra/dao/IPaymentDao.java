package com.milkmitra.dao;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import com.milkmitra.model.PaymentSummary;

public interface IPaymentDao {
	// 1. Feature for Farmer Latest Payment
	PaymentSummary getCurrentCycleSummary() throws SQLException;

	// 2. Feature for Admin To see Latest Payment
	PaymentSummary getCurrentCycleSummary(String farmerCode) throws SQLException;

	// 3. Feature for Payment Cycle History
	List<PaymentSummary> getPaymentHistory(String farmerCode) throws SQLException;
	
	//4. Feature for smart cards in payment cycle
	List<PaymentSummary> getCycleEntries(String farmerCode, LocalDate cycleStart, LocalDate cycleEnd) throws SQLException;

}
