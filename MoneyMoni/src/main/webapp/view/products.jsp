<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.entity.Product" %>
<html>
<head>
    <title>예금 상품 목록</title>
</head>
<body>
    <h1>💰 전체 예금 상품 목록</h1>
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
            List<Product> products = (List<Product>) request.getAttribute("products");
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
        <% } %>
    </table>
</body>
</html>
