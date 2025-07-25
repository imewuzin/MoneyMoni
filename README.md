# MoneyMoni
# 💰 예/적금 소개 서비스 - MoneyMoni

> 금융감독원 공개 데이터를 기반으로 한 예금·적금 상품 조회 웹 서비스입니다.
> 

### 팀원 소개
| 이제현  | 임유진     | 서민지              | 이조은                                                   |
|:---:|:--------------:|:------------------:|:--------------------------------:|
| <img src="https://github.com/lyjh98.png" width="80">      | <img src="https://github.com/imewuzin.png" width="80">    | <img src="https://github.com/menzzi.png" width="80">     | <img src="https://github.com/LeeJoEun-01.png" width="80"> |
| [@lyjh98](https://github.com/lyjh98)  |  [@imewuzin](https://github.com/imewuzin)       | [@2jeong2](https://github.com/menzzi)   | [@LeeJoEun-01](https://github.com/LeeJoEun-01) |


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

<details> <summary><strong> Git 브랜치 충돌 트러블슈팅: Eclipse(master) ↔ GitHub(main)  </strong></summary>

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
</details>

<details> <summary><strong>JSP 파일을 찾지 못함 (`404 Not Found`)</strong></summary>

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
</details>

<details> <summary><strong>세션 즐겨찾기 구현 오류 - 별표 상태 유지 안됨</strong></summary>

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
</details>

<details> <summary><strong> toggleFavorite URL만 바뀌고 별 상태가 바뀌지 않음 </strong></summary>

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
</details>


<details><summary><strong> em = null 코드에서 "must be final or effectively final" 오류 발생 </strong></summary>
### 💥 문제 상황

`em.find(...)`를 `stream().map()` 안에서 사용하는 DAO 메서드에서,

`em = null;` 코드를 추가했더니 **컴파일 오류**가 발생함.

```java
return finPrdtCds.stream()
    .map(id -> em.find(Product.class, id)) // ❗ 오류 발생
    ...
em = null; // 여기가 문제

```

### ❗ 에러 원인

- Java의 **람다 표현식(stream, map 등)** 내부에서 사용하는 지역 변수(`em`)는 반드시
    
    `final` 또는 effectively final(한 번만 초기화되고 변경되지 않는 값)이어야 함
    
- 하지만 아래와 같이 **람다 이후 `em = null;`** 을 작성하면서, `em`이 "변경 가능한 변수"가 되어버림
- 결국 `em.find(...)`에서 **"Local variable must be final or effectively final"** 오류 발생

### ✅ 해결 방법

- **방법 1 (권장)**: `em = null;`을 제거

```java
finally {
    em.close(); // ✅ 이것만 있어도 자원 해제 OK
    // em = null; ❌ 제거
}

```

- **방법 2**: `stream` 사용 대신 일반 `for-each` 문으로 변경

```java
List<Product> result = new ArrayList<>();
for (String id : finPrdtCds) {
    Product p = em.find(Product.class, id);
    if (p != null) result.add(p);
}

```

- **방법 3** : `try-with-resources` 문법으로 리팩터링하여 `em.close()`도 자동 처리

```java
try (EntityManager em = emf.createEntityManager()) {
    return finPrdtCds.stream()
        .map(id -> em.find(Product.class, id))
        .filter(Objects::nonNull)
        .collect(Collectors.toList());
}
```

### 🛡️ 방지 방법

- 람다 내부에서 사용할 외부 변수는 **절대로 바꾸지 말 것**
- 람다에서 사용하는 `EntityManager`, `Connection`, `BufferedReader` 등은
    
    **그 이후에 `null`로 초기화하거나 다시 할당하지 말 것**
    
- 가능하면 **`try-with-resources`를 활용하여 안전하고 간결하게 관리**할 것
 </details>

## 회고
- 이제현
  > 이번 프로젝트에서는 Java의 Stream과 Lambda를 활용해 데이터를 간결하고 효율적으로 처리하는 데 집중했다. 직접 활용해보며 코드의 가독성과 처리 흐름 측면에서 큰 편리함을 느꼈다. 다만 MVC 패턴의 역할 분리와 예외 처리 적용이 미흡했던 점을 느꼈고, 다음 프로젝트에서는 기능 구현뿐 아니라 유지보수성과 안정성까지 고려한 구조적인 설계까지 함께 고민해야겠다고 느꼈다.
- 임유진
  > 이번 프로젝트를 하며 Controller에 있어야 할 로직이 View에 남아 있어 피드백을 받았고, MVC 패턴에서 역할을 명확히 분리하는 것이 왜 중요한지 실감했습니다. 또 이클립스에서 JSTL 설정이나 라이브러리 연동, 프로젝트 빌드 환경을 맞추는 데 어려움을 겪으며 개발 환경의 중요성도 깊이 느꼈고, 앞으로는 구조뿐 아니라 개발 환경 세팅에도 더 신경 써야겠다고 다짐했습니다.
- 서민지:
  > JSTL 적용과 환경 세팅 과정에서 예상보다 많은 어려움을 겪었고, 팀원들에게 충분한 도움을 주지 못해 아쉬움과 미안함이 남습니다. 협업의 중요성과 MVC 패턴을 활용한 구조 설계의 핵심 가치를 깊이 느꼈으며, 초기 설계 단계에서의 소통이 무엇보다 중요하다는 점을 배웠습니다. 앞으로는 기술적 장벽도 팀과 함께 극복하며 더 적극적으로 협업에 참여하고 싶습니다.
- 이조은:
  > 이번 예·적금 추천 웹 애플리케이션은 Java Servlet & JSP 기반으로 개발하며 필터링 기능을 구현했습니다. 람다와 Stream API는 처음 사용해보았지만, 문법은 빠르게 익힐 수 있었고 다만 환경 설정이 다소 까다롭게 느껴졌습니다. 기능 구현에 집중한 나머지 MVC 패턴의 책임 분리와 에러 처리에는 부족함이 있었고, 이를 통해 구조적 설계와 예외 처리의 중요성을 다시금 느낄 수 있었습니다.
