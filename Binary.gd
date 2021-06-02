tool
class_name PressAccept_Byter_Binary

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This file contains the binary conversion functions both in signed and
# unsigned forms. In Godot integers are 64 bits and signed using 2s-complement.
#
# 2s-complement is 1s-complement - 1 (thus eliminating the negative zero) and
# is simple enough: the first bit is high, and the rest are the inverse of
# their unsigned counterparts.
#
# The conversion functions assume a binary input (string or array) with their
# output specified in the second-half. E.g. str2octal reads:
#
# binary string input -> octal string output
#
# This namespace contains the following (ordered by output):
#
# NOTE: numerical values (integers) are returned as Strings if they're large
#
# Binary Array
#     - str2array
#     - signed2array   (int2array)
#     - unsigned2array (uint2array)
#
# Binary String
#     - array2str
#     - signed2str       (int2str)
#     - unsigned2str     (uint2str)
#     - signed2bytes     (int2bytes)
#     - unsigned2bytes   (uint2bytes)
#     - signed2byte      (int2byte)
#     - unsigned2byte    (uint2byte)
#     - signed2bytes_2   (int2bytes_2)
#     - unsigned2bytes_2 (uint2bytes_2)
#     - signed2bytes_3   (int2bytes_3)
#     - unsigned2bytes_3 (uint2bytes_3)
#     - signed2bytes_4   (int2bytes_4)
#     - unsigned2bytes_4 (uint2bytes_4)
#     - signed2bytes_5   (int2bytes_5)
#     - unsigned2bytes_5 (uint2bytes_5)
#     - signed2bytes_6   (int2bytes_6)
#     - unsigned2bytes_6 (uint2bytes_6)
#     - signed2bytes_7   (int2bytes_7)
#     - unsigned2bytes_7 (uint2bytes_7)
#
# Signed Integer
#     - str2signed   (str2int)
#     - array2signed (array2int)
#
# Unsigned Integer
#     - str2unsigned   (str2uint)
#     - array2unsigned (array2uint)
#
# Octal String
#     - str2octal   (str2oct)
#     - array2octal (array2oct)
#
# Hexadecimal String
#     - str2hexadecimal   (str2hex)
#     - array2hexadecimal (array2hex)
#
# Base 36 String
#     - str2base36   (str2b36)
#     - array2base36 (array2b36)
#
# Base 62 String
#     - str2base62   (str2b62)
#     - array2base62 (array2b62)
#
# Arbitrary Base String
#     - str2arbitrary   (str2arb)
#     - array2arbitrary (array2arb)
#
# Multiple Outputs
#     - to_binary
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : Binary
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
# 1.0.0    0601/2021    First Release
#

# *************
# | Constants |
# *************

# maximum positive value of int variant data type in Godot
const INT_MAX           : int = 9223372036854775807

# maximum negative value of int variant data type in Godot
const INT_MIN           : int = (1 << 63) # -9223372036854775808

# maximum number of bits interpretable as a (signed) integer value in Godot
const INT_MAX_BITS      : int = 64

# standard measures in bits
const INT_BIT           : int = 1
const INT_BYTE_BITS     : int = 1 * 8                         # 8             bits
const INT_KIBIBIT_BITS  : int = 1 * 1024                      # 1,024         bits
const INT_KILOBYTE_BITS : int = 1 * 8    * 1024               # 8,192         bits
const INT_MEBIBIT_BITS  : int = 1 * 1024 * 1024               # 1,048,576     bits
const INT_MEGABYTE_BITS : int = 1 * 8    * 1024 * 1024        # 8,388,608     bits
const INT_GIBIBIT_BITS  : int = 1 * 1024 * 1024 * 1024        # 1,073,741,824 bits
const INT_GIGABYTE_BITS : int = 1 * 8    * 1023 * 1024 * 1024 # 8,589,934,592 bits

