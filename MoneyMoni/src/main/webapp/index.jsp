<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.entity.Product, model.ProductDAO" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>MoneyMoni 예금 상품</title>
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

    .filter-group {
      text-align: center;
      margin-bottom: 20px;
    }
  
    .filter-group button {
  margin: 0 8px;
  background: none;      /* 배경 없애기 */
  border: none;          /* 테두리 없애기 */
  font-weight: bold;
  font-size: 1.1rem;
  color: #745f50;
  cursor: pointer;
  border-radius: 12px;
  padding: 8px 20px;
  transition: background-color 0.3s, color 0.3s;
}

.filter-group button.active,
.filter-group button:hover {
  background-color: #a47764;
  color: white;
  outline: none;
}

    select {
      display: block;
      margin: 0 auto 30px;
      padding: 10px 15px;
      border-radius: 10px;
      border: 1px solid #ccc;
      font-size: 1rem;
      width: 250px;
      background-color: #fff;
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

    <!-- 예금 / 적금 필터 버튼 그룹 -->
    <div class="filter-group" id="typeFilterGroup">
      <button type="button" class="btn btn-outline-primary active" data-type="all">전체</button>
      <button type="button" class="btn btn-outline-primary" data-type="D">예금</button>
      <button type="button" class="btn btn-outline-primary" data-type="S">적금</button>
    </div>

    <!-- 은행 필터 드롭다운 -->
    <select id="bankFilter">
      <option value="all">전체 보기</option>
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
        Set<String> banks = new TreeSet<>();
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

    <!-- 상품 리스트 -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="productList">
      <%
        if (products != null && !products.isEmpty()) {
          for (Product p : products) {
      %>
      <div class="col product-card" data-bank="<%= p.getKorCoNm() %>" data-type="<%= p.getPrdtType() %>">
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

  <!-- 필터 스크립트 -->
  <script>
    const typeButtons = document.querySelectorAll('#typeFilterGroup button');
    const bankFilter = document.getElementById('bankFilter');
    const cards = document.querySelectorAll('.product-card');

    let selectedType = 'all';
    let selectedBank = 'all';

    // 예금/적금 버튼 클릭 이벤트
    typeButtons.forEach(btn => {
      btn.addEventListener('click', () => {
        // 버튼 active 스타일 토글
        typeButtons.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        selectedType = btn.getAttribute('data-type');
        filterCards();
      });
    });

    // 은행 필터 변경 이벤트
    bankFilter.addEventListener('change', () => {
      selectedBank = bankFilter.value;
      filterCards();
    });

    // 필터링 함수
    function filterCards() {
      cards.forEach(card => {
        const bank = card.getAttribute('data-bank');
        const type = card.getAttribute('data-type');

        const matchBank = (selectedBank === 'all' || bank === selectedBank);
        const matchType = (selectedType === 'all' || type === selectedType);

        card.style.display = (matchBank && matchType) ? 'block' : 'none';
      });
    }
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
