package com.template2.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * Main Spring Boot application class for Template2 Java Example.
 * 
 * This application demonstrates modern Java development practices including:
 * - RESTful API design
 * - Data persistence with JPA
 * - Security with JWT authentication
 * - API documentation with OpenAPI
 * - Comprehensive testing strategies
 * - Monitoring and observability
 * 
 * @author Template2 Contributors
 * @version 1.0.0
 */
@SpringBootApplication
@EnableJpaAuditing
@EnableCaching
public class Template2JavaExampleApplication {

    /**
     * Main method to start the Spring Boot application.
     * 
     * @param args command line arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(Template2JavaExampleApplication.class, args);
    }
}