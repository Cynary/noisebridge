%: Dockerfile.%
	docker build -f $^ . -t chdkptp.$@

all: $(patsubst ./Dockerfile.%,%,$(wildcard ./Dockerfile.*))
	docker tag chdkptp.x86-64 chdkptp
