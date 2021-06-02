tool
class_name PressAccept_Byter_Base62

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This file contains base 62 [0-9a-zA-Z] conversion functions both in signed
# and unsigned forms. In Godot integers are 64 bits and signed using
# 2s-complement.
#
# 2s-complement is 1s-complement - 1 (thus eliminating the negative zero) and
# is simple enough: the first bit is high, and the rest are the inverse of
# their unsigned counterparts.
#
# The conversion functions assume a hexadeimcal stirng input with their output
# specified in the second-half. E.g. str2hexadecimal reads:
#
# base 62 string input -> hexadecimal string output
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
#     - str2integer (str2int, str2signed)
#
# Unsigned Integer
#     - str2unsigned (str2uint)
#
# Octal String
#     - str2octal (str2oct)
#
# Hexadecimal String
#     - str2hexadecimal (str2hex)
#
# Base 36 String
#     - str2base36 (str2b36)
#
# Base 62 String
#     - int2str      (signed2str)
#     - unsigned2str (uint2str)
#     - to_base62
#
# Arbitrary Base
#     - str2arbitrary (str2arb)
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : Base62
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

# powers of 62
#
# used to compute integer
const ARR_POWERS_OF_62: Array = [
	int(pow(62,  0)),
	int(pow(62,  1)),
	int(pow(62,  2)),
	int(pow(62,  3)),
	int(pow(62,  4)),
	int(pow(62,  5)),
	int(pow(62,  6)),
	int(pow(62,  7)),
	int(pow(62,  8)),
	int(pow(62,  9)),
	int(pow(62, 10))
]

# array of digits where index indicates place value
const ARR_PLACE_VALUES: Array = [
	'0',
	'1',
	'2',
	'3',
	'4',
	'5',
	'6',
	'7',
	'8',
	'9',
	'a',
	'b',
	'c',
	'd',
	'e',
	'f',
	'g',
	'h',
	'i',
	'j',
	'k',
	'l',
	'm',
	'n',
	'o',
	'p',
	'q',
	'r',
	's',
	't',
	'u',
	'v',
	'w',
	'x',
	'y',
	'z',
	'A',
	'B',
	'C',
	'D',
	'E',
	'F',
	'G',
	'H',
	'I',
	'J',
	'K',
	'L',
	'M',
	'N',
	'O',
	'P',
	'Q',
	'R',
	'S',
	'T',
	'U',
	'V',
	'W',
	'X',
	'Y',
	'Z'
]

# dictionary of digits where ( key -> ) value indicates place value
const DICT_PLACE_VALUES: Dictionary = {
	'0':  0,
	'1':  1,
	'2':  2,
	'3':  3,
	'4':  4,
	'5':  5,
	'6':  6,
	'7':  7,
	'8':  8,
	'9':  9,
	'a': 10,
	'b': 11,
	'c': 12,
	'd': 13,
	'e': 14,
	'f': 15,
	'g': 16,
	'h': 17,
	'i': 18,
	'j': 19,
	'k': 20,
	'l': 21,
	'm': 22,
	'n': 23,
	'o': 24,
	'p': 25,
	'q': 26,
	'r': 27,
	's': 28,
	't': 29,
	'u': 30,
	'v': 31,
	'w': 32,
	'x': 33,
	'y': 34,
	'z': 35,
	'A': 36,
	'B': 37,
	'C': 38,
	'D': 39,
	'E': 40,
	'F': 41,
	'G': 42,
	'H': 43,
	'I': 44,
	'J': 45,
	'K': 46,
	'L': 47,
	'M': 48,
	'N': 49,
	'O': 50,
	'P': 51,
	'Q': 52,
	'R': 53,
	'S': 54,
	'T': 55,
	'U': 56,
	'V': 57,
	'W': 58,
	'X': 59,
	'Y': 60,
	'Z': 61
}

# maximum number of base62 digits representable as an integer is approx 11
const INT_MAX_DIGITS: int = 11

# ***************************
# | Public Static Functions |
# ***************************

# |----------------------------|
# | String -> Binary Functions |
# |----------------------------|


# convert a base 62 string to a binary representation
static func str2binary(
		base62_str : String) -> String:

	var ret: String = PressAccept_Byter_Binary.unsigned2str(
		str2integer(base62_str),
		-1
	).lstrip('0')

	return ret if ret else '0'


# alias for str2binary
static func str2bin(
		base62_str : String) -> String:

	return str2binary(base62_str)


# convert bsae 62 string representation to a boolean array
static func str2array(
		base62_str : String) -> Array:

	return PressAccept_Byter_Binary.str2array(str2binary(base62_str))


# |------------------------------|
# | String -> Integer Conversion |
# |------------------------------|


# convert base 62 string representation to a positive integer
#
# NOTE: does not convert to binary as an intemediary
static func str2integer(
		base62_str    : String,
		return_object : bool = false):

	var Common: Script = load('res://addons/PressAccept/Byter/Common.gd')

	var base62_arr: Array = []
	for digit in base62_str:
		base62_arr.push_back(DICT_PLACE_VALUES[digit])

	return Common.base2integer(base62_arr, ARR_POWERS_OF_62, return_object)


