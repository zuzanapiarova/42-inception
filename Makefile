NAME = inception

# check the directories from envs exist and that docker containers can write them
all: prune reload

linux:
	@ echo "127.0.0.1 zpiarova.42.fr" >> /etc/hosts
	
stop:
	@ docker-compose -f srcs/docker-compose.yml down

clean: stop
	@ rm -rf ~/Desktop/inception

prune: clean
	@ docker system prune -f

reload: 
	@ docker-compose -f srcs/docker-compose.yml up --build

.PHONY: linux stop clean prune reload all