# standard measures in bytes
const INT_BYTE          : int = 1
const INT_KILOBYTE      : int = 1 * 1024               # 1024          bytes
const INT_MEGABYTE      : int = 1 * 1024 * 1024        # 1,048,576     bytes
const INT_GIGABYTE      : int = 1 * 1024 * 1024 * 1024 # 1,073,741,824 bytes

# binary strings to octal digits
#
# used in the conversion function for fast string replacement
const DICT_BINARY_2_OCTAL = {
	'000': '0',
	'001': '1',
	'010': '2',
	'011': '3',
	'100': '4',
	'101': '5',
	'110': '6',
	'111': '7'
}

# binary strings to hexadecimal digits
#
# used in the conversion function for fast string replacement
const DICT_BINARY_2_HEXADECIMAL = {
	'0000': '0',
	'0001': '1',
	'0010': '2',
	'0011': '3',
	'0100': '4',
	'0101': '5',
	'0110': '6',
	'0111': '7',
	'1000': '8',
	'1001': '9',
	'1010': 'a',
	'1011': 'b',
	'1100': 'c',
	'1101': 'd',
	'1110': 'e',
	'1111': 'f'
}

# ***************************
# | Public Static Functions |
# ***************************

# |-------------------|
# | Utility Functions |
# |-------------------|

# strip all whitespace characters (regex) from a given string value
static func del_whitespace(
		string_value: String) -> String:

	var whitespace = RegEx.new()
	whitespace.compile("\\s+")
	return whitespace.sub(string_value, '', true)


# convert anything that's not a '0' to a '1'
static func enforce_binary(
		string_value   : String,
		del_whitespace : bool = true) -> String:

	var not_zero = RegEx.new()
	not_zero.compile('[^0]')
	if del_whitespace:
		return not_zero.sub(del_whitespace(string_value), '1', true)
	return not_zero.sub(string_value, '1', true)


# pad a string with ones
static func pad_ones(
		string_value : String,
		size         : int) -> String:

	var padding: int = size - string_value.length()

	if padding > 0:
		for i in range(padding):
			string_value = '1' + string_value

	return string_value


# pad a string to a multiple of <unit> size (INT_BYTE_BITS = 8 by default)
static func pad_to_byte(
		string_value : String,
		unit         : int    = INT_BYTE_BITS,
		digit        : String = '0') -> String:

	if not string_value:
		string_value = digit # pad_zeros 'formats a number'

	var str_len : int = string_value.length()
	var units   : int = int(str_len / unit) + (1 if str_len % unit else 0)

	match digit:
		'0':
			return string_value.pad_zeros(units * unit)
		'1':
			return pad_ones(string_value, units * unit)
		_:
			for i in range((units * unit) - str_len):
				string_value = digit + string_value
			return string_value


# pad a string with '1's to multiple of <unit> size (INT_BYTE_BITS = 8 default)
static func pad_to_byte_signed(
		string_value : String,
		unit         : int = INT_BYTE_BITS) -> String:

	return pad_to_byte(string_value, unit, '1')


# |----------------------|
# | Conversion Functions |
# |----------------------|

# NOTES:
#
#     1. (most->least) means 0101 = 5, not 10
#
#     2. 'unsigned' integers don't exist as a Godot variant type, just positive
#        integers with a maximum of 9223372036854775807 (INT_MAX)

# |-----------------------------|
# | String <-> Array Conversion |
# |-----------------------------|


# convert binary string representation to array of boolean values
#
# returns array of boolean values: [ false, true, false, true ] = 5
static func str2array(
		binary_str     : String,                # binary string (most->least)
		enforce_binary : bool = true) -> Array: # del_whitespace and enforce_binary?

	if enforce_binary:
		binary_str = enforce_binary(binary_str, true)

	var ret: Array = []
	ret.resize(binary_str.length())

	for place in range(binary_str.length()):
		ret[place] = not (binary_str[place] == '0')

	return ret


# convert array of boolean values (most->least) to boolean string representation
#
# returns a string: [ false, true, false, true ] -> '0101' = 5
static func array2str(
		bool_array: Array) -> String: # binary array (most->least)

	var ret: String = ''
	for value in bool_array:
		ret += '1' if value as bool else '0'
	return ret


