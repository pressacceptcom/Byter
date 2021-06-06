tool
class_name PressAccept_Byter_Byter

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This titular class definition outlines an object that stores an internal
# value of any magnitude (uses arbitrary precision arithmetic, Arbiter) Once
# a value of any given radix format is set, that value can then be retrieved
# using any other radix either via method or property access.
#
# The retrieved values are cached so as not to compute the same value twice
# from the same base. You are free to retrieve the same value string repeatedly
# for only the cost of a method call and an if clause.
#
# When the internal value changes, a signal 'value_changed' is fired with the
# new value and the old value.
#
# NOTE: this uses 2s-complement on binary I/O to cover the range of integers
#       set ones_complement to override this behavior (1s-complement never
#       actually returns negative zero in this case)
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : Byter
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
# | Signals |
# ***********

# fires when a new output value is calculated
#
# is fired once per value calculation since results are cached
signal calculated_value (output, new_value, emitter)

# fires when the number of bits to output in binary changes
signal resized          (new_size_value, old_size_value, emitter)

# fires when the internal value of the object changes
signal value_changed    (new_decimal_value, old_decimal_value, emitter)

# ***********
# | Imports |
# ***********

# arbitrary precision arithmetic, instance used for internal value
const Basic: Script = PressAccept_Arbiter_Basic

# import formats enumeration
const Formats      : Script     = PressAccept_Byter_Formats
const ENUM_FORMATS : Dictionary = Formats.ENUM_FORMATS

# import 'arbitrary radix' conversion modules
const Binary      : Script = PressAccept_Byter_Binary
const Octal       : Script = PressAccept_Byter_Octal
const Hexadecimal : Script = PressAccept_Byter_Hexadecimal
const Base36      : Script = PressAccept_Byter_Base36
const Base62      : Script = PressAccept_Byter_Base62

# ****************
# | Enumerations |
# ****************

# list of byter output formats (used in caching mechanism)
enum ENUM_OUTPUTS {
	UNSIGNED_BINARY_STR,
	UNSIGNED_BINARY_ARRAY,
	SIGNED_BINARY_STR,
	SIGNED_BINARY_ARRAY,
	UNSIGNED_OCTAL,
	SIGNED_OCTAL,
	DECIMAL,
	UNSIGNED_HEXADECIMAL,
	SIGNED_HEXADECIMAL,
	UNSIGNED_BASE_36,
	SIGNED_BASE_36,
	UNSIGNED_BASE_62,
	SIGNED_BASE_62
}

enum ENUM_OPS {
	UBINSTR,
	UBINARR,
	SBINSTR,
	SBINARR,
	UOCT,
	SOCT,
	DEC,
	UHEX,
	SHEX,
	UB36,
	SB36,
	UB62,
	SB62
}

# *************
# | Constants |
# *************

const ARR_OUTPUTS: Array = [
	'UNSIGNED_BINARY_STR',
	'UNSIGNED_BINARY_ARRAY',
	'SIGNED_BINARY_STR',
	'SIGNED_BINARY_ARRAY',
	'UNSIGNED_OCTAL',
	'SIGNED_OCTAL',
	'DECIMAL',
	'UNSIGNED_HEXADECIMAL',
	'SIGNED_HEXADECIMAL',
	'UNSIGNED_BASE_36',
	'SIGNED_BASE_36',
	'UNSIGNED_BASE_62',
	'SIGNED_BASE_62'
]

const ARR_OPS: Array = [
	'UBINSTR',
	'UBINARR',
	'SBINSTR',
	'SBINARR',
	'UOCT',
	'SOCT',
	'DEC',
	'UHEX',
	'SHEX',
	'UB36',
	'SB36',
	'UB62',
	'SB62'
]


# Convert format enumeration to string representation
static func outputs2str(
		output_code: int) -> String:

	return ARR_OUTPUTS[output_code]


# Convert string representation to pin integer
static func str2outputs(
		output_str: String) -> int:

	output_str = output_str.to_upper()

	if output_str in ARR_OUTPUTS:
		return ARR_OUTPUTS.find(output_str)
	return ARR_OUTPUTS.find(output_str)


# *********************
# | Public Properties |
# *********************

