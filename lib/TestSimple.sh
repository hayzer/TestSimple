#!/bin/bash
#===============================================================================
#
#          FILE:  TestSimple.sh
# 
#         USAGE:  source ./TestSimple.sh 
# 
#   DESCRIPTION:  Basic Bash testing library
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Thomas Maier, hayzer@gmail.com
#       VERSION:  0.01
#       CREATED:  06/15/2008 04:36:50 PM IDT
#      REVISION:  ---
#       LICENSE: GNU GPL
#===============================================================================
#
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

#-------------------------------------------------------------------------------
#   Basic functions
#-------------------------------------------------------------------------------

TESTPLAN=
TESTCOUNTER=0
TIME_ON=true
WITHCOUNTER=true
WITHDESCRIP=true
TODO=false
SKIP=false
SKIP_ALL=false
TRUE=0
FALSE=1
FAILCOUNTER=0
FOOTER=true

trap on_trap EXIT

function on_trap {
	declare msg_header="# Looks like you failed ${FAILCOUNTER}"
	declare msg_footer=''
	declare tests plan
	if [ ${FAILCOUNTER} -eq 1 ]; then
		test='test'
	elif [ ${FAILCOUNTER} -gt 1 ]; then
		test='tests'
	else
		return ${FALSE}
	fi

	if [ ${TESTPLAN} -eq 1 ]; then
		plan='test'
	else
		plan='tests'
	fi

	if [ ${TESTPLAN} -gt ${TESTCOUNTER} ]; then
		msg_footer="# Looks like you planned ${TESTPLAN}"
		      only='only '
                     extra=''

		msg_footer="${msg_footer} ${plan} but ${only}ran ${TESTCOUNTER} ${extra}\n"
	elif [ ${TESTPLAN} -lt ${TESTCOUNTER} ]; then
		msg_footer="# Looks like you planned ${TESTPLAN}"
		      only=''
		     extra='extra'

		extra_tests=$(( ${TESTCOUNTER} - ${TESTPLAN} ))
		msg_footer="${msg_footer} ${plan} but ${only}ran ${extra_tests} ${extra}\n"
	fi

	msg_header="${msg_header} ${test} of ${TESTCOUNTER}\n"
	if ${FOOTER}; then
		echo -ne "${msg_footer}${msg_header}" >&2
	fi
}
		
#-------------------------------------------------------------------------------
#   TAP functions
#-------------------------------------------------------------------------------
function diag {
	declare diagnostic="${*}"
	
	echo -en "# ${diagnostic}\n" >&2
}

function skip_all {
	SKIP_ALL_DESCRIPTION="${*}"
	SKIP_ALL=true
}

function testplan() {
	declare test="${1}"
	declare postfix
	
	if [ ! ${test} -gt 0 ]; then
		echo "Test plan cannot be ${test}"
		exit 1
	fi

	TESTPLAN=${test}

	if ${SKIP_ALL}; then
		postfix=" # Skipped: ${SKIP_ALL_DESCRIPTION}"
		   test=0
	fi

	echo -en "1..${test}${postfix}\n"
}

function reset() {
	TESTPLAN=
	TESTCOUNTER=0
	FOOTER=false
}

function todo_on {
	TODO=true
}

function todo_off {
	TODO=false
}

function skip_on {
	SKIP=true
}

function skip_off {
	SKIP=false
}

function bail_out {
	declare description="${*}"

	echo -en "Bail out! ${description}\n";
	exit 1
} 

function current_time {
	declare ctime=$(date +'%R:%S.%N %x')
	echo ${ctime}
}

function unset_time {
	unset START_TIME STOP_TIME
}

function print_verbose_result {
	declare        have="${1}"
	declare        want="${2}"
	declare description="${3}"
	declare        name="$0"
	declare        line="${BASH_LINENO[2]}"

	declare msg
	if [ "X${VERBOSE}" != "X" ]; then
		msg=$(cat <<END_RESULT
#   Failed test '${description}'
#  start test: '${START_TIME}'
#   stop test: '${STOP_TIME}'
#       where: '${name}:${line}'
#        have: '${got}'
#        want: '${expected}'
END_RESULT)
		echo "${msg}" >&2
	fi
}

function print_verbose_error {
	declare       error="${1}"
	declare description="${2}"
        declare        name="$0"
	declare        line="${BASH_LINENO[2]}"

	declare msg
	if [ "X${VERBOSE}" != "X" ]; then
		msg=$(cat <<END_RESULT
# Failed test '${description}'
#    where: '${name}:${line}'
#    error: '${error}'
END_RESULT)
		echo ${msg} >&2
	fi
}

function print_counter {
	TESTCOUNTER=$(( ${TESTCOUNTER} + 1 ))
	if ${WITHCOUNTER}; then
		echo -en "${TESTCOUNTER}"
	fi
}

function print_todo {
	declare msg=''
	
	if ${TODO}; then
		msg=" # TODO"
	elif ${SKIP}; then
		msg=" # SKIP"
	fi

	echo "${msg}"
}

function print_description {
	if ${WITHDESCRIP}; then
		echo -en "${prefix} ${description}"
	fi
}

function print_ok {
	declare description="${*}"
	declare prefix

	echo -en "ok "
	
	print_counter
	prefix="$( print_todo )"
	print_description "${prefix}" "${description}"

	echo -en "\n"
	return ${TRUE}
}
typeset -fx

