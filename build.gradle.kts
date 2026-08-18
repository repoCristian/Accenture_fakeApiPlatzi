plugins {
    id("java")
    id("com.github.spacialcircumstances.gradle-cucumber-reporting") version "0.1.25"
}

// ... resto igual ...

cucumberReports {
    outputDir = file("build/cucumber-html-reports")
    reports = fileTree("build/karate-reports/cucumber-json") {
        include("*.json")
    }
}

group = "blass.academy"
version = "1.0-SNAPSHOT"


repositories {
    mavenCentral()
}


java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(21))
    }
}


sourceSets {
    test {
        resources {
            srcDir("src/test/java")
            exclude("**/*.java")
        }
    }
}


dependencies {
    testImplementation("io.karatelabs:karate-junit5:1.5.1")
    testImplementation("io.karatelabs:karate-core:2.0.10")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}


tasks.test {
    useJUnitPlatform()
    outputs.upToDateWhen { false }
}
