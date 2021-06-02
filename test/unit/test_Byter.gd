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
# PressAccept_Byter_Byter is behaving as expected given a variety of inputs.
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
# Class                  : Byter Test
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
var Byter: Script = PressAccept_Byter_Byter

# |---------------|
# | Configuration |
# |---------------|

# random seed for deterministic randomized tests
var INT_RANDOM_SEED : int = hash('PressAccept_Byter_ArbitraryBase')

# number of times to iterate each test
var INT_NUM_TESTS   : int = TestUtilities.INT_NUM_TESTS

# |-------|
# | Tests |
# |-------|
#
# Tests follow this format -
#
# static method   - test_<method identifier>
# instance method - test_byter_<method identifier>
# signal          - test_byter_signal_<signal identifier>
#


func test_byter_signal_resized() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var comparison: int = random.randi()
	comparison  = comparison << 32
	comparison += random.randi()

	var byter: PressAccept_Byter_Byter = Byter.new(comparison)

	watch_signals(byter)

	byter.size = -1
	assert_signal_emitted_with_parameters(
		byter,
		'resized',
		[ -1, Binary.INT_MAX_BITS, byter ]
	)

	byter.set_size(32)
	assert_signal_emitted_with_parameters(
		byter,
		'resized',
		[ 32, -1, byter ]
	)

	byter.resize(42)
	assert_signal_emitted_with_parameters(
		byter,
		'resized',
		[ 42, 32, byter ]
	)


func test_byter_signal_value_changed() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var comparison: int = random.randi()
	comparison  = comparison << 32
	comparison += random.randi()

	var byter: PressAccept_Byter_Byter = Byter.new(comparison)

	watch_signals(byter)

	var new_value: int = comparison - random.randi()
	byter.value = new_value
	assert_eq(byter.value.to_decimal(), str(new_value))
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ str(comparison), str(new_value), byter ]
	)

	var new_basic: PressAccept_Arbiter_Basic = \
		Basic.new(new_value + random.randi())
	byter.value = new_basic
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ str(new_value), new_basic.to_decimal(), byter ]
	)

	var old_value: String = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	byter.value.set_value(new_basic)
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	byter.signed_binary_str = new_basic.to_binary()
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	new_basic.negative_bool = false
	byter.unsigned_binary_str = new_basic.to_binary()
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	byter.signed_binary_array = Binary.str2array(new_basic.to_binary())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	new_basic.negative_bool = false
	byter.unsigned_binary_array = Binary.str2array(new_basic.to_binary())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_value = comparison + random.randi()
	byter.decimal_str = str(new_value)
	assert_eq(byter.value.to_decimal(), str(new_value))
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, str(new_value), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())		
	var octal_str: String = Octal.signed2str(new_basic.to_decimal())
	byter.signed_octal_str = octal_str
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	new_basic.negative_bool = false
	octal_str = Octal.signed2str(new_basic.to_decimal())
	byter.unsigned_octal_str = octal_str
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	var hex_str: String = Hex.signed2str(new_basic.to_decimal())
	byter.signed_hexadecimal_str = hex_str
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	new_basic.negative_bool = false
	hex_str = Hex.signed2str(new_basic.to_decimal())
	byter.unsigned_hexadecimal_str = hex_str
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	new_basic.negative_bool = true
	byter.signed_base36_str = Base36.signed2str(new_basic.to_decimal())
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	new_basic.negative_bool = false
	byter.unsigned_base36_str = Base36.signed2str(new_basic.to_decimal())
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	new_basic.negative_bool = true
	byter.signed_base62_str = Base62.signed2str(new_basic.to_decimal())
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)

	old_value = byter.decimal_str
	new_basic = Basic.new(new_value + random.randi())
	new_basic.negative_bool = false
	byter.unsigned_base62_str = Base62.signed2str(new_basic.to_decimal())
	assert_eq(byter.value.to_decimal(), new_basic.to_decimal())
	assert_signal_emitted_with_parameters(
		byter,
		'value_changed',
		[ old_value, new_basic.to_decimal(), byter ]
	)


