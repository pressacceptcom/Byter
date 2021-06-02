extends "res://addons/gut/test.gd"

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This is a 'test suite' to be used by GUT to make sure the included source
# is operating correctly. This code was not developed using TDD methodologies,
# and so these tests most likely break some TDD rules. That being said, they
# perform random checks (adjustable by INT_NUM_TESTS) to see if
# PressAccept_Byter_ArbitraryBase is behaving as expected given a variety of
# inputs.
#
# If you have ideas for better, more rigorous or less dependent tests then go
# for it. Note that I have adopted this method due to memory constraints I was
# running into with Godot and other issues. (Using temporary files only
# resulted in long run times, and large files)
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : ArbitraryBase Test
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
# 1.0    06/01/2021    First Release
#

# |---------|
# | Imports |
# |---------|

# see test/Utilities.gd
var TestUtilities : Script = PressAccept_Byter_Test_Utilities
var Basic         : Script = PressAccept_Arbiter_Basic
var Binary        : Script = PressAccept_Byter_Binary
var Octal         : Script = PressAccept_Byter_Octal
var Hex           : Script = PressAccept_Byter_Hexadecimal
var Base36        : Script = PressAccept_Byter_Base36
var Base62        : Script = PressAccept_Byter_Base62
# shorthand for our library class
var Arbitrary: Script = PressAccept_Byter_ArbitraryBase

# |---------------|
# | Configuration |
# |---------------|

# random seed for deterministic randomized tests
var INT_RANDOM_SEED : int = hash('PressAccept_Byter_ArbitraryBase')

# number of times to iterate each test
var INT_NUM_TESTS   : int = TestUtilities.INT_NUM_TESTS

const STR_BASE_5  : String = "01234"
const STR_BASE_43 : String = "0123456789😊abcdefghijklmnopqrstuvwxyzABCDEF"

var arbitrary_base_5  : PressAccept_Byter_ArbitraryBase = \
	Arbitrary.new(STR_BASE_5)
var arbitrary_base_43 : PressAccept_Byter_ArbitraryBase = \
	Arbitrary.new(STR_BASE_43)

# |-------|
# | Tests |
# |-------|
#
# Tests follow this format -
#
# static method   - test_<method_identifier>
# instance method - test_arbitrarybase_<method_identifier>
#


