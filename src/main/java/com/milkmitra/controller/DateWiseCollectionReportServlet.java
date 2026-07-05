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

import com.milkmitra.dao.IMilkCollectionReportDao;
import com.milkmitra.dao.MilkCollectionReportDaoImpl;
import com.milkmitra.model.Report;

/**
 * Servlet implementation class PaymentReportServlet
 */
@WebServlet("/DateWiseCollectionReportServlet")
public class DateWiseCollectionReportServlet extends HttpServlet { 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		System.out.println("DateWise Collection Report Servlet Called");
    	response.setContentType("text/html");
    	HttpSession session   = request.getSession();
    	
    	String fromDate = request.getParameter("fromDate");
    	String toDate = request.getParameter("toDate");
    	
    	IMilkCollectionReportDao dao = null;
    	try
    	{
    		dao = new MilkCollectionReportDaoImpl();
    		
    		List<Report> reports =
    		        dao.getDateWiseCollectionReport(
    		                LocalDate.parse(fromDate),
    		                LocalDate.parse(toDate));
    		System.out.println("From Date : " + fromDate);
    		System.out.println("To Date   : " + toDate);
    		System.out.println("Records   : " + reports.size());

    		request.setAttribute(
    		        "reports",
    		        reports);

    		request.setAttribute(
    		        "fromDate",
    		        fromDate);

    		request.setAttribute(
    		        "toDate",
    		        toDate);
    		
    		request.setAttribute(
    		        "currentView",
    		        "datewise");

    		request.getRequestDispatcher(
    		        "milkcollectionReport.jsp")
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

    	    response.sendRedirect("milkcollectionReport.jsp");
    	    return;
    	}
    	finally
    	{
    	    if(dao != null)
    	    {
    	            ((MilkCollectionReportDaoImpl)dao).cleanUp();    
       	    }
    	}
	
   }

}
