
Feature: Endpoint products

  Background:
    * url baseUrl

  Scenario: get all products
    * def productSchema = read('classpath:schema/product/product-schema.json')

    Given path "products"
    When method GET
    Then status 200
    And match response == '#[] productSchema'
    And match header Content-Type contains 'application/json'


  Scenario: post, get by id and update

    #POST
    * def createSchema = read('classpath:schema/product/createProduct-schema.json')
    * def newProduct = read('classpath:utils/RandomProduct.js')

    Given path "products"
    * request newProduct()
    When method POST
    Then status 201
    And match response == createSchema
    And match header Content-Type contains 'application/json'
    * def newProductId = response.id
    * print 'producto creado con id:', newProductId

    #GET BY ID
    * def productSchema = read('classpath:schema/product/product-schema.json')

    Given path "products", newProductId
    When method GET
    Then status 200
    And match response == productSchema
    And match response.id == newProductId
    And match header Content-Type contains 'application/json'

#UPDATE
    * def updateSchema = read('classpath:schema/product/updateProduct-schema.json')
    * def uniqueId = karate.uuid()
    * def requestProduct = read('classpath:data/products/requestProduct.json')
    * set requestProduct.title = 'NEW PRODUCT UPDATE ' + uniqueId

    Given path "products", newProductId
    And request requestProduct
    When method PUT
    Then status 200
    And match response.title == requestProduct.title
    And match header Content-Type contains 'application/json'
    And match response == updateSchema

  @negative
  Scenario: get product with invalid id data type
    * def existId = read('classpath:data/products/getProductData.json')

    Given path "products", existId.invalId
    When method GET
    Then status 400
    And match header Content-Type contains 'application/json'