func test_byter_signal_calculated_value() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var comparison: int = random.randi()
	comparison  = comparison << 32
	comparison += random.randi()

	var byter: PressAccept_Byter_Byter = Byter.new(comparison)

	watch_signals(byter)

	var binary_str: String = byter.unsigned_binary_str
	binary_str = byter.unsigned_binary_str
	assert_signal_emit_count(byter, 'calculated_value', 1)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_STR, binary_str, byter ]
	)

	binary_str = byter.signed_binary_str
	binary_str = byter.signed_binary_str
	assert_signal_emit_count(byter, 'calculated_value', 2)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.SIGNED_BINARY_STR, binary_str, byter ]
	)

	var binary_array: Array = byter.unsigned_binary_array
	binary_array = byter.unsigned_binary_array
	assert_signal_emit_count(byter, 'calculated_value', 3)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY, binary_array, byter ]
	)

	binary_array = byter.signed_binary_array
	binary_array = byter.signed_binary_array
	assert_signal_emit_count(byter, 'calculated_value', 4)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.SIGNED_BINARY_ARRAY, binary_array, byter ]
	)

	var octal_str: String = byter.unsigned_octal_str
	octal_str = byter.unsigned_octal_str
	assert_signal_emit_count(byter, 'calculated_value', 5)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.UNSIGNED_OCTAL, octal_str, byter ]
	)

	octal_str = byter.signed_octal_str
	octal_str = byter.signed_octal_str
	assert_signal_emit_count(byter, 'calculated_value', 6)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.SIGNED_OCTAL, octal_str, byter ]
	)

	var decimal_str = byter.decimal_str
	decimal_str = byter.decimal_str
	assert_signal_emit_count(byter, 'calculated_value', 7)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.DECIMAL, decimal_str, byter ]
	)

	var hexadecimal_str: String = byter.unsigned_hexadecimal_str
	hexadecimal_str = byter.unsigned_hexadecimal_str
	assert_signal_emit_count(byter, 'calculated_value', 8)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL, hexadecimal_str, byter ]
	)

	hexadecimal_str = byter.signed_hexadecimal_str
	hexadecimal_str = byter.signed_hexadecimal_str
	assert_signal_emit_count(byter, 'calculated_value', 9)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.SIGNED_HEXADECIMAL, hexadecimal_str, byter ]
	)

	var base36_str: String = byter.unsigned_base36_str
	base36_str = byter.unsigned_base36_str
	assert_signal_emit_count(byter, 'calculated_value', 10)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.UNSIGNED_BASE_36, base36_str, byter ]
	)

	base36_str = byter.signed_base36_str
	base36_str = byter.signed_base36_str
	assert_signal_emit_count(byter, 'calculated_value', 11)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.SIGNED_BASE_36, base36_str, byter ]
	)

	var base62_str: String = byter.unsigned_base62_str
	base62_str = byter.unsigned_base62_str
	assert_signal_emit_count(byter, 'calculated_value', 12)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.UNSIGNED_BASE_62, base62_str, byter ]
	)

	base62_str = byter.signed_base62_str
	base62_str = byter.signed_base62_str
	assert_signal_emit_count(byter, 'calculated_value', 13)
	assert_signal_emitted_with_parameters(
		byter,
		'calculated_value',
		[ Byter.ENUM_OUTPUTS.SIGNED_BASE_62, base62_str, byter ]
	)


func test_byter_init() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var byter: PressAccept_Byter_Byter = Byter.new(comparison)

		assert_eq(byter.value.to_decimal(), str(comparison))

		byter = Byter.new(str(comparison))

		assert_eq(byter.value.to_decimal(), str(comparison))

		var int_arr: Array = Basic.unsigned_int_to_array(int(abs(comparison)))

		byter = Byter.new(int_arr, Basic.INT_BYTE_BASE)

		assert_eq(byter.value.to_decimal(), str(int(abs(comparison))))

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		byter = Byter.new(int_value)

		assert_eq(byter.value.to_decimal(), str(comparison))

		int_value.base_int = random.randi_range(5, 256)

		byter = Byter.new(int_value)

		assert_eq(byter.value.to_decimal(), str(comparison))


func _pad_truncate_string(
		input_str : String,
		size      : int) -> String:

	var input_len: int = input_str.length()

	if input_len > size:
		return input_str.substr(input_len - size)
	else:
		return input_str.pad_zeros(size)


