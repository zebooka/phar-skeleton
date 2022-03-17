
all: test install

composer:
	docker-compose -f docker-compose.composer.yml up

test: composer
	docker-compose -f docker-compose.tests.yml up

install: composer
	docker-compose -f docker-compose.build.yml up
