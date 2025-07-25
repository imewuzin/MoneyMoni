# MoneyMoni
# 💰 예/적금 소개 서비스 - MoneyMoni

> 금융감독원 공개 데이터를 기반으로 한 예금·적금 상품 조회 웹 서비스입니다.
> 

```markdown
| 이제현  | 임유진     | 서민지              | 이조은                                                   |
|:---:|:--------------:|:------------------:|:--------------------------------:|
| <img src="https://github.com/lyjh98.png" width="80">      | <img src="https://github.com/imewuzin.png" width="80">    | <img src="https://github.com/menzzi.png" width="80">     | <img src="https://github.com/LeeJoEun-01.png" width="80"> |
| [@lyjh98](https://github.com/lyjh98)  |  [@imewuzin](https://github.com/imewuzin)       | [@2jeong2](https://github.com/menzzi)   | [@LeeJoEun-01](https://github.com/LeeJoEun-01) |
```

## 🗂️ 주요 기능

- ✅ **예/적금 목록 전체 조회**
- ✅ **은행별 필터링** (은행 선택 DropDown)
- ✅ **예금 / 적금 필터링**
- ✅ **즐겨찾기 등록 (세션 기반)**
- ✅ 💡 카드 형 UI + 부트스트랩 기반 정적 페이지 스타일링

---

## 🛠 개발 환경

| 항목 | 내용 |
| --- | --- |
| IDE | Eclipse IDE for Enterprise Java |
| JDK | Java SE 17 |
| WAS | Apache Tomcat 9.x |
| 빌드 도구 | Maven |
| DB | OracleDB |
| ORM | JPA (Hibernate) |
| View | JSP + Bootstrap |
| 기타 | Servlet, JSTL, Lambda, Stream API |

---

## 📁 프로젝트 구조

```jsx
📁 src/main
 ┣ 📂java
 ┃ ┣ 📂 util
 ┃ ┃ ┗ DBUtil.java                   ← JPA EntityManager 제공 유틸
 ┃ ┣ 📂 model
 ┃ ┃ ┗ ProductDAO.java               ← DB 저장 및 조회 로직
 ┃ ┣ 📂 controller
 ┃ ┃ ┗ ToogleFavoriteServlet.java      ← 즐겨찾기 여부 세션에 저장
 ┣ 📂 resources/META-INF
 ┃ ┃ ┗ persistence.xml
 ┣ 📂 webapp
 ┃   ┣ index.jsp                       ← 전체 상품 목록 및 필터링
 ┃   ┣ 📂 view
 ┃   ┃   ┗  favorite.jsp                ← 즐겨찾기 상품 조회
 ┃   ┗ 📂WEB-INF
 ┃       ┗ web.xml
📄 .gitignore
```

---

## 💰 금융상품 테이블 구조

| 컬럼명 | 자료형 | 설명 |
| --- | --- | --- |
| `finPrdtCd` | VARCHAR2(255) | 🔑 기본키, 금융상품코드 |
| `prdtType` | VARCHAR2(255) | 🏦 예금/적금 구분 (D: 예금 / S: 적금) |
| `dclsMonth` | VARCHAR2(255) | 📅 공시 제출월 |
| `finCoNo` | VARCHAR2(255) | 🏢 금융회사 코드 |
| `korCoNm` | VARCHAR2(255) | 🏛 금융회사명 |
| `finPrdtNm` | VARCHAR2(255) | 💳 금융상품명 |
| `joinWay` | VARCHAR2(255) | 📝 가입 방법 |
| `mtrtInt` | VARCHAR2(2000) | 📈 만기 후 이자율 설명 |
| `spclCnd` | VARCHAR2(2000) | ⭐ 우대 조건 |
| `joinDeny` | VARCHAR2(255) | 🚫 가입 제한 여부 |
| `joinMember` | VARCHAR2(255) | 👥 가입 대상 |

---

## 🔍 lambda & Stream

### 1. `findByBank` 의 스트림 & 람다

```java
result = all.stream()
            .filter(p -> p.getKorCoNm().equals(bankName))
            .collect(Collectors.toList());
```

- **설명**: `all` 리스트에서 `getKorCoNm()`이 `bankName`인 것만 골라서 새 리스트로 반환

### 동등한 전통 자바 코드 (for문)

```java
List<Product> result = new ArrayList<>();
for (Product p : all) {
    if (p.getKorCoNm().equals(bankName)) {
        result.add(p);
    }
```

### 2. `findAllBankNames` 의 스트림 & 람다

```java
result = all.stream()
            .map(Product::getKorCoNm)
            .distinct()
            .sorted()
            .collect(Collectors.toList());
```

- **설명**: `all` 리스트에서 은행명만 뽑아서 중복 제거 후 정렬해서 리스트로 반환

### 동등한 전통 자바 코드 (for문 + Set + 정렬)

```java
Set<String> bankSet = new HashSet<>();
for (Product p : all) {
    bankSet.add(p.getKorCoNm());
}

List<String> result = new ArrayList<>(bankSet);
Collections.sort(result);
```

## 비교 요약

| 기능 | 스트림 + 람다 코드 | 전통 자바 코드 (for문) |
| --- | --- | --- |
| 필터링 | `.filter(p -> p.getKorCoNm().equals(bankName))` | `for` + `if` 조건문으로 직접 필터링 |
| 값 변환 (map) | `.map(Product::getKorCoNm)` | `for`문에서 각 요소의 `getKorCoNm()` 호출 후 추가 |
| 중복 제거 | `.distinct()` | `HashSet`에 담아 중복 제거 |
| 정렬 | `.sorted()` | `Collections.sort()` 호출 |
| 결과 수집 | `.collect(Collectors.toList())` | 직접 `List`에 요소 추가 |

