package controller;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/toggleFavorite")
public class ToggleFavoriteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String prdtCd = request.getParameter("finPrdtCd");
        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        Set<String> favorites = (Set<String>) session.getAttribute("favorites");
        if (favorites == null) {
            favorites = new HashSet<>();
            session.setAttribute("favorites", favorites);
        }

        if (favorites.contains(prdtCd)) {
            favorites.remove(prdtCd);
        } else {
            favorites.add(prdtCd);
        }

        session.setAttribute("favorites", favorites);
        response.setStatus(200);
    }
}