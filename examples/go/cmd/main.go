// Package main provides a comprehensive Go web API example using Gin framework
package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"

	"github.com/cbwinslow/template2/examples/go/internal/handlers"
	"github.com/cbwinslow/template2/examples/go/internal/middleware"
	"github.com/cbwinslow/template2/examples/go/internal/models"
	"github.com/cbwinslow/template2/examples/go/pkg/auth"
)

// @title Template2 Go Example API
// @version 1.0
// @description A comprehensive Go web API showcasing modern development practices
// @termsOfService http://swagger.io/terms/

// @contact.name API Support
// @contact.url http://www.swagger.io/support
// @contact.email support@swagger.io

// @license.name MIT
// @license.url https://opensource.org/licenses/MIT

// @host localhost:8080
// @BasePath /api/v1

// @securityDefinitions.apikey ApiKeyAuth
// @in header
// @name Authorization
func main() {
	// Initialize logger
	logger := initLogger()
	defer logger.Sync()

	// Initialize Gin with custom logger
	gin.DefaultWriter = zapcore.AddSync(logger.Core())
	
	// Set Gin mode
	if os.Getenv("GIN_MODE") == "" {
		gin.SetMode(gin.ReleaseMode)
	}

	// Initialize router
	router := gin.New()

	// Add middleware
	router.Use(middleware.Logger(logger))
	router.Use(middleware.Recovery(logger))
	router.Use(middleware.CORS())
	router.Use(middleware.RateLimit())

	// Initialize services
	userService := models.NewUserService()
	authService := auth.NewAuthService()
	userHandler := handlers.NewUserHandler(userService, logger)
	authHandler := handlers.NewAuthHandler(authService, logger)
	healthHandler := handlers.NewHealthHandler(logger)

	// API routes
	api := router.Group("/api/v1")
	{
		// Public routes
		api.GET("/health", healthHandler.HealthCheck)
		api.POST("/auth/login", authHandler.Login)
		api.POST("/auth/register", authHandler.Register)

		// User routes
		users := api.Group("/users")
		{
			users.GET("", userHandler.GetUsers)
			users.POST("", userHandler.CreateUser)
			users.GET("/:id", userHandler.GetUser)
			users.PUT("/:id", userHandler.UpdateUser)
			users.DELETE("/:id", userHandler.DeleteUser)
		}

		// Protected routes
		protected := api.Group("/protected")
		protected.Use(middleware.AuthRequired(authService))
		{
			protected.GET("/profile", authHandler.GetProfile)
		}
	}

	// Root route
	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Welcome to Template2 Go Example API",
			"docs":    "/swagger/index.html",
			"health":  "/api/v1/health",
			"version": "1.0.0",
		})
	})

	// Setup server
	srv := &http.Server{
		Addr:         ":8080",
		Handler:      router,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// Start server in a goroutine
	go func() {
		logger.Info("🚀 Server starting on port 8080")
		logger.Info("📚 Environment: " + gin.Mode())
		logger.Info("🏥 Health check: http://localhost:8080/api/v1/health")
		
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Fatal("Failed to start server", zap.Error(err))
		}
	}()

	// Wait for interrupt signal to gracefully shutdown the server
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	logger.Info("Shutting down server...")

	// Give outstanding requests 5 seconds to complete
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		logger.Fatal("Server forced to shutdown", zap.Error(err))
	}

	logger.Info("Server exited")
}

func initLogger() *zap.Logger {
	config := zap.NewProductionConfig()
	config.Level = zap.NewAtomicLevelAt(zap.InfoLevel)
	config.EncoderConfig.TimeKey = "timestamp"
	config.EncoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	config.EncoderConfig.StacktraceKey = ""

	if gin.Mode() == gin.DebugMode {
		config = zap.NewDevelopmentConfig()
		config.EncoderConfig.EncodeLevel = zapcore.CapitalColorLevelEncoder
	}

	logger, err := config.Build()
	if err != nil {
		log.Fatal("Failed to initialize logger:", err)
	}

	return logger
}