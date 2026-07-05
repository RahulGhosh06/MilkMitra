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

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ── Session guard ──────────────────────────────────────────────────
        String username = (String) session.getAttribute("username");
        String role     = (String) session.getAttribute("role");
        if (username == null || !"ADMIN".equals(role)) {
            response.sendRedirect("Login.jsp");
            return;
        }

        // ── Resolve view ───────────────────────────────────────────────────
        String view = request.getParameter("view");
        if (view == null || view.isEmpty()) view = "dashboard";

        // farmerList is handled by its own servlet — redirect immediately,
        // no DB work needed here.
        if ("farmerList".equals(view)) {
            response.sendRedirect("FarmerListServlet?view=farmerList");
            return;
        }

        request.setAttribute("currentView", view);

        // ── Route by view ──────────────────────────────────────────────────
        switch (view) {

            // ── DASHBOARD — needs both dashboard stats and cycle summary ───
            case "dashboard": {
                IAdminDashboardDao dao = null;
                IPaymentDao paymentDao = null;
                try {
                    dao        = new AdminDashboardDaoImpl();
                    paymentDao = new PaymentDaoImpl();

                    Dashboard      dashboard    = dao.getDashboardData();
                    PaymentSummary cycleSummary = paymentDao.getCurrentCycleSummary();

                    System.out.println("Cycle Start   : " + cycleSummary.getCycleStart());
                    System.out.println("Cycle End     : " + cycleSummary.getCycleEnd());
                    System.out.println("Total Farmers : " + cycleSummary.getTotalFarmers());
                    System.out.println("Total Milk    : " + cycleSummary.getTotalMilk());
                    System.out.println("Total Amount  : " + cycleSummary.getTotalAmount());

                    request.setAttribute("dashboard",    dashboard);
                    request.setAttribute("cycleSummary", cycleSummary);

                    request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);

                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("errorMsg", "System Error : " + e.getMessage());
                    response.sendRedirect("Login.jsp");
                } finally {
                    cleanUpDao(dao);
                    cleanUpPaymentDao(paymentDao);
                }
                break;
            }

            // ── ADD FARMER — static form, no DB needed ─────────────────────
            case "addFarmer": {
                try {
                    request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("errorMsg", "System Error : " + e.getMessage());
                    response.sendRedirect("Login.jsp");
                }
                break;
            }

            // ── PAYMENTS — needs cycle summary only ────────────────────────
            case "payments": {
                IPaymentDao paymentDao = null;
                try {
                    paymentDao = new PaymentDaoImpl();

                    PaymentSummary cycleSummary = paymentDao.getCurrentCycleSummary();
                    request.setAttribute("cycleSummary", cycleSummary);

                    request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);

                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("errorMsg", "System Error : " + e.getMessage());
                    response.sendRedirect("Login.jsp");
                } finally {
                    cleanUpPaymentDao(paymentDao);
                }
                break;
            }

            // ── STATIC VIEWS — no DB queries needed ───────────────────────
            // feedStore, reports, priceConfig all just render the JSP
            case "feedStore":
            case "reports":
            case "priceConfig": {
                try {
                    request.getRequestDispatcher("AdminDashboard.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("errorMsg", "System Error : " + e.getMessage());
                    response.sendRedirect("Login.jsp");
                }
                break;
            }

            // ── UNKNOWN VIEW — fall back to dashboard ──────────────────────
            default: {
                response.sendRedirect("AdminDashboardServlet?view=dashboard");
                break;
            }
        }
    }

    // ── Cleanup helpers ────────────────────────────────────────────────────
    private void cleanUpDao(IAdminDashboardDao dao) {
        if (dao != null) {
                ((AdminDashboardDaoImpl) dao).cleanUp();
        }
    }

    private void cleanUpPaymentDao(IPaymentDao dao) {
        if (dao != null) {
                ((PaymentDaoImpl) dao).cleanUp();
        }
    }
}
