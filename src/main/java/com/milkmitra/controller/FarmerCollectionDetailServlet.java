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

import com.milkmitra.dao.ImilkcollectionReportDao;
import com.milkmitra.dao.milkcollectionReportDaoImpl;
import com.milkmitra.model.Collection;

/**
 * Servlet implementation class FarmerCollectionDetailServlet
 */
@WebServlet("/FarmerCollectionDetailServlet")
public class FarmerCollectionDetailServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		System.out.println("Farmer Collection Details Servlet Called");
    	response.setContentType("text/html");
    	HttpSession session   = request.getSession();
    	
    	String farmerCode = request.getParameter("farmerCode");
    	String fromDate = request.getParameter("fromDate");
    	String toDate = request.getParameter("toDate");
    	
    	ImilkcollectionReportDao dao = null;
    	try
    	{
    		dao = new milkcollectionReportDaoImpl();
    		
    		List<Collection> collections =
                    dao.getFarmerCollections(
                            farmerCode,
                            LocalDate.parse(fromDate),
                            LocalDate.parse(toDate));
    		

    		request.setAttribute("entries", collections);

            request.setAttribute(
                    "farmerCode",
                    farmerCode);

            request.setAttribute(
                    "fromDate",
                    fromDate);

            request.setAttribute(
                    "toDate",
                    toDate);

            request.getRequestDispatcher(
                    "FarmerCollectionDetails.jsp")
                    .forward(request, response);

            return;
    	}
    	catch(Exception e)
    	{
    	    e.printStackTrace();

    	    session.setAttribute(
    	        "errorMsg",
    	        "System Error : " + e.getMessage()
    	    );

    	    response.sendRedirect("DateWiseCollectionReport.jsp");
    	    return;
    	}
    	finally
    	{
    	    if(dao != null)
    	    {
    	        try
    	        {
    	            ((milkcollectionReportDaoImpl)dao).cleanUp();
    	        }
    	        catch(SQLException e)
    	        {
    	            e.printStackTrace();
    	        }
    	    }
    	}
	}

}
