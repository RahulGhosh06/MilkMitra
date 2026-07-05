package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.dao.FarmerDashboardDaoImpl;
import com.milkmitra.dao.IFarmerDashboardDao;
import com.milkmitra.dao.IPaymentDao;
import com.milkmitra.dao.PaymentDaoImpl;
import com.milkmitra.model.Farmer;
import com.milkmitra.model.FarmerDashboard;
import com.milkmitra.model.PaymentSummary;

@WebServlet("/FarmerDashboardServlet")
public class FarmerDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        IFarmerDashboardDao dao = null;
        IPaymentDao paymentDao = null;
        

        String view = request.getParameter("view");

        if(view == null)
            view = "dashboard";

        request.setAttribute("currentView", view);

        try {

        	String farmerCode = (String)session.getAttribute("farmerCode");
            // Verify later if username actually stores F001
            
            System.out.println("Farmer Code = " + farmerCode);

            dao = new FarmerDashboardDaoImpl();
            paymentDao = new PaymentDaoImpl(); 

            FarmerDashboard dashboard = dao.getFarmerDashboardData(farmerCode);
            PaymentSummary cycleSummary =paymentDao.getCurrentCycleSummary(farmerCode);
            Farmer farmer = dao.getFarmerProfile(farmerCode);

            request.setAttribute(
                    "dashboard",
                    dashboard);
            request.setAttribute(
                    "cycleSummary",
                    cycleSummary);
            
            request.setAttribute("farmerProfile", farmer);

            System.out.println(
                    "Today Milk : "
                    + dashboard.getTodayMilk());

            System.out.println(
                    "Today Earning : "
                    + dashboard.getTodayEarning());
            
            System.out.println(
                    cycleSummary.getCycleStart());

            System.out.println(
                    cycleSummary.getCycleEnd());
            System.out.println(
                    "Cycle Milk : "
                    + cycleSummary.getTotalMilk());

            System.out.println(
                    "Cycle Amount : "
                    + cycleSummary.getTotalAmount());

            request.getRequestDispatcher(
                    "FarmerDashboard.jsp")
                    .forward(request, response);

            return;

        }
        catch(Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "errorMsg",
                    "System Error : "
                    + e.getMessage());

            response.sendRedirect(
                    "Login.jsp");

            return;
        }
        finally {

            if(dao != null) {
                    ((FarmerDashboardDaoImpl)dao).cleanUp();
            }

            if(paymentDao != null) {
                    ((PaymentDaoImpl)paymentDao)
                            .cleanUp();

            }
        }
    }
}