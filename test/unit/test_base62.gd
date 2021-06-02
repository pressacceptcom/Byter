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
# PressAccept_Byter_Base62 is behaving as expected given a variety of inputs.
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
# Class                  : Base62 Test
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
var Arbitrary     : Script = PressAccept_Byter_ArbitraryBase
# shorthand for our library class
var Base62 : Script = PressAccept_Byter_Base62

# |---------------|
# | Configuration |
# |---------------|

# random seed for deterministic randomized tests
var INT_RANDOM_SEED : int = hash('PressAccept_Byter_Base62')

# number of times to iterate each test
var INT_NUM_TESTS   : int = TestUtilities.INT_NUM_TESTS

# |-------|
# | Tests |
# |-------|
#
# Tests follow this format -
#
# static method   - test_<method_identifier>
#

func test_str2integer() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_decimal: String = int_value.to_decimal()
		
		var b62_value: PressAccept_Arbiter_Basic = Basic.new(comparison, 62)
		var b62_arr  : Array = b62_value.to_array()
		var b62_str  : String
		for digit in b62_arr:
			b62_str += Base62.ARR_PLACE_VALUES[digit]

		var test_value     = Base62.str2integer(b62_str)
		var test_value_obj = Base62.str2integer(b62_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		int_value.multiply(comparison)
		int_value_decimal = int_value.to_decimal()

		b62_value = Basic.new(int_value, 62)
		b62_arr   = b62_value.to_array()
		b62_str   = ''
		for digit in b62_arr:
			b62_str += Base62.ARR_PLACE_VALUES[digit]

		test_value     = Base62.str2integer(b62_str)
		test_value_obj = Base62.str2integer(b62_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)


func test_str2signed() -> void:

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

		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())

		var test_value     = Base62.str2signed(int_value_b62_str)
		var test_value_obj = Base62.str2signed(int_value_b62_str, false, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		test_value = Base62.str2signed(int_value_b62_str, true)

		var int_value_plus_one: PressAccept_Arbiter_Basic = \
			int_value.immutable_add(1)
		assert_eq(str(test_value), int_value_plus_one.to_decimal())
		
		int_value.multiply(comparison)
		int_value.negative_bool = true
		int_value_decimal       = int_value.to_decimal()
		
		int_value_b62_str = Binary.str2base62(int_value.to_binary())

		test_value     = Base62.str2signed(int_value_b62_str)
		test_value_obj = Base62.str2signed(int_value_b62_str, false, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)


func test_str2unsigned() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_decimal: String = int_value.to_decimal()

		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())

		var test_value     = Base62.str2unsigned(int_value_b62_str)
		var test_value_obj = Base62.str2unsigned(int_value_b62_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)

		int_value.multiply(comparison)
		int_value_decimal = int_value.to_decimal()

		int_value_b62_str = Binary.str2base62(int_value.to_binary())

		test_value     = Base62.str2unsigned(int_value_b62_str)
		test_value_obj = Base62.str2unsigned(int_value_b62_str, true)

		assert_typeof(test_value_obj, TYPE_OBJECT)

		assert_eq(str(test_value), int_value_decimal)
		assert_eq(test_value_obj.to_decimal(), int_value_decimal)


func test_integer2str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_decimal: String = int_value.to_decimal()
		
		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())

		var test_str: String = Base62.integer2str(comparison)

		assert_eq(test_str, int_value_b62_str)

		int_value.multiply(comparison)

		int_value_b62_str = Binary.str2base62(int_value.to_binary())

		test_str = Base62.integer2str(int_value.to_decimal())

		assert_eq(test_str, int_value_b62_str)


func test_signed2str() -> void:

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

		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())

		var test_str: String = Base62.signed2str(comparison)

		assert_eq(test_str, int_value_b62_str)

		int_value.multiply(comparison)
		int_value.negative_bool = true
		int_value_decimal       = int_value.to_decimal()

		int_value_b62_str = Binary.str2base62(int_value.to_binary())

		test_str = Base62.signed2str(int_value.to_decimal())

		assert_eq(test_str, int_value_b62_str)