# |-----------------------------|
# | Binary Output Configuration |
# |-----------------------------|

# number of output bits, defaults to 64 (INT_MAX_BITS)
var size            : int  = Binary.INT_MAX_BITS setget set_size

# call enforce_binary?
var enforce_binary  : bool = true  setget set_enforce_binary

# use 1s-complement instead of 2s-complement?
var ones_complement : bool = false setget set_ones_complement

# |---------------|
# | Binary Output |
# |---------------|

# binary string representation
var unsigned_binary_str : String \
	setget set_unsigned_binary_str, get_unsigned_binary_str
var signed_binary_str   : String \
	setget set_signed_binary_str  , get_signed_binary_str

# binary array representation
var unsigned_binary_array : Array \
	setget set_unsigned_binary_array, get_unsigned_binary_array
var signed_binary_array   : Array \
	setget set_signed_binary_array  , get_signed_binary_array

# shorthand aliases
var ubin_str  : String setget set_unsigned_binary_str, get_unsigned_binary_str
var sbin_str  : String setget set_signed_binary_str  , get_signed_binary_str
var u_bin_arr : Array  \
	setget set_unsigned_binary_array, get_unsigned_binary_array
var s_bin_arr : Array  \
	setget set_signed_binary_array  , get_signed_binary_array

# |--------------|
# | Octal Output |
# |--------------|

# octal string representation
var unsigned_octal_str : String \
	setget set_unsigned_octal_str, get_unsigned_octal_str
var signed_octal_str   : String \
	setget set_signed_octal_str  , get_signed_octal_str

# shorthand alias
var u_oct_str: String setget set_unsigned_octal_str, get_unsigned_octal_str
var s_oct_str: String setget set_signed_octal_str  , get_signed_octal_str

# |----------------|
# | Decimal Output |
# |----------------|

# decimal string representation
var decimal_str : String setget set_decimal_str, get_decimal_str

# shorthand alias
var dec         : String setget set_decimal_str, get_decimal_str

# |--------------------|
# | Hexadecimal Output |
# |--------------------|

# hexadecimal string representation
var unsigned_hexadecimal_str : String \
	setget set_unsigned_hexadecimal_str, get_unsigned_hexadecimal_str
var signed_hexadecimal_str   : String \
	setget set_signed_hexadecimal_str  , get_signed_hexadecimal_str

# shorthand alias
var u_hex_str: String \
	setget set_unsigned_hexadecimal_str, get_unsigned_hexadecimal_str
var s_hex_str: String \
	setget set_signed_hexadecimal_str  , get_signed_hexadecimal_str

# |----------------|
# | Base 36 Output |
# |----------------|

# base 36 string representation
var unsigned_base36_str : String \
	setget set_unsigned_base36_str, get_unsigned_base36_str
var signed_base36_str   : String \
	setget set_signed_base36_str  , get_signed_base36_str

# shorthand alias
var u_b36_str: String setget set_unsigned_base36_str, get_unsigned_base36_str
var s_b36_str: String setget set_signed_base36_str  , get_signed_base36_str

# |----------------|
# | Base 62 Output |
# |----------------|

# base 62 string representation
var unsigned_base62_str : String \
	setget set_unsigned_base62_str, get_unsigned_base62_str
var signed_base62_str   : String \
	setget set_signed_base62_str  , get_signed_base62_str

# shorthand alias
var u_b62_str: String setget set_unsigned_base62_str, get_unsigned_base62_str
var s_b62_str: String setget set_signed_base62_str  , get_signed_base62_str

# internal value
var value setget set_value # PressAccept_Arbiter_Basic

# **********************
# | Private Properties |
# **********************

# need to compute new values?
var _dirty: Dictionary = {
	ENUM_OUTPUTS.UNSIGNED_BINARY_STR   : true,
	ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY : true,
	ENUM_OUTPUTS.SIGNED_BINARY_STR     : true,
	ENUM_OUTPUTS.SIGNED_BINARY_ARRAY   : true,
	ENUM_OUTPUTS.UNSIGNED_OCTAL        : true,
	ENUM_OUTPUTS.SIGNED_OCTAL          : true,
	ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL  : true,
	ENUM_OUTPUTS.SIGNED_HEXADECIMAL    : true,
	ENUM_OUTPUTS.DECIMAL               : true,
	ENUM_OUTPUTS.UNSIGNED_BASE_36      : true,
	ENUM_OUTPUTS.SIGNED_BASE_36        : true,
	ENUM_OUTPUTS.UNSIGNED_BASE_62      : true,
	ENUM_OUTPUTS.SIGNED_BASE_62        : true
}

