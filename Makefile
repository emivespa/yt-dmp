# .env: https://www.robg3d.com/2020/05/2288/
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

default: ;

################################################################################

.PHONY: deploy
deploy:
	sam deploy \
		--template-file template.yaml \
		--stack-name $$STACK_NAME \
		--capabilities CAPABILITY_IAM \
		--

.PHONY: start-api
start-api:
	sam local start-api \
		--debug \
		--

.PHONY: invoke
invoke:
	sam local invoke 'YtDlpInfoFunction' \
		--debug \
		--template-file template.yaml \
		-e event.json \
		--

################################################################################

FORCE: ;
deps: FORCE requirements.txt
	rm deps -rf
	mkdir -p deps
	pip install -r ./requirements.txt -t ./deps
# deps.zip: FORCE requirements.txt deps
# 	cd deps && zip -r9 ../deps.zip .