func test_unsigned2str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_decimal: String = int_value.to_decimal()

		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())

		var test_str: String = Base62.unsigned2str(comparison)

		assert_eq(test_str, int_value_b62_str)

		int_value.multiply(comparison)
		int_value_decimal = int_value.to_decimal()

		int_value_b62_str = Binary.str2base62(int_value.to_binary())

		test_str = Base62.unsigned2str(int_value.to_decimal())

		assert_eq(test_str, int_value_b62_str)


func test_str2binary() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())

		var test_binary_str: String = Base62.str2binary(int_value_b62_str)

		assert_eq(test_binary_str, int_value.to_binary().lstrip('0'))

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true

		int_value_b62_str = Binary.str2base62(int_value.to_binary())

		test_binary_str = Base62.str2binary(int_value_b62_str)

		assert_eq(test_binary_str, int_value.to_binary().lstrip('0'))


func test_str2octal() -> void:

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

		var int_value_b62_str: String = Binary.str2base62(int_value_bin_str)

		var test_octal_str: String = \
			Base62.str2octal(int_value_b62_str, int_value.negative_bool)

		assert_eq(test_octal_str, int_value_octal_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true

		int_value_bin_str   = int_value.to_binary().lstrip('0')
		int_value_octal_str = \
			Binary.str2octal(int_value_bin_str, int_value.negative_bool)

		int_value_b62_str = Binary.str2base62(int_value_bin_str)

		test_octal_str = Base62.str2octal(
			int_value_b62_str,
			int_value.negative_bool
		)

		assert_eq(test_octal_str, int_value_octal_str)


func test_str2hexadecimal() -> void:

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

		var int_value_b62_str: String = Binary.str2base62(int_value_bin_str)

		var test_hexadecimal_str: String = \
			Base62.str2hexadecimal(int_value_b62_str, int_value.negative_bool)
		
		assert_eq(test_hexadecimal_str, int_value_hex_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true
		int_value_bin_str = int_value.to_binary().lstrip('0')
		int_value_hex_str = \
			Binary.str2hexadecimal(int_value_bin_str, int_value.negative_bool)

		int_value_b62_str = Binary.str2base62(int_value_bin_str)

		test_hexadecimal_str = \
			Base62.str2hexadecimal(int_value_b62_str, int_value.negative_bool)
		
		assert_eq(test_hexadecimal_str, int_value_hex_str)


func test_str2base36() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())
		var int_value_b36_str: String = \
			Binary.str2base36(int_value.to_binary())

		var test_str: String = Base62.str2base36(int_value_b62_str)

		assert_eq(test_str, int_value_b36_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true

		int_value_b62_str = Binary.str2base62(int_value.to_binary())
		int_value_b36_str = Binary.str2base36(int_value.to_binary())

		test_str = Base62.str2base36(int_value_b62_str)

		assert_eq(test_str, int_value_b36_str)


func test_str2arbitrary() -> void:

	var test_ArbitraryBase: Script = \
		load('res://addons/PressAccept/Byter/test/unit/test_ArbitraryBase.gd')
	
	var arbitrary_base_5  : PressAccept_Byter_ArbitraryBase = \
		Arbitrary.new(test_ArbitraryBase.STR_BASE_5)
	var arbitrary_base_43 : PressAccept_Byter_ArbitraryBase = \
		Arbitrary.new(test_ArbitraryBase.STR_BASE_43)

	var _5_func  : FuncRef = arbitrary_base_5.get_func()
	var _43_func : FuncRef = arbitrary_base_43.get_func()

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
			_5_func
		)

		var test_str: String = Base62.str2arbitrary(int_value_b62_str, _5_func)

		assert_eq(test_str, int_value_b5_str)

		var int_value_b43_str: String = Binary.str2arbitrary(
			int_value.to_binary(),
			_43_func
		)

		test_str = Base62.str2arbitrary(int_value_b62_str, _43_func)

		assert_eq(test_str, int_value_b43_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true

		int_value_b62_str = Binary.str2base62(int_value.to_binary())

		int_value_b5_str = Binary.str2arbitrary(int_value.to_binary(), _5_func)

		test_str = Base62.str2arbitrary(
			int_value_b62_str,
			_5_func
		)

		assert_eq(test_str, int_value_b5_str)

		int_value_b43_str = Binary.str2arbitrary(
			int_value.to_binary(),
			_43_func
		)

		test_str = Base62.str2arbitrary(int_value_b62_str, _43_func)

		assert_eq(test_str, int_value_b43_str)


func test_to_base62() -> void:

	var Formats      : Script     = PressAccept_Byter_Formats
	var ENUM_FORMATS : Dictionary = Formats.ENUM_FORMATS
	var ENUM_RADIX   : Dictionary = Formats.ENUM_RADIX

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var signed_base62: String = Base62.to_base62(
			comparison,
			ENUM_RADIX.SIGNED_DECIMAL
		)

		var unsigned_base62: String = Base62.to_base62(
			int(abs(comparison)),
			ENUM_RADIX.UNSIGNED_DECIMAL
		)

		assert_eq(signed_base62  , Base62.signed2str  (comparison))
		assert_eq(unsigned_base62, Base62.unsigned2str(int(abs(comparison))))

		signed_base62 = Base62.to_base62(
			str(comparison),
			ENUM_RADIX.SIGNED_DECIMAL
		)

		unsigned_base62 = Base62.to_base62(
			str(int(abs(comparison))),
			ENUM_RADIX.UNSIGNED_DECIMAL
		)

		assert_eq(signed_base62  , Base62.signed2str  (comparison))
		assert_eq(unsigned_base62, Base62.unsigned2str(int(abs(comparison))))

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_octal_str = int_value.to_signed_octal()

		var base62: String = Base62.to_base62(
			int_value_octal_str,
			ENUM_RADIX.OCTAL
		)

		assert_eq(base62, Octal.str2base62(int_value_octal_str))

		var int_value_hex_str = int_value.to_signed_hexadecimal()

		base62 = Base62.to_base62(
			int_value_hex_str,
			ENUM_RADIX.HEXADECIMAL
		)

		assert_eq(base62, Hex.str2base62(int_value_hex_str))

		var int_value_b36_str: String = \
			Binary.str2base36(int_value.to_binary())

		base62 = Base62.to_base62(
			int_value_b36_str,
			ENUM_RADIX.UNSIGNED_BASE_36
		)

		assert_eq(base62, Base36.str2base62(int_value_b36_str))

		var int_value_b62_str: String = \
			Binary.str2base62(int_value.to_binary())

		base62 = Base62.to_base62(
			int_value_b62_str,
			ENUM_RADIX.UNSIGNED_BASE_62
		)

		assert_eq(base62, int_value_b62_str)

		var int_value_arr: Array = Binary.str2array(int_value.to_binary())

		base62 = Base62.to_base62(
			int_value_arr,
			ENUM_RADIX.BINARY
		)

		assert_eq(base62, Binary.array2base62(int_value_arr))

		int_value.negative_bool = true

		signed_base62 = Base62.to_base62(
			int_value,
			ENUM_RADIX.SIGNED_DECIMAL
		)

		int_value.negative_bool = false

		unsigned_base62 = Base62.to_base62(
			int_value,
			ENUM_RADIX.UNSIGNED_DECIMAL
		)

		int_value.negative_bool = true

		assert_eq(signed_base62  , Base62.signed2str  (int_value.to_decimal()))

		int_value.negative_bool = false

		assert_eq(unsigned_base62, Base62.unsigned2str(int_value.to_decimal()))

