build:
	docker build -t identidock .

run_detach:
	docker run -d -p 9090:9090 -p 9191:9191 identidock

run:
	docker run identidock whoami

run_P:
	docker run -d -P --name port-test identidock