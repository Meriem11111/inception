COMPOSE_FILE	= ./srcs/docker-compose.yml

DATA_DIR		= /home/meabdelk/data
WP_DATA_DIR		= $(DATA_DIR)/wordpress
DB_DATA_DIR		= $(DATA_DIR)/mariadb

GREEN			= \033[0;32m
RED				= \033[0;31m
YELLOW			= \033[0;33m
BLUE			= \033[0;34m
RESET			= \033[0m


all: create-dirs build up
	@echo "$(GREEN)✓ Inception is up and running!$(RESET)"

build: create-dirs
	@echo "$(YELLOW)Building Docker images...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) build
	@echo "$(GREEN)✓ Build complete!$(RESET)"

up: create-dirs	
	@echo "$(YELLOW)Starting containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN)✓ Containers are up!$(RESET)"
	@$(MAKE) --no-print-directory status

down:
	@echo "$(YELLOW)Stopping containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN)✓ Containers stopped!$(RESET)"



clean: down	
	@echo "$(YELLOW)Cleaning up containers and volumes...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down -v
	@echo "$(GREEN)✓ Cleanup complete!$(RESET)"

fclean: clean remove-dirs
	@if [ -n "$$(docker images -q)" ]; then \
		echo "$(YELLOW)Removing Docker images...$(RESET)"; \
		docker rmi -f $$(docker images -q)\
	fi
	@echo "$(GREEN)✓ Full clean complete!$(RESET)"

re: fclean all	


create-dirs:
	@if [ ! -d "$(WP_DATA_DIR)" ]; then \
		echo "$(YELLOW)Creating WordPress data directory...$(RESET)"; \
		mkdir -p $(WP_DATA_DIR); \
	fi
	@if [ ! -d "$(DB_DATA_DIR)" ]; then \
		echo "$(YELLOW)Creating MariaDB data directory...$(RESET)"; \
		mkdir -p $(DB_DATA_DIR); \
	fi

remove-dirs:					
	@echo "$(RED)Removing data directories...$(RESET)"
	@if [ -d "$(WP_DATA_DIR)" ]; then \
		rm -rf $(WP_DATA_DIR); \
		echo "$(GREEN)✓ WordPress data removed$(RESET)"; \
	fi
	@if [ -d "$(DB_DATA_DIR)" ]; then \
		rm -rf $(DB_DATA_DIR); \
		echo "$(GREEN)✓ MariaDB data removed$(RESET)"; \
	fi


logs:
	@docker compose -f $(COMPOSE_FILE) logs

ps:								
	@docker compose -f $(COMPOSE_FILE) ps

.PHONY: all build up down clean fclean re \
		logs ps create-dirs remove-dirs