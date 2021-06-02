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
# PressAccept_Byter_Binary is behaving as expected given a variety of inputs.
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
# Class                  : BinaryTest
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
# 1.0    05/25/2021    First Release
#

# |---------|
# | Imports |
# |---------|

# see test/Utilities.gd
var TestUtilities : Script = PressAccept_Byter_Test_Utilities
var Basic         : Script = PressAccept_Arbiter_Basic
var Octal         : Script = PressAccept_Byter_Octal
var Hex           : Script = PressAccept_Byter_Hexadecimal
var Base36        : Script = PressAccept_Byter_Base36
var Base62        : Script = PressAccept_Byter_Base62
var Arbitrary     : Script = PressAccept_Byter_ArbitraryBase
# shorthand for our library class
var Binary        : Script = PressAccept_Byter_Binary

# |---------------|
# | Configuration |
# |---------------|

# random seed for deterministic randomized tests
var INT_RANDOM_SEED : int = hash('PressAccept_Byter_Binary')

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


func test_del_whitespace() -> void:

	var tests: Dictionary = {
		[ "10 011\t101\n111   0001\r\n\t 1" ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '1001110111100011'
			}
	}

	TestUtilities.batch(self, tests, funcref(Binary, 'enforce_binary'))


func test_enforce_binary() -> void:

	var tests: Dictionary = {
		[ 'a0 500r0 t0t 0', false ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '10110010110110'
			},
		[ 'a0 500r0 t0t 0', true ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '10100101010'
			}
	}

	TestUtilities.batch(self, tests, funcref(Binary, 'enforce_binary'))


func test_pad_ones() -> void:

	var tests: Dictionary = {
		[ '', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '11111111'
			},
		[ '01010101', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '01010101'
			},
		[ '010101010', 11 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '11010101010'
			},
		[ '', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '11111'
			},
		[ '01010', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '01010'
			},
		[ '0101010', 10 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '1110101010'
			}
	}

	TestUtilities.batch(self, tests, funcref(Binary, 'pad_ones'))


func test_pad_to_byte() -> void:

	var tests: Dictionary = {
		[ '', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '00000000'
			},
		[ '01010101', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '01010101'
			},
		[ '010101010', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '0000000010101010'
			},
		[ '00101010101010101', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '000000000101010101010101'
			},
		[ '', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '00000'
			},
		[ '01010', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '01010'
			},
		[ '0101010', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '0000101010'
			},
		[ '1010101010101', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '001010101010101'
			},
		[ '', 5, 'X' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : 'XXXXX'
			},
		[ '01010', 5, 'X' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '01010'
			},
		[ '0101010', 5, 'X' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : 'XXX0101010'
			},
		[ '1010101010101', 5, 'X' ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : 'XX1010101010101'
			}
	}

	TestUtilities.batch(self, tests, funcref(Binary, 'pad_to_byte'))


func test_pad_to_byte_signed() -> void:

	var tests: Dictionary = {
		[ '', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '11111111'
			},
		[ '01010101', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '01010101'
			},
		[ '010101010', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '1111111010101010'
			},
		[ '00101010101010101', 8 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '111111100101010101010101'
			},
		[ '', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '11111'
			},
		[ '01010', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '01010'
			},
		[ '0101010', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '1110101010'
			},
		[ '1010101010101', 5 ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '111010101010101'
			}
	}

	TestUtilities.batch(self, tests, funcref(Binary, 'pad_to_byte_signed'))


func test_str2array() -> void:

	var tests: Dictionary = {
		['01011010']:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION :
					[ false, true,  false, true,  true,  false, true, false ]
			},
		['10100111']:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION :
					[ true,  false, true,  false, false, true,  true, true  ]
			},
		["0a0h 0\t0", false]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION :
					[ false, true, false,  true,  true,  false, true, false ]
			},
		["0a0h 0\t0", true]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION :
					[ false, true, false,  true,  false, false ]
			}
	}

	TestUtilities.batch(self, tests, funcref(Binary, 'str2array'))


