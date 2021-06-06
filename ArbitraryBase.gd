tool
class_name PressAccept_Byter_ArbitraryBase

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This file takes the base-36 and base-62 files and uses similar logic to
# create a dynamic module (object) whose member functions perform radix
# conversion to an arbitrary base defined by a string. The string passed to
# the constructor defines the 'digits' to be used in output, much like 0-F is
# used for hexadecimal or 0-9a-z for base 36.
#
# For example to create an object that uses base 6 you would pass '012345' or
# to use an object that uses base 21 with alphabetic digit representation you
# might use 'abcdefghijklmnopqrstu'
#
# This file contains base conversion functions both in signed and unsigned
# forms. In Godot integers are 64 bits and signed using 2s-complement.
#
# 2s-complement is 1s-complement - 1 (thus eliminating the negative zero) and
# is simple enough: the first bit is high, and the rest are the inverse of
# their unsigned counterparts.
#
# The conversion functions assume a hexadeimcal stirng input with their output
# specified in the second-half. E.g. str2hexadecimal reads:
#
# abirtrary base string input -> hexadecimal string output
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
#     - str2base62 (str2b62)
#
# Arbitrary Base String
#     - int2str      (signed2str)
#     - unsigned2str (uint2str)
#     - to_base
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
# Class                  : ArbitraryBase
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

# ***********
# | Imports |
# ***********

const Binary: Script = PressAccept_Byter_Binary

var Common: Script = load('res://addons/PressAccept/Byter/Common.gd')

# *********************
# | Public Properties |
# *********************

# place values array, index indicates place value
var place_values_arr  : Array = []

# dictionary of digits where ( key -> ) value indicates place value
var place_values_dict : Dictionary = {}

# place values string, string index indicates place value
var place_values_str  : String setget set_place_values_str

# ***************
# | Constructor |
# ***************

# constructor( String )
#
# the string passed to the constructor defines the 'digits' to be used in
# output, much like 0-F is used for hexadecimal or 0-9a-z for base 36.
#
# For example to create an object that uses base 6 you would pass '012345' or
# to use an object that uses base 21 with alphabetic digit representation you
# might use 'abcdefghijklmnopqrstu'
func _init(
		init_place_values_str: String) -> void:

	if not init_place_values_str:
		return

	self.place_values_str = init_place_values_str


# ******************
# | SetGet Methods |
# ******************


# reinitializes the place values set in the constructor
func set_place_values_str(
		new_place_values_str: String) -> PressAccept_Byter_ArbitraryBase:

	place_values_str = new_place_values_str

	place_values_arr  = []
	place_values_dict = {}

	if not place_values_str:
		return null

	for place in range(place_values_str.length()):
		place_values_arr.push_back(place_values_str[place])
		place_values_dict[place_values_str[place]] = place

	return self


# ******************
# | Public Methods |
# ******************

# |-----------------|
# | Utility Methods |
# |-----------------|


# returns the funcref expected by str2arbitrary functions elsewhere
func get_func() -> FuncRef:

	return funcref(self, 'integer2str')


# |----------------------------|
# | String -> Binary Functions |
# |----------------------------|


# convert am arbitrary base to a binary representation
func str2binary(
		base_str : String) -> String:

	var ret: String = \
		Binary.unsigned2str(str2integer(base_str), -1).lstrip('0')

	return ret if ret else '0'


# alias for str2binary
func str2bin(
		base_str : String) -> String:

	return str2binary(base_str)


# convert an atbirary base string representation to a boolean array
func str2array(
		base_str : String) -> Array:

	return Binary.str2array(str2binary(base_str))


# |------------------------------|
# | String -> Integer Conversion |
# |------------------------------|


# convert arbitrary string representation to a positive integer
#
# NOTE: does not convert to binary as an intemediary
func str2integer(
		base_str      : String,
		return_object : bool = false):

	var base_arr: Array = []
	for digit in base_str:
		base_arr.push_back(place_values_dict[digit])

	return Common.base2integer(
		base_arr,
		[ 1, place_values_str.length() ],
		return_object
	)


# convert arbitrary string to a signed integer using 2s-complement (default)
#
# NOTE: converts to binary as an intermediary
#
# 1s-complement NEVER returns negative zero (-0)
func str2signed(
		base_str        : String,
		ones_complement : bool = false,
		return_object   : bool = false):

	return Binary.str2signed(
		str2binary(base_str),
		false,
		ones_complement,
		return_object
	)


# alias for str2signed
func str2int(
		base_str        : String,
		ones_complement : bool = false,
		return_object   : bool = false):
	
	return str2signed(base_str, ones_complement, return_object)


# convert base 62 string to an unsigned integer
func str2unsigned(
		base_str      : String,
		return_object : bool = false):

	return Binary.str2unsigned(
		str2binary(base_str),
		false,
		return_object
	)


# alias for str2unsigned
func str2uint(
		base_str      : String,
		return_object : bool = false):

	return str2unsigned(base_str, return_object)


# |---------------------------|
# | String -> Base Conversion |
# |---------------------------|


# convert an arbitrary base string to an octal equivalent
#
# passing sign is necessary for proper padding of the octal output
func str2octal(
		base_str : String,
		signed   : bool = true) -> String:

	var base_binary_str: String = str2binary(base_str)

	return Binary.str2octal(base_binary_str, signed)


# alias for str2octal
func str2oct(
		base_str : String,
		signed   : bool = true) -> String:

	return str2octal(base_str, signed)


