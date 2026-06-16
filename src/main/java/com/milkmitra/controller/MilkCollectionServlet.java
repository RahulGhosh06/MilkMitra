package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.dao.FarmerDaoImpl;
import com.milkmitra.dao.IFarmerDao;
import com.milkmitra.dao.IMilkCollectionDao;
import com.milkmitra.dao.MilkCollectionDaoImpl;
import com.milkmitra.model.Collection;
import com.milkmitra.model.Farmer;

/**
 * Servlet implementation class milkcollectionServlet
 */
@WebServlet("/milkcollectionServlet")
public class MilkCollectionServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("milkcollectionServlet Called");
    	response.setContentType("text/html");
    	HttpSession session = request.getSession();
    	
    	//| farmerCode | collectionDate | shift | milkType
		//quantity | fat | snf | amount | ratePerLtr
		//isActive 
    	
    	String farmerInput = request.getParameter("farmerCode");
    	if(Integer.parseInt(farmerInput) <= 0 || Integer.parseInt(farmerInput) > 999)
    	{
    	    session.setAttribute(
    	        "errorMsg",
    	        "Invalid Farmer Code."
    	    );

    	    response.sendRedirect(
    	        "milkcollection.jsp"
    	    );
    	    return;
    	}
    	
    	String farmerCode = "F" + String.format("%03d", Integer.parseInt(farmerInput));
    	double quantity = Double.parseDouble(request.getParameter("quantity"));
    	double fat = Double.parseDouble(request.getParameter("fat"));
    	double snf = Double.parseDouble(request.getParameter("snf"));
    	double amount = Double.parseDouble(request.getParameter("amount"));
    	
    	if(quantity <= 0)
    	{
    	    session.setAttribute(
    	        "errorMsg",
    	        "Quantity must be greater than zero."
    	    );

    	    response.sendRedirect("milkcollection.jsp");
    	    return;
    	}
    	
    	LocalDate collectionDate = LocalDate.now(java.time.ZoneId.of("Asia/Kolkata")); // ✅
    	double ratePerLtr = amount / quantity;
    	String milkType;
    	if(fat >= 6.0)
    	{
    	    // Buffalo category

    	    if(snf < 8.3)
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            "Buffalo milk requires minimum SNF 8.3"
    	        );

    	        response.sendRedirect("milkcollection.jsp");
    	        return;
    	    }
    	    else
    	    {
    	    	milkType = "B";
    	    }
    	}
    	else
    	{
    	    // Cow category

    	    if(fat < 3.0 || snf < 8.0)
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            "Cow milk requires minimum Fat 3.0 and SNF 8.0"
    	        );

    	        response.sendRedirect("milkcollection.jsp");
    	        return;
    	    }
    	    else
    	    {
    	    	milkType = "C";    	    }
    	}
    	String shift;

    	if(LocalTime.now(java.time.ZoneId.of("Asia/Kolkata")).getHour() < 12) 
    	{
    	    shift = "MORNING";
    	}
    	else
    	{
    	    shift = "EVENING";
    	}
    	
    	IMilkCollectionDao dao = null;
    	IFarmerDao farmerDao = null;
    	try {
    		dao = new MilkCollectionDaoImpl();
    		
    		farmerDao = new FarmerDaoImpl();

    		Farmer farmer = farmerDao.getFarmerDetails(farmerCode);

    		if(farmer == null)
    		{
    		    session.setAttribute(
    		        "errorMsg",
    		        "Farmer Code does not exist."
    		    );

    		    response.sendRedirect("milkcollection.jsp");
    		    return;
    		}

    		if(!farmer.isActive())
    		{
    		    session.setAttribute(
    		        "errorMsg",
    		        "This farmer is inactive and cannot give milk."
    		    );

    		    response.sendRedirect("milkcollection.jsp");
    		    return;
    		}
    		
    		Collection collection = new Collection();

    		collection.setFarmerCode(farmerCode);
    		collection.setCollectionDate(collectionDate);
    		collection.setShift(shift);
    		collection.setMilkType(milkType);
    		collection.setQuantity(quantity);
    		collection.setFat(fat);
    		collection.setSnf(snf);
    		collection.setAmount(amount);
    		collection.setRatePerLtr(ratePerLtr);
    		collection.setActive(true);
    		
    		String status = dao.addCollection(collection);
    		
    		if(status != null)
    		{
    		    session.setAttribute(
    		        "successMsg",
    		        status
    		    );

    		    response.sendRedirect("milkcollection.jsp");
    		    return;
    		}
    		else
    		{
    		    session.setAttribute(
    		        "errorMsg",
    		        "Unable to save collection."
    		    );

    		    response.sendRedirect("milkcollection.jsp");
    		    return;
    		}
    	}
    	catch(SQLException e)
    	{
    	    e.printStackTrace();

    	    String error = e.getMessage();

    	    if(error.contains("Duplicate"))
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            "Milk collection already exists for this farmer, shift and milk type."
    	        );
    	    }
    	    else if(error.contains("foreign key"))
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            "Farmer code does not exist."
    	        );
    	    }
    	    else
    	    {
    	        session.setAttribute(
    	            "errorMsg",
    	            "Database Error : " + error
    	        );
    	    }

    	    response.sendRedirect("milkcollection.jsp");
    	    return;
    	}
    	catch(Exception e)
    	{
    	    e.printStackTrace();

    	    session.setAttribute(
    	        "errorMsg",
    	        "System Error : " + e.getMessage()
    	    );

    	    response.sendRedirect("milkcollection.jsp");
    	    return;
    	}
    	finally
    	{
    	    if(dao != null)
    	    {
    	        try
    	        {
    	            ((MilkCollectionDaoImpl)dao).cleanUp();
    	        }
    	        catch(SQLException e)
    	        {
    	            e.printStackTrace();
    	        }
    	    }
    	    if(farmerDao != null)
    	    {
    	        try
    	        {
    	            ((FarmerDaoImpl)farmerDao).cleanUp();
    	        }
    	        catch(SQLException e)
    	        {
    	            e.printStackTrace();
    	        }
    	    }
    	}
    	
    	
	}
	
	

}
