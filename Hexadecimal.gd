tool
class_name PressAccept_Byter_Hexadecimal

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This file contains hexadecimal conversion functions both in signed and
# unsigned forms. In Godot integers are 64 bits and signed using 2s-complement.
#
# 2s-complement is 1s-complement - 1 (thus eliminating the negative zero) and
# is simple enough: the first bit is high, and the rest are the inverse of
# their unsigned counterparts.
#
# The conversion functions assume a hexadeimcal stirng input with their output
# specified in the second-half. E.g. str2octal reads:
#
# hexadecimal string input -> octal string output
#
# This namespace contains the following (ordered by output):
#
# NOTE: numerical values (integers) are returned as Strings if they're large
#
# Binary Array
#     - str2array
#
# Binary String
#     - str2binary (str2bin)
#
# Signed Integer
#     - str2signed (str2int)
#
# Unsigned Integer
#     - str2unsigned (str2uint)
#
# Positive Integer (Doesn't Convert To Binary)
#     - str2integer (str2pint)
#
# Octal String
#     - str2octal (str2oct)
#
# Hexadecimal String
#     - signed2str   (int2str)
#     - unsigned2str (uint2str)
#     - to_hexadecimal
#
# Base 36 String
#     - str2base36 (str2b36)
#
# Base 62 String
#     - str2base62 (str2b62)
#
# Arbitrary Base String
#     - str2arbitrary (str2arb)
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : Hexadecimal
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

# *************
# | Constants |
# *************

# hexadecimal digits to binary strings
#
# used in the conversion function for fast string replacement
const DICT_HEXADECIMAL_2_BINARY = {
	'0': '0000',
	'1': '0001',
	'2': '0010',
	'3': '0011',
	'4': '0100',
	'5': '0101',
	'6': '0110',
	'7': '0111',
	'8': '1000',
	'9': '1001',
	'a': '1010',
	'b': '1011',
	'c': '1100',
	'd': '1101',
	'e': '1110',
	'f': '1111'
}

# powers of 16
#
# used to compute positive integer
const ARR_POWERS_OF_16: Array = [
	1 <<  0, # 1
	1 <<  4, # 16
	1 <<  8, # 256
	1 << 12, # 4,096
	1 << 16, # 65,536
	1 << 20, # 1,048,576
	1 << 24, # 16,777,216
	1 << 28, # 268,435,456
	1 << 32, # 4,294,967,296
	1 << 36, # 68,719,476,736
	1 << 40, # 1,099,511,627,776
	1 << 44, # 17,592,186,044,416
	1 << 48, # 281,474,976,710,656
	1 << 52, # 4,503,599,627,370,496
	1 << 56, # 72,057,594,037,927,936
	1 << 60, # 1,152,921,504,606,846,976
]

# max number of hexadecimal digits representable as an integer is 16 (64 bits)
const INT_MAX_DIGITS: int = 16

# ***************************
# | Public Static Functions |
# ***************************

# |----------------------------|
# | String -> Binary Functions |
# |----------------------------|


# convert hexadecimal string representation to a binary string representation
#
# truncate removes leading zeros from conversion (hexadecimal is in sets of 4)
static func str2binary(
		hexadecimal_str : String,
		truncate        : bool = false) -> String:

	# some conventions preface hexadecimal_str numbers with 0x
	hexadecimal_str = hexadecimal_str.trim_prefix('0x')
	hexadecimal_str = hexadecimal_str.to_lower()

	var ret: String = ''

	for digit in hexadecimal_str:
		ret += DICT_HEXADECIMAL_2_BINARY[digit]

	if truncate:
		ret = ret.lstrip('0')
		ret = ret if ret else '0'

	return ret


# alias for str2binary
static func str2bin(
		hexadecimal_str : String,
		truncate        : bool = false) -> String:

	return str2binary(hexadecimal_str, truncate)


# convert hexadecimal string representation to a boolean array (binary)
static func str2array(
		hexadecimal_str : String,
		truncate        : bool = false) -> Array:

	return PressAccept_Byter_Binary.str2array(
		str2binary(hexadecimal_str, truncate)
	)


# |------------------------------|
# | String -> Integer Conversion |
# |------------------------------|


# convert hexadecimal string representation to a signed integer
#
# 2s-complement is default
static func str2signed(
		hexadecimal_str : String,
		ones_complement : bool = false,
		return_object   : bool = false) -> int:

	return PressAccept_Byter_Binary.str2signed(
		str2binary(hexadecimal_str, false), # truncating = always negative
		false,
		ones_complement,
		return_object
	)


# alias for str2signed
static func str2int(
		hexadecimal_str : String,
		ones_complement : bool = false,
		return_object   : bool = false) -> int:

	return str2signed(hexadecimal_str, ones_complement, return_object)


# convert hexadecimal string representation to an unsigned integer
static func str2unsigned(
		hexadecimal_str : String,
		return_object   : bool = false) -> int:

	return PressAccept_Byter_Binary.str2unsigned(
		str2binary(hexadecimal_str, true), # doesn't matter
		false,
		return_object
	)