---

## 🔍 JPA 활용

### 1. EntityManagerFactory 생성 및 관리 (DBUtil)

```java
private static EntityManagerFactory emf;

static {
    emf = Persistence.createEntityManagerFactory("moneymoni");
```

- JPA의 핵심 객체인 `EntityManagerFactory`를 애플리케이션 실행 시 한 번 생성해 재사용
- `persistence.xml` 설정 파일 내에 정의된 `moneymoni`라는 영속성 유닛(Persistence Unit)을 기반으로 생성

### 2. EntityManager 생성 (DBUtil)

```java
public static EntityManager getEntityManager(){
    return emf.createEntityManager();
}
```

- 데이터베이스 작업 단위인 `EntityManager`를 생성하여 반환
- `EntityManager`는 JPA에서 CRUD 작업을 수행

### 3. 데이터베이스 작업 수행 (ProductDAO)

```java
EntityManager em = emf.createEntityManager();
```

- DAO 클래스에서 데이터베이스 작업을 위해 `EntityManager`를 획득

```java
List<Product> result = em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
```

- JPQL을 이용해 `Product` 엔티티 전체 목록을 조회
- `createQuery()` 메서드에 JPQL과 결과 타입을 지정하고, `getResultList()`로 결과 리스트를 받음

```java
Product product = em.find(Product.class, finPrdtCd);
```

- 기본키(`finPrdtCd`)를 기준으로 단일 엔티티를 조회할 때 `find()` 메서드를 사용

### 4. EntityManager 자원 해제 (ProductDAO)

```java
if (em != null && em.isOpen()) {
    em.close();
    em = null;
}
```

- 데이터 작업이 끝나면 `EntityManager`를 반드시 닫아 커넥션 등 자원을 반환

---

## 트러블 슈팅

### Git 브랜치 충돌 트러블슈팅: Eclipse(master) ↔ GitHub(main)

### 💥 문제 상황

- 이클립스에서 Git 프로젝트를 생성하면 기본 브랜치가 `master`인 경우가 있음.
- GitHub에 먼저 생성된 레포는 기본 브랜치가 `main`.
- Eclipse에서 `master`에서 작업 후 push하려고 하면 다음과 같은 문제 발생:

### ❗ 에러 메시지

```bash
error: src refspec main does not match any
error: failed to push some refs to 'https://github.com/USERNAME/REPO.git'
```

---

### ✅ 문제 원인

- 로컬 브랜치: `master`
- GitHub 원격 브랜치: `main`
- 브랜치 이름이 다르기 때문에 push가 제대로 안 되고 충돌 발생.

---

### ✅ 해결 방법 : 로컬 브랜치를 `main`으로 이름 변경하기

### 1. 브랜치 이름 `master` → `main` 변경

```bash
git branch -m master main
```

### 2. 원격 브랜치에 연결

```bash
git remote -v   # 현재 원격 저장소 확인
```

### 3. 원격에 main 브랜치로 push

```bash
git push -u origin main
```

> 이때, 만약 GitHub에 이미 커밋이 있다면 충돌이 날 수 있음
> 

### **JSP 파일을 찾지 못함 (`404 Not Found`)**

### 💥 문제 상황

`/view/favorites.jsp` 경로에 파일이 있음에도 불구하고 다음과 같은 에러 발생:

> 메시지: 파일 [/view/favorites.jsp]을(를) 찾을 수 없습니다.
> 

### ❗ 에러 원인

- JSP 파일을 `src/main/java` 아래에 두었음
- 실제 JSP 파일은 `src/main/webapp` 폴더 아래에 위치해야 Tomcat이 렌더링 가능

### ✅ 해결 방법

- `favorites.jsp` 파일을 `src/main/webapp/view/favorites.jsp`로 이동
- Eclipse에서 WebContent 대신 webapp 디렉토리를 설정 경로로 사용

### 🛡️ 방지 방법

- JSP는 항상 `webapp` 아래에 생성
- Java 소스 코드(`Servlet`, `DAO` 등)와 뷰 파일은 디렉토리 분리

### **세션 즐겨찾기 구현 오류 - 별표 상태 유지 안됨**

### 💥 문제 상황

즐겨찾기 버튼을 눌렀을 때 UI에서는 별이 노란색으로 바뀌지만, 새로고침 시 원래 상태로 돌아감

### ❗ 에러 원인

- 서버에 즐겨찾기 상태가 저장되지 않았거나, 상태를 기반으로 렌더링하지 않음

### ✅ 해결 방법

- `ToggleFavoriteServlet`에서 세션의 `Set<String>`을 업데이트
- `index.jsp`에서 `favorites.contains(p.getFinPrdtCd())`로 `class="active"` 토글 여부 결정

### 🛡️ 방지 방법

- 상태를 세션 또는 DB에 반드시 저장하고
- JSP 렌더링 시 상태 기반으로 HTML 클래스나 값 렌더링

### **`toggleFavorite` URL만 바뀌고 별 상태가 바뀌지 않음**

### 💥 문제 상황

별표를 눌러도 URL은 `toggleFavorite`로 바뀌고 아무 변화 없음

### ❗ 에러 원인

- `<form>` 태그를 사용했지만 submit 시 전체 페이지 리로드 발생
- `fetch()` 또는 AJAX 비동기 처리를 하지 않음

### ✅ 해결 방법

- `<form>` 대신 `<button>` 클릭 이벤트에서 `fetch('toggleFavorite', { ... })` 사용
- 서버는 응답만 보내고 `JSP`는 새로고침하지 않도록 구성

### 🛡️ 방지 방법

- 단순 상태 변경에는 form 대신 `fetch()`로 비동기 호출 사용
- 별도 `event.preventDefault()` 또는 `type="button"` 명시
