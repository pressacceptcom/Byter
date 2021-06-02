tool

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This file contains functions that are common to a numebr of the modules. This
# includes an algorithm for converting a given base to an integer given a
# starter power table, normalizing an input radix for the included function of
# converting from a given radix input.
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : Common
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

# ***************************
# | Public Static Functions |
# ***************************


# convert <base> array representation to a positive integer
#
# NOTE: does not convert to binary as an intemediary
static func base2integer(
		value_arr     : Array,
		power_arr     : Array,
		return_object : bool = false):

	var Basic: Script = PressAccept_Arbiter_Basic

	var value_len : int = value_arr.size()
	var power_len : int = power_arr.size()

	var ret_obj   : PressAccept_Arbiter_Basic = Basic.new()
	var power_obj : PressAccept_Arbiter_Basic = null
	
	var value_obj : PressAccept_Arbiter_Basic = Basic.new()

	for value_place in range(value_len):
		if value_place < power_len:
			value_obj.set_value(value_arr[-value_place - 1])
			value_obj.multiply(power_arr[value_place])
			ret_obj.add(value_obj)
		else:
			if not power_obj:
				power_obj = Basic.new(power_arr[-1])
				for i in range(value_place - power_len + 1):
					power_obj.multiply(power_arr[1])

			value_obj.set_value(value_arr[-value_place - 1])
			value_obj.multiply(power_obj)
			ret_obj.add(value_obj)

		if power_obj:
			if value_place != value_len - 1:
				power_obj.multiply(power_arr[1])

	if return_object:
		return ret_obj

	return ret_obj.to_decimal()


# normalize a radix input so that's it's always a decimal value
static func normalize_radix(
		radix) -> int:

	var Formats    : Script     = PressAccept_Byter_Formats
	var ENUM_RADIX : Dictionary = Formats.ENUM_RADIX

	if radix is String:
		radix = Formats.str2radix(radix)
		
	if radix < 0:
		radix = ENUM_RADIX.SIGNED_DECIMAL

	return radix


# dynamically typed conversion
static func to_base(
		from_value,
		self_obj    : Object,
		func_suffix : String,
		from_radix = -1) -> String: # radix of from_value , def: signed decimal

	var ENUM_RADIX: Dictionary = PressAccept_Byter_Formats.ENUM_RADIX

	match typeof(from_value):
		TYPE_INT:
			match from_radix:
				ENUM_RADIX.UNSIGNED_DECIMAL:
					return self_obj.unsigned2str(from_value)
				ENUM_RADIX.SIGNED_DECIMAL:
					return self_obj.signed2str(from_value)

		TYPE_STRING:
			var base_module: Script
			match from_radix:
				ENUM_RADIX.UNSIGNED_DECIMAL:
					return self_obj.unsigned2str(from_value)
				ENUM_RADIX.SIGNED_DECIMAL:
					return self_obj.signed2str(from_value)
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
				ENUM_RADIX.UNSIGNED_BASE_36, ENUM_RADIX.SIGNED_BASE_36:
					base_module = \
						load('res://addons/PressAccept/Byter/Base36.gd')
					continue
				ENUM_RADIX.UNSIGNED_BASE_62, ENUM_RADIX.SIGNED_BASE_62:
					base_module = \
						load('res://addons/PressAccept/Byter/Base62.gd')
					continue
				ENUM_RADIX.OCTAL, ENUM_RADIX.HEXADECIMAL:
					var function: FuncRef = \
						funcref(base_module, 'str2' + func_suffix)
					if function:
						
						return function.call_func(from_value)
				ENUM_RADIX.UNSIGNED_BASE_36, ENUM_RADIX.UNSIGNED_BASE_62:
					var function: FuncRef = \
						funcref(base_module, 'str2' + func_suffix)
					if function:
						
						return function.call_func(from_value, false)
				ENUM_RADIX.SIGNED_BASE_36, ENUM_RADIX.SIGNED_BASE_62:
					var function: FuncRef = \
						funcref(base_module, 'str2' + func_suffix)
					if function:
						
						return function.call_func(from_value, true)

		TYPE_ARRAY:
			var function: FuncRef = \
				funcref(PressAccept_Byter_Binary, 'array2' + func_suffix)
			if function:
				return function.call_func(from_value)

		TYPE_OBJECT:
			match from_radix:
				ENUM_RADIX.UNSIGNED_DECIMAL:
					return self_obj.unsigned2str(from_value.to_decimal())
				ENUM_RADIX.SIGNED_DECIMAL:
					return self_obj.signed2str(from_value.to_decimal())

	return ''