# |--------------------------------------|
# | String | Array -> Integer Conversion |
# |--------------------------------------|


# convert binary string representation to signed integer
#
# NOTE: 2s-complement is default
#
# returns int if integer is within the integer maximum-minimum range,
# otherwise returns a decimal string representation
static func str2signed(
		binary_str      : String,        # binary string (most->least)
		enforce_binary  : bool = true,   # del_whitespace and enforce_binary?
		ones_complement : bool = false,  # use 1s-complement?
		return_object   : bool = false): # return Basic object if necessary?
	
	var Basic: Script = PressAccept_Arbiter_Basic

	if enforce_binary:
		binary_str = enforce_binary(binary_str, true)

	var ret        : int = 0
	var _sign      : int = 1
	var binary_len : int = binary_str.length()

	var ret_obj   : PressAccept_Arbiter_Basic = null
	var power_obj : PressAccept_Arbiter_Basic = null
	if binary_len - 1 >= 64:
		ret_obj   = Basic.new()

	if binary_str[0] == '1':
		_sign = -1

	for bit_place in range(binary_len - 1):
		if binary_str[-bit_place - 1] == ('1' if _sign == 1 else '0'):
			if ret_obj:
				if bit_place < Basic.ARR_POWERS_OF_2.size():
					ret_obj.add(Basic.ARR_POWERS_OF_2[bit_place] * _sign)
				else:
					if not power_obj:
						power_obj = \
							Basic.new(Basic.ARR_POWERS_OF_2[-1])
						power_obj.negative_bool = \
							true if _sign == -1 else false
						for i in range(
								bit_place - Basic.ARR_POWERS_OF_2.size() + 1
							):
							power_obj.add(power_obj)
					
					ret_obj.add(power_obj)
			else:
				ret += Basic.ARR_POWERS_OF_2[bit_place] * _sign
		
		if power_obj:
			if bit_place != binary_len - 2:
				power_obj.add(power_obj)

	if ones_complement:
		if _sign == -1:
			if not '0' in binary_str.substr(1):
				return 0       # negative zero
	else:
		if _sign == -1:
			if ret_obj:
				ret_obj.subtract(1)
			else:
				ret -= 1

	if return_object:
		if ret_obj:
			return ret_obj

		return Basic.new(ret)
	
	if ret_obj:
		return ret_obj.to_decimal()

	return ret


# alias for str2signed
static func str2int(
		binary_str      : String,        # binary string (most->least)
		enforce_binary  : bool = true,   # del_whitespace and enforce_binary?
		ones_complement : bool = false,  # use 1s-complement?
		return_object   : bool = false): # return Basic object if necessary?

	return str2signed(
		binary_str,
		enforce_binary,
		ones_complement,
		return_object
	)


# convert array of boolean values (first->last) to signed integer
#
# returns int if integer is within the integer maximum-minimum range,
# otherwise returns a decimal string representation
static func array2signed(
		bool_array      : Array,         # binary string (most->least)
		ones_complement : bool = false,  # use 1s-complement?
		return_object   : bool = false): # return Basic object if necessary?

	return str2signed(
		array2str(bool_array),
		false,
		ones_complement,
		return_object
	)


# alias for array2signed
static func array2int(
		bool_array      : Array,         # binary string (most->least)
		ones_complement : bool = false,  # use 1s-complement?
		return_object   : bool = false): # return Basic object if necessary?

	return array2signed(bool_array, ones_complement, return_object)


