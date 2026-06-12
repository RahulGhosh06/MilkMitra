package com.milkmitra.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.milkmitra.dao.FarmerDaoImpl;
import com.milkmitra.dao.IFarmerDao;
import com.milkmitra.model.Farmer;

/**
 * Servlet implementation class FarmerLookUpServlet
 */
@WebServlet("/FarmerLookUpServlet")
public class FarmerLookUpServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest request,
	        HttpServletResponse response)
	        throws ServletException, IOException {

	    String farmerCode =
	            request.getParameter("farmerCode");

	    IFarmerDao farmerDao = null;

	    try {

	        farmerDao = new FarmerDaoImpl();

	        System.out.println("Farmer Code = " + farmerCode);

	        Farmer farmer = farmerDao.getFarmerDetails(farmerCode);

	        System.out.println("Farmer = " + farmer);
	        response.setContentType("text/plain");

	        if(farmer != null)
	        {
	            response.getWriter()
	                    .write(farmer.getFarmerName());
	        }
	        else
	        {
	            response.getWriter().write("");
	        }
	    }
	    catch(Exception e)
	    {
	        e.printStackTrace();
	    }
	    finally
	    {
	        if(farmerDao != null)
	        {
	            try
	            {
	                ((FarmerDaoImpl)farmerDao).cleanUp();
	            }
	            catch(Exception e){}
	        }
	    }
	}

}