func test_byter_re_size() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		basic.multiply(comparison)

		var binary_str: String = basic.to_binary()

		var byter: PressAccept_Byter_Byter   = Byter.new(basic)
		byter.size = -1

		assert_eq(byter.signed_binary_str, basic.to_binary())

		byter.size = 80

		var comparison_str: String = _pad_truncate_string(binary_str, 80)

		assert_eq(byter.signed_binary_str, comparison_str)

		byter.set_size(72)

		comparison_str = _pad_truncate_string(binary_str, 72)

		assert_eq(byter.signed_binary_str, comparison_str)

		byter.resize(8)

		comparison_str = _pad_truncate_string(binary_str, 8)

		assert_eq(byter.signed_binary_str, comparison_str)

		byter.resize(3).set_size(5).size = 7

		comparison_str = _pad_truncate_string(binary_str, 7)

		assert_eq(byter.signed_binary_str, comparison_str)


func test_byter_enforce_binary() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var comparison: int = random.randi()
	comparison  = comparison << 32
	comparison += random.randi()

	var basic      : PressAccept_Arbiter_Basic = Basic.new(comparison)
	var binary_str : String = basic.to_binary()
	binary_str = binary_str.replace('1', 'x')

	var byter: PressAccept_Byter_Byter = Byter.new(0)
	byter.enforce_binary = true

	byter.signed_binary_str = binary_str
	assert_eq(byter.decimal_str, basic.to_decimal())

	byter.set_enforce_binary(false).enforce_binary = true
	assert_true(byter.enforce_binary)

	byter.enforce_binary = false
	assert_false(byter.enforce_binary)


func test_ones_complement() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		if comparison > 0:
			comparison *= -1

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)

		var binary_str : String = basic.to_binary()
		var byter      : PressAccept_Byter_Byter = Byter.new(0)

		byter.ones_complement = true

		byter.signed_binary_str = binary_str
		assert_eq(int(byter.decimal_str), comparison + 1)

		byter.ones_complement = false
		byter.signed_binary_str = binary_str
		assert_eq(int(byter.decimal_str), comparison)

		byter.set_ones_complement(true).ones_complement = false

		assert_false(byter.ones_complement)


func test_set_value() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var byter: PressAccept_Byter_Byter = Byter.new(comparison)

		assert_eq(byter.value.to_decimal(), str(comparison))

		byter.set_value(str(comparison))

		assert_eq(byter.value.to_decimal(), str(comparison))

		var int_arr: Array = Basic.unsigned_int_to_array(int(abs(comparison)))

		byter.set_value(int_arr, Basic.INT_BYTE_BASE)

		assert_eq(byter.value.to_decimal(), str(int(abs(comparison))))

		var int_value: PressAccept_Arbiter_Basic = Basic.new(comparison)

		byter.set_value(int_value)

		assert_eq(byter.value.to_decimal(), str(comparison))

		int_value.base_int = random.randi_range(5, 256)

		byter.set_value(int_value)

		assert_eq(byter.value.to_decimal(), str(comparison))


func test_unsigned_binary_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var unsigned_binary_str = Binary.unsigned2str(comparison)

		assert_eq(byter.get_unsigned_binary_str(), unsigned_binary_str)
		assert_eq(byter.unsigned_binary_str      , unsigned_binary_str)

		basic.multiply(comparison)
		unsigned_binary_str = Binary.unsigned2str(basic.to_decimal())

		byter.unsigned_binary_str = unsigned_binary_str
		assert_eq(byter.get_unsigned_binary_str(), unsigned_binary_str)
		assert_eq(byter.unsigned_binary_str      , unsigned_binary_str)

		basic.add(comparison)
		unsigned_binary_str = Binary.unsigned2str(basic.to_decimal())

		byter.set_unsigned_binary_str(unsigned_binary_str)
		assert_eq(byter.get_unsigned_binary_str(), unsigned_binary_str)
		assert_eq(byter.unsigned_binary_str      , unsigned_binary_str)

		byter.set_unsigned_binary_str('0').unsigned_binary_str = \
			unsigned_binary_str
		assert_eq(byter.get_unsigned_binary_str(), unsigned_binary_str)
		assert_eq(byter.unsigned_binary_str      , unsigned_binary_str)


