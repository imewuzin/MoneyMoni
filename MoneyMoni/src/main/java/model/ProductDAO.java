package model;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

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
	            }
	        }

	        return result;
	    }
}