# ***************
# | Constructor |
# ***************


# constructor( int | String | Array | Object, int)
#
# this is the same constructor as an instance of PressAccept_Arbiter_Basic
#
# if the first argument is an array, then init_base represents the radix of
# that array and will be the radix of the new values_arr, otherwise init_base
# indicates the radix by which the new value will be stored
func _init(
		init_value     = 0,
		init_base: int = Basic.INT_BYTE_BASE) -> void:

	self.value = Basic.new(init_value, init_base)
	value.signal_value_change = true
	value.connect('value_changed', self, '_on_value_changed')


# ******************
# | SetGet Methods |
# ******************


# |--------------------------|
# | Configuration Properties |
# |--------------------------|


# sets the max output size of the binary output, set to -1 for unlimited
func set_size(
		new_value: int) -> PressAccept_Byter_Byter:

	if (new_value != size):
		var old_size_value: int = size
		size = new_value
		_dirty[ENUM_OUTPUTS.UNSIGNED_BINARY_STR]   = true
		_dirty[ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY] = true
		_dirty[ENUM_OUTPUTS.SIGNED_BINARY_STR]     = true
		_dirty[ENUM_OUTPUTS.SIGNED_BINARY_ARRAY]   = true
		emit_signal('resized', size, old_size_value, self)

	return self


# alias for set_size
func resize(
		new_value: int) -> PressAccept_Byter_Byter:

	return set_size(new_value)


# do we do 'relaxed' binary string interpretation?
func set_enforce_binary(
		new_value: bool) -> PressAccept_Byter_Byter:

	enforce_binary = new_value
	return self


# do we use 1s-complement to interpret -input- binary instead of 2s-complement?
func set_ones_complement(
		new_value: bool) -> PressAccept_Byter_Byter:

	ones_complement = new_value
	return self


# set the internal value (PressAccept_Arbiter_Basic instance), see constructor
#
# new_value can also be a PressAccept_Arbiter_Basic object itself, in which
# case we transfer our signal observations to the new instance and disconnect
# from the old instance
func set_value(
		new_value,
		new_value_base_int: int = Basic.INT_BYTE_BASE) -> void:

	if new_value is PressAccept_Arbiter_Basic:
		var old_decimal_value: String = '0'

		# make sure we disconnect from the old instance
		if value:
			old_decimal_value = value.to_decimal()
			value.disconnect('value_changed', self, '_on_value_changed')
		
		value = new_value

		# make sure the new instance signals us
		value.signal_value_change = true
		value.connect('value_changed', self, '_on_value_changed')
		_set_all_dirty()
		
		emit_signal(
			'value_changed',
			old_decimal_value,
			value.to_decimal(),
			self
		)
	else:
		value.set_value(new_value, new_value_base_int)


# |---------------|
# | Binary Output |
# |---------------|

#     |----------|
#     | Unsigned |
#     |----------|

#         |--------|
#         | String |
#         |--------|


# set by unsigned binary string
func set_unsigned_binary_str(
		new_binary_value: String) -> PressAccept_Byter_Byter:

	value.set_value(Binary.str2unsigned(new_binary_value, enforce_binary))
	return self


# returns unsigned binary string
func get_unsigned_binary_str() -> String:

	if _dirty[ENUM_OUTPUTS.UNSIGNED_BINARY_STR]:
		unsigned_binary_str = \
			Binary.unsigned2str(value.to_decimal().trim_prefix('-'), size)

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.UNSIGNED_BINARY_STR,
			unsigned_binary_str,
			self
		)

		_dirty[ENUM_OUTPUTS.UNSIGNED_BINARY_STR] = false

	return unsigned_binary_str


#         |-----------------------|
#         | Unsigned Binary Array |
#         |-----------------------|


