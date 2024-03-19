run:
	docker-compose up -d 

stop: 
	docker-compose down

restart: stop run

show:
	docker-compose ps 

reload:
	docker-compose exec proxy nginx -s reload

logs:
	docker-compose logs -f proxy