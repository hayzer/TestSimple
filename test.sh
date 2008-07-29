#!/bin/bash
#===============================================================================
#
#          FILE:  test.sh
# 
#         USAGE:  ./test.sh 
# 
#   DESCRIPTION:  Example of TestSimple.sh usage.
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Thomas Maier (Bashunit), hayzer@gmail.com
#       COMPANY:  GNU
#       VERSION:  0.01
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

testplan 26

is_equal         "2 * 2" 4   "check is_eqal"

skip_on
is_equal         "2 * 2" 5   "check is_eqal"
skip_off

is_greater       1       4   "check is_greater"
is_less          2       1   "check is_less"
is_greater_or_equal                                       \
                 2       1   "check is_greater_or_equal"
is_greater_or_equal                                       \
                 44      44  "check is_greater_or_equal"
is_less_or_equal 3       4   "check is_less_or_equal"
is_less_or_equal 4       4   "check is_less_or_equal"

is_greater_or_equal                                       \
                 2       3   "check is_greater_or_equal"

is_not_equal     "2 * 2" 5   "check is_not_eqal"
is_true          'ls -l'     "Correct operation"
is_false         'ls ./dda'  "False operation"
is_exact          2 2        "Two is two"

diag             "Very slow test"

is_exact         "baa" "aa"  "is_exact fail"
is_not_exact     "baa" "aa"  "is_not_exact pass"

is_file          "./test.sh"  "is_file test"
is_not_file      "./testy.sh" "is_not_file test"

is_dir           "/usr/local" "is_dir test"
is_not_dir       "/abc"       "is_not_dir test"

ln -s ./test.sh ./stam.link
is_symlink       ./stam.link  "is_symlink test"

rm -f ./stam.link
is_not_symlink   ./stam.link  "is_not_symlink test"

process=$$
is_process_id    "${process}" "is_process test"
process=$(( process++ ))
is_not_process_id "${process}" "is_not_process test"

is_executable    "./test.sh"  "is_executable test"
is_insmod        "tg3"        "is_insmod test"
is_not_insmod    "ipw2200"    "is_not_insmod"

exit 0