# set by unsigned binary array
func set_unsigned_binary_array(
		new_binary_value: Array) -> PressAccept_Byter_Byter:

	value.set_value(
		Binary.array2unsigned(new_binary_value, ones_complement)
	)

	return self


# returns unsigned binary array
func get_unsigned_binary_array() -> Array:

	if _dirty[ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY]:
		unsigned_binary_array = \
			Binary.unsigned2array(value.to_decimal().trim_prefix('-'), size)

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY,
			unsigned_binary_array,
			self
		)

		_dirty[ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY] = false

	return unsigned_binary_array


#     |--------|
#     | Signed |
#     |--------|

#         |--------|
#         | String |
#         |--------|


# set by signed binary string
func set_signed_binary_str(
		new_binary_value: String) -> PressAccept_Byter_Byter:

	value.set_value(
		Binary.str2signed(new_binary_value, enforce_binary, ones_complement)
	)
	return self


#returns signed binary string
func get_signed_binary_str() -> String:

	if _dirty[ENUM_OUTPUTS.SIGNED_BINARY_STR]:
		signed_binary_str = Binary.signed2str(value.to_decimal(), size)

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.SIGNED_BINARY_STR,
			signed_binary_str,
			self
		)

		_dirty[ENUM_OUTPUTS.SIGNED_BINARY_STR] = false

	return signed_binary_str


#         |---------------------|
#         | Signed Binary Array |
#         |---------------------|


# set by signed binary array
func set_signed_binary_array(
		new_binary_value: Array) -> PressAccept_Byter_Byter:

	value.set_value(Binary.array2signed(new_binary_value, ones_complement))

	return self


# return signed binary array
func get_signed_binary_array() -> Array:

	if _dirty[ENUM_OUTPUTS.SIGNED_BINARY_ARRAY]:
		signed_binary_array = Binary.signed2array(value.to_decimal(), size)

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.SIGNED_BINARY_ARRAY,
			signed_binary_array,
			self
		)

		_dirty[ENUM_OUTPUTS.SIGNED_BINARY_ARRAY] = false

	return signed_binary_array


# |--------------|
# | Octal Output |
# |--------------|

#     |----------|
#     | Unsigned |
#     |----------|


# set bu unsigned octal string
func set_unsigned_octal_str(
		new_octal_value: String) -> PressAccept_Byter_Byter:

	value.set_value(Octal.str2unsigned(new_octal_value))

	return self


# return unsigned octal string
func get_unsigned_octal_str() -> String:

	if _dirty[ENUM_OUTPUTS.UNSIGNED_OCTAL]:
		unsigned_octal_str = \
			Octal.unsigned2str(value.to_decimal().trim_prefix('-'))

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.UNSIGNED_OCTAL,
			unsigned_octal_str,
			self
		)

		_dirty[ENUM_OUTPUTS.UNSIGNED_OCTAL] = false

	return unsigned_octal_str


#     |--------|
#     | Signed |
#     |--------|


# set by signed octal string
func set_signed_octal_str(
		new_octal_value: String) -> PressAccept_Byter_Byter:

	value.set_value(Octal.str2signed(new_octal_value))

	return self


# return signed octal string
func get_signed_octal_str() -> String:

	if _dirty[ENUM_OUTPUTS.SIGNED_OCTAL]:
		signed_octal_str = Octal.signed2str(value.to_decimal())

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.SIGNED_OCTAL,
			signed_octal_str,
			self
		)

		_dirty[ENUM_OUTPUTS.SIGNED_OCTAL] = false

	return signed_octal_str


# |----------------|
# | Decimal Output |
# |----------------|


# set by decimal value (String only)
func set_decimal_str(
		new_decimal_value: String) -> PressAccept_Byter_Byter:

	value.set_value(new_decimal_value)

	return self


# return decimal value (String only)
func get_decimal_str() -> String:

	if _dirty[ENUM_OUTPUTS.DECIMAL]:
		decimal_str = value.to_decimal()

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.DECIMAL,
			decimal_str,
			self
		)

		_dirty[ENUM_OUTPUTS.DECIMAL] = false

	return decimal_str


# |--------------------|
# | Hexadecimal Output |
# |--------------------|

#     |----------|
#     | Unsigned |
#     |----------|


