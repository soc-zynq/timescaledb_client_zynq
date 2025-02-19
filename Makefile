# Makefile

.PHONY: build clean docker-build execute run test rebuild help lint format docker-shell docker-clean docker-test

# Docker image name
DOCKER_IMAGE := raspberrypi5-app-builder:latest

# Build directory inside container
BUILD_DIR := build

# Executable name
EXECUTABLE := hello_rpi_world

# Color codes
GREEN := \033[0;32m
NC := \033[0m # No Color

default: build

help:
	@echo -e "${GREEN}Available targets:${NC}"
	@echo "  build        - Build the project"
	@echo "  clean        - Clean the build directory"
	@echo "  rebuild      - Clean and build the project"
	@echo "  run          - Execute the built binary"
	@echo "  test         - Run tests"
	@echo "  lint         - Run cpplint"
	@echo "  format       - Format the code using clang-format"
	@echo "  docker-shell - Open a shell inside the Docker container"
	@echo "  docker-clean - Clean the Docker environment"
	@echo "  docker-test  - Run tests inside the Docker container"
	@echo "  help         - Display this help message"

docker-build: clean 
	@echo -e "${GREEN}Starting Docker build...${NC}"
	docker run --rm -v ${PWD}:/workspace ${DOCKER_IMAGE} \
		bash -c "set -e && \
		source /opt/poky/environment-setup-cortexa76-poky-linux && \
		cd /workspace && \
		mkdir -p ${BUILD_DIR} && \
		cd ${BUILD_DIR} && \
		cmake .. && \
		make"
	@echo -e "${GREEN}Docker build completed.${NC}"

build: docker-build

execute: build
	@echo -e "${GREEN}Executing the built binary...${NC}"
	docker run --rm -v ${PWD}:/workspace ${DOCKER_IMAGE} \
		bash -c "cd /workspace/${BUILD_DIR} && ./${EXECUTABLE}"
	@echo -e "${GREEN}Execution completed.${NC}"

run: execute

test: build
	@echo -e "${GREEN}Running tests...${NC}"
	docker run --rm -v ${PWD}:/workspace ${DOCKER_IMAGE} \
		bash -c "cd /workspace/${BUILD_DIR} && ctest"
	@echo -e "${GREEN}Tests completed.${NC}"

lint:
	@echo -e "${GREEN}Running cpplint...${NC}"
	cpplint --recursive src include lib tests
	@echo -e "${GREEN}Linting completed.${NC}"

format:
	@echo -e "${GREEN}Formatting code using clang-format...${NC}"
	find src include lib tests -name '*.cpp' -o -name '*.h' | xargs clang-format -i
	@echo -e "${GREEN}Code formatting completed.${NC}"

docker-shell:
	@echo -e "${GREEN}Opening a shell inside the Docker container...${NC}"
	docker run --rm -it -v ${PWD}:/workspace ${DOCKER_IMAGE} bash

docker-clean:
	@echo -e "${GREEN}Cleaning Docker environment...${NC}"
	docker system prune -f
	@echo -e "${GREEN}Docker environment cleaned.${NC}"

docker-test: build
	@echo -e "${GREEN}Running tests inside the Docker container...${NC}"
	docker run --rm -v ${PWD}:/workspace ${DOCKER_IMAGE} \
		bash -c "cd /workspace/${BUILD_DIR} && ctest"
	@echo -e "${GREEN}Docker tests completed.${NC}"

clean:
	@echo -e "${GREEN}Cleaning build directory...${NC}"
	rm -rf ${BUILD_DIR}/
	@echo -e "${GREEN}Clean completed.${NC}"

rebuild: clean build