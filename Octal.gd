tool
class_name PressAccept_Byter_Octal

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This file contains octal conversion functions both in signed and unsigned
# forms. In Godot integers are 64 bits and signed using 2s-complement.
#
# 2s-complement is 1s-complement - 1 (thus eliminating the negative zero) and
# is simple enough: the first bit is high, and the rest are the inverse of
# their unsigned counterparts.
#
# The conversion functions assume a hexadeimcal stirng input with their output
# specified in the second-half. E.g. str2hexadecimal reads:
#
# octal string input -> hexadecimal string output
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
#     - signed2str   (int2str)
#     - unsigned2str (uint2str)
#     - to_octal
#
# Hexadecimal String
#     - str2hexadecimal (str2hex)
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
# Class                  : Octal
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
const DICT_OCTAL_2_BINARY = {
	'0': '000',
	'1': '001',
	'2': '010',
	'3': '011',
	'4': '100',
	'5': '101',
	'6': '110',
	'7': '111'
}

# powers of 8
#
# used to compute positive integer
const ARR_POWERS_OF_8: Array = [
	1 <<  0, # 1
	1 <<  3, # 8
	1 <<  6, # 64
	1 <<  9, # 512
	1 << 12, # 4,096
	1 << 15, # 32,768
	1 << 18, # 262,144
	1 << 21, # 2,097,152
	1 << 24, # 16,777,216
	1 << 27, # 134,217,728
	1 << 30, # 1,073,741,824
	1 << 33, # 8,589,934,592
	1 << 36, # 68,719,476,736
	1 << 39, # 549,755,813,888
	1 << 42, # 4,398,046,511,104
	1 << 45, # 35,184,372,088,832
	1 << 48, # 281,474,976,710,656
	1 << 51, # 2,251,799,813,685,248
	1 << 54, # 18,014,398,509,481,984
	1 << 57, # 144,115,188,075,855,872
	1 << 60, # 1,152,921,504,606,846,976
]

# maximum number of octal digits representable as an integer is 21 (63 bits)
const INT_MAX_DIGITS: int = 21

# ***************************
# | Public Static Functions |
# ***************************

# |----------------------------|
# | String -> Binary Functions |
# |----------------------------|


# convert octal string representation to a binary string representation
#
# truncate removes leading zeros from conversion (octal is in sets of 3)
static func str2binary(
		octal_str : String,
		truncate  : bool = false) -> String:

	var ret: String = ''

	for digit in octal_str:
		ret += DICT_OCTAL_2_BINARY[digit]

	if truncate:
		ret = ret.lstrip('0')
		ret = ret if ret else '0'

	return ret


# alias for str2binary
static func str2bin(
		octal_str : String,
		truncate  : bool = false) -> String:

	return str2binary(octal_str, truncate)


# convert octal string representation to a boolean array (binary)
static func str2array(
		octal_str : String,
		truncate  : bool = false) -> Array:

	return PressAccept_Byter_Binary.str2array(
		str2binary(octal_str, truncate)
	)


# |------------------------------|
# | String -> Integer Conversion |
# |------------------------------|


# convert octal string representation to a signed integer
#
# 2s-complement is default
static func str2signed(
		octal_str       : String,
		ones_complement : bool = false,
		return_object   : bool = false):

	return PressAccept_Byter_Binary.str2signed(
		str2binary(octal_str, false), # truncating = always negative
		false,
		ones_complement,
		return_object
	)


# alias for str2signed
static func str2int(
		octal_str       : String,
		ones_complement : bool = false,
		return_object   : bool = false):

	return str2signed(octal_str, ones_complement, return_object)


# convert octal string representation to an unsigned integer
static func str2unsigned(
		octal_str     : String,
		return_object : bool = false):

	return PressAccept_Byter_Binary.str2unsigned(
		str2binary(octal_str, true), # doesn't matter
		false,
		return_object
	)


# alias for str2unsigned
static func str2uint(
		octal_str     : String,
		return_object : bool = false):

	return str2unsigned(octal_str, return_object)


# convert octal string representation to a positive integer
#
# NOTE: does not convert to binary as an intemediary
static func str2integer(
		octal_str     : String,
		return_object : bool = false):

	var Basic  : Script = PressAccept_Arbiter_Basic
	var Common : Script = load('res://addons/PressAccept/Byter/Common.gd')

	return Common.base2integer(
		Basic.octal_to_array(octal_str),
		ARR_POWERS_OF_8,
		return_object
	)


# alias for str2integer
static func str2pint(
		octal_str     : String,
		return_object : bool = false):

	return str2integer(octal_str, return_object)


# |---------------------------|
# | String -> Base Conversion |
# |---------------------------|


# convert octal string representation to hexadecimal string representation
static func str2hexadecimal(
		octal_str : String,
		truncate  : bool = false) -> String:

	return PressAccept_Byter_Binary.str2hexadecimal(
		str2binary(octal_str, truncate)
	)


# alias for str2hexadecimal
static func str2hex(
		octal_str : String,
		truncate  : bool = false) -> String:

	return str2hexadecimal(octal_str, truncate)


# convert octal string representation to base-36 string representation
#
# Test in test_base36.gd
static func str2base36(
		octal_str : String) -> String:

	var Base36: Script = load('res://addons/PressAccept/Byter/Base36.gd')

	return Base36.integer2str(str2unsigned(octal_str))


# alias for str2base36
static func str2b36(
		octal_str : String) -> String:

	return str2base36(octal_str)


# convert octal string representation to base-62 string representation
#
# Test in test_base62.gd
static func str2base62(
		octal_str : String) -> String:

	var Base62: Script = load('res://addons/PressAccept/Byter/Base62.gd')

	return Base62.integer2str(str2unsigned(octal_str))


# alias for str2base62
static func str2b62(
		octal_str : String) -> String:

	return str2base62(octal_str)


# convert octal string representation to arbitrary base string representation
#
# Test in test_base36.gd
static func str2arbitrary(
		octal_str : String,
		from_int  : FuncRef) -> String:

	return PressAccept_Byter_Binary.str2arbitrary(
		str2binary(octal_str),
		from_int
	)


# alias for str2base36
static func str2arb(
		octal_str : String,
		from_int  : FuncRef) -> String:

	return str2arbitrary(octal_str, from_int)


# |------------------------------|
# | Integer -> String Conversion |
# |------------------------------|


# convert signed integer to an octal string representation
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

	return PressAccept_Byter_Binary.str2octal(
		signed_binary_str,
		signed_binary_str[0] == '1' # signed?
	)


# alias for signed2str
static func int2str(
		int_value,                                # int | String
		ones_complement: bool = false) -> String:

	return signed2str(int_value, ones_complement)


# convert unsigned integer to an octal string representation
static func unsigned2str(
		int_value) -> String: # int | String

	return PressAccept_Byter_Binary.str2octal(
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
static func to_octal(
		from_value,
		from_radix = -1) -> String: # radix of from_value, def: signed decimal

	var Myself: Script = load( 'res://addons/PressAccept/Byter/Octal.gd' )
	var Common: Script = load( 'res://addons/PressAccept/Byter/Common.gd')

	var ENUM_RADIX: Dictionary = PressAccept_Byter_Formats.ENUM_RADIX

	from_radix = Common.normalize_radix(from_radix)

	if typeof(from_value) == TYPE_STRING:
		if from_radix == ENUM_RADIX.OCTAL:
			return from_value

	return Common.to_base(from_value, Myself, 'octal', from_radix)

