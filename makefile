# Wren's C Makefile :)
TARGET := target/apg
CFLAGS := -Og -g3 -fshort-enums -Isrc
LDFLAGS := -Og -g3

WARNINGS := -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wcast-qual -Wcast-align
FULLCFLAGS := $(CFLAGS) $(WARNINGS)
FULLLDFLAGS := $(LDFLAGS) $(WARNINGS)

.PHONY: run all fmt lint clean check-fmt check-lint $(TARGET)

run: $(TARGET)
	@echo -e "\x1b[1m ⇒ \x1b[31mRunning '$(TARGET)'\x1b[0m"
	@./$(TARGET)

all: $(TARGET)

fmt:
	@echo -e "\x1b[1m ⇒ \x1b[35mAuto formatting\x1b[0m"
	@clang-format -i $(SOURCES) $(HEADERS)

lint: check-fmt check-lint

clean:
	@echo -e "\x1b[1m ⇒ \x1b[33mRemoving build files\x1b[0m"
	@rm -rf $(TARGET) $(BUILD) compile_commands.json

check-fmt:
	@echo -e "\x1b[1m ⇒ \x1b[35mValidating formatting\x1b[0m"
	@clang-format --dry-run --Werror $(SOURCES) $(HEADERS)

check-lint:
	@echo -e "\x1b[1m ⇒ \x1b[32mLinting code\x1b[0m"
	@clang-tidy $(SOURCES) $(HEADERS) -- $(FULLCFLAGS)

$(TARGET):
	@echo -e "\x1b[1m ⇒ \x1b[32mBuilding...\x1b[0m"
	@cmake -GNinja -Btarget
	@ninja -Ctarget

