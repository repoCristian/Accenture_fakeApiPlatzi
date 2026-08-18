Feature: Endpoint categories

  Background:
    * url baseUrl
    * def categoriesSchema = read('classpath:schema/categories/categories-schema.json')


  Scenario: get category by id
    * def categoriesData = read('classpath:data/categories/getCategoriesInfo.json')
    Given path "categories", categoriesData.id
    When method GET
    Then status 200
    And match response == categoriesSchema
    And match header Content-Type contains 'application/json'


  Scenario: create, update and delete category

    #CREATE
    Given path "categories"
    And request read('classpath:data/categories/createCategory.json')
    When method POST
    Then status 201
    And match header Content-Type contains 'application/json'
    And match response == categoriesSchema
    * def newCategoryId = response.id
    * print 'category created with id:', newCategoryId

  #UPDATE
    Given path "categories", newCategoryId
    And request read('classpath:data/categories/updateCategory.json')
    When method PUT
    Then status 200
    And match response.name == 'Updated Category Name'
    And match header Content-Type contains 'application/json'

  #DELETE
    Given path "categories", newCategoryId
    When method DELETE
    Then status 200
    And match response.trim() == 'true'


  @negative
  Scenario: create category with empty data
    Given path "categories"
    And request read('classpath:data/categories/emptyData.json')
    When method POST
    Then status 500
