package com.github.vasatanasov.auto.data.repositories;

import com.github.vasatanasov.auto.data.models.Car;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface CarRepository extends JpaRepository<Car, Integer> {

  @Query(
      value =
          "SELECT * FROM CAR WHERE MATCH(`MAKER`, `MODEL`,`YEAR`, `TRIM`) "
              + "AGAINST(:searchString IN BOOLEAN MODE)",
      nativeQuery = true)
  Page<Car> fetchCars(String searchString, Pageable page);
}
