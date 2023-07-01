# .env: https://www.robg3d.com/2020/05/2288/
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

default: ;

################################################################################

.PHONY: deploy
deploy: x.zip
	sam deploy \
		--template-file template.yaml \
		--stack-name $$STACK_NAME \
		--capabilities CAPABILITY_IAM \
		--resolve-s3
		--

x.zip: app.py deps
	zip -r x.zip app.py deps

.PHONY: start-api
start-api: deps
	sam local start-api \
		--debug \
		--

.PHONY: invoke
invoke: deps
	sam local invoke 'YtDmpFunction' \
		--debug \
		--template-file template.yaml \
		-e event.json \
		--

################################################################################

# FORCE: ;
# deps: FORCE requirements.txt
deps: requirements.txt
	rm deps -rf
	mkdir -p deps
	pip install -r ./requirements.txt -t ./deps
# deps.zip: FORCE requirements.txt deps
# 	cd deps && zip -r9 ../deps.zip .
