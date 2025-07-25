package controller;

import model.ProductDAO;
import model.entity.Product;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/products/filter")
public class ProductFilterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String type = req.getParameter("type"); // "예금" or "적금"

        // 예금: D, 적금: S
        String prdtType = null;
        if ("예금".equals(type)) {
            prdtType = "D";
        } else if ("적금".equals(type)) {
            prdtType = "S";
        }

        List<Product> products = ProductDAO.findAll();

        List<Product> filtered = (prdtType == null)
                ? products
                : products.stream()
                    .filter(p -> prdtType.equals(p.getPrdtType()))
                    .collect(Collectors.toList());

        // JSON 문자열 수동 생성
        StringBuilder json = new StringBuilder();
        json.append("[");

        for (int i = 0; i < filtered.size(); i++) {
            Product p = filtered.get(i);

            json.append("{")
                .append("\"id\":").append(p.getId()).append(",")
                .append("\"name\":\"").append(escape(p.getName())).append("\",")
                .append("\"prdtType\":\"").append(p.getPrdtType()).append("\"")
                .append("}");

            if (i < filtered.size() - 1) {
                json.append(",");
            }
        }

        json.append("]");

        resp.setContentType("application/json; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(json.toString());
    }

    // 따옴표, 줄바꿈 등 이스케이프
    private String escape(String str) {
        if (str == null) return "";
        return str.replace("\"", "\\\"")
                  .replace("\n", "")
                  .replace("\r", "");
    }
}
