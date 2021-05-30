package com.github.vasatanasov.auto.data.models.common;


import java.io.Serializable;

public interface Identifiable<T> extends Serializable {

  T getId();
}