func test_array2str() -> void:

	var tests: Dictionary = {
		[ [ false, true,    false, true,  true,  false,  true, false ] ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '01011010'
			},
		[ [ true,  false,   true,  false, false, true,   true, true  ] ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '10100111'
			},
		[ [ 1,     0,       1,     1,     0,     1,      0,    0     ] ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '10110100'
			},
		[ [ false, 'false', true,  false, false, 'true', true, -1    ] ]:
			{
				TestUtilities.ASSERTION   : TestUtilities.EQUALS,
				TestUtilities.EXPECTATION : '01100111'
			}
	}

	TestUtilities.batch(self, tests, funcref(Binary, 'array2str'))


func test_str2signed() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_decimal: String = int_value.to_decimal()

		assert_eq(
			str(Binary.str2signed(int_value.to_binary())),
			int_value_decimal
		)

		if int_value.negative_bool:
			var int_value_plus_one: PressAccept_Arbiter_Basic = \
				int_value.immutable_add(1)
			assert_eq(
				str(Binary.str2signed(
					int_value.to_binary(),
					false, # enforce_binary
					true   # ones_complement
				)),
				int_value_plus_one.to_decimal()
			)

		var return_value = Binary.str2signed(
			int_value.to_binary(),
			false, # enforce_binary
			false, # ones_complement
			true   # return_object
		)

		assert_typeof(return_value, TYPE_OBJECT)
		assert_eq(return_value.to_decimal(), int_value_decimal)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true
		int_value_decimal = int_value.to_decimal()

		var test = Binary.str2signed(int_value.to_binary())
		assert_eq(str(test), int_value_decimal)

		if int_value.negative_bool:
			var int_value_plus_one: PressAccept_Arbiter_Basic = \
				int_value.immutable_add(1)
			assert_eq(
				str(Binary.str2signed(
					int_value.to_binary(),
					false, # enforce_binary
					true   # ones_complement
				)),
				int_value_plus_one.to_decimal()
			)

		var wrong_binary: String = int_value.to_binary()
		wrong_binary = wrong_binary.replace('1', 'x')

		assert_eq(
			str(Binary.str2signed(wrong_binary, true)),
			int_value_decimal
		)


func test_array2signed() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_arr     : Array  = \
			Binary.str2array(int_value.to_binary())
		var int_value_decimal : String = int_value.to_decimal()

		assert_eq(
			str(Binary.array2signed(int_value_arr)),
			int_value_decimal
		)

		if comparison < 0:
			var int_value_plus_one: PressAccept_Arbiter_Basic = \
				int_value.immutable_add(1)
			assert_eq(
				str(Binary.array2signed(
					int_value_arr,
					true   # ones_complement
				)),
				int_value_plus_one.to_decimal()
			)

		var return_value = Binary.array2signed(
			int_value_arr,
			false, # ones_complement
			true   # return_object
		)

		assert_typeof(return_value, TYPE_OBJECT)
		assert_eq(return_value.to_decimal(), int_value_decimal)

		int_value.multiply(comparison)
		int_value_decimal = int_value.to_decimal()
		int_value_arr = Binary.str2array(int_value.to_binary())

		var test = Binary.array2signed(int_value_arr)

		assert_eq(str(test), int_value_decimal)


func test_str2unsigned() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_decimal: String = int_value.to_decimal()

		assert_eq(
			str(Binary.str2unsigned(int_value.to_binary())),
			int_value_decimal
		)

		var return_value = Binary.str2unsigned(
			int_value.to_binary(),
			false, # enforce_binary
			true   # return_object
		)

		assert_typeof(return_value, TYPE_OBJECT)
		assert_eq(return_value.to_decimal(), int_value_decimal)

		int_value.multiply(comparison)
		int_value_decimal = int_value.to_decimal()

		var test = Binary.str2unsigned(int_value.to_binary())
		assert_eq(str(test), int_value_decimal)

		var wrong_binary: String = int_value.to_binary()
		wrong_binary = wrong_binary.replace('1', 'x')

		assert_eq(
			str(Binary.str2unsigned(wrong_binary, true)),
			int_value_decimal
		)


func test_str2octal() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_octal: String = int_value.to_signed_octal().lstrip('0')

		var test_str: String = Binary.str2octal(
			int_value.to_binary().lstrip('0'),
			int_value.negative_bool
		)

		assert_eq(test_str, int_value_octal)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true
		int_value_octal = int_value.to_signed_octal().lstrip('0')

		test_str = Binary.str2octal(
			int_value.to_binary().lstrip('0'),
			int_value.negative_bool
		)
		
		assert_eq(test_str, int_value_octal)


