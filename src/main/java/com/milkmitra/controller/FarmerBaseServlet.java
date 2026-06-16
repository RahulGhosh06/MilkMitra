package com.milkmitra.controller;

import java.sql.SQLException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import com.milkmitra.dao.IFarmerDashboardDao;
import com.milkmitra.dao.FarmerDashboardDaoImpl;

public abstract class FarmerBaseServlet extends HttpServlet
{
    protected void loadFarmerProfile(HttpServletRequest request, String farmerCode) throws Exception
    {
        IFarmerDashboardDao dao = null;
        try
        {
            dao = new FarmerDashboardDaoImpl();
            request.setAttribute("farmerProfile", dao.getFarmerProfile(farmerCode));
        }
        catch(Exception e)
        {
        	
        }
//        finally
//        {
//            if (dao != null)
//                ((FarmerDashboardDaoImpl) dao).cleanUp();
//        }
    }
}