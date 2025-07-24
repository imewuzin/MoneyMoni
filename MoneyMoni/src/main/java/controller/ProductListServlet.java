package controller;

import model.ProductDAO;
import model.entity.Product;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;

@WebServlet("/products")
public class ProductListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            List<Product> products = ProductDAO.findAll();

            if (products == null) {
                req.setAttribute("error", "상품 목록을 불러오는 데 실패했습니다.");
            } else {
                req.setAttribute("products", products);
            }

            req.getRequestDispatcher("/view/products.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "예기치 않은 오류가 발생했습니다: " + e.getMessage());
            req.getRequestDispatcher("/view/error.jsp").forward(req, resp);
        }
    }
}