func test_signed_binary_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var signed_binary_str = Binary.signed2str(comparison)

		assert_eq(byter.get_signed_binary_str(), signed_binary_str)
		assert_eq(byter.signed_binary_str      , signed_binary_str)

		basic.multiply(comparison)
		signed_binary_str = Binary.signed2str(basic.to_decimal())

		byter.signed_binary_str = signed_binary_str
		assert_eq(byter.get_signed_binary_str(), signed_binary_str)
		assert_eq(byter.signed_binary_str      , signed_binary_str)

		basic.add(comparison)
		signed_binary_str = Binary.signed2str(basic.to_decimal())

		byter.set_signed_binary_str(signed_binary_str)
		assert_eq(byter.get_signed_binary_str(), signed_binary_str)
		assert_eq(byter.signed_binary_str      , signed_binary_str)

		byter.set_signed_binary_str('0').signed_binary_str = signed_binary_str
		assert_eq(byter.get_signed_binary_str(), signed_binary_str)
		assert_eq(byter.signed_binary_str      , signed_binary_str)


func test_unsigned_binary_array() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var unsigned_binary_array = Binary.unsigned2array(comparison)

		assert_eq(byter.get_unsigned_binary_array(), unsigned_binary_array)
		assert_eq(byter.unsigned_binary_array      , unsigned_binary_array)

		basic.multiply(comparison)
		unsigned_binary_array = Binary.unsigned2array(basic.to_decimal())

		byter.unsigned_binary_array = unsigned_binary_array
		assert_eq(byter.get_unsigned_binary_array(), unsigned_binary_array)
		assert_eq(byter.unsigned_binary_array      , unsigned_binary_array)

		basic.add(comparison)
		unsigned_binary_array = Binary.unsigned2array(basic.to_decimal())

		byter.set_unsigned_binary_array(unsigned_binary_array)
		assert_eq(byter.get_unsigned_binary_array(), unsigned_binary_array)
		assert_eq(byter.unsigned_binary_array      , unsigned_binary_array)

		byter.set_unsigned_binary_array([ false ]).unsigned_binary_array = \
			unsigned_binary_array
		assert_eq(byter.get_unsigned_binary_array(), unsigned_binary_array)
		assert_eq(byter.unsigned_binary_array      , unsigned_binary_array)


func test_signed_binary() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var signed_binary_array = Binary.signed2array(comparison)

		assert_eq(byter.get_signed_binary_array(), signed_binary_array)
		assert_eq(byter.signed_binary_array      , signed_binary_array)

		basic.multiply(comparison)
		signed_binary_array = Binary.signed2array(basic.to_decimal())

		byter.signed_binary_array = signed_binary_array
		assert_eq(byter.get_signed_binary_array(), signed_binary_array)
		assert_eq(byter.signed_binary_array      , signed_binary_array)

		basic.add(comparison)
		signed_binary_array = Binary.signed2array(basic.to_decimal())

		byter.set_signed_binary_array(signed_binary_array)
		assert_eq(byter.get_signed_binary_array(), signed_binary_array)
		assert_eq(byter.signed_binary_array      , signed_binary_array)

		byter.set_signed_binary_array([ false ]).signed_binary_array = \
			signed_binary_array
		assert_eq(byter.get_signed_binary_array(), signed_binary_array)
		assert_eq(byter.signed_binary_array      , signed_binary_array)


func test_unsigned_octal_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var unsigned_octal_str = Octal.unsigned2str(comparison)

		assert_eq(byter.get_unsigned_octal_str(), unsigned_octal_str)
		assert_eq(byter.unsigned_octal_str      , unsigned_octal_str)

		basic.multiply(comparison)
		unsigned_octal_str = Octal.unsigned2str(basic.to_decimal())

		byter.unsigned_octal_str = unsigned_octal_str
		assert_eq(byter.get_unsigned_octal_str(), unsigned_octal_str)
		assert_eq(byter.unsigned_octal_str      , unsigned_octal_str)

		basic.add(comparison)
		unsigned_octal_str = Octal.unsigned2str(basic.to_decimal())

		byter.set_unsigned_octal_str(unsigned_octal_str)
		assert_eq(byter.get_unsigned_octal_str(), unsigned_octal_str)
		assert_eq(byter.unsigned_octal_str      , unsigned_octal_str)

		byter.set_unsigned_octal_str('0').unsigned_octal_str = \
			unsigned_octal_str
		assert_eq(byter.get_unsigned_octal_str(), unsigned_octal_str)
		assert_eq(byter.unsigned_octal_str      , unsigned_octal_str)


