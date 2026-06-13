package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.milkmitra.dao.FarmerDaoImpl;
import com.milkmitra.dao.IFarmerDao;
import com.milkmitra.model.Farmer;

@WebServlet("/LoadEditFarmerServlet")
public class LoadEditFarmerServlet extends HttpServlet
{
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException
    {
        System.out.println("LoadEditFarmerServlet Called");

        String farmerCode = request.getParameter("farmerCode");

        IFarmerDao dao = null;

        try
        {
            dao = new FarmerDaoImpl();

            Farmer farmer = dao.getFarmerDetails(farmerCode);

            if(farmer != null)
            {
                request.setAttribute("farmer", farmer);

                request.setAttribute(
                    "currentView",
                    "editFarmer"
                );

                request.getRequestDispatcher(
                    "AdminDashboard.jsp"
                ).forward(request, response);
            }
            else
            {
                response.sendRedirect("FarmerListServlet");
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            response.sendRedirect("FarmerListServlet");
        }
        finally
        {
            if(dao != null)
            {
                try
                {
                    ((FarmerDaoImpl) dao).cleanUp();
                }
                catch(SQLException e)
                {
                    e.printStackTrace();
                }
            }
        }
    }
}