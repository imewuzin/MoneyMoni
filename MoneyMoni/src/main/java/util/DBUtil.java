package util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class DBUtil {
	
	private static EntityManagerFactory emf;
	
    static {
        emf = Persistence.createEntityManagerFactory("moneymoni");
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
    
}