# set by unsigned hexadecimal string
func set_unsigned_hexadecimal_str(
		new_hexadecimal_value: String) -> PressAccept_Byter_Byter:

	value.set_value(Hexadecimal.str2unsigned(new_hexadecimal_value))

	return self


# return unsigned hexadecimal string
func get_unsigned_hexadecimal_str() -> String:

	if _dirty[ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL]:
		unsigned_hexadecimal_str = \
			Hexadecimal.unsigned2str(value.to_decimal().trim_prefix('-'))

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL,
			unsigned_hexadecimal_str,
			self
		)

		_dirty[ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL] = false

	return unsigned_hexadecimal_str


#     |--------|
#     | Signed |
#     |--------|


# set by signed hexadecimal string
func set_signed_hexadecimal_str(
		new_hexadecimal_value: String) -> PressAccept_Byter_Byter:

	value.set_value(Hexadecimal.str2signed(new_hexadecimal_value))

	return self


# return signed hexadecimal string
func get_signed_hexadecimal_str() -> String:

	if _dirty[ENUM_OUTPUTS.SIGNED_HEXADECIMAL]:
		signed_hexadecimal_str = Hexadecimal.signed2str(value.to_decimal())

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.SIGNED_HEXADECIMAL,
			signed_hexadecimal_str,
			self
		)

		_dirty[ENUM_OUTPUTS.SIGNED_HEXADECIMAL] = false

	return signed_hexadecimal_str


# |----------------|
# | Base 36 Output |
# |----------------|

#     |----------|
#     | Unsigned |
#     |----------|


# set by unsigned base 36 string
func set_unsigned_base36_str(
		new_base36_value: String) -> PressAccept_Byter_Byter:

	value.set_value(Base36.str2unsigned(new_base36_value))

	return self


# return unsigned base 36 string
func get_unsigned_base36_str() -> String:

	if _dirty[ENUM_OUTPUTS.UNSIGNED_BASE_36]:
		# string replacement algorithm
		unsigned_base36_str = \
			Base36.unsigned2str(value.to_decimal().trim_prefix('-'))

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.UNSIGNED_BASE_36,
			unsigned_base36_str,
			self
		)

		_dirty[ENUM_OUTPUTS.UNSIGNED_BASE_36] = false

	return unsigned_base36_str


#     |--------|
#     | Signed |
#     |--------|


# set by signed base 36 string
func set_signed_base36_str(
		new_base36_value: String) -> PressAccept_Byter_Byter:

	value.set_value(Base36.str2signed(new_base36_value))

	return self


# return signed base 36 string
func get_signed_base36_str() -> String:

	if _dirty[ENUM_OUTPUTS.SIGNED_BASE_36]:
		signed_base36_str = Base36.signed2str(value.to_decimal())

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.SIGNED_BASE_36,
			signed_base36_str,
			self
		)

		_dirty[ENUM_OUTPUTS.SIGNED_BASE_36] = false

	return signed_base36_str


# |----------------|
# | Base 62 Output |
# |----------------|

#     |----------|
#     | Unsigned |
#     |----------|


# set by unsigned base 62 string
func set_unsigned_base62_str(
		new_base62_value: String) -> PressAccept_Byter_Byter:

	value.set_value(Base62.str2unsigned(new_base62_value))

	return self


# return unsigned base 62 string
func get_unsigned_base62_str() -> String:

	if _dirty[ENUM_OUTPUTS.UNSIGNED_BASE_62]:
		unsigned_base62_str = \
			Base62.unsigned2str(value.to_decimal().trim_prefix('-'))

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.UNSIGNED_BASE_62,
			unsigned_base62_str,
			self
		)

		_dirty[ENUM_OUTPUTS.UNSIGNED_BASE_62] = false

	return unsigned_base62_str


#     |--------|
#     | Signed |
#     |--------|


# set by signed base 62 string
func set_signed_base62_str(
		new_base62_value: String) -> PressAccept_Byter_Byter:

	value.set_value(Base62.str2signed(new_base62_value))

	return self


# return signed base 62 string
func get_signed_base62_str() -> String:

	if _dirty[ENUM_OUTPUTS.SIGNED_BASE_62]:
		signed_base62_str = Base62.signed2str(value.to_decimal())

		emit_signal(
			'calculated_value',
			ENUM_OUTPUTS.SIGNED_BASE_62,
			signed_base62_str,
			self
		)

		_dirty[ENUM_OUTPUTS.SIGNED_BASE_62] = false

	return signed_base62_str


