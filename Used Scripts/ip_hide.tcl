################################################################
###            hide_ip v1.2
### by KorTexx <vlad@ifrance.com>
################################################################


# This script logs in your eggdrop to Undernet's channel service,
# sets +x mode (host hiding) and joins the channels AFTER the
# bot's host is hidden.


#   you should remove any "PRIVMSG x@channels.undernet.org :login ..."
#   command in "set init-server ..." in eggdrop.conf, if present.

# set here the cservice username the bot will use:
set xuser freshprinses

# set the username's password:
set xpass E N T E R  P A S S



################################################################
bind evnt - connect-server iphconn
bind evnt - init-server iphinit

proc iphconn {type} {
global nick iphnick flood-msg iphfloodmsg

 foreach chan [channels] {
  channel set $chan +inactive
 }
 set iphnick $nick
 set nick "^Fr3Sh^" 
 set iphfloodmsg ${flood-msg}
 set flood-msg 0:0
}

proc iphinit {type} {
global xuser xpass botnick

 putserv "MODE $botnick +x"
 putserv "PRIVMSG x@channels.undernet.org :login $xuser $xpass"
 bind notc - "AUTHENTICATION SUCCESSFUL*" iphlogged
 putlog "Waiting for authentication..."
 utimer 30 iphrelog
}

proc iphrelog {} {
global xuser xpass

 putserv "PRIVMSG x@channels.undernet.org :login $xuser $xpass"
 utimer 45 iphrelog
}

proc iphlogged {mnick uhost hand text {dest ""}} {
global nick iphnick flood-msg iphfloodmsg

 if {$mnick == "X"} {
  set nick $iphnick
  unbind notc - "AUTHENTICATION SUCCESSFUL*" iphlogged
  foreach chan [channels] {
   channel set $chan -inactive
  }
  if {[utimerexists iphrelog]!=""} {killutimer [utimerexists iphrelog]}
  set flood-msg $iphfloodmsg
 }
}