func test_signed_octal_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var signed_octal_str = Octal.signed2str(comparison)

		assert_eq(byter.get_signed_octal_str(), signed_octal_str)
		assert_eq(byter.signed_octal_str      , signed_octal_str)

		basic.multiply(comparison)
		signed_octal_str = Octal.signed2str(basic.to_decimal())

		byter.signed_octal_str = signed_octal_str
		assert_eq(byter.get_signed_octal_str(), signed_octal_str)
		assert_eq(byter.signed_octal_str      , signed_octal_str)

		basic.add(comparison)
		signed_octal_str = Octal.signed2str(basic.to_decimal())

		byter.set_signed_octal_str(signed_octal_str)
		assert_eq(byter.get_signed_octal_str(), signed_octal_str)
		assert_eq(byter.signed_octal_str      , signed_octal_str)

		byter.set_signed_octal_str('0').signed_octal_str = signed_octal_str
		assert_eq(byter.get_signed_octal_str(), signed_octal_str)
		assert_eq(byter.signed_octal_str      , signed_octal_str)


func test_decimal_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var decimal_str = basic.to_decimal()

		assert_eq(byter.get_decimal_str(), decimal_str)
		assert_eq(byter.decimal_str      , decimal_str)

		basic.multiply(comparison)
		decimal_str = basic.to_decimal()

		byter.decimal_str = decimal_str
		assert_eq(byter.get_decimal_str(), decimal_str)
		assert_eq(byter.decimal_str      , decimal_str)

		basic.add(comparison)
		decimal_str = basic.to_decimal()

		byter.set_decimal_str(decimal_str)
		assert_eq(byter.get_decimal_str(), decimal_str)
		assert_eq(byter.decimal_str      , decimal_str)

		byter.set_decimal_str('0').decimal_str = decimal_str
		assert_eq(byter.get_decimal_str(), decimal_str)
		assert_eq(byter.decimal_str      , decimal_str)


func test_unsigned_hexadecimal_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var unsigned_hexadecimal_str = Hex.unsigned2str(comparison)

		assert_eq(
			byter.get_unsigned_hexadecimal_str(),
			unsigned_hexadecimal_str
		)

		assert_eq(
			byter.unsigned_hexadecimal_str,
			unsigned_hexadecimal_str
		)

		basic.multiply(comparison)
		unsigned_hexadecimal_str = Hex.unsigned2str(basic.to_decimal())

		byter.unsigned_hexadecimal_str = unsigned_hexadecimal_str
		assert_eq(
			byter.get_unsigned_hexadecimal_str(),
			unsigned_hexadecimal_str
		)

		assert_eq(
			byter.unsigned_hexadecimal_str,
			unsigned_hexadecimal_str
		)

		basic.add(comparison)
		unsigned_hexadecimal_str = Hex.unsigned2str(basic.to_decimal())

		byter.set_unsigned_hexadecimal_str(unsigned_hexadecimal_str)
		assert_eq(
			byter.get_unsigned_hexadecimal_str(),
			unsigned_hexadecimal_str
		)

		assert_eq(
			byter.unsigned_hexadecimal_str,
			unsigned_hexadecimal_str
		)

		byter.set_unsigned_hexadecimal_str('0').unsigned_hexadecimal_str = \
			unsigned_hexadecimal_str
		assert_eq(
			byter.get_unsigned_hexadecimal_str(),
			unsigned_hexadecimal_str
		)

		assert_eq(
			byter.unsigned_hexadecimal_str,
			unsigned_hexadecimal_str
		)


