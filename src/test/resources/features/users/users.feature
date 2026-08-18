
Feature: Endpoint users

  Background:
    * url baseUrl
    * def usersSchema = read('classpath:schema/users/users-schema.json')


  Scenario: Get All Users
    Given path "users"
    When method GET
    Then status 200
    And match response == '#[] usersSchema'
    And match header Content-Type contains 'application/json'


  Scenario: Get a Single User
    * def usersData = read('classpath:data/users/getUsersData.json')

    Given path "users" , usersData.id
    When method GET
    Then status 200
    And match response == usersSchema
    And match header Content-Type contains 'application/json'


  Scenario: Create and update user

    # CREATE
    Given path "users"
    And request read('classpath:data/users/createNewUser.json')
    When method POST
    Then status 201
    And match response == usersSchema
    * def newUserId = response.id
    * print 'usuario creado con id:', newUserId

  # UPDATE (usando el id capturado)
    Given path "users", newUserId
    And request { name: 'Nicolas Actualizado' }
    When method PUT
    Then status 200
    And match response.name == 'Nicolas Actualizado'

    @negative
    Scenario: update user when user does not exist
      * def user = read('classpath:data/users/getUsersData.json')
      Given path "user", user.id
      When method PUT
      Then status 404
      And match response.error == 'Not Found'