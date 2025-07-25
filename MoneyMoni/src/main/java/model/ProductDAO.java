package model;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import model.entity.Product;

public class ProductDAO {
	 private static EntityManagerFactory emf;

	    static {
	        try {
	            emf = Persistence.createEntityManagerFactory("moneymoni");
	        } catch (Exception e) {
	            System.err.println("❌ EntityManagerFactory 초기화 실패: " + e.getMessage());
	            e.printStackTrace();
	        }
	    }

	    public static List<Product> findAll() {
	        EntityManager em = null;
	        List<Product> result = null;

	        try {
	            em = emf.createEntityManager();
	            result = em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
	        } catch (Exception e) {
	            System.err.println("❌ 상품 목록 조회 중 오류: " + e.getMessage());
	            e.printStackTrace();
	        } finally {
	            if (em != null && em.isOpen()) {
	                em.close();
	                em = null;
	            }
	        }

	        return result;
	    }
	    
	    
	    public static List<Product> findByIds(Set<String> finPrdtCds) {
	        EntityManager em = emf.createEntityManager();
	        try {
	            return finPrdtCds.stream()
	                .map(id -> em.find(Product.class, id))
	                .filter(Objects::nonNull)           // null 제거 (없는 상품 방지)
	                .collect(Collectors.toList());
	        } finally {
	            em.close();
	        }
	    }

	    
	    public static List<String> findAllBankNames() {
	        EntityManager em = emf.createEntityManager();
	        List<String> result = null;
	        try {
	            List<Product> all = em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
	            result = all.stream()
	                        .map(Product::getKorCoNm)
	                        .distinct()
	                        .sorted()
	                        .collect(Collectors.toList());
	        } finally {
	            em.close();
	            em = null;
	        }
	        return result;
	    }
	    
//	    public static List<Product> findByBank(String bankName) {
//	        EntityManager em = emf.createEntityManager();
//	        List<Product> result = null;
//	        try {
//	            List<Product> all = em.createQuery("SELECT p FROM Product p", Product.class).getResultList();
//	            result = all.stream()
//	                        .filter(p -> p.getKorCoNm().equals(bankName))
//	                        .collect(Collectors.toList());
//	        } finally {
//	            em.close();
//	            em = null;
//	        }
//	        return result;
//	    }
}
