extends TextEdit

# |=========================================|
# |                                         |
# |           Press Accept: Byter           |
# |  Byte-wise Arbitrary Radix Conversions  |
# |                                         |
# |=========================================|
#
# This is part of the example scene that shows how the Byter library may be
# utilized. This script listens to two text fields to produce an arbitrary
# base conversion.
#
# |------------------|
# | Meta Information |
# |------------------|
#
# Organization Namespace : PressAccept
# Package Namespace      : Byter
# Class                  : Example ArbitraryBase
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
var Basic     : Script = PressAccept_Arbiter_Basic
# conversion module
var Arbitrary : Script = PressAccept_Byter_ArbitraryBase

# **********************
# | Node Relationships |
# **********************

# get our input nodes when scene is ready
onready var Decimal       : TextEdit = get_node('../Decimal')
onready var ArbitraryBase : TextEdit = get_node('../ArbitraryBase')

# *************************
# | Event/Signal Handlers |
# *************************


# called when either TextEdit node changes
func _on_text_changed() -> void:

	if not ArbitraryBase.text:
		text = ''
		return

	# parse
	var basic     : PressAccept_Arbiter_Basic = Basic.new(Decimal.text)
	var arbitrary : PressAccept_Byter_ArbitraryBase = \
		Arbitrary.new(ArbitraryBase.text)

	# convert
	if basic.negative_bool:
		text = arbitrary.signed2str(basic.to_decimal())
	else:
		text = arbitrary.unsigned2str(basic.to_decimal())

