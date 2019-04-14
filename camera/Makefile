%: Dockerfile.%
	docker build -f $^ -t chdkptp.$@ .

all: $(shell uname -m)
	docker rmi chdkptp
	docker tag chdkptp.$^ chdkptp
