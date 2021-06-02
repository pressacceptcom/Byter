tool
class_name PressAccept_Byter_Formats

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This file contains enumerations and constants that are used across the
# different 'modules' of the library. _FORMATS indicates what format we're
# expecting binary output to be, and _RADIX indicates what format we're
# expecting input to be in the to_* dynamically typed functions.
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : Formats
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

# ****************
# | Enumerations |
# ****************

# format enumeration
#
# used in Binary.gd to indicate whether to output a string or an array
enum ENUM_FORMATS {
	STRING,
	ARRAY
}

enum ENUM_FORM {
	STR,
	ARR
}

# radix enumeration
#
# used in to_* functions to indicate what format the input value is in
enum ENUM_RADIX {
	BINARY,
	OCTAL,
	UNSIGNED_DECIMAL,
	SIGNED_DECIMAL,
	HEXADECIMAL,
	UNSIGNED_BASE_36,
	SIGNED_BASE_36,
	UNSIGNED_BASE_62,
	SIGNED_BASE_62
}

enum ENUM_RAD {
	BIN,
	OCT,
	UDEC,
	SDEC,
	HEX,
	UB36,
	SB36,
	UB62,
	SB62
}

# *************
# | Constants |
# *************

const ARR_FORMATS: Array = [
	'STRING',
	'ARRAY'
]

const ARR_FORM: Array = [
	'STR',
	'ARR'
]

const ARR_RADIX: Array = [
	'BINARY',
	'OCTAL',
	'UNSIGNED_DECIMAL',
	'SIGNED_DECIMAL',
	'HEXADECIMAL',
	'UNSIGNED_BASE_36',
	'SIGNED_BASE_36',
	'UNSIGNED_BASE_62',
	'SIGNED_BASE_62'
]

const ARR_RAD: Array = [
	'BIN',
	'OCT',
	'UDEC',
	'SDEC',
	'HEX',
	'UB36',
	'SB36',
	'UB62',
	'SB62'
]

# ***************************
# | Public Static Functions |
# ***************************


# Convert format enumeration to string representation
static func format2str(
		format_code: int) -> String:

	return ARR_FORMATS[format_code]


# Convert string representation to pin integer
static func str2format(
		format_str: String) -> int:

	format_str = format_str.to_upper()

	if format_str in ARR_FORM:
		return ARR_FORM.find(format_str)
	return ARR_FORMATS.find(format_str)


# Convert format enumeration to string representation
static func radix2str(
		radix_code: int) -> String:

	return ARR_RADIX[radix_code]


# Convert string representation to pin integer
static func str2radix(
		radix_str: String) -> int:

	radix_str = radix_str.to_upper()

	if radix_str in ARR_RAD:
		return ARR_RAD.find(radix_str)
	return ARR_RADIX.find(radix_str)

