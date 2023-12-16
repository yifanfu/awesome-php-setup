dev-up:
	docker compose -f ./.devops/docker-compose.yml up -d

dev-build-up:
	docker compose -f ./.devops/docker-compose.yml up --build -d

dev-down:
	docker compose -f ./.devops/docker-compose.yml down

dev-rm:
	docker compose -f ./.devops/docker-compose.yml rm

dev-log:
	docker compose -f ./.devops/docker-compose.yml logs -f unit

dev-rebuild:
	make dev-down && \
	make dev-rm && \
	make dev-build-up

dev-ssh:
	docker compose -f ./.devops/docker-compose.yml exec unit bash