function print_not_ok {
	declare description="${*}"

	FAILCOUNTER=$(( ${FAILCOUNTER} + 1 ))

	echo -en "not ok "

	print_counter
	prefix="$( print_todo )"
	print_description "${prefix}" "${description}"

	echo -en "\n"
	return ${FALSE}
}
typeset -fx
#-------------------------------------------------------------------------------
#   Testing functions
#-------------------------------------------------------------------------------
function is_equal {
	_equal "${1}" "${2}" "${3}" '-eq'
}

function is_not_equal {
	_equal "${1}" "${2}" "${3}" '-ne'
}

function is_greater {
	_equal "${1}" "${2}" "${3}" '-gt'
}

function is_less {
	_equal "${1}" "${2}" "${3}" '-lt'
}

function is_greater_or_equal {
	_equal "${1}" "${2}" "${3}" '-le'
}

function is_less_or_equal {
	_equal "${1}" "${2}" "${3}" '-ge'
}

function _equal {
	declare     operation="${1}"
	declare expect_result="${2}"
	declare   description="${3}"
	declare      operator="${4}"
	declare result

	if ${SKIP}; then
		print_ok "${description}"
		return 0
	fi

	#-------------------------------------------------------------------------------
	#   bc is often not a defult distribution package   
	#-------------------------------------------------------------------------------
	if ! which bc 2>/dev/null 1>&2; then 
		print_not_ok "${description}"
		diag "System command \"bc\" is not available for this user"
		diag "or missing from this system. You must install it first"
		diag "to use this test properly."
		return 1
	fi

	export START_TIME=$( current_time )
	result=$( echo "${operation}" | bc -l )
	export STOP_TIME=$( current_time )

	if [ ${expect_result} ${operator} ${result} ]; then
		print_ok             "${description}"
		return 0
	else
		print_not_ok         "${description}"
		print_verbose_result "${result}"        \
							 "${expect_result}" \
							 "${description}"
		return 1
	fi
	
	unset_time
	
}

function is_true {
	_boolean "${1}" "${2}"
}

function is_false {
	_boolean "${1}" "${2}" !
}

function _boolean {
	declare   operation="${1}"
	declare description="${2}"
	declare        bool="${3}"

	if ${SKIP}; then
		print_ok "${description}"
		return 0
	fi

	if ${bool} ${operation} 2>/dev/null 1>&2; then
		print_ok     "${description}"
		return 0
	else
		print_not_ok "${description}"
		return 1
	fi
	
}

function is_exact {
	_exact "${1}" "${2}" "${3}" '='
}

function is_not_exact {
	_exact "${1}" "${2}" "${3}" '!='
}

function _exact {
	declare       given="${1}"
	declare    expected="${2}"
	declare description="${3}"
	declare    operator="${4}"

	export START_TIME=$( current_time )

	if ${SKIP}; then
		print_ok "${description}"
		return 0
	fi

	if [ "${given}" ${operator} "${expected}" ]; then
		print_ok             "${description}"
		return 0
	else 
		print_not_ok         "${description}"
		export STOP_TIME=$( current_time )
		print_verbose_result "${given}"       \
                                     "${expected}"    \
				     "${description}"
		return 1
	fi

	unset_time
}

function is_file {
	_file "${1}" "${2}" -e
}

function is_not_file {
	_file "${1}" "${2}" -e !
}

function is_dir {
	_file "${1}" "${2}" -d
}

function is_not_dir {
	_file "${1}" "${2}" -d !
}

function is_executable {
	_file "${1}" "${2}" -x
}

function is_not_executable {
	_file "${1}" "${2}" -x !
}

function is_symlink {
	_file "${1}" "${2}" -L
}

function is_not_symlink {
	_file "${1}" "${2}" -L !
}

function _file {
	declare      target="${1}"
	declare description="${2}"
	declare    operator="${3}"
	declare    negative="${4}"

	if ${SKIP}; then
		print_ok "${description}"
		return 0
	fi

	if [ ${negative} ${operator} ${target} ]; then
		print_ok     "${description}"
		return 0
	else
		print_not_ok "${description}"
		return 1
	fi
}

function is_process_id {
	_process_id "${1}" "${2}" 
}

function is_not_process_id {
	_process_id "${1}" "${2}" "!"
}

function _process_id {
	declare     process="${1}"
	declare description="${2}"
	declare    operator="${3}"

	if ${SKIP}; then
		print_ok "${description}"
		return 0
	fi

	if [ ${operator} -d /proc/${process} ]; then
		print_ok     "${description}"
		return 0
	else 
		print_not_ok "${description}"
		return 1
	fi
}

function is_insmod {
	_insmod "${1}" "${2}" "-eq"
}

function is_not_insmod {
	_insmod "${1}" "${2}" "-ne"
}

function _insmod {
	declare      module="${1}"
	declare description="${2}"
	declare    operator="${3}"

	if ${SKIP}; then
		print_ok "${description}"
		return 0
	fi

	grep -qe "${module}" /proc/modules
	if [ $? ${operator} 0 ]; then
		print_ok     "${description}"
		return 0
	else
		print_not_ok "${description}"
		return 1
	fi
}

