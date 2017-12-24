#!/bin/bash
caller_dir=$PWD
# Move to the current script directory
cd "${0%/*}"

ins_node_test_dir="ins-node/test"
ins_server_dir="server"
ins_app_dir="ins-app"
coverage_report_dir="coverage-reports"

# Specify which directories are to be excluded from coverage report
coverage_ignore_dirs="\
    '/usr/*' \
    '${ins_node_test_dir}/ins_mock/*' \
    '${ins_node_test_dir}/build/arduino_mock/*' \
    '${ins_node_test_dir}/stubs/*' \
    '${ins_node_test_dir}/ut/*' \
    '${ins_server_dir}/include/external/spdlog/*' \
    '${ins_server_dir}/test/*'
"

# Run coverage for ins-node and ins-server
eval mkdir -p $coverage_report_dir
eval lcov --directory . --capture --output-file coverage.info
eval lcov --remove coverage.info $coverage_ignore_dirs --output-file $coverage_report_dir/cpp_coverage.info
eval lcov --list coverage.info
# Run coverage for ins-app
eval $ins_app_dir/gradlew createDebugCoverageReport
eval cp $ins_app_dir/app/build/reports/coverage/debug/report.xml $coverage_report_dir/android_coverage.xml

# Go back to the initial directory when you are done
cd $caller_dir
