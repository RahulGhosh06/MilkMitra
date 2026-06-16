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

/**
 * Servlet implementation class FarmerCycleDetailServlet
 */
@WebServlet("/FarmerCycleDetailServlet")
public class FarmerCycleDetailServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		IPaymentDao dao = null;
		try {
			String farmerCode = (String) session.getAttribute("farmerCode");
			String startStr = request.getParameter("cycleStart");
			String endStr = request.getParameter("cycleEnd");

			LocalDate cycleStart = LocalDate.parse(startStr);
			LocalDate cycleEnd = LocalDate.parse(endStr);

			dao = new PaymentDaoImpl();

			List<PaymentSummary> entries = dao.getCycleEntries(farmerCode, cycleStart, cycleEnd);

			request.setAttribute("cycleEntries", entries);
			request.setAttribute("cycleStart", cycleStart);
			request.setAttribute("cycleEnd", cycleEnd);
			request.setAttribute("currentView", "cycleDetail");

			request.getRequestDispatcher("FarmerDashboard.jsp").forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect("FarmerPaymentHistoryServlet");
		} finally {
			if (dao != null) {
				try {
					((PaymentDaoImpl) dao).cleanUp();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
}