func test_str2hexadecimal() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_hexadecimal: String = \
			int_value.to_signed_hexadecimal().lstrip('0')

		var test_str: String = Binary.str2hexadecimal(
			int_value.to_binary().lstrip('0'),
			int_value.negative_bool
		)

		assert_eq(test_str, int_value_hexadecimal)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true
		int_value_hexadecimal = int_value.to_signed_hexadecimal().lstrip('0')

		test_str = Binary.str2hexadecimal(
			int_value.to_binary().lstrip('0'),
			int_value.negative_bool
		)

		assert_eq(test_str, int_value_hexadecimal)


func _create_signed_base_string(
		int_value: PressAccept_Arbiter_Basic,
		module) -> String:

	var ret: String
	if int_value.negative_bool:
		ret = module.signed2str(int_value.to_decimal())
	else:
		ret = module.unsigned2str(int_value.to_decimal())

	return ret


func test_str2base36() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_b36_str : String = \
			_create_signed_base_string(int_value, Base36)
		var test_str          : String = \
			Binary.str2base36(int_value.to_binary())

		assert_eq(test_str, int_value_b36_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true
		int_value_b36_str = _create_signed_base_string(int_value, Base36)
		
		test_str          = Binary.str2base36(int_value.to_binary())

		assert_eq(test_str, int_value_b36_str)


func test_str2base62() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_b62_str : String = \
			_create_signed_base_string(int_value, Base62)
		var test_str          : String = \
			Binary.str2base62(int_value.to_binary())

		assert_eq(test_str, int_value_b62_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true
		int_value_b62_str = _create_signed_base_string(int_value, Base62)
		
		test_str          = Binary.str2base62(int_value.to_binary())

		assert_eq(test_str, int_value_b62_str)


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

		var int_value_b5_str : String = \
			_create_signed_base_string(int_value, arbitrary_base_5)
		var test_str         : String = Binary.str2arbitrary(
			int_value.to_binary(),
			_5_func
		)

		assert_eq(test_str, int_value_b5_str)

		var int_value_b43_str : String = \
			_create_signed_base_string(int_value, arbitrary_base_43)
		test_str = Binary.str2arbitrary(int_value.to_binary(), _43_func)

		assert_eq(test_str, int_value_b43_str)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true

		int_value_b5_str = _create_signed_base_string(
			int_value,
			arbitrary_base_5
		)

		test_str = Binary.str2arbitrary(int_value.to_binary(), _5_func)

		assert_eq(test_str, int_value_b5_str)

		int_value_b43_str = _create_signed_base_string(
			int_value,
			arbitrary_base_43
		)

		test_str = Binary.str2arbitrary(int_value.to_binary(), _43_func)

		assert_eq(test_str, int_value_b43_str)


func _pad_truncate_int_value(
		negative         : bool,
		int_value_binary : String,
		size             : int) -> String:

	if int_value_binary.length() < size:
		if negative:
			for i in range(size - int_value_binary.length()):
				int_value_binary = '1' + int_value_binary
		else:
			int_value_binary = int_value_binary.pad_zeros(size)
	else:
		int_value_binary = int_value_binary.substr(
			int_value_binary.length() - size
		)

	return int_value_binary


func test_signed2str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_decimal: String = int_value.to_decimal()

		var test_str   : String = Binary.signed2str(comparison, -1)
		var test_str_2 : String = Binary.signed2str(int_value_decimal, -1)

		assert_eq(test_str  , int_value.to_binary())
		assert_eq(test_str_2, int_value.to_binary())

		# 1s-complement
		test_str   = Binary.signed2str(comparison, -1, true)
		test_str_2 = Binary.signed2str(int_value_decimal, -1, true)

		# 1s-complement
		if int_value.negative_bool:
			int_value.add(1)

		assert_eq(test_str  , int_value.to_binary())
		assert_eq(test_str_2, int_value.to_binary())

		# reset int_value
		int_value.set_value(comparison)
		test_str   = Binary.signed2str(comparison, 80)
		test_str_2 = Binary.signed2str(int_value_decimal, 80)

		var int_value_binary: String = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			80
		)

		assert_eq(test_str  , int_value_binary)
		assert_eq(test_str_2, int_value_binary)

		test_str   = Binary.signed2str(comparison)
		test_str_2 = Binary.signed2str(int_value_decimal)

		int_value.set_value(comparison)
		int_value_binary = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			Binary.INT_MAX_BITS
		)

		assert_eq(test_str  , int_value_binary)
		assert_eq(test_str_2, int_value_binary)

		test_str   = Binary.signed2str(comparison, 16)
		test_str_2 = Binary.signed2str(int_value_decimal, 16)

		int_value_binary = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			16
		)

		assert_eq(test_str  , int_value_binary)
		assert_eq(test_str_2, int_value_binary)

		int_value.multiply(comparison)
		if random.randi_range(0, 1) < 1:
			int_value.negative_bool = true
		int_value_decimal = int_value.to_decimal()

		test_str = Binary.signed2str(int_value_decimal, -1)

		assert_eq(test_str, int_value.to_binary())

		test_str = Binary.signed2str(int_value_decimal)

		int_value_binary = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			Binary.INT_MAX_BITS
		)

		assert_eq(test_str, int_value_binary)

		test_str = Binary.signed2str(int_value_decimal, 16)

		int_value_binary = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			16
		)

		assert_eq(test_str, int_value_binary)


