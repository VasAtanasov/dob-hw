package com.github.vasatanasov.auto.api.models;

import com.github.vasatanasov.auto.data.models.Car;

public class CarsResponse {
  private Integer id;
  private String maker;
  private String model;
  private String year;
  private String trim;

  public static CarsResponse of(Car car) {
    CarsResponse response = new CarsResponse();
    response.id = car.getId();
    response.maker = car.getMaker();
    response.model = car.getModel();
    response.year = car.getYear();
    response.trim = car.getTrim();
    return response;
  }

  public Integer getId() {
    return id;
  }

  public String getMaker() {
    return maker;
  }

  public String getModel() {
    return model;
  }

  public String getYear() {
    return year;
  }

  public String getTrim() {
    return trim;
  }
}