# alias for str2unsigned
static func str2uint(
		hexadecimal_str : String,
		return_object   : bool = false) -> int:

	return str2unsigned(hexadecimal_str, return_object)


# convert hexadecimal string representation to a positive integer
#
# NOTE: does not convert to binary as an intemediary (for optimization)
static func str2integer(
		hexadecimal_str : String,
		return_object   : bool = false):

	var Basic  : Script = PressAccept_Arbiter_Basic

	# some conventions preface hexadecimal_str numbers with 0x
	hexadecimal_str = hexadecimal_str.trim_prefix('0x')
	hexadecimal_str = hexadecimal_str.to_lower()

	return PressAccept_Byter_Common.base2integer(
		Basic.hexadecimal_to_array(hexadecimal_str),
		ARR_POWERS_OF_16,
		return_object
	)


# alias for str2integer
static func str2pint(
		hexadecimal_str : String,
		return_object   : bool = false):

	return str2integer(hexadecimal_str, return_object)


# |---------------------------|
# | String -> Base Conversion |
# |---------------------------|


# convert hexadecimal string representation to octal string representation
static func str2octal(
		hexadecimal_str : String,
		truncate        : bool = false) -> String:

	return PressAccept_Byter_Binary.str2octal(
		str2binary(hexadecimal_str, truncate)
	)


static func str2oct(
		hexadecimal_str : String,
		truncate        : bool = false) -> String:

	return str2octal(hexadecimal_str, truncate)


# convert hexadecimal string representation to base-36 string
#
# pass true to signed to use 2s-complement
#
# Test in test_base36.gd
static func str2base36(
		hexadecimal_str : String) -> String:

	var Base36: Script = load('res://addons/PressAccept/Byter/Base36.gd')

	return Base36.integer2str(str2unsigned(hexadecimal_str))


# alias for str2base36
static func str2b36(
		hexadecimal_str : String) -> String:

	return str2base36(hexadecimal_str)


# convert hexadecimal string representation to base-62 string representation
#
# pass true to signed to use 2s-complement
#
# Test in test_base62.gd
static func str2base62(
		hexadecimal_str : String) -> String:

	var Base62: Script = load('res://addons/PressAccept/Byter/Base62.gd')

	return Base62.integer2str(str2unsigned(hexadecimal_str))


# alias for str2base62
static func str2b62(
		hexadecimal_str : String) -> String:

	return str2base62(hexadecimal_str)


# convert hexadecimal string representation to arbitrary base string
#
# pass true to signed to use 2s-complement
#
# Test in test_base36.gd
static func str2arbitrary(
		hexadecimal_str : String,
		from_int        : FuncRef) -> String:

	return PressAccept_Byter_Binary.str2arbitrary(
		str2binary(hexadecimal_str),
		from_int
	)


# alias for str2base36
static func str2arb(
		hexadecimal_str : String,
		from_int        : FuncRef) -> String:

	return str2arbitrary(hexadecimal_str, from_int)


# |------------------------------|
# | Integer -> String Conversion |
# |------------------------------|


# convert signed integer to a hexadecimal string representation
#
# 2s-complement is default
static func signed2str(
		int_value,                                # int | String
		ones_complement: bool = false) -> String:

	var signed_binary_str: String = PressAccept_Byter_Binary.signed2str(
		int_value,
		-1,
		ones_complement
	)

	return PressAccept_Byter_Binary.str2hexadecimal(
		signed_binary_str,
		signed_binary_str[0] == '1' # signed?
	)


# alias for signed2str
static func int2str(
		int_value,                                # int | String 
		ones_complement: bool = false) -> String:

	return signed2str(int_value, ones_complement)


# convert unsigned integer to a hexadecimal string representation
static func unsigned2str(
		int_value) -> String: # int | String

	return PressAccept_Byter_Binary.str2hexadecimal(
		PressAccept_Byter_Binary.unsigned2str(int_value, -1),
		false
	)


# alias for unsigned2str
static func uint2str(
		int_value) -> String: # int | String

	return unsigned2str(int_value)


# |--------------------------|
# | Any -> String Conversion |
# |--------------------------|


# dynamically typed conversion
static func to_hexadecimal(
		from_value,
		from_radix = -1) -> String: # radix of from_value, def: signed decimal

	var Myself: Script = load('res://addons/PressAccept/Byter/Hexadecimal.gd')

	var ENUM_RADIX: Dictionary = PressAccept_Byter_Formats.ENUM_RADIX

	from_radix = PressAccept_Byter_Common.normalize_radix(from_radix)

	if typeof(from_value) == TYPE_STRING:
		if from_radix == ENUM_RADIX.HEXADECIMAL:
			return from_value

	return PressAccept_Byter_Common.to_base(
		from_value,
		Myself,
		'hexadecimal',
		from_radix
	)