func test_arbitrarybase_str2integer() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_decimal: String = int_value.to_decimal()

		var b5_value : PressAccept_Arbiter_Basic = Basic.new(comparison, 5)
		var b5_arr   : Array = b5_value.to_array()
		var b5_str   : String
		for digit in b5_arr:
			b5_str += arbitrary_base_5.place_values_arr[digit]

		var test_value     = arbitrary_base_5.str2integer(b5_str)
		var test_value_obj = arbitrary_base_5.str2integer(b5_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		var b43_value : PressAccept_Arbiter_Basic = Basic.new(comparison, 43)
		var b43_arr   : Array = b43_value.to_array()
		var b43_str   : String
		for digit in b43_arr:
			b43_str += arbitrary_base_43.place_values_arr[digit]

		test_value     = arbitrary_base_43.str2integer(b43_str)
		test_value_obj = arbitrary_base_43.str2integer(b43_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		int_value.multiply(comparison)
		int_value_decimal = int_value.to_decimal()

		b5_value = Basic.new(int_value, 5)
		b5_arr   = b5_value.to_array()
		b5_str   = ''
		for digit in b5_arr:
			b5_str += arbitrary_base_5.place_values_arr[digit]

		test_value     = arbitrary_base_5.str2integer(b5_str)
		test_value_obj = arbitrary_base_5.str2integer(b5_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		b43_value = Basic.new(int_value, 43)
		b43_arr   = b43_value.to_array()
		b43_str   = ''
		for digit in b43_arr:
			b43_str += arbitrary_base_43.place_values_arr[digit]

		test_value     = arbitrary_base_43.str2integer(b43_str)
		test_value_obj = arbitrary_base_43.str2integer(b43_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)


func test_arbitrarybase_str2signed() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		if comparison > 0:
			comparison *= -1

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_decimal: String = int_value.to_decimal()

		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		var test_value     = arbitrary_base_5.str2signed(int_value_b5_str)
		var test_value_obj = arbitrary_base_5.str2signed(int_value_b5_str, false, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		test_value = arbitrary_base_5.str2signed(int_value_b5_str, true)

		var int_value_plus_one: PressAccept_Arbiter_Basic = \
			int_value.immutable_add(1)
		assert_eq(str(test_value), int_value_plus_one.to_decimal())

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_value     = arbitrary_base_43.str2signed(int_value_b43_str)
		test_value_obj = arbitrary_base_43.str2signed(int_value_b43_str, false, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		test_value = arbitrary_base_43.str2signed(int_value_b43_str, true)

		assert_eq(str(test_value), int_value_plus_one.to_decimal())

		int_value.multiply(comparison)
		int_value.negative_bool = true
		int_value_decimal       = int_value.to_decimal()

		int_value_b5_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		test_value     = arbitrary_base_5.str2signed(int_value_b5_str)
		test_value_obj = arbitrary_base_5.str2signed(int_value_b5_str, false, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		int_value_b43_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_value     = arbitrary_base_43.str2signed(int_value_b43_str)
		test_value_obj = arbitrary_base_43.str2signed(int_value_b43_str, false, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)


func test_arbitrarybase_str2unsigned() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_decimal: String = int_value.to_decimal()

		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		var test_value     = arbitrary_base_5.str2unsigned(int_value_b5_str)
		var test_value_obj = arbitrary_base_5.str2unsigned(int_value_b5_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_value     = arbitrary_base_43.str2unsigned(int_value_b43_str)
		test_value_obj = arbitrary_base_43.str2unsigned(int_value_b43_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		int_value.multiply(comparison)
		int_value_decimal = int_value.to_decimal()

		int_value_b5_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		test_value     = arbitrary_base_5.str2unsigned(int_value_b5_str)
		test_value_obj = arbitrary_base_5.str2unsigned(int_value_b5_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		int_value_b43_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_value     = arbitrary_base_43.str2unsigned(int_value_b43_str)
		test_value_obj = arbitrary_base_43.str2unsigned(int_value_b43_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)


func test_arbitrarybase_integer2str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		var test_str: String = arbitrary_base_5.integer2str(comparison)

		assert_eq(test_str, int_value_b5_str)

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_str = arbitrary_base_43.integer2str(comparison)

		assert_eq(test_str, int_value_b43_str)

		int_value.multiply(comparison)
		var int_value_decimal: String = int_value.to_decimal()

		int_value_b5_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		test_str = arbitrary_base_5.int2str(int_value_decimal)

		assert_eq(test_str, int_value_b5_str)

		int_value_b43_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_str = arbitrary_base_43.int2str(int_value_decimal)

		assert_eq(test_str, int_value_b43_str)


func test_arbitrarybase_signed2str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		if comparison > 0:
			comparison *= -1

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_decimal: String = int_value.to_decimal()

		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		var test_str: String = arbitrary_base_5.signed2str(comparison)

		assert_eq(test_str, int_value_b5_str)

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_str = arbitrary_base_43.signed2str(comparison)

		assert_eq(test_str, int_value_b43_str)

		int_value.multiply(comparison)
		int_value.negative_bool = true
		int_value_decimal       = int_value.to_decimal()

		int_value_b5_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		test_str = arbitrary_base_5.signed2str(int_value_decimal)

		assert_eq(test_str, int_value_b5_str)

		int_value_b43_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_str = arbitrary_base_43.signed2str(int_value_decimal)

		assert_eq(test_str, int_value_b43_str)


func test_arbitrarybase_unsigned2str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		var test_str: String = arbitrary_base_5.unsigned2str(comparison)

		assert_eq(test_str, int_value_b5_str)

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_str = arbitrary_base_43.unsigned2str(comparison)

		assert_eq(test_str, int_value_b43_str)

		int_value.multiply(comparison)
		var int_value_decimal: String = int_value.to_decimal()

		int_value_b5_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		test_str = arbitrary_base_5.unsigned2str(int_value_decimal)

		assert_eq(test_str, int_value_b5_str)

		int_value_b43_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_str = arbitrary_base_43.unsigned2str(int_value_decimal)

		assert_eq(test_str, int_value_b43_str)


func test_arbitrarybase_str2binary() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value : PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		var test_binary_str: String = \
			arbitrary_base_5.str2binary(int_value_b5_str)

		assert_eq(test_binary_str, int_value.to_binary().lstrip('0'))

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_binary_str = arbitrary_base_43.str2binary(int_value_b43_str)

		assert_eq(test_binary_str, int_value.to_binary().lstrip('0'))

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true

		int_value_b5_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		test_binary_str = arbitrary_base_5.str2binary(int_value_b5_str)

		assert_eq(test_binary_str, int_value.to_binary().lstrip('0'))

		int_value_b43_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_binary_str = arbitrary_base_43.str2binary(int_value_b43_str)

		assert_eq(test_binary_str, int_value.to_binary().lstrip('0'))


func test_arbitrarybase_str2octal() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_bin_str   : String = int_value.to_binary().lstrip('0')
		var int_value_octal_str : String = \
			Binary.str2octal(int_value_bin_str, int_value.negative_bool)
		
		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value_bin_str,
			arbitrary_base_5.get_func()
		)

		var test_octal_str: String = arbitrary_base_5.str2octal(
			int_value_b5_str,
			int_value.negative_bool
		)
		
		assert_eq(test_octal_str, int_value_octal_str)

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value_bin_str,
			arbitrary_base_43.get_func()
		)

		test_octal_str = arbitrary_base_43.str2octal(
			int_value_b43_str,
			int_value.negative_bool
		)

		assert_eq(test_octal_str, int_value_octal_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true

		int_value_bin_str   = int_value.to_binary().lstrip('0')
		int_value_octal_str = \
			Binary.str2octal(int_value_bin_str, int_value.negative_bool)

		int_value_b5_str = Binary.str2arbitrary(
			int_value_bin_str,
			arbitrary_base_5.get_func()
		)

		test_octal_str = arbitrary_base_5.str2octal(
			int_value_b5_str,
			int_value.negative_bool
		)

		assert_eq(test_octal_str, int_value_octal_str)

		int_value_b43_str = Binary.str2arbitrary(
			int_value_bin_str,
			arbitrary_base_43.get_func()
		)

		test_octal_str = arbitrary_base_43.str2octal(
			int_value_b43_str,
			int_value.negative_bool
		)

		assert_eq(test_octal_str, int_value_octal_str)


func test_arbitrarybase_str2hexadecimal() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_bin_str: String = int_value.to_binary().lstrip('0')
		var int_value_hex_str: String = \
			Binary.str2hexadecimal(int_value_bin_str, int_value.negative_bool)

		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value_bin_str,
			arbitrary_base_5.get_func()
		)

		var test_hexadecimal_str: String = arbitrary_base_5.str2hexadecimal(
			int_value_b5_str,
			int_value.negative_bool
		)
		
		assert_eq(test_hexadecimal_str, int_value_hex_str)

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value_bin_str,
			arbitrary_base_43.get_func()
		)

		test_hexadecimal_str = arbitrary_base_43.str2hexadecimal(
			int_value_b43_str,
			int_value.negative_bool
		)

		assert_eq(test_hexadecimal_str, int_value_hex_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true
		int_value_bin_str = int_value.to_binary().lstrip('0')
		int_value_hex_str = \
			Binary.str2hexadecimal(int_value_bin_str, int_value.negative_bool)

		int_value_b5_str = Binary.str2arbitrary(
			int_value_bin_str,
			arbitrary_base_5.get_func()
		)

		test_hexadecimal_str = arbitrary_base_5.str2hexadecimal(
			int_value_b5_str,
			int_value.negative_bool
		)

		assert_eq(
			test_hexadecimal_str,
			int_value.to_signed_hexadecimal().lstrip('0')
		)

		int_value_b43_str = Binary.str2arbitrary(
			int_value_bin_str,
			arbitrary_base_43.get_func()
		)

		test_hexadecimal_str = arbitrary_base_43.str2hexadecimal(
			int_value_b43_str,
			int_value.negative_bool
		)

		assert_eq(
			test_hexadecimal_str,
			int_value.to_signed_hexadecimal().lstrip('0')
		)


func test_arbitrarybase_str2base36() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_b36_str: String = \
			Binary.str2base36(int_value.to_binary())

		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		var test_base36_str: String = \
			arbitrary_base_5.str2base36(int_value_b5_str)

		assert_eq(test_base36_str, int_value_b36_str)

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_base36_str = \
			arbitrary_base_43.str2base36(int_value_b43_str)
		
		assert_eq(test_base36_str, int_value_b36_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true

		int_value_b36_str = Binary.str2base36(int_value.to_binary())

		int_value_b5_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		test_base36_str = \
			arbitrary_base_5.str2base36(int_value_b5_str)

		assert_eq(test_base36_str, int_value_b36_str)

		int_value_b43_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_base36_str = \
			arbitrary_base_43.str2base36(int_value_b43_str)
		
		assert_eq(test_base36_str, int_value_b36_str)


func test_arbitrarybase_str2base62() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())

		var int_value_b5_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		var test_base62_str: String = \
			arbitrary_base_5.str2base62(int_value_b5_str)

		assert_eq(test_base62_str, int_value_b62_str)

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_base62_str = \
			arbitrary_base_43.str2base62(int_value_b43_str)
		
		assert_eq(test_base62_str, int_value_b62_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true

		int_value_b62_str = Binary.str2base62(int_value.to_binary())

		int_value_b5_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_5.get_func()
		)

		test_base62_str = \
			arbitrary_base_5.str2base62(int_value_b5_str)

		assert_eq(test_base62_str, int_value_b62_str)

		int_value_b43_str = Binary.str2arbitrary(
			int_value.to_binary(),
			arbitrary_base_43.get_func()
		)

		test_base62_str = \
			arbitrary_base_43.str2base62(int_value_b43_str)
		
		assert_eq(test_base62_str, int_value_b62_str)


func test_arbitrarybase_to_base() -> void:

	var Formats      : Script     = PressAccept_Byter_Formats
	var ENUM_FORMATS : Dictionary = Formats.ENUM_FORMATS
	var ENUM_RADIX   : Dictionary = Formats.ENUM_RADIX

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var signed_base5: String = arbitrary_base_5.to_base(
			comparison,
			ENUM_RADIX.SIGNED_DECIMAL
		)

		var unsigned_base5: String = arbitrary_base_5.to_base(
			int(abs(comparison)),
			ENUM_RADIX.UNSIGNED_DECIMAL
		)

		assert_eq(
			signed_base5,
			arbitrary_base_5.signed2str(comparison)
		)

		assert_eq(
			unsigned_base5,
			arbitrary_base_5.unsigned2str(int(abs(comparison)))
		)

		signed_base5 = arbitrary_base_5.to_base(
			str(comparison),
			ENUM_RADIX.SIGNED_DECIMAL
		)

		unsigned_base5 = arbitrary_base_5.to_base(
			str(int(abs(comparison))),
			ENUM_RADIX.UNSIGNED_DECIMAL
		)

		assert_eq(
			signed_base5,
			arbitrary_base_5.signed2str(comparison)
		)

		assert_eq(
			unsigned_base5,
			arbitrary_base_5.unsigned2str(int(abs(comparison)))
		)

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_octal_str = int_value.to_signed_octal()

		var base5: String = arbitrary_base_5.to_base(
			int_value_octal_str,
			ENUM_RADIX.OCTAL
		)

		assert_eq(
			base5,
			Octal.str2arbitrary(
				int_value_octal_str,
				arbitrary_base_5.get_func()
			)
		)

		var int_value_hex_str = int_value.to_signed_hexadecimal()

		base5 = arbitrary_base_5.to_base(
			int_value_hex_str,
			ENUM_RADIX.HEXADECIMAL
		)

		assert_eq(
			base5,
			Hex.str2arbitrary(
				int_value_hex_str,
				arbitrary_base_5.get_func()
			)
		)

		var int_value_b36_str: String = \
			Binary.str2base36(int_value.to_binary())

		base5 = arbitrary_base_5.to_base(
			int_value_b36_str,
			ENUM_RADIX.UNSIGNED_BASE_36
		)

		assert_eq(
			base5,
			Base36.str2arbitrary(
				int_value_b36_str,
				arbitrary_base_5.get_func()
			)
		)

		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())

		base5 = arbitrary_base_5.to_base(
			int_value_b62_str,
			ENUM_RADIX.UNSIGNED_BASE_62
		)

		assert_eq(
			base5,
			Base62.str2arbitrary(
				int_value_b62_str,
				arbitrary_base_5.get_func()
			)
		)

		var int_value_arr: Array = Binary.str2array(int_value.to_binary())

		base5 = arbitrary_base_5.to_base(
			int_value_arr,
			ENUM_RADIX.BINARY
		)

		assert_eq(
			base5,
			Binary.array2arbitrary(
				int_value_arr,
				arbitrary_base_5.get_func()
			)
		)

		int_value.negative_bool = true

		signed_base5 = arbitrary_base_5.to_base(
			int_value,
			ENUM_RADIX.SIGNED_DECIMAL
		)

		int_value.negative_bool = false

		unsigned_base5 = arbitrary_base_5.to_base(
			int_value,
			ENUM_RADIX.UNSIGNED_DECIMAL
		)

		int_value.negative_bool = true

		assert_eq(
			signed_base5,
			arbitrary_base_5.signed2str(int_value.to_decimal())
		)

		int_value.negative_bool = false

		assert_eq(
			unsigned_base5,
			arbitrary_base_5.unsigned2str(int_value.to_decimal())
		)

		var signed_base43: String = arbitrary_base_43.to_base(
			comparison,
			ENUM_RADIX.SIGNED_DECIMAL
		)

		var unsigned_base43: String = arbitrary_base_43.to_base(
			int(abs(comparison)),
			ENUM_RADIX.UNSIGNED_DECIMAL
		)

		assert_eq(
			signed_base43,
			arbitrary_base_43.signed2str(comparison)
		)

		assert_eq(
			unsigned_base43,
			arbitrary_base_43.unsigned2str(int(abs(comparison)))
		)

		signed_base43 = arbitrary_base_43.to_base(
			str(comparison),
			ENUM_RADIX.SIGNED_DECIMAL
		)

		unsigned_base43 = arbitrary_base_43.to_base(
			str(int(abs(comparison))),
			ENUM_RADIX.UNSIGNED_DECIMAL
		)

		assert_eq(
			signed_base43,
			arbitrary_base_43.signed2str(comparison)
		)

		assert_eq(
			unsigned_base43,
			arbitrary_base_43.unsigned2str(int(abs(comparison)))
		)

		var base43: String = arbitrary_base_43.to_base(
			int_value_octal_str,
			ENUM_RADIX.OCTAL
		)

		assert_eq(
			base43,
			Octal.str2arbitrary(
				int_value_octal_str,
				arbitrary_base_43.get_func()
			)
		)

		base43 = arbitrary_base_43.to_base(
			int_value_hex_str,
			ENUM_RADIX.HEXADECIMAL
		)

		assert_eq(
			base43,
			Hex.str2arbitrary(
				int_value_hex_str,
				arbitrary_base_43.get_func()
			)
		)

		base43 = arbitrary_base_43.to_base(
			int_value_b36_str,
			ENUM_RADIX.UNSIGNED_BASE_36
		)

		assert_eq(
			base43,
			Base36.str2arbitrary(
				int_value_b36_str,
				arbitrary_base_43.get_func()
			)
		)

		base43 = arbitrary_base_43.to_base(
			int_value_b62_str,
			ENUM_RADIX.UNSIGNED_BASE_62
		)

		assert_eq(
			base43,
			Base62.str2arbitrary(
				int_value_b62_str,
				arbitrary_base_43.get_func()
			)
		)

		base43 = arbitrary_base_43.to_base(
			int_value_arr,
			ENUM_RADIX.BINARY
		)

		assert_eq(
			base43,
			Binary.array2arbitrary(
				int_value_arr,
				arbitrary_base_43.get_func()
			)
		)

		int_value.negative_bool = true

		signed_base43 = arbitrary_base_43.to_base(
			int_value,
			ENUM_RADIX.SIGNED_DECIMAL
		)

		int_value.negative_bool = false

		unsigned_base43 = arbitrary_base_43.to_base(
			int_value,
			ENUM_RADIX.UNSIGNED_DECIMAL
		)

		int_value.negative_bool = true

		assert_eq(
			signed_base43,
			arbitrary_base_43.signed2str(int_value.to_decimal())
		)

		int_value.negative_bool = false

		assert_eq(
			unsigned_base43,
			arbitrary_base_43.unsigned2str(int_value.to_decimal())
		)

