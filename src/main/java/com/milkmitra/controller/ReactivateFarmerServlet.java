package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.dao.FarmerDaoImpl;
import com.milkmitra.dao.IFarmerDao;

/**
 * Servlet implementation class ReactivateFarmerServlet
 */
@WebServlet("/ReactivateFarmerServlet")
public class ReactivateFarmerServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        System.out.println("ReactivateFarmerServlet Called");
        response.setContentType("text/html");
        HttpSession session  = request.getSession();
        String farmerCode    = request.getParameter("farmerCode");

        IFarmerDao dao = null;

        try {
            dao = new FarmerDaoImpl();

            int status = dao.reactivateFarmer(farmerCode);  // ✅ int

            if(status == 1) {
                session.setAttribute("successMsg",           // ✅ fixed typo
                    "Farmer " + farmerCode + " reactivated successfully.");
            } else {
                session.setAttribute("errorMsg",
                    "Unable to reactivate " + farmerCode +
                    ". Farmer may already be active.");
            }

            response.sendRedirect(
            	    "FarmerListServlet?view=farmerList"
            	);

        } catch(Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", e.getMessage());
            response.sendRedirect("FarmerListServlet?view=farmerList");

        }
	 finally
	 {
            if(dao != null)
	    {
                 ((FarmerDaoImpl) dao).cleanUp(); 
            }
        }
    }
}