# convert an arbitrary base string to a hexadecimal equivalent
#
# passing sign is necessary for proper padding of the hexadecimal output
func str2hexadecimal(
		base_str : String,
		signed   : bool = true) -> String:

	var base_binary_str: String = str2binary(base_str)

	return Binary.str2hexadecimal(base_binary_str, signed)


# alias for str2hexadecimal
func str2hex(
		base_str : String,
		signed   : bool = true) -> String:

	return str2hexadecimal(base_str, signed)


# convert arbitrary base string to a base 36 string
func str2base36(
		base_str: String) -> String:
		
	return Binary.str2base36(str2binary(base_str))


# alias for str2base36
func str2b36(
		base_str: String) -> String:

	return str2base62(base_str)


# convert arbitrary base string to a base 62 string
func str2base62(
		base_str: String) -> String:
		
	return Binary.str2base62(str2binary(base_str))


# alias for str2base62
func str2b62(
		base_str: String) -> String:

	return str2base62(base_str)


# convert an arbitrary base string into another arbitrary base via function
#
# NOTE: converts to binary as an intermediary
#
# the function is passed an integer value from which to convert
func str2arbitrary(
		base_str: String,
		from_int: FuncRef) -> String:

	return Binary.str2arbitrary(str2binary(base_str), from_int)


# alias for str2arbitrary
func str2arb(
		base_str: String,
		from_int: FuncRef) -> String:

	return str2arbitrary(base_str, from_int)


# |------------------------------|
# | Integer -> String Conversion |
# |------------------------------|


# convert a positive integer to an arbitrary base string
#
# NOTE: does not conver to binary as an intermediary
func integer2str(
		int_value) -> String: # int | String

	var Basic: Script = PressAccept_Arbiter_Basic

	var base: PressAccept_Arbiter_Basic = \
		Basic.new(int_value, place_values_str.length())

	var base_arr : Array = base.to_array()
	var ret      : String
	for digit in base_arr:
		ret += place_values_arr[digit]

	return ret


# convert a negative integer to a 2s-complement arbitrary base string
#
# NOTE: converts to binary as an intermediary
func signed2str(
		int_value,
		ones_complement: bool = false) -> String: # int | String

	return Binary.str2arbitrary(
		Binary.signed2str(
			int_value,
			-1,
			ones_complement
		),
		get_func()
	)


# alias for signed2str
func int2str(
		int_value,
		ones_complement: bool = false) -> String: # int | String

	return signed2str(int_value, ones_complement)


# convert a positive integer to an arbitrary base string
#
# NOTE: converts to binary as an intermediary
func unsigned2str(
		int_value) -> String: # int | String


	return Binary.str2arbitrary(Binary.unsigned2str(int_value, -1), get_func())


# alias for unsigned2str
func uint2str(
		int_value) -> String: # int | String

	return unsigned2str(int_value)


# |--------------------------|
# | Any -> String Conversion |
# |--------------------------|


# dynamically typed conversion
func to_base(
		from_value,
		from_radix = -1) -> String: # radix from_value is in, defaults to signed decimal

	var ENUM_RADIX: Dictionary = PressAccept_Byter_Formats.ENUM_RADIX

	match typeof(from_value):
		TYPE_INT:
			match from_radix:
				ENUM_RADIX.UNSIGNED_DECIMAL:
					return unsigned2str(from_value)
				ENUM_RADIX.SIGNED_DECIMAL:
					return signed2str(from_value)

		TYPE_STRING:
			var base_module: Script
			match from_radix:
				ENUM_RADIX.UNSIGNED_DECIMAL:
					return unsigned2str(from_value)
				ENUM_RADIX.SIGNED_DECIMAL:
					return signed2str(from_value)
				ENUM_RADIX.BINARY:
					base_module = \
						load('res://addons/PressAccept/Byter/Binary.gd')
					continue
				ENUM_RADIX.OCTAL:
					base_module = \
						load('res://addons/PressAccept/Byter/Octal.gd')
					continue
				ENUM_RADIX.HEXADECIMAL:
					base_module = \
						load('res://addons/PressAccept/Byter/Hexadecimal.gd')
					continue
				ENUM_RADIX.UNSIGNED_BASE_36, \
				ENUM_RADIX.SIGNED_BASE_36:
					base_module = \
						load('res://addons/PressAccept/Byter/Base36.gd')
					continue
				ENUM_RADIX.UNSIGNED_BASE_62, \
				ENUM_RADIX.SIGNED_BASE_62:
					base_module = \
						load('res://addons/PressAccept/Byter/Base62.gd')
					continue
				ENUM_RADIX.OCTAL,            \
				ENUM_RADIX.HEXADECIMAL,      \
				ENUM_RADIX.UNSIGNED_BASE_36, \
				ENUM_RADIX.SIGNED_BASE_36,   \
				ENUM_RADIX.UNSIGNED_BASE_62, \
				ENUM_RADIX.SIGNED_BASE_62:
					return base_module.str2arbitrary(
						from_value,
						funcref(self, 'integer2str')
					)

		TYPE_ARRAY:
			return Binary.array2arbitrary(
				from_value,
				funcref(self, 'integer2str')
			)

		TYPE_OBJECT:
			match from_radix:
				ENUM_RADIX.UNSIGNED_DECIMAL:
					return unsigned2str(from_value.to_decimal())
				ENUM_RADIX.SIGNED_DECIMAL:
					return signed2str(from_value.to_decimal())

	return ''

