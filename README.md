# Prueba Técnica - Automatización de API con Karate DSL


Proyecto de automatización de pruebas para una API REST, desarrollado con **Karate DSL**, **Gradle** y **Java 21**. Cubre pruebas funcionales (CRUD) y casos negativos sobre los módulos de productos, categorías, usuarios y filtros.



## Requisitos previos


- JDK 21 instalado
- No es necesario tener Gradle instalado globalmente (el proyecto incluye el wrapper `gradlew`)


##  Estructura del proyecto




├── build.gradle.kts
├── settings.gradle.kts
├── gradlew
├── gradlew.bat
├── README.md
└── src
├── main
│ └── java # Clases de apoyo/configuraciones globales (opcional)
└── test
├── java
│ ├── config # Configuraciones de soporte para los tests
│ └── runners # Runners de ejecución
│   ├── AllTestRunner.java
│   ├── CategoriesRunner.java
│   ├── DebugRunner.java
│   ├── FilterProductsRunner.java
│   ├── ProductsRunner.java
│   └── UsersRunner.java
└── resources
├── karate-config.js # Configuración global (URL base, entornos)
├── utils # Funciones JS reutilizables (generación de datos dinámicos)
├── features # Escenarios .feature organizados por dominio
│   ├── categories
│   ├── filters
│   ├── products
│   └── users
├── data # Datos de prueba reutilizables (JSON)
│   ├── categories
│   ├── filterProducts
│   ├── products
│   └── users
└── schema # Esquemas JSON para validar estructura de respuestas
    ├── categories
    ├── filter
    ├── product
    └── users






## Cómo ejecutar el proyecto


### Ejecutar todas las pruebas


bash

    ./gradlew test --tests runners.AllTestRunner




En Windows:


bash

    gradlew.bat test --tests runners.AllTestRunner




### Ejecutar un runner específico por feature


bash

    ./gradlew test --tests runners.ProductsRunner
    ./gradlew test --tests runners.CategoriesRunner
    ./gradlew test --tests runners.UsersRunner
    ./gradlew test --tests runners.FilterProductsRunner




### Ejecutar solo el runner de debug (pruebas en desarrollo)


bash

    ./gradlew test --tests runners.DebugRunner




### Ejecutar solo pruebas con un tag específico


Los escenarios están etiquetados (por ejemplo `@debug`). Para correr solo un grupo:


bash

    ./gradlew test -Dkarate.options="--tags @negative"




bash

    ./gradlew test -Dkarate.env=dev

## Generación y ubicación de reportes


Al finalizar la ejecución, Karate genera automáticamente reportes HTML con el detalle de cada escenario (pasos, request/response, tiempos de respuesta).


Los reportes se generan en:


build/karate-reports/


ld/karate-reports/


Para visualizarlos, abre el archivo `karate-summary.html` en cualquier navegador:


bash

    open build/karate-reports/karate-summary.html




*(en Windows/Linux, abre el archivo manualmente desde el explorador de archivos)*

### los reportes de cucumber se generan en:

    build/karate-reports/cucumber-json/

file:/build/cucumber-html-reports/cucumber-html-reports/overview-features.html


## Preguntas técnicas del proyecto


### a. ¿Cuáles fueron los principales desafíos que enfrentaste al implementar las funcionalidades?
El mayor reto no fue escribir los escenarios de Karate en sí, sino la configuración del entorno: migrar de Maven a Gradle cambió cómo se resuelven los archivos “.feature” y “karate-config.js” en el classpath, así que tuve que entender bien la diferencia entre cómo cada herramienta empaqueta los recursos de test. Otro desafío fue el manejo de datos dinámicos, ya que se me generaban errores en la API al crear o actualizar productos, por lo que tuve que generar valores aleatorios (UUID) en vez de datos fijos para evitar choques de duplicados entre corridas. También hubo que ajustar validaciones según el comportamiento real de la API (por ejemplo, respuestas en texto plano en vez de JSON en ciertos endpoints).



### b. ¿Qué técnicas de pruebas se usaron y qué enfoque se le dio a la automatización?
Se aplicó un enfoque de pruebas de API basado en BDD (Behavior Driven Development) con Gherkin, separando los escenarios por dominio funcional (productos, categorías, usuarios, filtros), cada uno con su propio runner. Se usaron tanto casos positivos (flujos exitosos de create/read/update/delete) como casos negativos (IDs inválidos, precios negativos, elementos inexistentes) y asi validar que la API nos responde de forma controlada ante entradas inesperadas. También aplique encadenamiento de escenarios (crear → actualizar → eliminar el mismo recurso dentro de un mismo Scenario) para simular flujos reales de negocio sin depender de datos precargados.



### c. ¿Cómo gestionaste la validación de datos y la verificación de la estructura de las respuestas JSON en tus pruebas automatizadas?
usando la funcionalidad de schema validation de Karate, definiendo archivos JSON con esquema (“#string”, “#number” , “#[] #string” , etc.) en la carpeta schema se describe la forma esperada de cada respuesta en vez de comparar campo por campo. Esto permite validar tipos de datos y estructura sin acoplar la prueba a valores específicos que cambian en cada ejecución (como IDs o nombres).
Para los datos de entrada, centralice estos en archivos JSON reutilizables dentro de la carpeta data, y para los casos que requieren valores únicos por ejecución (como títulos de productos), use la función JavaScript reutilizable y la ubique en la carpeta utils para generar datos dinámicos con “karate.uuid()”.




### d. ¿Qué aprendizajes obtuviste al desarrollar esta prueba técnica y cómo consideras que aportan a tu crecimiento profesional?

Aprendí lo importante que es que cada prueba pueda correr por su cuenta, sin depender de qué otra prueba haya corrido antes. Al usar ejecución en paralelo, el orden no está garantizado y las pruebas pueden fallar sin que exista un error en la API. Aprendí a resolverlo haciendo que cada prueba genere sus propios datos, para que no le importe el orden.

Considero que la prueba aporta a mi crecimiento profesional ya que me ayudó a darme cuenta de que muchas veces la API no se comporta exactamente como uno espera, y no sirve de nada asumir o adivinar. Tuve que aprender a leer con calma la respuesta real del servidor (el status), el mensaje de error, el tipo de dato que devolvía para entender qué estaba pasando de verdad antes de corregir algo. La costumbre de investigar antes de asumir es algo que considero fundamental para cualquier QA automation, debido a que en un proyecto real las cosas casi nunca salen como dice la documentación.