func test_unsigned2str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var int_value_decimal: String = int_value.to_decimal()

		var test_str   : String = Binary.unsigned2str(comparison, -1)
		var test_str_2 : String = Binary.unsigned2str(int_value_decimal, -1)

		# unsigned2str strips leading zeros
		assert_eq(test_str  , int_value.to_binary())
		assert_eq(test_str_2, int_value.to_binary())

		test_str   = Binary.unsigned2str(comparison, 80)
		test_str_2 = Binary.unsigned2str(int_value_decimal, 80)

		var int_value_binary: String = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			80
		)

		# unsigned2str strips leading zeros
		assert_eq(test_str  , int_value_binary)
		assert_eq(test_str_2, int_value_binary)

		test_str   = Binary.unsigned2str(comparison)
		test_str_2 = Binary.unsigned2str(int_value_decimal)

		int_value_binary = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			Binary.INT_MAX_BITS
		)

		# unsigned2str strips leading zeros
		assert_eq(test_str  , int_value_binary)
		assert_eq(test_str_2, int_value_binary)

		test_str   = Binary.unsigned2str(comparison, 16)
		test_str_2 = Binary.unsigned2str(int_value_decimal, 16)

		int_value_binary = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			16
		)

		# unsigned2str strips leading zeros
		assert_eq(test_str  , int_value_binary)
		assert_eq(test_str_2, int_value_binary)

		int_value.multiply(comparison)
		int_value_decimal = int_value.to_decimal()

		test_str = Binary.unsigned2str(int_value_decimal, -1)

		# unsigned2str strips leading zeros
		assert_eq(test_str, int_value.to_binary())

		test_str = Binary.unsigned2str(int_value_decimal) # 64 bits

		int_value_binary = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			Binary.INT_MAX_BITS
		)

		assert_eq(test_str, int_value_binary)

		test_str = Binary.unsigned2str(int_value_decimal, 16)

		int_value_binary = _pad_truncate_int_value(
			int_value.negative_bool,
			int_value.to_binary(),
			16
		)

		assert_eq(test_str, int_value_binary)


