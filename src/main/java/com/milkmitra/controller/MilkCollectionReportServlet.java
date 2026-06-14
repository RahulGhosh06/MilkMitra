package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.dao.IMilkCollectionReportDao;
import com.milkmitra.dao.MilkCollectionReportDaoImpl;
import com.milkmitra.model.Collection;

/**
 * Servlet implementation class MilkColelctionReportServlet
 */
// This Servlet Is for Today's Collection Report
@WebServlet("/MilkCollectionReportServlet")
public class MilkCollectionReportServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Milk Collection Report Servlet Called");
    	response.setContentType("text/html");
    	HttpSession session   = request.getSession();
    	

    	
    	IMilkCollectionReportDao dao = null;
    	
    	try
    	{
    		dao = new MilkCollectionReportDaoImpl();
    		
    		List<Collection> collections =
    		        dao.getTodayCollections();

    		request.setAttribute(
    		        "collections",
    		        collections);

    		request.getRequestDispatcher(
    		        "MilkCollectionReport.jsp")
    		       .forward(request,response);
    		
    		return;
    		
    	}
    	catch(Exception e)
    	{
    	    e.printStackTrace();

    	    session.setAttribute(
    	        "errorMsg",
    	        "System Error : " + e.getMessage()
    	    );

    	    response.sendRedirect("MilkCollectionReport.jsp");
    	    return;
    	}
    	finally
    	{
    	    if(dao != null)
    	    {
    	        try
    	        {
    	            ((MilkCollectionReportDaoImpl)dao).cleanUp();
    	        }
    	        catch(SQLException e)
    	        {
    	            e.printStackTrace();
    	        }
    	    }
    	}
	}

}
