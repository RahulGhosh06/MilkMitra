package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.dao.IPaymentDao;
import com.milkmitra.dao.PaymentDaoImpl;
import com.milkmitra.model.PaymentSummary;

@WebServlet("/FarmerPaymentHistoryServlet")
public class FarmerPaymentHistoryServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		IPaymentDao paymentDao = null;

		try {
			String farmerCode = (String) session.getAttribute("farmerCode");

			paymentDao = new PaymentDaoImpl();

			// ✅ Check if user clicked "View Details" on a specific cycle
			String cycleStartStr = request.getParameter("cycleStart");
			String cycleEndStr = request.getParameter("cycleEnd");

			if (cycleStartStr != null && cycleEndStr != null) {
				// ── CYCLE DETAIL VIEW ──
				LocalDate cycleStart = LocalDate.parse(cycleStartStr);
				LocalDate cycleEnd = LocalDate.parse(cycleEndStr);

				List<PaymentSummary> cycleEntries = paymentDao.getCycleEntries(farmerCode, cycleStart, cycleEnd);

				request.setAttribute("cycleEntries", cycleEntries);
				request.setAttribute("cycleStart", cycleStart);
				request.setAttribute("cycleEnd", cycleEnd);
				request.setAttribute("currentView", "cycleDetail");

				// Still need cycleSummary for dashboard stat tiles (won't crash)
				PaymentSummary cycleSummary = paymentDao.getCurrentCycleSummary(farmerCode);
				request.setAttribute("cycleSummary", cycleSummary);

			} else {
				// ── PAYMENT HISTORY LIST VIEW (original logic) ──
				List<PaymentSummary> paymentList = paymentDao.getPaymentHistory(farmerCode);
				request.setAttribute("paymentList", paymentList);
				request.setAttribute("currentView", "paymentHistory");

				PaymentSummary cycleSummary = paymentDao.getCurrentCycleSummary(farmerCode);
				request.setAttribute("cycleSummary", cycleSummary);
			}

			request.getRequestDispatcher("FarmerDashboard.jsp").forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			session.setAttribute("errorMsg", "System Error : " + e.getMessage());
			response.sendRedirect("Login.jsp");
		} finally {
			if (paymentDao != null) {
				try {
					((PaymentDaoImpl) paymentDao).cleanUp();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}

}