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
 * Servlet implementation class DeactivateFarmerServlet
 */
@WebServlet("/DeactivateFarmerServlet")
public class DeactivateFarmerServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        System.out.println("DeactivateFarmerServlet Called");
        response.setContentType("text/html");
        HttpSession session  = request.getSession();
        String farmerCode    = request.getParameter("farmerCode");

        IFarmerDao dao = null;

        try {
            dao = new FarmerDaoImpl();

            int status = dao.deactivateFarmer(farmerCode);  // ✅ int

            if(status == 1) {
                session.setAttribute("successMsg",           // ✅ fixed typo
                    "Farmer " + farmerCode + " deactivated successfully.");
            } else {
                session.setAttribute("errorMsg",
                    "Unable to deactivate " + farmerCode +
                    ". Farmer may already be inactive.");
            }

            response.sendRedirect(
            	    "FarmerListServlet?view=farmerList"
            	);

        } catch(Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMsg", e.getMessage());
            response.sendRedirect("FarmerListServlet?view=farmerList");

        } finally {
            if(dao != null) {
                try { ((FarmerDaoImpl) dao).cleanUp(); }
                catch(SQLException e) { e.printStackTrace(); }
            }
        }
    }

}
