package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.dao.AdminDashboardDaoImpl;
import com.milkmitra.dao.IAdminDashboardDao;
import com.milkmitra.dao.IPaymentDao;
import com.milkmitra.dao.PaymentDaoImpl;
import com.milkmitra.model.Dashboard;
import com.milkmitra.model.PaymentSummary;

/**
 * Servlet implementation class AdminDashboardServlet
 */
@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();

		IAdminDashboardDao dao = null;

		IPaymentDao paymentDao = null;

		String view = request.getParameter("view");
		if (view == null)
			view = "dashboard";
		if ("farmerList".equals(view)) {
			response.sendRedirect("FarmerListServlet?view=farmerList");
			return;
		}
		request.setAttribute("currentView", view);

		try {
			dao = new AdminDashboardDaoImpl();

			paymentDao = new PaymentDaoImpl();

			Dashboard dashboard = dao.getDashboardData();

			PaymentSummary cycleSummary = paymentDao.getCurrentCycleSummary();
			
			System.out.println(
			        "Cycle Start : "
			        + cycleSummary.getCycleStart());

			System.out.println(
			        "Cycle End : "
			        + cycleSummary.getCycleEnd());

			System.out.println(
			        "Total Farmers : "
			        + cycleSummary.getTotalFarmers());

			System.out.println(
			        "Total Milk : "
			        + cycleSummary.getTotalMilk());

			System.out.println(
			        "Total Amount : "
			        + cycleSummary.getTotalAmount());

			request.setAttribute("dashboard", dashboard);

			request.setAttribute("cycleSummary", cycleSummary);

			request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);

			return;
		} catch (Exception e) {
			e.printStackTrace();

			session.setAttribute("errorMsg", "System Error : " + e.getMessage());

			response.sendRedirect("Login.jsp");

			return;
		} finally {
			if (dao != null) {
				try {
					((AdminDashboardDaoImpl) dao).cleanUp();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			
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
