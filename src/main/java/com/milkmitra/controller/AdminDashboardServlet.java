package com.milkmitra.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.milkmitra.dao.AdminDashboardDaoImpl;
import com.milkmitra.dao.IAdminDashboardDao;
import com.milkmitra.model.Dashboard;

/**
 * Servlet implementation class AdminDashboardServlet
 */
@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet
{
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException
    {
        HttpSession session = request.getSession();

        IAdminDashboardDao dao = null;

        try
        {
            dao = new AdminDashboardDaoImpl();

            Dashboard dashboard =
                    dao.getDashboardData();

            request.setAttribute(
                    "dashboard",
                    dashboard);

            request.getRequestDispatcher(
                    "AdminDashboard.jsp")
                    .forward(request, response);

            return;
        }
        catch(Exception e)
        {
            e.printStackTrace();

            session.setAttribute(
                    "errorMsg",
                    "System Error : "
                    + e.getMessage());

            response.sendRedirect(
                    "Login.jsp");

            return;
        }
        finally
        {
            if(dao != null)
            {
                try
                {
                    ((AdminDashboardDaoImpl)dao)
                            .cleanUp();
                }
                catch(SQLException e)
                {
                    e.printStackTrace();
                }
            }
        }
    }
}
