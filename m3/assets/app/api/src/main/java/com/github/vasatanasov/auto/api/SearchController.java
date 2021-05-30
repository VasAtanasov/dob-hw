package com.github.vasatanasov.auto.api;

import com.github.vasatanasov.auto.api.models.CarsResponse;
import com.github.vasatanasov.auto.data.repositories.CarRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = SearchController.URL_SEARCH, method = RequestMethod.GET)
public class SearchController {
  public static final String URL_SEARCH = "/search";

  protected static final int DEFAULT_PAGE_SIZE = 20;
  private final CarRepository carRepository;

  public SearchController(CarRepository carRepository) {
    this.carRepository = carRepository;
  }

  @GetMapping
  public ResponseEntity<Page<CarsResponse>> searchCar(
      @RequestParam(defaultValue = "") String q,
      @PageableDefault(size = DEFAULT_PAGE_SIZE) Pageable pageable) {
    String searchString = q.isBlank() ? "" : String.format("*%s*", q);
    Page<CarsResponse> cars = carRepository.fetchCars(searchString, pageable).map(CarsResponse::of);
    return ResponseEntity.ok(cars);
  }
}
