package model.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Entity
public class Product {
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "product_seq_gen")
    @SequenceGenerator(
        name = "product_seq_gen",
        sequenceName = "product_seq",  // 실제 DB에서 생성될 시퀀스 이름
        allocationSize = 1             // 1씩 증가
    )
    private Long id;

    private String bankName;      // 금융회사명
    private String productName;   // 상품명
    private String joinWay;       // 가입 방법
    private String interestType;  // 금리 유형
    private String period;        // 저축 기간
    private Double rate;          // 금리
}
