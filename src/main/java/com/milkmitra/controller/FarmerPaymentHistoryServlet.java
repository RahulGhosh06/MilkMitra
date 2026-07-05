package com.milkmitra.controller;
 
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
 
import com.milkmitra.dao.IPaymentDao;
import com.milkmitra.dao.PaymentDaoImpl;
import com.milkmitra.model.PaymentSummary;
 
@WebServlet("/FarmerPaymentHistoryServlet")
public class FarmerPaymentHistoryServlet extends FarmerBaseServlet {
 
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        // ── Session guard ──────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("username") : null;
        String role     = (session != null) ? (String) session.getAttribute("role")     : null;
 
        if (username == null || !"FARMER".equals(role)) {
            response.sendRedirect("Login.jsp");
            return;
        }
 
        String farmerCode = (String) session.getAttribute("farmerCode");
 
        // ── Check for cycleStart / cycleEnd params to decide subview ───────
        String cycleStartStr = request.getParameter("cycleStart");
        String cycleEndStr   = request.getParameter("cycleEnd");
 
        IPaymentDao paymentDao = null;
 
        try {
            paymentDao = new PaymentDaoImpl();
 
            // Always load the farmer profile — needed by topbar / drawer
            loadFarmerProfile(request, farmerCode);
 
            if (cycleStartStr != null && cycleEndStr != null) {
 
                
                LocalDate cycleStart = LocalDate.parse(cycleStartStr);
                LocalDate cycleEnd   = LocalDate.parse(cycleEndStr);
 
                List<PaymentSummary> cycleEntries =
                        paymentDao.getCycleEntries(farmerCode, cycleStart, cycleEnd);
 
               
                PaymentSummary cycleSummary =
                        paymentDao.getCurrentCycleSummary(farmerCode);
 
                request.setAttribute("cycleEntries",  cycleEntries);
                request.setAttribute("cycleStart",    cycleStart);
                request.setAttribute("cycleEnd",      cycleEnd);
                request.setAttribute("cycleSummary",  cycleSummary);
                request.setAttribute("currentView",   "cycleDetail");
 
                System.out.println("CycleDetail | farmer=" + farmerCode
                        + " | start=" + cycleStart + " | end=" + cycleEnd
                        + " | entries=" + (cycleEntries != null ? cycleEntries.size() : 0));
 
            } else {
 
                // ── PAYMENT HISTORY LIST VIEW ──────────────────────────────
                List<PaymentSummary> paymentList =
                        paymentDao.getPaymentHistory(farmerCode);
 
                PaymentSummary cycleSummary =
                        paymentDao.getCurrentCycleSummary(farmerCode);
 
                request.setAttribute("paymentList",  paymentList);
                request.setAttribute("cycleSummary", cycleSummary);
                request.setAttribute("currentView",  "paymentHistory");
 
                System.out.println("PaymentHistory | farmer=" + farmerCode
                        + " | cycles=" + (paymentList != null ? paymentList.size() : 0));
            }
 
            request.getRequestDispatcher("FarmerDashboard.jsp").forward(request, response);
 
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", "System Error : " + e.getMessage());
            response.sendRedirect("Login.jsp");
 
        } finally {
            if (paymentDao != null) {
                    ((PaymentDaoImpl) paymentDao).cleanUp();
            }
        }
    }
}