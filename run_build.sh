#!/bin/bash
set -e

sh run_clean.sh
sh run_tests.sh
sh run_build_android.sh
sh run_build_ios.sh
sh run_build_windows.sh
sh run_build_macos.sh