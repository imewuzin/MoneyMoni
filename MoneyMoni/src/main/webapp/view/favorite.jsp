<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.entity.Product, model.ProductDAO" %>
<%
Set<String> favorites = (Set<String>) session.getAttribute("favorites");
List<Product> products = (favorites != null && !favorites.isEmpty()) 
    ? ProductDAO.findByIds(favorites)
    : new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>⭐ 내 즐겨찾기 상품</title>
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
    .back-link {
      position: absolute;
      top: 20px;
      right: 0;
      padding-right: 15px;
    }
    .back-link a {
      border: none;
      background: none;
      color: #745f50;
      font-weight: bold;
      font-size: 1rem;
      text-decoration: none;
      padding: 6px 12px;
    }
    .back-link a:hover {
      text-decoration: underline;
    }
    .card {
      border: none;
      border-radius: 16px;
      background-color: #fffaf4;
      box-shadow: 0 4px 8px rgba(0,0,0,0.05);
      transition: transform 0.2s;
      position: relative;
    }
    .card:hover {
      transform: translateY(-5px);
    }
    .favorite-btn {
      position: absolute;
      top: 10px;
      right: 10px;
      background: none;
      border: none;
      font-size: 1.5rem;
      color: #ffd700;
      cursor: pointer;
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
      position: relative;
      padding-right: 15px;
      padding-left: 15px;
    }
  </style>
</head>
<body>
  <div class="container">
    <p class="back-link"><a href="../index.jsp">← 상품 목록으로 돌아가기</a></p>
    <div style="text-align: center;" class="mb-4">
      <img src="../images/logo.png" alt="MoneyMoni 로고" style="height: 78px; margin-top: 30px;">
    </div>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="favorites-container">
      <% for (Product p : products) { %>
        <div class="col product-card" id="card-<%= p.getFinPrdtCd() %>">
          <div class="card h-100 p-3" onclick="removeFavorite('<%= p.getFinPrdtCd() %>')">
            <button class="favorite-btn">★</button>
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
      <% } %>
    </div>
  </div>

  <script>
    function removeFavorite(finPrdtCd) {
      fetch('../toggleFavorite', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'finPrdtCd=' + encodeURIComponent(finPrdtCd)
      })
      .then(response => {
        if (response.ok) {
          const card = document.getElementById('card-' + finPrdtCd);
          if (card) card.remove();
        } else {
          alert('❌ 즐겨찾기 해제 중 오류 발생');
        }
      });
    }
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
