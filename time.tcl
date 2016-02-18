##################################
### ShellTime.tcl              ###
### Version 1.0                ###
### Edited By ArNz|8o8         ###
##################################

set shelltime_setting(flag) "-|-"
set shelltime_setting(cmd) "time"

########################################################
# Set the pub command for viewing the shell time here. #
########################################################

set shelltime_setting(pubcmd) "!time"

###############################
# Set the clock format here.  #
###############################

set shelltime_setting(format) "%H:%M:%S on %A, %d %B %Y"

###################################
# Enable use of bold in DCC chat? #
###################################

set shelltime_setting(bold) 1

#############################################
# Prefix "SHELLTIME:" in DCC chat messages? #
#############################################

set shelltime_setting(SHELLTIME:) 1

####################
# Code begins here #
####################

bind dcc $shelltime_setting(flag) $shelltime_setting(cmd) shelltime_dcc
bind pub $shelltime_setting(flag) $shelltime_setting(pubcmd) shelltime_pub

proc shelltime_dopre {} {
	global shelltime_setting
	if {!$shelltime_setting(SHELLTIME:)} { return "" }
	if {!$shelltime_setting(bold)} { return "SHELLTIME: " }
	return "\002SHELLTIME:\002 "
}
proc shelltime_dcc {hand idx text} {
	global shelltime_setting
	putdcc $idx "[shelltime_dopre][clock format [clock seconds] -format $shelltime_setting(format)]"
}
proc shelltime_pub {nick uhost hand chan text} {
	global shelltime_setting
	puthelp "PRIVMSG $chan :Hey $nick, the time is [clock format [clock seconds] -timezone :Europe/Amsterdam -format $shelltime_setting(format)]"
}
putlog "\002SHELLTIME:\002 Time.tcl 1.0 by ArNz|8o8 is loaded."