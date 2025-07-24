package util;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.junit.Test;


public class DBUtil {
	private static EntityManagerFactory emf;
    static {
        emf = Persistence.createEntityManagerFactory("moneyMone");
    }
    public static EntityManager getEntityManager(){
        return emf.createEntityManager();
    }
    public static void close() {
        if(emf != null) {
            emf.close();
            emf = null;
        }
    }
    
//    @Test
//    public void test() {
//        System.out.println(getEntityManager());
//    }
}
