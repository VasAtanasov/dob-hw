package com.github.vasatanasov.auto.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SearchController {

  @GetMapping("/up")
  public ResponseEntity<?> getMakersAndModels() {
    return ResponseEntity.ok("ok");
  }
}
