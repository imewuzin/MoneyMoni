<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Set, java.util.HashSet, java.util.List, model.entity.Product, model.ProductDAO" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>MoneyMoni 예금/적금 상품</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
  <style>
    body {
      background-color: #fdfaf6;
      font-family: 'Noto Sans KR', sans-serif;
    }
    h1 {
      text-align: center;
      margin: 40px 0 10px;
      color: #a47764;
      font-weight: bold;
    }
    .favorite-link {
      position: absolute;
      top: 20px;
      right: 0;
      padding-right: 15px;
    }
    .favorite-link a {
      border: none;
      background: none;
      color: #745f50;
      font-weight: bold;
      font-size: 1rem;
      text-decoration: none;
      padding: 6px 0px 6px 12px;
    }
    .favorite-link a:hover {
      text-decoration: underline;
    }
    .favorite-icon {
      position: absolute;
      top: 10px;
      right: 10px;
      font-size: 1.5rem;
      color: #ccc;
      z-index: 10;
    }
    .favorite-icon.active {
      color: #ffd700;
    }
    .filter-group {
      text-align: center;
      margin-bottom: 20px;
    }
    .filter-group button {
      margin: 0 8px;
      background: none;
      border: none;
      font-weight: bold;
      font-size: 1.1rem;
      color: #745f50;
      cursor: pointer;
      border-radius: 12px;
      padding: 8px 20px;
      transition: background-color 0.3s, color 0.3s;
    }
    .filter-group button.active, .filter-group button:hover {
      background-color: #a47764;
      color: white;
      outline: none;
    }
    select.form-select {
      background-color: transparent;
      color: #745f50;
      border: 1px solid #745f50;
    }
    .card {
      border: none;
      border-radius: 16px;
      background-color: #fffaf4;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
      transition: transform 0.2s;
      cursor: pointer;
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
      padding-right: 15px;
      padding-left: 15px;
      position: relative;
    }
  </style>
</head>
<body>
  <div class="container">
    <p class="favorite-link"><a href="view/favorite.jsp">⭐ 내 상품 보기</a></p>
    <div style="text-align: center;" class="mb-4">
      <img src="images/logo.png" alt="MoneyMoni 로고" style="height: 78px; margin-top: 30px;">
    </div>

    <% 
    	//? el & jstl로 변환 필수 
    	//MVC 깨졌다??? 쩝
       List<Product> products = null;
       Set<String> favorites = (Set<String>) session.getAttribute("favorites");
       
       if (favorites == null) {
         favorites = new HashSet<>();
         session.setAttribute("favorites", favorites);
       }
       try {
         products = ProductDAO.findAll();
       } catch (Exception e) { %>
       <div class="alert alert-danger">
         ❌ 상품을 불러오는 중 오류 발생: <%= e.getMessage() %>
       </div>
    <% } %>

    <div class="d-flex align-items-center justify-content-between mb-4 gap-3">
      <div class="filter-group" id="typeFilterGroup">
        <button type="button" class="btn btn-outline-primary active" data-type="all">전체</button>
        <button type="button" class="btn btn-outline-primary" data-type="D">예금</button>
        <button type="button" class="btn btn-outline-primary" data-type="S">적금</button>
      </div>
      <div>
        <select id="bankFilter" class="form-select">
          <option value="all">전체 보기</option>
          <% List<String> banks = ProductDAO.findAllBankNames();
             if (products != null) {
               for (Product p : products) {
                 banks.add(p.getKorCoNm());
               }
               for (String bank : banks) {
          %>
          <option value="<%= bank %>"><%= bank %></option>
          <% } } %>
        </select>
      </div>
    </div>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="productList">
      <% if (products != null && !products.isEmpty()) {
           for (Product p : products) {
             boolean isFavorite = favorites.contains(p.getFinPrdtCd()); %>
        <div class="col product-card" data-bank="<%= p.getKorCoNm() %>" data-type="<%= p.getPrdtType() %>">
          <div class="card h-100 p-3 position-relative"
               onclick="toggleFavorite(this, '<%= p.getFinPrdtCd() %>')">
            <span class="favorite-icon <%= isFavorite ? "active" : "" %>">★</span>
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
      <% } } else { %>
        <p class="text-center">불러올 상품이 없습니다.</p>
      <% } %>
    </div>
  </div>

  <script>
    const typeButtons = document.querySelectorAll('#typeFilterGroup button');
    const bankFilter = document.getElementById('bankFilter');
    const cards = document.querySelectorAll('.product-card');

    let selectedType = 'all';
    let selectedBank = 'all';

    typeButtons.forEach(btn => {
      btn.addEventListener('click', () => {
        typeButtons.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        selectedType = btn.getAttribute('data-type');
        filterCards();
      });
    });

    bankFilter.addEventListener('change', () => {
      selectedBank = bankFilter.value;
      filterCards();
    });

    function filterCards() {
      cards.forEach(card => {
        const bank = card.getAttribute('data-bank');
        const type = card.getAttribute('data-type');
        const matchBank = (selectedBank === 'all' || bank === selectedBank);
        const matchType = (selectedType === 'all' || type === selectedType);
        card.style.display = (matchBank && matchType) ? 'block' : 'none';
      });
    }

    function toggleFavorite(card, finPrdtCd) {
      fetch('toggleFavorite', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'finPrdtCd=' + encodeURIComponent(finPrdtCd)
      })
      .then(response => {
        if (response.ok) {
          card.querySelector('.favorite-icon').classList.toggle('active');
        } else {
          alert('즐겨찾기 변경 실패');
        }
      });
    }
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>