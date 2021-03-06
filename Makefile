#!make
include .env
export $(shell sed 's/=.*//' .env)

#publish: up
#    mv docs/CNAME /tmp
#    docker-compose exec -u www-data php bash -c "php vendor/bin/sculpin generate -e prod --clean"
#    rm -rf docs
#    mv output_prod docs
#    mv /tmp/CNAME docs
#
#    git add .
#    git commit -m "Add post"
#    git push origin master

# Provides a bash in PHP container (user www-data)
bash-php: up
	docker-compose exec -u www-data php bash

# Provides a bash in PHP container (user root)
bash-php-root: up
	docker-compose exec php bash

composer-install: up
	# Install PHP dependencies
	docker-compose exec -u www-data php composer install

# Up containers
up:
	docker-compose up -d
	docker-compose exec php usermod -u ${HOST_UID} www-data

# Up containers, with build forced
build:
	docker-compose up -d --build
	docker-compose exec php usermod -u ${HOST_UID} www-data

# Down containers
down:
	docker-compose down