# convert binary string representation to 'unsigned' integer
#
# returns int if integer is within the integer maximum-minimum range,
# otherwise returns a decimal string representation
static func str2unsigned(
		binary_str     : String,        # binary string (most->least)
		enforce_binary : bool = true,   # del_whitespace and enforce_binary?
		return_object  : bool = false): # return Basic object if necessary?

	var Basic: Script = PressAccept_Arbiter_Basic

	if enforce_binary:
		binary_str = enforce_binary(binary_str, true)

	var ret        : int = 0
	var binary_len : int = binary_str.length()

	var ret_obj   : PressAccept_Arbiter_Basic = null
	var power_obj : PressAccept_Arbiter_Basic = null
	if binary_str.length() > Basic.ARR_POWERS_OF_2.size():
		ret_obj = Basic.new(0)

	for bit_place in range(binary_len):
		if binary_str[-bit_place - 1] == '1':
			if ret_obj:
				if bit_place < Basic.ARR_POWERS_OF_2.size():
					ret_obj.add(Basic.ARR_POWERS_OF_2[bit_place])
				else:
					if not power_obj:
						power_obj = Basic.new(Basic.ARR_POWERS_OF_2[-1])
						for i in range(
								bit_place - Basic.ARR_POWERS_OF_2.size() + 1
							):
							power_obj.add(power_obj)
					
					ret_obj.add(power_obj)
			else:
				ret += Basic.ARR_POWERS_OF_2[bit_place]

		if power_obj:
			if bit_place != binary_len - 1:
				power_obj.add(power_obj)

	if return_object:
		if ret_obj:
			return ret_obj

		return Basic.new(ret)
	
	if ret_obj:
		return ret_obj.to_decimal()

	return ret


# alias for str2unsigned
static func str2uint(
		binary_str     : String,        # binary string (most->least)
		enforce_binary : bool = true,   # del_whitespace and enforce_binary?
		return_object  : bool = false): # return Basic object if necessary?

	return str2unsigned(binary_str, enforce_binary, return_object)


# convert array of boolean values (first->last) to 'unsigned' integer
#
# returns int if integer is within the integer maximum-minimum range,
# otherwise returns a decimal string representation
static func array2unsigned(
		bool_array    : Array,         # binary string (most->least)
		return_object : bool = false): # return Basic object if necessary?

	return str2unsigned(array2str(bool_array), false)


# alias of array2unsigned
static func array2uint(
		bool_array    : Array,         # binary string (most->least)
		return_object : bool = false): # return Basic object if necessary?

	return array2unsigned(bool_array)


# |-----------------------------------|
# | String | Array -> Base Conversion |
# |-----------------------------------|


# convert binary string representation to an octal string representation
#
# acts on bits only, not value (2s-complement is not interpreted)
#
# NOTE: use this instead of converting binary to (arbitrary) integer first and
#       then converting to base 8. This algorithm is optimized for binary and
#       uses a quick string replacement system for much better performance
static func str2octal(
		binary_str : String,
		signed     : bool = true) -> String:

	var Octal: Script = load('res://addons/PressAccept/Byter/Octal.gd')
	
	var ret: String = ''

	if signed:
		binary_str = pad_to_byte_signed(binary_str, 3)
	else:
		binary_str = pad_to_byte(binary_str, 3)

	for i in range(0, binary_str.length(), 3):
		var unit: String = binary_str.substr(i, 3)
		ret += DICT_BINARY_2_OCTAL[unit]

	return ret


# alias for str2octal
static func str2oct(
		binary_str : String,
		signed     : bool = true) -> String:

	return str2octal(binary_str, signed)


# convert array of boolean values (first->last) to octal string representation
#
# NOTE: uses str2octal after converting array to string, see str2octal for
#       performance information
static func array2octal(
		bool_array : Array,
		signed     : bool = true) -> String:

	return str2octal(array2str(bool_array), signed)


# alias for array2octal
static func array2oct(
		bool_array : Array,
		signed     : bool = true) -> String:

	return str2octal(array2str(bool_array), signed)


# convert boolean string representation to hexadecimal string representation
#
# acts on bits only, not value (2s-complement is not interpreted)
#
# NOTE: use this instead of converting binary to (arbitrary) integer first and
#       then converting to base 16. This algorithm is optimized for binary and
#       uses a quick string replacement system for much better performance
static func str2hexadecimal(
		binary_str : String,
		signed     : bool = true) -> String:

	var Hexadecimal: Script = \
		load('res://addons/PressAccept/Byter/Hexadecimal.gd')
	
	var ret: String = ''

	if signed:
		binary_str = pad_to_byte_signed(binary_str, 4)
	else:
		binary_str = pad_to_byte(binary_str, 4)

	for i in range(0, binary_str.length(), 4):
		var unit: String = binary_str.substr(i, 4)
		ret += DICT_BINARY_2_HEXADECIMAL[unit]

	return ret


