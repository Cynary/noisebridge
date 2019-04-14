%: Dockerfile.%
	docker build -f $^ . -t chdkptp.$@

all: $(patsubst ./Dockerfile.%,%,$(wildcard ./Dockerfile.*))
	docker tag chdkptp.$(shell uname -m) chdkptp
