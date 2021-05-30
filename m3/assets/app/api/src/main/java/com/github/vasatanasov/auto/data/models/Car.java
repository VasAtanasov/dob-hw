package com.github.vasatanasov.auto.data.models;

import com.github.vasatanasov.auto.data.models.common.Identifiable;

import javax.persistence.*;

@Entity
@Table(name = "CAR")
public class Car implements Identifiable<Integer> {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "ID", updatable = false, unique = true, nullable = false)
  @Access(AccessType.PROPERTY)
  private Integer id;

  @Column(name = "MAKER")
  private String maker;

  @Column(name = "MODEL")
  private String model;

  @Column(name = "YEAR")
  private String year;

  @Column(name = "`TRIM`")
  private String trim;

  @Override
  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getMaker() {
    return maker;
  }

  public void setMaker(String maker) {
    this.maker = maker;
  }

  public String getModel() {
    return model;
  }

  public void setModel(String model) {
    this.model = model;
  }

  public String getYear() {
    return year;
  }

  public void setYear(String year) {
    this.year = year;
  }

  public String getTrim() {
    return trim;
  }

  public void setTrim(String trim) {
    this.trim = trim;
  }
}
