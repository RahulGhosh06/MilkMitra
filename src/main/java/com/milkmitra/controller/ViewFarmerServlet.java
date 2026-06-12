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
import com.milkmitra.model.Farmer;

/**
 * Servlet implementation class viewFarmerServlet
 */
@WebServlet("/ViewFarmerServlet")
public class ViewFarmerServlet extends HttpServlet {
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ViewFarmerServlet Servlet Called");
    	response.setContentType("text/html");
    	HttpSession session = request.getSession();
    	String farmerCode = request.getParameter("farmerCode");
    	
    	IFarmerDao dao = null;
    	
    	try
    	{
    		
    		dao = new FarmerDaoImpl();
    		
    		Farmer farmer = dao.getFarmerDetails(farmerCode);
    		
    		if(farmer == null)
    		{
    		    session.setAttribute("errorMsg", "Farmer not found!");
    		    response.sendRedirect("FarmerListServlet");
    		    return;
    		}
    		
    		System.out.println("Farmer Code = " + farmer.getFarmerCode());
    		System.out.println("Forwarding to JSP...");
    		
    		 request.setAttribute("farmer", farmer);

             request.getRequestDispatcher("/ViewFarmer.jsp").forward(request, response);
    		
    		
    	}
    	 catch(Exception e)
	    {
    		 
    		 
	        e.printStackTrace();
	        
	        System.out.println("ERROR TYPE: " + e.getClass().getName());
	        System.out.println("ERROR MSG:  " + e.getMessage());
	        session.setAttribute("errorMsg", e.getMessage());
	        response.sendRedirect("FarmerListServlet");
	        
	        
	        session.setAttribute("errorMsg", e.getMessage());

	        response.sendRedirect("FarmerListServlet");
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
