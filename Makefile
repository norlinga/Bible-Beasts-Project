.PHONY: build remove-image run console

APP_NAME = biblebeastsapp

build:
	@echo "Building..."
	docker build -t $(APP_NAME) .

remove-image:
	@echo "Removing image..."
	-docker rmi $(APP_NAME)

run:
	docker run --rm -it -p 3000:3000 --name $(APP_NAME)-dev $(APP_NAME)

console:
	@docker run --rm -it -h $(APP_NAME)-app --name $(APP_NAME)-dev $(APP_NAME) /bin/sh