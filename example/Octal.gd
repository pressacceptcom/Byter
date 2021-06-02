extends TextEdit

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This is part of the example scene that shows how the Byter library may be
# utilized. This script listens to the Decimal text field to produce an
# equivalent representation in octal.
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : Example Octal
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

# ***********
# | Imports |
# ***********

# arbitrary integer arithmetic/representation (used for parsing decimal)
var Basic : Script = PressAccept_Arbiter_Basic
# conversion module
var Octal : Script = PressAccept_Byter_Octal

# **********************
# | Node Relationships |
# **********************

# get input node when scene is ready
onready var Decimal       : TextEdit = get_node('../Decimal')

# *************************
# | Event/Signal Handlers |
# *************************


# called when Decimal TextEdit changes contents
func _on_Decimal_text_changed() -> void:

	# parse
	var basic: PressAccept_Arbiter_Basic = Basic.new(Decimal.text)
	
	# convert
	if basic.negative_bool:
		text = Octal.signed2str(basic.to_decimal())
	else:
		text = Octal.unsigned2str(basic.to_decimal())

