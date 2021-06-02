tool
class_name PressAccept_Byter_Test_Utilities

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This file contains utility functions and definitions to make writing batch
# assertions and tests into simply a matter of arranging a data structure.
#
# For some tests this creates a consistent outline and is easier to maintain.
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : Test Utilities
#
# Organization        : Press Accept
# Organization URI    : https://pressaccept.com/
# Organization Social : @pressaccept
#
# Author        : Asher Kadar Wolfstein
# Author URI    : https://wunk.me/ (Personal Blog)
# Author Social : https://incarnate.me/members/asherwolfstein/
#                 @asherwolfstein (Twitter)
#                 https://ko-fi.com/asherwolfstein
#
# Copyright : Press Accept: Byter © 2021 The Novelty Factor LLC
#                 (Press Accept, Asher Kadar Wolfstein)
# License   : MIT (see LICENSE)
#
# |-----------|
# | Changelog |
# |-----------|
#
# 1.0.0    06/01/2021    First Release
#

# indices for what we're testing
const ASSERTION     : int    = 0
const EXPECTATION   : int    = 1

# default equivalency function
const EQUALS        : String = 'assert_eq'

# number of tests to run on deterministic random cycles
const INT_NUM_TESTS : int = 32


# batch run several tests form a given dictionary on a test object instance
static func batch(
		obj   : Object,
		tests : Dictionary,
		f     : FuncRef) -> void:

	for test in tests:
		var assertion: FuncRef = funcref(obj, tests[test][ASSERTION])
		assertion.call_func(f.call_funcv(test), tests[test][EXPECTATION])