func test_to_binary() -> void:

	var Formats      : Script     = PressAccept_Byter_Formats
	var ENUM_FORMATS : Dictionary = Formats.ENUM_FORMATS
	var ENUM_RADIX   : Dictionary = Formats.ENUM_RADIX

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var signed_binary = Binary.to_binary(
			comparison,
			ENUM_RADIX.SIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.STRING
		)

		var signed_array = Binary.to_binary(
			comparison,
			ENUM_RADIX.SIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.ARRAY
		)

		var unsigned_binary = Binary.to_binary(
			int(abs(comparison)),
			ENUM_RADIX.UNSIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.STRING
		)

		var unsigned_array = Binary.to_binary(
			int(abs(comparison)),
			ENUM_RADIX.UNSIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.ARRAY
		)

		assert_typeof(signed_binary, TYPE_STRING)
		assert_typeof(signed_array , TYPE_ARRAY )

		assert_typeof(unsigned_binary, TYPE_STRING)
		assert_typeof(unsigned_array , TYPE_ARRAY )

		assert_eq(signed_binary, Binary.signed2str  (comparison, -1))
		assert_eq(signed_array , Binary.signed2array(comparison, -1))

		assert_eq(
			unsigned_binary,
			Binary.unsigned2str(int(abs(comparison)), -1)
		)

		assert_eq(
			unsigned_array,
			Binary.unsigned2array(int(abs(comparison)), -1)
		)

		signed_binary = Binary.to_binary(
			str(comparison),
			ENUM_RADIX.SIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.STRING
		)

		signed_array = Binary.to_binary(
			str(comparison),
			ENUM_RADIX.SIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.ARRAY
		)

		unsigned_binary = Binary.to_binary(
			str(int(abs(comparison))),
			ENUM_RADIX.UNSIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.STRING
		)

		unsigned_array = Binary.to_binary(
			str(int(abs(comparison))),
			ENUM_RADIX.UNSIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.ARRAY
		)

		assert_typeof(signed_binary, TYPE_STRING)
		assert_typeof(signed_array , TYPE_ARRAY )

		assert_typeof(unsigned_binary, TYPE_STRING)
		assert_typeof(unsigned_array , TYPE_ARRAY )

		assert_eq(signed_binary, Binary.signed2str  (comparison, -1))
		assert_eq(signed_array , Binary.signed2array(comparison, -1))

		assert_eq(
			unsigned_binary,
			Binary.unsigned2str(int(abs(comparison)), -1)
		)

		assert_eq(
			unsigned_array,
			Binary.unsigned2array(int(abs(comparison)), -1)
		)

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)
		
		var int_value_octal_str: String = \
			int_value.to_signed_octal().lstrip('0')

		var binary = Binary.to_binary(
			int_value_octal_str,
			ENUM_RADIX.OCTAL,
			-1,
			ENUM_FORMATS.STRING
		)

		var array = Binary.to_binary(
			int_value_octal_str,
			ENUM_RADIX.OCTAL,
			-1,
			ENUM_FORMATS.ARRAY
		)

		assert_typeof(binary, TYPE_STRING)
		assert_typeof(array , TYPE_ARRAY )

		assert_eq(binary, Octal.str2binary(int_value_octal_str, true))
		assert_eq(
			array,
			Binary.str2array(Octal.str2binary(int_value_octal_str, true))
		)

		var int_value_hex_str = int_value.to_signed_hexadecimal().lstrip('0')

		binary = Binary.to_binary(
			int_value_hex_str,
			ENUM_RADIX.HEXADECIMAL,
			-1,
			ENUM_FORMATS.STRING
		)

		array = Binary.to_binary(
			int_value_hex_str,
			ENUM_RADIX.HEXADECIMAL,
			-1,
			ENUM_FORMATS.ARRAY
		)

		assert_typeof(binary, TYPE_STRING)
		assert_typeof(array , TYPE_ARRAY )

		assert_eq(binary, Hex.str2binary(int_value_hex_str, true))
		assert_eq(
			array,
			Binary.str2array(Hex.str2binary(int_value_hex_str, true))
		)

		var int_value_b36_value: PressAccept_Arbiter_Basic = \
			Basic.new(int_value, 36)

		var int_value_b36_arr : Array = int_value_b36_value.to_array()
		var int_value_b36_str: String
		for digit in int_value_b36_arr:
			int_value_b36_str += Base36.ARR_PLACE_VALUES[digit]

		binary = Binary.to_binary(
			int_value_b36_str,
			ENUM_RADIX.UNSIGNED_BASE_36,
			-1,
			ENUM_FORMATS.STRING
		)

		array = Binary.to_binary(
			int_value_b36_str,
			ENUM_RADIX.UNSIGNED_BASE_36,
			-1,
			ENUM_FORMATS.ARRAY
		)

		assert_typeof(binary, TYPE_STRING)
		assert_typeof(array , TYPE_ARRAY )

		assert_eq(binary, Base36.str2binary(int_value_b36_str))
		assert_eq(
			array,
			Binary.str2array(Base36.str2binary(int_value_b36_str))
		)

		binary = Binary.to_binary(
			int_value_b36_str,
			ENUM_RADIX.SIGNED_BASE_36,
			-1,
			ENUM_FORMATS.STRING
		)

		array = Binary.to_binary(
			int_value_b36_str,
			ENUM_RADIX.SIGNED_BASE_36,
			-1,
			ENUM_FORMATS.ARRAY
		)

		assert_typeof(binary, TYPE_STRING)
		assert_typeof(array , TYPE_ARRAY )

		assert_eq(binary, Base36.str2binary(int_value_b36_str))
		assert_eq(
			array,
			Binary.str2array(Base36.str2binary(int_value_b36_str))
		)

		var int_value_b62_value: PressAccept_Arbiter_Basic = \
			Basic.new(int_value, 62)

		var int_value_b62_arr : Array = int_value_b62_value.to_array()
		var int_value_b62_str : String
		for digit in int_value_b62_arr:
			int_value_b62_str += Base62.ARR_PLACE_VALUES[digit]

		binary = Binary.to_binary(
			int_value_b62_str,
			ENUM_RADIX.UNSIGNED_BASE_62,
			-1,
			ENUM_FORMATS.STRING
		)

		array = Binary.to_binary(
			int_value_b62_str,
			ENUM_RADIX.UNSIGNED_BASE_62,
			-1,
			ENUM_FORMATS.ARRAY
		)

		assert_typeof(binary, TYPE_STRING)
		assert_typeof(array , TYPE_ARRAY )

		assert_eq(binary, Base62.str2binary(int_value_b62_str))
		assert_eq(
			array,
			Binary.str2array(Base62.str2binary(int_value_b62_str))
		)

		binary = Binary.to_binary(
			int_value_b62_str,
			ENUM_RADIX.SIGNED_BASE_62,
			-1,
			ENUM_FORMATS.STRING
		)

		array = Binary.to_binary(
			int_value_b62_str,
			ENUM_RADIX.SIGNED_BASE_62,
			-1,
			ENUM_FORMATS.ARRAY
		)

		assert_typeof(binary, TYPE_STRING)
		assert_typeof(array , TYPE_ARRAY )

		assert_eq(binary, Base62.str2binary(int_value_b62_str))
		assert_eq(
			array,
			Binary.str2array(Base62.str2binary(int_value_b62_str))
		)

		var int_value_arr: Array = Binary.str2array(int_value.to_binary())

		binary = Binary.to_binary(
			int_value_arr,
			ENUM_RADIX.BINARY,
			-1,
			ENUM_FORMATS.STRING
		)

		assert_typeof(binary, TYPE_STRING)
		assert_eq(binary, Binary.signed2str(int(int_value.to_decimal()), -1))

		int_value.negative_bool = true

		signed_binary = Binary.to_binary(
			int_value,
			ENUM_RADIX.SIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.STRING
		)

		signed_array = Binary.to_binary(
			int_value,
			ENUM_RADIX.SIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.ARRAY
		)

		int_value.negative_bool = false

		unsigned_binary = Binary.to_binary(
			int_value,
			ENUM_RADIX.UNSIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.STRING
		)

		unsigned_array = Binary.to_binary(
			int_value,
			ENUM_RADIX.UNSIGNED_DECIMAL,
			-1,
			ENUM_FORMATS.ARRAY
		)

		assert_typeof(signed_binary, TYPE_STRING)
		assert_typeof(signed_array , TYPE_ARRAY )

		assert_typeof(unsigned_binary, TYPE_STRING)
		assert_typeof(unsigned_array , TYPE_ARRAY )

		int_value.negative_bool = true

		assert_eq(
			signed_binary,
			Binary.signed2str  (int_value.to_decimal(), -1)
		)

		assert_eq(
			signed_array,
			Binary.signed2array(int_value.to_decimal(), -1)
		)

		int_value.negative_bool = false

		assert_eq(
			unsigned_binary,
			Binary.unsigned2str  (int_value.to_decimal(), -1)
		)

		assert_eq(
			unsigned_array,
			Binary.unsigned2array(int_value.to_decimal(), -1)
		)

