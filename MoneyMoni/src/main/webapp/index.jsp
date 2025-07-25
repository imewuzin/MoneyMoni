<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.HashSet, model.entity.Product, model.ProductDAO" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>MoneyMoni 예금 상품</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #fdfaf6;
      font-family: 'Noto Sans KR', sans-serif;
    }
    h1 {
      text-align: center;
      margin: 40px 0 20px;
      color: #a47764;
      font-weight: bold;
    }
    select {
      display: block;
      margin: 0 auto 30px;
      padding: 10px;
      border-radius: 10px;
      border: 1px solid #ccc;
      font-size: 1rem;
    }
    .card {
      border: none;
      border-radius: 16px;
      background-color: #fffaf4;
      box-shadow: 0 4px 8px rgba(0,0,0,0.05);
      transition: transform 0.2s;
    }
    .card:hover {
      transform: translateY(-5px);
    }
    .card-title {
      font-weight: bold;
      color: #745f50;
    }
    .card-text {
      font-size: 0.9rem;
      color: #555;
      white-space: pre-line;
    }
    .container {
      max-width: 1200px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>💰 MoneyMoni 예금 상품 목록</h1>

    <%
      List<Product> products = null;
      try {
          products = ProductDAO.findAll();
      } catch (Exception e) {
    %>
      <div class="alert alert-danger">
        ❌ 상품을 불러오는 중 오류 발생: <%= e.getMessage() %>
      </div>
    <%
      }
    %>

    <!-- 은행 필터 드롭다운 -->
    <select id="bankFilter">
      <option value="all">전체 보기</option>
      <%
        HashSet<String> banks = new HashSet<>();
        if (products != null) {
          for (Product p : products) {
              banks.add(p.getKorCoNm());
          }
          for (String bank : banks) {
      %>
        <option value="<%= bank %>"><%= bank %></option>
      <%
          }
        }
      %>
    </select>

    <!-- 카드 리스트 -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="productList">
      <%
        if (products != null && !products.isEmpty()) {
            for (Product p : products) {
      %>
        <div class="col product-card" data-bank="<%= p.getKorCoNm() %>">
          <div class="card h-100 p-3">
            <div class="card-body">
              <h5 class="card-title"><%= p.getFinPrdtNm() %></h5>
              <h6 class="card-subtitle mb-2 text-muted"><%= p.getKorCoNm() %></h6>
              <p class="card-text">
                🧾 <strong>가입 방법:</strong> <%= p.getJoinWay() %><br>
                🕓 <strong>공시월:</strong> <%= p.getDclsMonth() %><br>
                💡 <strong>만기 후 이자:</strong> <%= p.getMtrtInt() %><br>
                🎯 <strong>우대 조건:</strong> <%= p.getSpclCnd() %><br>
                🙅 <strong>가입 제한:</strong> <%= p.getJoinDeny() %><br>
                👥 <strong>가입 대상:</strong> <%= p.getJoinMember() %>
              </p>
            </div>
          </div>
        </div>
      <%
            }
        } else {
      %>
        <p class="text-center">불러올 상품이 없습니다.</p>
      <%
        }
      %>
    </div>
  </div>

  <!-- 필터링 스크립트 -->
  <script>
    const filter = document.getElementById("bankFilter");
    const cards = document.querySelectorAll(".product-card");

    filter.addEventListener("change", () => {
      const selected = filter.value;
      cards.forEach(card => {
        const bank = card.getAttribute("data-bank");
        card.style.display = (selected === "all" || bank === selected) ? "block" : "none";
      });
    });
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
