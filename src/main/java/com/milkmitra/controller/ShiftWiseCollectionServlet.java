package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.milkmitra.dao.ImilkcollectionReportDao;
import com.milkmitra.dao.milkcollectionReportDaoImpl;
import com.milkmitra.model.Collection;

@WebServlet("/ShiftWiseCollectionServlet")
public class ShiftWiseCollectionServlet extends HttpServlet
{
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException
    {
        HttpSession session = request.getSession();

        String shift = request.getParameter("shift");

        ImilkcollectionReportDao dao = null;

        try
        {
            // First time page opens
            if(shift == null || shift.trim().isEmpty())
            {
                request.getRequestDispatcher(
                        "milkcollectionReport.jsp")
                       .forward(request, response);
                return;
            }

            dao = new milkcollectionReportDaoImpl();

            List<Collection> collections =
                    dao.getCollectionsByShift(shift);

            request.setAttribute(
                    "collections",
                    collections);

            request.setAttribute(
                    "selectedShift",
                    shift);

            request.getRequestDispatcher(
                    "milkcollectionReport.jsp")
                   .forward(request, response);
        }
        catch(Exception e)
        {
            e.printStackTrace();

            session.setAttribute(
                    "errorMsg",
                    "System Error : " + e.getMessage());

            response.sendRedirect(
                    "milkcollectionReportServlet");
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