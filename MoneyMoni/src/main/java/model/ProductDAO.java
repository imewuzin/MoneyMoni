package model;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import jakarta.persistence.EntityManager;
import model.entity.Product;
import util.DBUtil;

public class ProductDAO {

	    public static List<Product> findAll() {
	        EntityManager em = null;
	        List<Product> result = null;

	        try {
	        	em = DBUtil.getEntityManager();
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
	        EntityManager em = DBUtil.getEntityManager();
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
	        EntityManager em = DBUtil.getEntityManager();
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
//	        EntityManager em = DBUtil.getEntityManager();
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