func test_signed_hexadecimal_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var signed_hexadecimal_str = Hex.signed2str(comparison)

		assert_eq(byter.get_signed_hexadecimal_str(), signed_hexadecimal_str)
		assert_eq(byter.signed_hexadecimal_str      , signed_hexadecimal_str)

		basic.multiply(comparison)
		signed_hexadecimal_str = Hex.signed2str(basic.to_decimal())

		byter.signed_hexadecimal_str = signed_hexadecimal_str
		assert_eq(byter.get_signed_hexadecimal_str(), signed_hexadecimal_str)
		assert_eq(byter.signed_hexadecimal_str      , signed_hexadecimal_str)

		basic.add(comparison)
		signed_hexadecimal_str = Hex.signed2str(basic.to_decimal())

		byter.set_signed_hexadecimal_str(signed_hexadecimal_str)
		assert_eq(byter.get_signed_hexadecimal_str(), signed_hexadecimal_str)
		assert_eq(byter.signed_hexadecimal_str      , signed_hexadecimal_str)

		byter.set_signed_hexadecimal_str('0').signed_hexadecimal_str = \
			signed_hexadecimal_str
		assert_eq(byter.get_signed_hexadecimal_str(), signed_hexadecimal_str)
		assert_eq(byter.signed_hexadecimal_str      , signed_hexadecimal_str)


func test_unsigned_base36_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var unsigned_base36_str = Base36.unsigned2str(comparison)

		assert_eq(byter.get_unsigned_base36_str(), unsigned_base36_str)
		assert_eq(byter.unsigned_base36_str      , unsigned_base36_str)

		basic.multiply(comparison)
		unsigned_base36_str = Base36.unsigned2str(basic.to_decimal())

		byter.unsigned_base36_str = unsigned_base36_str
		assert_eq(byter.get_unsigned_base36_str(), unsigned_base36_str)
		assert_eq(byter.unsigned_base36_str      , unsigned_base36_str)

		basic.add(comparison)
		unsigned_base36_str = Base36.unsigned2str(basic.to_decimal())

		byter.set_unsigned_base36_str(unsigned_base36_str)
		assert_eq(byter.get_unsigned_base36_str(), unsigned_base36_str)
		assert_eq(byter.unsigned_base36_str      , unsigned_base36_str)

		byter.set_unsigned_base36_str('0').unsigned_base36_str = \
			unsigned_base36_str
		assert_eq(byter.get_unsigned_base36_str(), unsigned_base36_str)
		assert_eq(byter.unsigned_base36_str      , unsigned_base36_str)


func test_signed_base36_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		if comparison > 0:
			comparison *= -1

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var signed_base36_str = Base36.signed2str(comparison)

		assert_eq(byter.get_signed_base36_str(), signed_base36_str)
		assert_eq(byter.signed_base36_str      , signed_base36_str)

		basic.multiply(comparison)
		basic.negative_bool = true

		signed_base36_str = Base36.signed2str(basic.to_decimal())

		byter.signed_base36_str = signed_base36_str
		assert_eq(byter.get_signed_base36_str(), signed_base36_str)
		assert_eq(byter.signed_base36_str      , signed_base36_str)

		basic.add(comparison)
		signed_base36_str = Base36.signed2str(basic.to_decimal())

		byter.set_signed_base36_str(signed_base36_str)
		assert_eq(byter.get_signed_base36_str(), signed_base36_str)
		assert_eq(byter.signed_base36_str      , signed_base36_str)

		byter.set_signed_base36_str('0').signed_base36_str = signed_base36_str
		assert_eq(byter.get_signed_base36_str(), signed_base36_str)
		assert_eq(byter.signed_base36_str      , signed_base36_str)


func test_unsigned_base62_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = (comparison << 32) & 0x7fffffff00000000
		comparison += random.randi()

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var unsigned_base62_str = Base62.unsigned2str(comparison)

		assert_eq(byter.get_unsigned_base62_str(), unsigned_base62_str)
		assert_eq(byter.unsigned_base62_str      , unsigned_base62_str)

		basic.multiply(comparison)
		unsigned_base62_str = Base62.unsigned2str(basic.to_decimal())

		byter.unsigned_base62_str = unsigned_base62_str
		assert_eq(byter.get_unsigned_base62_str(), unsigned_base62_str)
		assert_eq(byter.unsigned_base62_str      , unsigned_base62_str)

		basic.add(comparison)
		unsigned_base62_str = Base62.unsigned2str(basic.to_decimal())

		byter.set_unsigned_base62_str(unsigned_base62_str)
		assert_eq(byter.get_unsigned_base62_str(), unsigned_base62_str)
		assert_eq(byter.unsigned_base62_str      , unsigned_base62_str)

		byter.set_unsigned_base62_str('0').unsigned_base62_str = \
			unsigned_base62_str
		assert_eq(byter.get_unsigned_base62_str(), unsigned_base62_str)
		assert_eq(byter.unsigned_base62_str      , unsigned_base62_str)


