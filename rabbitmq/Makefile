.PHONY: up down test

up:
	@echo "Running at: $$(pwd)"
	docker compose up -d
	
down:
	@echo "Running at: $$(pwd)"
	@echo "Shutdown the services is in process..."
	docker compose down
	@echo "Completed"

test:
	@echo "Running at: $$(pwd)"
	python3 test.py