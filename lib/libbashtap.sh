#!/bin/bash
#===============================================================================
#
#          FILE:  libtap.sh
# 
#         USAGE:  ./libtap.sh 
# 
#   DESCRIPTION:  TAP implementation in Bash
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Thomas Maier, hayzer@gmail.com
#       VERSION:  0.01
#       CREATED:  01/08/2008 10:45:19 PM IST
#      REVISION:  ---
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
	echo -ne "${msg_footer}${msg_header}"
}
		
#-------------------------------------------------------------------------------
#   TAP functions
#-------------------------------------------------------------------------------
function diag {
	declare diagnostic="${*}"
	echo -en "# ${diagnostic}\n"
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

function todo_on {
	TODO=true
}

function todo_off {
	TODO=false
}

function skip_on {
	SKIP=true
}

function skipp_off {
	SKIP=false
}

function bail_out {
	declare description="${*}"

	echo -en "Bail out! ${description}\n";
	exit 1
} 

function current_time {
	declare ctime=$(date +'%R:%S %x')
	echo ${ctime}
}

function unset_time {
	unset START_TIME STOP_TIME
}

function print_verbose_result {
	declare         got="${1}"
	declare    expected="${2}"
	declare description="${3}"
	declare name="$0"
	declare line="${BASH_LINENO[2]}"

	if [ "${VERBOSE}" != "" ]; then
		cat <<END_RESULT
#   Failed test '${description}'
#  start test: '${START_TIME}'
#   stop test: '${STOP_TIME}'
#       where: '${name}:${line}'
#         got: '${got}'
#    expected: '${expected}'
END_RESULT
	fi
}

function print_verbose_error {
	declare       error="${1}"
	declare description="${2}"
        declare        name="$0"
	declare        line="${BASH_LINENO[2]}"

	if [ "${VERBOSE}" != "" ]; then
		cat <<END_RESULT
# Failed test '${description}'
#    where: '${name}:${line}'
#    error: '${error}'
END_RESULT
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
