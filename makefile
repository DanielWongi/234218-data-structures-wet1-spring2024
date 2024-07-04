# Makefile

# Compiler
CXX = g++
CXXFLAGS = -std=c++11 -Wall -Werror -pedantic-errors -DNDEBUG
INCLUDES = -I../
OBJ_DIR = obj
TEST_EXEC = FileTester

# Find all .cpp files in specified directories, excluding main.cpp and main24b1.cpp
SRCS = $(filter-out ../main.cpp, $(filter-out ../main24b1.cpp, $(wildcard ../*.cpp ./*.cpp)))
SRCS += main_test.cpp # Add the test main file explicitly

# Convert source files to object file paths, prefixing with the object directory
OBJS = $(patsubst ../%.cpp,$(OBJ_DIR)/%.o,$(filter ../%.cpp,$(SRCS)))
OBJS += $(patsubst ./%.cpp,$(OBJ_DIR)/%.o,$(filter ./%.cpp,$(SRCS)))

# Header files
HDRS = $(wildcard ../*.h ./*.h)

# Ensure directories exist and compile the source files into object files
$(OBJ_DIR)/%.o: ../%.cpp $(HDRS)
	mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR)/%.o: ./%.cpp $(HDRS)
	mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Link the object files to create the test executable
$(TEST_EXEC): $(OBJS)
	$(CXX) $(OBJS) -o $@

.PHONY: clean
clean:
	rm -rf $(OBJ_DIR) $(TEST_EXEC)