# alias for str2hexadecimal
static func str2hex(
		binary_str : String,
		signed     : bool = true) -> String:

	return str2hexadecimal(binary_str, signed)


# convert array of bools (most->least) to hexadecimal string representation
#
# NOTE: uses str2hexadecimal after converting array to string, see
#       str2hexadecimal for performance information
static func array2hexadecimal(
		bool_array : Array,
		signed     : bool = true) -> String:

	return str2hexadecimal(array2str(bool_array), signed)


# alias for array2hexadecimal
static func array2hex(
		bool_array : Array,
		signed     : bool = true) -> String:

	return array2hexadecimal(bool_array, signed)


# convert boolean string representation to base-36 string
#
# pass true to signed to use 2s-complement
#
# Test in test_base36.gd
static func str2base36(
		binary_str: String) -> String:

	var Base36: Script = load('res://addons/PressAccept/Byter/Base36.gd')

	return Base36.integer2str(str2unsigned(binary_str))


# alias for str2base36
static func str2b36(
		binary_str: String) -> String:

	return str2base36(binary_str)


# convert array of boolean values (first->last) to base-36 string
#
# pass true to signed to use 2s-complement
static func array2base36(
		bool_array: Array) -> String:

	return str2base36(array2str(bool_array))


# alias for array2base36
static func array2b36(
		bool_array: Array) -> String:

	return array2base36(bool_array)


# convert boolean string representation to base-62 string representation
#
# pass true to signed to use 2s-complement
#
# Test in test_base62.gd
static func str2base62(
		binary_str: String) -> String:

	var Base62: Script = load('res://addons/PressAccept/Byter/Base62.gd')

	return Base62.integer2str(str2unsigned(binary_str))


# alias for str2base62
static func str2b62(
		binary_str: String) -> String:

	return str2base62(binary_str)


# convert array of boolean values (first->last) to base-62 string
#
# pass true to signed to use 2s-complement
static func array2base62(
		bool_array: Array) -> String:

	return str2base62(array2str(bool_array))


# alias for array2base62
static func array2b62(
		bool_array: Array) -> String:

	return array2base62(bool_array)


# convert boolean string representation to arbitrary base string
#
# pass true to signed to use 2s-complement
static func str2arbitrary(
		binary_str : String,
		from_int   : FuncRef) -> String:

	return from_int.call_func(str2unsigned(binary_str))


# alias for str2base36
static func str2arb(
		binary_str : String,
		from_int   : FuncRef) -> String:

	return str2arbitrary(binary_str, from_int)


# convert array of bools (first->last) to base-36 string
#
# pass true to signed to use 2s-complement
static func array2arbitrary(
		bool_array : Array,
		from_int   : FuncRef) -> String:

	return str2arbitrary(array2str(bool_array), from_int)


# alias for array2base36
static func array2arb(
		bool_array : Array,
		from_int   : FuncRef) -> String:

	return array2arb(bool_array, from_int)


# |--------------------------------------|
# | Integer -> String | Array Conversion |
# |--------------------------------------|


# convert 2s-complement signed integer to binary padding/truncating <size> bits
#
# size of -1 doesn't pad nor truncate
#
# 1s-complement NEVER returns negative zero (-0)
static func signed2str(
		int_value,                                 # int | String
		size            : int  = INT_MAX_BITS,     # num bits to output
		ones_complement : bool = false) -> String: # use 1s-complement?

	var Basic: Script = PressAccept_Arbiter_Basic

	int_value = Basic.new(int_value)

	if ones_complement and int_value.negative_bool:
		int_value.add(1)

	var ret: String = int_value.to_binary()

	if size > 0:
		if ret.length() > size:
			ret = ret.substr(ret.length() - size)
		else:
			if int_value.negative_bool:
				# 2s-complement
				ret = pad_ones(ret, size)
			else:
				ret = ret.pad_zeros(size)

	return ret