func test_signed_base62_str() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	for _i in range(INT_NUM_TESTS):
		var comparison: int = random.randi()
		comparison  = comparison << 32
		comparison += random.randi()

		if comparison > 0:
			comparison *= -1

		var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
		var byter: PressAccept_Byter_Byter   = Byter.new(comparison)

		var signed_base62_str = Base62.signed2str(comparison)

		assert_eq(byter.get_signed_base62_str(), signed_base62_str)
		assert_eq(byter.signed_base62_str      , signed_base62_str)

		basic.multiply(comparison)
		basic.negative_bool = true

		signed_base62_str = Base62.signed2str(basic.to_decimal())

		byter.signed_base62_str = signed_base62_str
		assert_eq(byter.get_signed_base62_str(), signed_base62_str)
		assert_eq(byter.signed_base62_str      , signed_base62_str)

		basic.add(comparison)
		signed_base62_str = Base62.signed2str(basic.to_decimal())

		byter.set_signed_base62_str(signed_base62_str)
		assert_eq(byter.get_signed_base62_str(), signed_base62_str)
		assert_eq(byter.signed_base62_str      , signed_base62_str)

		byter.set_signed_base62_str('0').signed_base62_str = signed_base62_str
		assert_eq(byter.get_signed_base62_str(), signed_base62_str)
		assert_eq(byter.signed_base62_str      , signed_base62_str)


