%: Dockerfile.%
	docker build -f $^ -t chdkptp.$@ .

all: $(shell uname -m)
	docker tag chdkptp.$^ chdkptp
