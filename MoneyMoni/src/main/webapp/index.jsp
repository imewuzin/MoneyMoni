<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.entity.Product, model.ProductDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>💰 Welcome to MoneyMoni!</h1>
    <p>상품 목록 보기: <a href="products">/products</a></p>
    
    <h1>💰 전체 예금 상품 목록</h1>

    <%
        List<Product> products = null;
        try {
            products = ProductDAO.findAll();
        } catch (Exception e) {
            out.println("❌ 상품을 불러오는 중 오류 발생: " + e.getMessage());
        }
    %>

    <table border="1">
        <tr>
            <th>상품코드</th>
            <th>상품유형</th>
            <th>공시월</th>
            <th>금융사코드</th>
            <th>금융사명</th>
            <th>상품명</th>
            <th>가입방법</th>
            <th>만기후이자</th>
            <th>우대조건</th>
            <th>가입제한</th>
            <th>가입대상</th>
        </tr>

        <%
            if (products != null) {
                for (Product p : products) {
        %>
        <tr>
            <td><%= p.getFinPrdtCd() %></td>
            <td><%= p.getPrdtType() %></td>
            <td><%= p.getDclsMonth() %></td>
            <td><%= p.getFinCoNo() %></td>
            <td><%= p.getKorCoNm() %></td>
            <td><%= p.getFinPrdtNm() %></td>
            <td><%= p.getJoinWay() %></td>
            <td><%= p.getMtrtInt() %></td>
            <td><%= p.getSpclCnd() %></td>
            <td><%= p.getJoinDeny() %></td>
            <td><%= p.getJoinMember() %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr><td colspan="11">불러올 상품이 없습니다.</td></tr>
        <%
            }
        %>
    </table>
</body>
</html>