func test_byter_set_by_radix() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var comparison: int = random.randi()
	comparison  = comparison << 32
	comparison += random.randi()

	var byter: PressAccept_Byter_Byter = Byter.new(comparison)

	var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
	byter.set_by_radix(
		basic.to_binary(),
		Byter.ENUM_OUTPUTS.SIGNED_BINARY_STR
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	byter.set_by_radix(
		basic.to_binary(),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_BINARY_STR]
	)

	assert_eq(byter.decimal_str, basic.to_decimal())

	basic = Basic.new(comparison + random.randi())
	byter.set_by_radix(
		Binary.str2array(basic.to_binary()),
		Byter.ENUM_OUTPUTS.SIGNED_BINARY_ARRAY
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	byter.set_by_radix(
		Binary.str2array(basic.to_binary()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_BINARY_ARRAY]
	)

	assert_eq(byter.decimal_str, basic.to_decimal())

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		basic.to_binary(),
		Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_STR
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		basic.to_binary(),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_STR]
	)

	assert_eq(byter.decimal_str, basic.to_decimal())

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Binary.str2array(basic.to_binary()),
		Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Binary.str2array(basic.to_binary()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY]
	)

	assert_eq(byter.decimal_str, basic.to_decimal())

	basic = Basic.new(comparison + random.randi())
	byter.set_by_radix(
		Octal.signed2str(basic.to_decimal()),
		Byter.ENUM_OUTPUTS.SIGNED_OCTAL
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	byter.set_by_radix(
		Octal.signed2str(basic.to_decimal()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_OCTAL]
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Octal.unsigned2str(basic.to_decimal()),
		Byter.ENUM_OUTPUTS.UNSIGNED_OCTAL
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Octal.unsigned2str(basic.to_decimal()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_OCTAL]
	)

	basic = Basic.new(comparison + random.randi())
	byter.set_by_radix(
		basic.to_decimal(),
		Byter.ENUM_OUTPUTS.DECIMAL
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	byter.set_by_radix(
		basic.to_decimal(),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.DECIMAL]
	)

	basic = Basic.new(comparison + random.randi())
	byter.set_by_radix(
		Hex.signed2str(basic.to_decimal()),
		Byter.ENUM_OUTPUTS.SIGNED_HEXADECIMAL
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	byter.set_by_radix(
		Hex.signed2str(basic.to_decimal()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_HEXADECIMAL]
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Hex.unsigned2str(basic.to_decimal()),
		Byter.ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Hex.unsigned2str(basic.to_decimal()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL]
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = true
	byter.set_by_radix(
		Base36.signed2str(basic.to_decimal()),
		Byter.ENUM_OUTPUTS.SIGNED_BASE_36
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = true
	byter.set_by_radix(
		Base36.signed2str(basic.to_decimal()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_BASE_36]
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Base36.unsigned2str(basic.to_decimal()),
		Byter.ENUM_OUTPUTS.UNSIGNED_BASE_36
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Base36.unsigned2str(basic.to_decimal()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_BASE_36]
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = true
	byter.set_by_radix(
		Base62.signed2str(basic.to_decimal()),
		Byter.ENUM_OUTPUTS.SIGNED_BASE_62
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = true
	byter.set_by_radix(
		Base62.signed2str(basic.to_decimal()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_BASE_62]
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Base62.unsigned2str(basic.to_decimal()),
		Byter.ENUM_OUTPUTS.UNSIGNED_BASE_62
	)

	assert_eq(byter.decimal_str, basic.to_decimal())
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.set_by_radix(
		Base62.unsigned2str(basic.to_decimal()),
		Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_BASE_62]
	)


func test_byter_get_by_radix() -> void:

	var random: RandomNumberGenerator = RandomNumberGenerator.new()
	random.seed = INT_RANDOM_SEED

	var comparison: int = random.randi()
	comparison  = comparison << 32
	comparison += random.randi()

	var byter: PressAccept_Byter_Byter = Byter.new(comparison)

	var basic: PressAccept_Arbiter_Basic = Basic.new(comparison)
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.SIGNED_BINARY_STR),
		basic.to_binary()
	)
	
	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_BINARY_STR]
		),
		basic.to_binary()
	)

	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.SIGNED_BINARY_ARRAY),
		Binary.str2array(basic.to_binary())
	)
	
	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_BINARY_ARRAY]
		),
		Binary.str2array(basic.to_binary())
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_STR),
		basic.to_binary()
	)
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_STR]
		),
		basic.to_binary()
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY),
		Binary.str2array(basic.to_binary())
	)
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY]
		),
		Binary.str2array(basic.to_binary())
	)

	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.SIGNED_OCTAL),
		Octal.signed2str(basic.to_decimal())
	)
	
	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_OCTAL]
		),
		Octal.signed2str(basic.to_decimal())
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.UNSIGNED_OCTAL),
		Octal.unsigned2str(basic.to_decimal())
	)
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_OCTAL]
		),
		Octal.unsigned2str(basic.to_decimal())
	)

	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.DECIMAL),
		basic.to_decimal()
	)
	
	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.DECIMAL]
		),
		basic.to_decimal()
	)

	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.SIGNED_HEXADECIMAL),
		Hex.signed2str(basic.to_decimal())
	)
	
	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_HEXADECIMAL]
		),
		Hex.signed2str(basic.to_decimal())
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL),
		Hex.unsigned2str(basic.to_decimal())
	)
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL]
		),
		Hex.unsigned2str(basic.to_decimal())
	)

	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.SIGNED_BASE_36),
		Base36.signed2str(basic.to_decimal())
	)
	
	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_BASE_36]
		),
		Base36.signed2str(basic.to_decimal())
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.UNSIGNED_BASE_36),
		Base36.unsigned2str(basic.to_decimal())
	)
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_BASE_36]
		),
		Base36.unsigned2str(basic.to_decimal())
	)

	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.SIGNED_BASE_62),
		Base62.signed2str(basic.to_decimal())
	)
	
	basic = Basic.new(comparison + random.randi())
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.SIGNED_BASE_62]
		),
		Base62.signed2str(basic.to_decimal())
	)

	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(Byter.ENUM_OUTPUTS.UNSIGNED_BASE_62),
		Base62.unsigned2str(basic.to_decimal())
	)
	
	basic = Basic.new(comparison + random.randi())
	basic.negative_bool = false
	byter.value = basic.to_decimal()
	assert_eq(
		byter.get_by_radix(
			Byter.ARR_OUTPUTS[Byter.ENUM_OUTPUTS.UNSIGNED_BASE_62]
		),
		Base62.unsigned2str(basic.to_decimal())
	)