# convert base 62 string to a signed integer using 2s-complement (default)
#
# NOTE: converts to binary as an intermediary
#
# 1s-complement NEVER returns negative zero (-0)
static func str2signed(
		base62_str      : String,
		ones_complement : bool = false,
		return_object   : bool = false):

	return PressAccept_Byter_Binary.str2signed(
		str2binary(base62_str),
		false,
		ones_complement,
		return_object
	)


# alias for str2signed
static func str2int(
		base62_str      : String,
		ones_complement : bool = false,
		return_object   : bool = false):
	
	return str2signed(base62_str, ones_complement, return_object)


# convert base 62 string to an unsigned integer
static func str2unsigned(
		base62_str    : String,
		return_object : bool = false):

	return PressAccept_Byter_Binary.str2unsigned(
		str2binary(base62_str),
		false,
		return_object
	)


# alias for str2unsigned
static func str2uint(
		base62_str    : String,
		return_object : bool = false):

	return str2unsigned(base62_str, return_object)


# |---------------------------|
# | String -> Base Conversion |
# |---------------------------|


# convert a base 62 string to an octal equivalent
#
# passing sign is necessary for proper padding of the octal output
static func str2octal(
		base62_str : String,
		signed     : bool = true) -> String:

	var base62_binary_str: String = str2binary(base62_str)

	return PressAccept_Byter_Binary.str2octal(base62_binary_str, signed)


# alias for str2octal
static func str2oct(
		base62_str : String,
		signed     : bool = true) -> String:

	return str2octal(base62_str, signed)


# convert a base 62 string to a hexadecimal equivalent
#
# passing sign is necessary for proper padding of the hexadecimal output
static func str2hexadecimal(
		base62_str : String,
		signed     : bool = true) -> String:

	var base62_binary_str: String = str2binary(base62_str)

	return PressAccept_Byter_Binary.str2hexadecimal(base62_binary_str, signed)


# alias for str2hexadecimal
static func str2hex(
		base62_str : String,
		signed     : bool = true) -> String:

	return str2hexadecimal(base62_str, signed)


# convert base 62 string to a base 36 string
static func str2base36(
		base62_str: String) -> String:
		
	return PressAccept_Byter_Binary.str2base36(str2binary(base62_str))


# alias for str2base36
static func str2b36(
		base62_str: String) -> String:

	return str2base36(base62_str)


# convert a base 62 string into an arbitrary base using a given function
#
# NOTE: converts to binary as an intermediary
#
# the function is passed an integer value from which to convert
static func str2arbitrary(
		base62_str : String,
		from_int   : FuncRef) -> String:

	return PressAccept_Byter_Binary.str2arbitrary(
		str2binary(base62_str),
		from_int
	)


# alias for str2arbitrary
static func str2arb(
		base62_str : String,
		from_int   : FuncRef) -> String:

	return str2arbitrary(base62_str, from_int)


# |------------------------------|
# | Integer -> String Conversion |
# |------------------------------|


# convert a positive integer to a base 62 string
#
# NOTE: does not conver to binary as an intermediary
static func integer2str(
		int_value) -> String: # int | String

	var Basic: Script = PressAccept_Arbiter_Basic

	var base62: PressAccept_Arbiter_Basic = Basic.new(int_value, 62)

	var base62_arr : Array = base62.to_array()
	var ret        : String
	for digit in base62_arr:
		ret += ARR_PLACE_VALUES[digit]

	return ret


# convert a negative integer to a 2s-complement base 62 string
#
# NOTE: converts to binary as an intermediary
static func signed2str(
		int_value,
		ones_complement: bool = false) -> String: # int | String

	return PressAccept_Byter_Binary.str2base62(
		PressAccept_Byter_Binary.signed2str(
			int_value,
			-1,
			ones_complement
		)
	)


# alias for signed2str
static func int2str(
		int_value,
		ones_complement: bool = false) -> String: # int | String

	return signed2str(int_value, ones_complement)


# convert a positive integer to a base 62 string
#
# NOTE: converts to binary as an intermediary
static func unsigned2str(
		int_value) -> String: # int | String

	return PressAccept_Byter_Binary.str2base62(
		PressAccept_Byter_Binary.unsigned2str(int_value, -1)
	)

# alias for unsigned2str
static func uint2str(
		int_value) -> String: # int | String

	return unsigned2str(int_value)


# |---------------|
# | Any -> String |
# |---------------|

# dynamically typed conversion
static func to_base62(
		from_value,
		from_radix = -1) -> String: # radix of from_value, def: signed decimal

	var Myself: Script = load( 'res://addons/PressAccept/Byter/Base62.gd' )
	var Common: Script = load( 'res://addons/PressAccept/Byter/Common.gd' )
	var Base36: Script = load( 'res://addons/PressAccept/Byter/Base36.gd' )

	var ENUM_RADIX: Dictionary = PressAccept_Byter_Formats.ENUM_RADIX

	from_radix = Common.normalize_radix(from_radix)

	if typeof(from_value) == TYPE_STRING:
		match from_radix:
			ENUM_RADIX.UNSIGNED_BASE_62, \
			ENUM_RADIX.SIGNED_BASE_62:
				return from_value
			ENUM_RADIX.UNSIGNED_BASE_36, \
			ENUM_RADIX.SIGNED_BASE_36:
				return Base36.str2base62(from_value)

	return Common.to_base(from_value, Myself, 'base62', from_radix)

