#!/bin/bash
#===============================================================================
#
#          FILE:  test.sh
# 
#         USAGE:  ./test.sh 
# 
#   DESCRIPTION:  Test libtab.sh
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Thomas Maier (Bashunit), hayzer@gmail.com
#       COMPANY:  GNU
#       VERSION:  1.0
#       CREATED:  01/08/2008 11:46:39 PM IST
#      REVISION:  ---
#       LICENSE: GNU GPL
#===============================================================================

#===============================================================================
# This file is part of TestSimple.
# Copyright (C) 2008 - 2008 Thomas Maier
#
# TestSimple is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#===============================================================================


source lib/TestSimple.sh

testplan 10

is_true 'ls -l'
is_false 'ls ./dda'
is_exact 2 2 "Two is two"
is_like "abc" "ab*" "Check is_like"

diag "Very slow test"

is_exact "baa" "aa" "Two is not four"
is_like "abcd" "bc" "is_like test"
is_file "./test.sh" "is_file test"
is_dir "/usr/local" "is_dir test"
is_executable "./test.sh" "is_executable test"
is_insmod tg3      "is_insmod test"

exit 0
