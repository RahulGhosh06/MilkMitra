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

import com.milkmitra.dao.FarmerDaoImpl;
import com.milkmitra.dao.IFarmerDao;
import com.milkmitra.model.Farmer;

/**
 * Servlet implementation class FarmerListServlet
 */
@WebServlet("/FarmerListServlet")
public class FarmerListServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("FarmerListServlet Servlet Called");
    	response.setContentType("text/html");
    	
    	HttpSession session   = request.getSession();
        String successMsg     = (String) session.getAttribute("successMsg");
        String errorMsg       = (String) session.getAttribute("errorMsg");
        session.removeAttribute("successMsg");
        session.removeAttribute("errorMsg");
        if(successMsg != null) request.setAttribute("successMsg", successMsg);
        if(errorMsg   != null) request.setAttribute("errorMsg",   errorMsg);
    	
    	IFarmerDao dao = null;
    	
    	try
    	{
    		
    		dao = new FarmerDaoImpl();
    		
    		List<Farmer> farmers = dao.getAllFarmers();
    		
    		int activeCount = 0;
    		int inactiveCount = 0;
    		int joinedThisMonth = 0;

    		LocalDate today = LocalDate.now();

    		for(Farmer farmer : farmers)
    		{
    			if(farmer.isActive())
    			{
    			    activeCount++;
    			}
    			else
    			{
    			    inactiveCount++;
    			}

    		    LocalDate joiningDate = farmer.getJoiningDate();

    		    if(joiningDate != null
    		            && joiningDate.getMonth() == today.getMonth()
    		            && joiningDate.getYear() == today.getYear())
    		    {
    		        joinedThisMonth++;
    		    }
    		}

    		request.setAttribute("farmers", farmers);
    		request.setAttribute("activeCount", activeCount);
    		request.setAttribute("inactiveCount", inactiveCount);
    		request.setAttribute("joinedThisMonth", joinedThisMonth);

    		request.getRequestDispatcher("FarmerList.jsp")
    		       .forward(request, response);
    		
    	}
    	
    	catch(Exception e)
	    {
	        e.printStackTrace();
	        request.setAttribute("errorMsg", e.getMessage());

	        request.getRequestDispatcher("FarmerList.jsp").forward(request, response);
	        return;
	    }
        
	    finally // ← ALWAYS runs, success or failure
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
