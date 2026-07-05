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
import com.milkmitra.dao.FarmerDaoImpl;
import com.milkmitra.dao.IAdminDashboardDao;
import com.milkmitra.dao.IFarmerDao;
import com.milkmitra.model.Dashboard;
import com.milkmitra.model.Farmer;

/**
 * Servlet implementation class viewFarmerServlet
 */
@WebServlet("/ViewFarmerServlet")
public class ViewFarmerServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("ViewFarmerServlet Called");
        HttpSession session = request.getSession();
        String farmerCode = request.getParameter("farmerCode");
        
        IFarmerDao dao = null;
        IAdminDashboardDao dashDao = null;
        
        try {
            dao = new FarmerDaoImpl();
            Farmer farmer = dao.getFarmerDetails(farmerCode);
            
            if(farmer == null) {
                session.setAttribute("errorMsg", "Farmer not found!");
                response.sendRedirect("AdminDashboardServlet?view=farmerList");
                return;
            }
            
            // Load dashboard data too (needed by AdminDashboard.jsp)
            dashDao = new AdminDashboardDaoImpl();
            Dashboard dashboard = dashDao.getDashboardData();
            
            // Set all attributes
            request.setAttribute("farmer", farmer);
            request.setAttribute("dashboard", dashboard);
            request.setAttribute("currentView", "viewFarmer");
            
            // Forward to AdminDashboard.jsp (not ViewFarmer.jsp)
            request.getRequestDispatcher("AdminDashboard.jsp")
                   .forward(request, response);
            
        } catch(Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", e.getMessage());
            response.sendRedirect("AdminDashboardServlet?view=farmerList");
            
        } finally {
            if(dao != null) {
                 ((FarmerDaoImpl) dao).cleanUp();   
            }
            if(dashDao != null) {
                 ((AdminDashboardDaoImpl) dashDao).cleanUp(); 
            }
        }
    }
}