# alias for signed2str
static func int2str(
		int_value,                                 # int | String
		size            : int  = INT_MAX_BITS,     # num bits to output
		ones_complement : bool = false) -> String: # use 1s-complement?

	return signed2str(int_value, size, ones_complement)


# convert 2s-complement signed integer to binary array
# 
# pads/truncates to <size> bits, size of -1 doesn't pad nor truncate
static func signed2array(
		int_value,                                # int | String
		size            : int  = INT_MAX_BITS,    # num bits to output
		ones_complement : bool = false) -> Array: # use 1s-complement?

	return str2array(signed2str(int_value, size, ones_complement))


# alias for signed2array
static func int2array(
		int_value,                                # int | String
		size            : int  = INT_MAX_BITS,    # num bits to output
		ones_complement : bool = false) -> Array: # use 1s-complement?

	return signed2array(int_value, size, ones_complement)


# convert 'unsigned' integer to binary string padding/truncating to <size> bits
#
# NOTE: performs an absolute value on any passed value ensuring a positive int
#
# size of -1 does not pad nor truncate
static func unsigned2str(
		int_value,                           # int | String
		size: int = INT_MAX_BITS) -> String: # num bits to output

	var Basic: Script = PressAccept_Arbiter_Basic

	int_value = Basic.new(int_value)
	int_value.negative_bool = false

	var ret: String = int_value.to_binary()

	if size > 0:
		if ret.length() > size:
			ret = ret.substr(ret.length() - size)
		else:
			ret = ret.pad_zeros(size)

	return ret


# alias for unsigned2str
static func uint2str(
		int_value,                           # int | String
		size: int = INT_MAX_BITS) -> String: # num bits to output

	return unsigned2str(int_value, size)


# convert 'unsigned' integer to array padding or truncating to <size> bits
#
# size of -1 does not pad nor truncate
static func unsigned2array(
		int_value,                          # int | String
		size: int = INT_MAX_BITS) -> Array: # num bits to output

	return str2array(unsigned2str(int_value, size))


# alias for unsigned2array
static func uint2array(
		int_value,                          # int | String
		size: int = INT_MAX_BITS) -> Array: # num bits to output

	return unsigned2array(int_value, size)


# |------------------------------------------------|
# | Integer -> String Conversion To Specific Bytes |
# |------------------------------------------------|


# convert 2s-complement signed integer to binary string
#
# pads/truncates to <bytes> bytes, partial application of signed2str
static func signed2bytes(
		int_value,                                 # int | String
		bytes           : int  = 1,                # bytes which to pad
		ones_complement : bool = false) -> String: # use 1s-complement?

	return signed2str(int_value, INT_BYTE_BITS * bytes, ones_complement)


# alias for signed2bytes
static func int2bytes(
		int_value,                                 # int | String
		bytes           : int  = 1,                # bytes which to pad
		ones_complement : bool = false) -> String: # use 1s-complement?

	return signed2bytes(int_value, bytes, ones_complement)


# convert 'unsigned' integer to binary, padding/truncating to <bytes> bytes
#
# partial application of unsigned2str
static func unsigned2bytes(
		int_value,                 # int | String
		bytes: int = 1) -> String: # bytes to output

	return unsigned2str(int_value, INT_BYTE_BITS * bytes)


# alias for unsigned2bytes
static func uint2bytes(
		int_value,                 # int | String
		bytes: int = 1) -> String: # bytes to output

	return unsigned2bytes(int_value, bytes)


