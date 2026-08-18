
Feature: Endpoint products

  Background:
    * url baseUrl
    * def productSchema = read('classpath:schema/product/product-schema.json')
    * def productData = read('classpath:data/filterProducts/getFilterData.json')


  Scenario: filter By title
    Given path "products"
    And param title = productData.title
    When method GET
    Then status 200
    And match response == '#[] productSchema'
    And match header Content-Type contains 'application/json'


  Scenario: filter By price
    Given path "products"
    And param price = productData.price
    When method GET
    Then status 200
    And match response == '#[] productSchema'
    And match header Content-Type contains 'application/json'


  Scenario: filter By price range
    Given path "products"
    And param PriceMin = productData.priceMin
    And param PriceMax = productData.priceMax
    When method GET
    Then status 200
    And match response == '#[] productSchema'
    And match header Content-Type contains 'application/json'


  Scenario: filter By category
    Given path "products"
    And param productCategory = productData.categoryId
    When method GET
    Then status 200
    And match response == '#[] productSchema'
    And match header Content-Type contains 'application/json'

  @negative
  Scenario: filter with negative price
    * def productData = read('classpath:data/filterProducts/getFilterData.json')

    Given path "products"
    And param price = -1
    When method GET
    Then status 200
    And match response == []
    And match header Content-Type contains 'application/json'