# *************************
# | Event/Signal Handlers |
# *************************


# emitted by value property when its value changes
func _on_value_changed(
		old_decimal_value : String,
		new_decimal_value : String,
		emitter           : PressAccept_Arbiter_Basic) -> void:

	_set_all_dirty()

	# re-broadcast out to our subscribers
	emit_signal('value_changed', old_decimal_value, new_decimal_value, self)


# ******************
# | Public Methods |
# ******************


# set by the given radix (uses enumeration)
func set_by_radix(
		new_value,
		# int | String
		radix = ENUM_OUTPUTS.DECIMAL) -> PressAccept_Byter_Byter:

	if typeof(radix) == TYPE_STRING:
		radix = str2outputs(radix)

	if typeof(new_value) == TYPE_OBJECT:
		new_value = new_value.to_decimal()

	match radix:
		ENUM_OUTPUTS.UNSIGNED_BINARY_STR:
			self.unsigned_binary_str = new_value
		ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY:
			self.unsigned_binary_array = new_value
		ENUM_OUTPUTS.SIGNED_BINARY_STR:
			self.signed_binary_str = new_value
		ENUM_OUTPUTS.SIGNED_BINARY_ARRAY:
			self.signed_binary_array = new_value
		ENUM_OUTPUTS.UNSIGNED_OCTAL:
			self.unsigned_octal_str = new_value
		ENUM_OUTPUTS.SIGNED_OCTAL:
			self.signed_octal_str = new_value
		ENUM_OUTPUTS.DECIMAL:
			self.decimal_str = new_value
		ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL:
			self.unsigned_hexadecimal_str = new_value
		ENUM_OUTPUTS.SIGNED_HEXADECIMAL:
			self.signed_hexadecimal_str = new_value
		ENUM_OUTPUTS.UNSIGNED_BASE_36:
			self.unsigned_base36_str = new_value
		ENUM_OUTPUTS.SIGNED_BASE_36:
			self.signed_base36_str = new_value
		ENUM_OUTPUTS.UNSIGNED_BASE_62:
			self.unsigned_base62_str = new_value
		ENUM_OUTPUTS.SIGNED_BASE_62:
			self.signed_base62_str = new_value

	return self


# returns the internal value by a given radix (uses enumeration)
func get_by_radix(
		radix): #int | String

	if typeof(radix) == TYPE_STRING:
		radix = str2outputs(radix)

	match radix:
		ENUM_OUTPUTS.UNSIGNED_BINARY_STR:
			return self.unsigned_binary_str
		ENUM_OUTPUTS.UNSIGNED_BINARY_ARRAY:
			return self.unsigned_binary_array
		ENUM_OUTPUTS.SIGNED_BINARY_STR:
			return self.signed_binary_str
		ENUM_OUTPUTS.SIGNED_BINARY_ARRAY:
			return self.signed_binary_array
		ENUM_OUTPUTS.UNSIGNED_OCTAL:
			return self.unsigned_octal_str
		ENUM_OUTPUTS.SIGNED_OCTAL:
			return self.signed_octal_str
		ENUM_OUTPUTS.DECIMAL:
			return self.decimal_str
		ENUM_OUTPUTS.UNSIGNED_HEXADECIMAL:
			return self.unsigned_hexadecimal_str
		ENUM_OUTPUTS.SIGNED_HEXADECIMAL:
			return self.signed_hexadecimal_str
		ENUM_OUTPUTS.UNSIGNED_BASE_36:
			return self.unsigned_base36_str
		ENUM_OUTPUTS.SIGNED_BASE_36:
			return self.signed_base36_str
		ENUM_OUTPUTS.UNSIGNED_BASE_62:
			return self.unsigned_base62_str
		ENUM_OUTPUTS.SIGNED_BASE_62:
			return self.signed_base62_str


# *******************
# | Private Methods |
# *******************


# eliminate the cache to recalculate the values
func _set_all_dirty() -> void:

	for key in _dirty:
		_dirty[key] = true

