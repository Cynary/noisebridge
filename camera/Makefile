%: Dockerfile.%
	docker build -f $^ -t chdkptp.$@ .

all: $(shell uname -m)
	docker rmi chdkptp || true
	docker tag chdkptp.$^ chdkptp
