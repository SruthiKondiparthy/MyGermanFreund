.PHONY: ci-local backend-test web-install web-build clean-build-artifacts

ci-local: backend-test web-install web-build
	@echo "Local CI parity checks completed."

backend-test:
	cd backend-fastapi && PYTHONPATH=. python3 -m pytest -q

web-install:
	cd web-ui && npm ci

web-build:
	cd web-ui && npm run build

clean-build-artifacts:
	rm -rf backend-fastapi/app/__pycache__ \
		backend-fastapi/app/routers/__pycache__ \
		backend-fastapi/app/services/__pycache__ \
		backend-fastapi/tests/__pycache__ \
		web-ui/node_modules \
		web-ui/dist \
		web-ui/tsconfig.tsbuildinfo
