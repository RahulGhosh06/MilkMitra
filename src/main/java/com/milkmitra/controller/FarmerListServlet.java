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

import com.milkmitra.dao.AdminDashboardDaoImpl;
import com.milkmitra.dao.FarmerDaoImpl;
import com.milkmitra.dao.IAdminDashboardDao;
import com.milkmitra.dao.IFarmerDao;
import com.milkmitra.model.Dashboard;
import com.milkmitra.model.Farmer;

/**
 * Servlet implementation class FarmerListServlet
 */
@WebServlet("/FarmerListServlet")
public class FarmerListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        IFarmerDao farmerDao = null;
        IAdminDashboardDao dashDao = null;
        
        try {
            farmerDao = new FarmerDaoImpl();
            dashDao = new AdminDashboardDaoImpl();
            
            List<Farmer> farmers = farmerDao.getAllFarmers();
            Dashboard dashboard = dashDao.getDashboardData();
            
            // Count stats
            int activeCount = 0, inactiveCount = 0, joinedThisMonth = 0;
            java.time.LocalDate now = java.time.LocalDate.now();
            for(Farmer f : farmers) {
                if(f.isActive()) activeCount++;
                else inactiveCount++;
                if(f.getJoiningDate() != null &&
                   f.getJoiningDate().getMonth() == now.getMonth() &&
                   f.getJoiningDate().getYear() == now.getYear()) {
                    joinedThisMonth++;
                }
            }
            
            request.setAttribute("farmers", farmers);
            request.setAttribute("dashboard", dashboard);
            request.setAttribute("activeCount", activeCount);
            request.setAttribute("inactiveCount", inactiveCount);
            request.setAttribute("joinedThisMonth", joinedThisMonth);
            request.setAttribute("currentView", "farmerList");
            
            request.getRequestDispatcher("AdminDashboard.jsp")
                   .forward(request, response);
            
        } catch(Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", e.getMessage());
            response.sendRedirect("AdminDashboardServlet?view=dashboard");
            
        } finally {
            if(farmerDao != null) {
                try { ((FarmerDaoImpl) farmerDao).cleanUp(); }
                catch(SQLException e) { e.printStackTrace(); }
            }
            if(dashDao != null) {
                try { ((AdminDashboardDaoImpl) dashDao).cleanUp(); }
                catch(SQLException e) { e.printStackTrace(); }
            }
        }
    }
}