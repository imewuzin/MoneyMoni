package model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

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

    // 기본키: 금융상품코드
    @Id
    private String finPrdtCd;

    // 예금/적금 구분 (D: 예금, S: 적금)
    private String prdtType;

    // 공시 제출월
    private String dclsMonth;

    // 금융회사 코드
    private String finCoNo;

    // 금융회사명
    private String korCoNm;

    // 상품명
    private String finPrdtNm;

    // 가입 방법
    private String joinWay;

    // 만기 후 이자율 설명
    @Column(length = 2000)
    private String mtrtInt;

    // 우대 조건
    private String spclCnd;

    // 가입 제한 여부
    private String joinDeny;

    // 가입 대상
    private String joinMember;
}
