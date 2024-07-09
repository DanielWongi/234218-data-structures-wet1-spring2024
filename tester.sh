#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Counter for failed tests and string to hold failed test numbers
FAILED_TESTS=0
FAILED_TEST_NUMBERS=""

# Number of tests to run, starting from test number 0
TESTS_TO_RUN=33

# JSON result file
JSON_RESULT_FILE="test_results.json"

echo -e "${PURPLE}
 _____    ______  _______  ______     ______  _______  ______   _    _   ______ _______  _    _   ______   ______  ______    1
| | \ \  | |  | |   | |   | |  | |   / |        | |   | |  | \ | |  | | | |       | |   | |  | | | |  | \ | |     / |
| |  | | | |__| |   | |   | |__| |   '------.   | |   | |__| | | |  | | | |       | |   | |  | | | |__| | | |---- '------.
|_|_/_/  |_|  |_|   |_|   |_|  |_|    ____|_/   |_|   |_|  \_\ \_|__|_| |_|____   |_|   \_|__|_| |_|  \_\ |_|____  ____|_/

 _   _   _   ______ _______   1   ______   ______   ______  _____  ______   ______    2024
| | | | | | | |       | |        / |      | |  | \ | |  | \  | |  | |  \ \ | | ____
| | | | | | | |----   | |        '------. | |__|_/ | |__| |  | |  | |  | | | |  | |
|_|_|_|_|_/ |_|____   |_|         ____|_/ |_|      |_|  \_\ _|_|_ |_|  |_| |_|__|_

${NC}"

# Initialize the JSON result file
echo "{" > "$JSON_RESULT_FILE"

# Main loop for running tests
for ((testNumber=0; testNumber<=TESTS_TO_RUN; testNumber++)); do
    inFile="fileTests/inFiles/test${testNumber}.in"
    resultFile="fileTests/outFiles/test${testNumber}.result"
    expectedFile="fileTests/outFiles/test${testNumber}.out"
    valgrindLogFile="fileTests/inFiles/test${testNumber}.valgrind_log"

     echo -e "${BLUE}Running test $testNumber >>>${NC}"

    # Normalize line endings and trim trailing whitespace for the input file, result file, and the expected file
    dos2unix "$inFile"
    dos2unix "$expectedFile"
    sed -i 's/[ \t]*$//' "$inFile"
    sed -i 's/[ \t]*$//' "$expectedFile"

    # Run the test simulation and output results to a file, recording the time taken
    start_time=$(date +%s%N)
    ./FileTester < "$inFile" > "$resultFile"
    end_time=$(date +%s%N)
    elapsed=$(( (end_time - start_time) / 1000000 ))

    echo "Test $testNumber execution time: ${elapsed}ms"

    # Compare the generated result with the expected result
    if diff "$expectedFile" "$resultFile" > /dev/null; then
        echo -e "Test Simulation: ${GREEN}pass${NC},"
    else
        echo -e "Test Simulation: ${RED}fail${NC}"
        ((FAILED_TESTS++))
        FAILED_TEST_NUMBERS+="$testNumber \n"
    fi

        # Check if the test execution time is within the acceptable limit
    if [ $elapsed -le 15000 ]; then
        echo -e "Time Complexity (≤ 15 sec): ${GREEN}pass${NC},"
    else
        echo -e "Time Complexity (≤ 15 sec): ${RED}fail${NC}"
        ((FAILED_TESTS++))
        FAILED_TEST_NUMBERS+="$testNumber "
    fi

    # Run Valgrind to check for memory leaks
    valgrind --log-file="$valgrindLogFile" --leak-check=full ./FileTester < "$inFile" > /dev/null 2>&1

    # Check Valgrind's output for the absence of memory leaks
    if grep -q "ERROR SUMMARY: 0 errors" "$valgrindLogFile"; then
        echo -e "Memory Leak: ${GREEN}pass${NC}\n"
    else
        echo -e "Memory Leak: ${RED}fail${NC}\n"
        cat "$valgrindLogFile"
        ((FAILED_TESTS++))
        FAILED_TEST_NUMBERS+="$testNumber "
    fi

    # Remove Valgrind log file after checking
    rm -f "$valgrindLogFile"

    # Append the execution time to the JSON result file
    if [[ $testNumber -eq $TESTS_TO_RUN ]]; then
        echo "\"test${testNumber}\": ${elapsed}" >> "$JSON_RESULT_FILE"
    else
        echo "\"test${testNumber}\": ${elapsed}," >> "$JSON_RESULT_FILE"
    fi
done

# Close the JSON result file
echo "}" >> "$JSON_RESULT_FILE"


# Final output, showing whether all tests passed or some failed
if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}
        ┏┓┓ ┓   ┏┳┓┏┓┏┓┏┳┓┏┓  ┏┓┏┓┏┓┏┓┏┓┳┓
        ┣┫┃ ┃    ┃ ┣ ┗┓ ┃ ┗┓  ┃┃┣┫┗┓┗┓┣ ┃┃
        ┛┗┗┛┗┛   ┻ ┗┛┗┛ ┻ ┗┛  ┣┛┛┗┗┛┗┛┗┛┻┛
            ┓ ┏┓ ┏┓ ┏ ┓ ┏┏┓┳┓┏┓┳ ┳┏┓
            ┃┃┃┃┃┃┃┃┃ ┃┃┃┃┃┃┃┃┓┃ ┃┃┃
            ┗┻┛┗┻┛┗┻┛•┗┻┛┗┛┛┗┗┛┻•┻┗┛
${NC}"
else
    echo -e "${RED}
 _____    ______  _______  ______     ______  _______  ______   _    _   ______ _______  _    _   ______   ______  ______    1
| | \ \  | |  | |   | |   | |  | |   / |        | |   | |  | \ | |  | | | |       | |   | |  | | | |  | \ | |     / |
| |  | | | |__| |   | |   | |__| |   '------.   | |   | |__| | | |  | | | |       | |   | |  | | | |__| | | |---- '------.
|_|_/_/  |_|  |_|   |_|   |_|  |_|    ____|_/   |_|   |_|  \_\ \_|__|_| |_|____   |_|   \_|__|_| |_|  \_\ |_|____  ____|_/

 _   _   _   ______ _______   1   ______   ______   ______  _____  ______   ______    2024
| | | | | | | |       | |        / |      | |  | \ | |  | \  | |  | |  \ \ | | ____
| | | | | | | |----   | |        '------. | |__|_/ | |__| |  | |  | |  | | | |  | |
|_|_|_|_|_/ |_|____   |_|         ____|_/ |_|      |_|  \_\ _|_|_ |_|  |_| |_|__|_
    "
    echo -e "\n${RED}Failed $FAILED_TESTS tests.${NC}"
    echo -e "Failed tests: \n${FAILED_TEST_NUMBERS}${NC}\n"
    echo "To see the differences for a failed test, use the diff.sh script. For example:"
    echo -e "${BLUE}./diff.sh <test_number>${NC}"
    echo "Make sure you have given execute permission to the script before using it. Run the following command to do so:"
    echo -e "${BLUE}chmod +x diff.sh${NC}"
fi
echo "Increase TESTS_TO_RUN in tester.sh to run more tests."