# convert 2s-complement signed integer to binary padded/truncated to one byte
#
# partial application of signed2bytes
static func signed2byte(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?

	return signed2bytes(int_value, 1, ones_complement)


# alias of signed2str
static func int2byte(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?
	
	return signed2bytes(int_value, ones_complement)


# convert 'unsigned' integer to binary padded/truncated to one byte
#
# partial application of unsigned2bytes
static func unsigned2byte(
		int_value) -> String: # int | String

	return unsigned2bytes(int_value, 1)


# alias of unsigned2str
static func uint2byte(
		int_value) -> String: # int | String

	return unsigned2byte(int_value)


# convert 2s-complement signed integer to binary padded/truncated to two bytes
#
# partial application of signed2bytes
static func signed2bytes_2(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?

	return signed2bytes(int_value, 2, ones_complement)


# alias of signed2bytes_2
static func int2bytes_2(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?
	
	return signed2bytes_2(int_value, ones_complement)


# convert 'unsigned' integer to binary string padded/truncated to two bytes
#
# partial application of unsigned2bytes
static func unsigned2bytes_2(
		int_value) -> String: # int | String

	return unsigned2bytes(int_value, 2)


# alias of unsigned2bytes_2
static func uint2bytes_2(
		int_value) -> String: # int | String

	return unsigned2bytes_2(int_value)


# convert 2s-complement signed integer to binary string
#
# padded/truncated to three bytes, partial application of signed2bytes
static func signed2bytes_3(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?

	return signed2bytes(int_value, 3, ones_complement)


# alias of signed2bytes_3
static func int2bytes_3(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?
	
	return signed2bytes_3(int_value, ones_complement)


# convert 'unsigned' integer to binary string padded/truncated to three byte
#
# partial application of unsigned2bytes
static func unsigned2bytes_3(
		int_value) -> String: # int | String

	return unsigned2bytes(int_value, 3)


# alias of unsigned2bytes_3
static func uint2bytes_3(
		int_value) -> String: # int | String

	return unsigned2bytes_3(int_value)


# convert 2s-complement signed integer to binary string
#
# padded/truncated to four bytes, partial application of signed2bytes
static func signed2bytes_4(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?

	return signed2bytes(int_value, 4, ones_complement)


# alias of signed2bytes_4
static func int2bytes_4(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?
	
	return signed2bytes_4(int_value, ones_complement)


# convert 'unsigned' integer to binary string padded/truncated to four bytes
#
# partial application of unsigned2bytes
static func unsigned2bytes_4(
		int_value) -> String: # int | String

	return unsigned2bytes(int_value, 4)


# alias of unsigned2bytes_4
static func uint2bytes_4(
		int_value) -> String: # int | String

	return unsigned2bytes_4(int_value)


# convert 2s-complement signed integer to binary string
#
# padded/truncated to five bytes, partial application of signed2bytes
static func signed2bytes_5(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?

	return signed2bytes(int_value, 5, ones_complement)


# alias of signed2bytes_5
static func int2bytes_5(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?
	
	return signed2bytes_5(int_value, ones_complement)


# convert 'unsigned' integer to binary string padded/truncated to five bytes
#
# partial application of unsigned2bytes
static func unsigned2bytes_5(
		int_value) -> String: # int | String

	return unsigned2bytes(int_value, 5)


# alias of unsigned2bytes_5
static func uint2bytes_5(
		int_value) -> String: # int | String

	return unsigned2bytes_5(int_value)


# convert 2s-complement signed integer to binary string
#
# padded/truncated to six bytes, partial application of signed2bytes
static func signed2bytes_6(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?

	return signed2bytes(int_value, 6, ones_complement)


# alias of signed2bytes_6
static func int2bytes_6(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?
	
	return signed2bytes_6(int_value, ones_complement)


# convert 'unsigned' integer to binary string padded/truncated to six bytes
#
# partial application of unsigned2bytes
static func unsigned2bytes_6(
		int_value) -> String: # int | String

	return unsigned2bytes(int_value, 6)


# alias of unsigned2bytes_6
static func uint2bytes_6(
		int_value) -> String: # int | String

	return unsigned2bytes_6(int_value)


# convert 2s-complement signed integer to binary string
#
# padded to seven bytes, partial application of signed2bytes
static func signed2bytes_7(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?

	return signed2bytes(int_value, 7, ones_complement)


# alias of signed2bytes_7
static func int2bytes_7(
		int_value,                                # int | String
		ones_complement: bool = false) -> String: # use 1s-complement?
	
	return signed2bytes_7(int_value, ones_complement)


# convert 'unsigned' integer to binary string padded/truncated to seven bytes
#
# partial application of unsigned2bytes
static func unsigned2bytes_7(
		int_value) -> String: # int | String

	return unsigned2bytes(int_value, 7)


# alias of unsigned2bytes_7
static func uint2bytes_7(
		int_value) -> String: # int | String

	return unsigned2bytes_7(int_value)


# |----------------------------------|
# | Any -> String | Array Conversion |
# |----------------------------------|


# dynamically typed conversion
static func to_binary(
		from_value,
		radix     = -1,           # radix from_value is in
								  #     defaults to signed decimal
		size: int = -1,           # bits to output
		to_value  = -1):          # ENUM_FORMAT/ARR_FORMAT to output,
								  #     defaults to STRING

	var Formats      : Script     = PressAccept_Byter_Formats
	var ENUM_FORMATS : Dictionary = Formats.ENUM_FORMATS
	var ENUM_RADIX   : Dictionary = Formats.ENUM_RADIX

	if radix is String:
		radix = Formats.str2radix(radix)

	if radix < 0:
		radix = ENUM_RADIX.SIGNED_DECIMAL

	if to_value is String:
		to_value = Formats.str2format(to_value)

	if to_value < 0:
		to_value = ENUM_FORMATS.STRING

	match typeof(from_value):
		TYPE_INT:
			match radix:
				ENUM_RADIX.UNSIGNED_DECIMAL:
					from_value = unsigned2str(from_value, size)
				ENUM_RADIX.SIGNED_DECIMAL:
					from_value = signed2str(from_value, size)

		TYPE_STRING:
			var base_module: Script
			match radix:
				ENUM_RADIX.UNSIGNED_DECIMAL:
					from_value = unsigned2str(from_value, size)
				ENUM_RADIX.SIGNED_DECIMAL:
					from_value = signed2str(from_value, size)
				ENUM_RADIX.OCTAL:
					base_module = \
						load('res://addons/PressAccept/Byter/Octal.gd')
					continue
				ENUM_RADIX.HEXADECIMAL:
					base_module = \
						load('res://addons/PressAccept/Byter/Hexadecimal.gd')
					continue
				ENUM_RADIX.UNSIGNED_BASE_36, ENUM_RADIX.SIGNED_BASE_36:
					base_module = \
						load('res://addons/PressAccept/Byter/Base36.gd')
					continue
				ENUM_RADIX.UNSIGNED_BASE_62, ENUM_RADIX.SIGNED_BASE_62:
					base_module = \
						load('res://addons/PressAccept/Byter/Base62.gd')
					continue
				ENUM_RADIX.OCTAL, ENUM_RADIX.HEXADECIMAL:
					from_value = base_module.str2binary(from_value, true)
				ENUM_RADIX.UNSIGNED_BASE_36, \
				ENUM_RADIX.SIGNED_BASE_36, \
				ENUM_RADIX.UNSIGNED_BASE_62,\
				ENUM_RADIX.SIGNED_BASE_62:
					from_value = base_module.str2binary(from_value)

		TYPE_ARRAY:
			if to_value == ENUM_FORMATS.ARRAY:
				return from_value
			from_value = array2str(from_value).pad_zeros(size)

		TYPE_OBJECT:
			match radix:
				ENUM_RADIX.UNSIGNED_DECIMAL:
					from_value = unsigned2str(from_value.to_decimal(), size)
				ENUM_RADIX.SIGNED_DECIMAL:
					from_value = signed2str(from_value.to_decimal(), size)

		_:
			return null

	match to_value:
		ENUM_FORMATS.STRING:
			return from_value
		ENUM_FORMATS.ARRAY:
			return str2array(from_value, true)

	return null;

