###################################################################
#================================================================ #
# pubcommand by GoGers - Colors striped, and redone by ArNz|8o8   #
#================================================================ #
# ..::Description::..                                             #
# This script is a modification of my previous script.This will be#
# good for having your own channel and protecting it. You can     #
# find me on dalnet under nick "anto" or channels		          #
# #delhelps / #dalhelps	 added !access !info changed notice type  #
# to channel msg (many asked me to put in a channel msg)          #
# so only few commands will be sending notices.	Thanks for the    #
# support guys, any bugs please feel free to tell on DALnet       #
#================================================================ #
# Version: 3.01    Public Commands TCL                            #
#================================================================ #
####################YOU MUST EDIT THIS ###############################
#set password for nick identification if you are changing nick to registered nick and it has the same password as the botnick
set password "E N T E R  P A S S"

#Commands

bind pub o !op pub_do_op
bind pub o !deop pub_do_deop
bind pub o !voice pub_do_voice
bind pub o !devoice pub_do_devoice
bind pub o !topic pub_do_topic
bind pub o !perm pub_do_perm
bind pub o !kick pub_do_kick
bind pub o !unban pub_do_unban
bind pub o !unperm pub_do_unperm
bind pub o !bans pub_do_bans
bind pub m !mode pub_do_mode 
bind pub m !away pub_do_away
bind pub m !back pub_do_back
bind pub o !bot pub_do_bot
bind pub m !rehash pub_do_rehash
bind pub m !restart pub_do_restart
bind pub m !jump pub_do_jump
bind pub m !save pub_do_save
bind pub m !ban ban:pub
bind pub m !kban kban:pub
bind pub m "!chattr" chattr:pub
bind pub m !act pub:act
bind pub m !say pub:say
bind pub m !global pub:global
bind pub m !access pub_access
bind pub m !info pub_info

#code 
bind pub m !identify  do_identify

#----------------------------------------------------------------
proc pub_do_bot {nick host hand channel text} {
  puthelp "PRIVMSG $nick :Commands On This Bot"
  puthelp "PRIVMSG $nick :!op <nick> - Ops the nick on a current channel."
  puthelp "PRIVMSG $nick :!deop <nick> - Deops the nick on the current channel."
  puthelp "PRIVMSG $nick :!voice <nick> - Voices the nick on the current channel."
  puthelp "PRIVMSG $nick :!devoice <nick> - Devoices the nick on the current channel."
  puthelp "PRIVMSG $nick :!topic <what you like> - Sets the topic in the channel it's typed."
  puthelp "PRIVMSG $nick :!perm <nick> <reason> - Permanently bans the nick you specify."
  puthelp "PRIVMSG $nick :!kick <nick> <reason> - Kicks the nick."
  puthelp "PRIVMSG $nick :!unban <host> - Unbans the nick who is banned."
  puthelp "PRIVMSG $nick :!unperm <host> - Unbanns the user from the Permanent list."
  puthelp "PRIVMSG $nick :!bans - Lists the current bans on the channel."
  puthelp "PRIVMSG $nick :!away <msg> - Set the bot away with a message."
  puthelp "PRIVMSG $nick :!back - Sets the bot back."
  puthelp "PRIVMSG $nick :!bot - Brings up this menu. more commands to go.such as2!jump !restart !rehash !save !ban !kban !act !say !global !join !part !chattr !adduser !botnick !uptime to avoid get flooding on Pvt its restircted"
  puthelp "PRIVMSG $nick :End of bot commands."
  return
}

#----------------------------------------------------------------
#Make the bot op someone
proc pub_do_op {nick host handle channel testes} {
set who [lindex $testes 0]
if {$who == ""} {
if {![botisop $channel]} {
putserv "PRIVMSG $channel :I'm not op'd. I need to be op'd to do that."
return 1
}
if {[isop $channel]} {
putserv "PRIVMSG $channel :YOU are ALREADY op'd in $channel you dumbass."
return 1
}
putserv "MODE $channel +o $nick"
return 1
}
if {![botisop $channel]} {
putserv "PRIVMSG $channel :I'm not op'd. I need to be op'd to do that."
return 1
}

if {[isop $who $channel]} {
putserv "PRIVMSG $channel :$who is ALREADY op'd in $channel you muppet."
return 1
} 

putserv "MODE $channel +o $who"
putserv "PRIVMSG $channel :Op'd $who on $channel."
putlog "$nick made me op $who in $channel."
}
#End of pub_do_op

#----------------------------------------------------------------

#Deop someone
proc pub_do_deop {nick host handle channel testes} {
global botnick
set who [lindex $testes 0]
if {$who == ""} {
putserv "PRIVMSG $channel :Usage: !deop <Nick to Deop>"
return 1
}
if {[string tolower $who] == [string tolower $botnick]} {
putserv "MODE $channel -o $nick"
putserv "PRIVMSG $channel :This is not fair, you think that's funny? Trying to make me deop myself ? you muppet."
return 1
}
if {[string tolower $who] == [string tolower $nick]} {
putserv "PRIVMSG $channel :You really wanna deop yourself $nick, ok then here goes."
putserv "MODE $channel -o $nick"
return 1
}
if {[matchattr $who +n]} {
putserv "MODE $channel -o $nick"
putserv "PRIVMSG $channel :I i worship my master $nick, im not gonna deop my owner!"
return 1
}
if {![isop $who $channel]} {
putserv "PRIVMSG $channel :That user is already deop'd."
return 1
}
putserv "MODE $channel -o $who"
return 1
}
#end of pub_do_deop

#----------------------------------------------------------------

#Make the bot voice someone
proc pub_do_voice {nick host handle channel testes  } {
set who [lindex $testes 0]
if {$who == ""} {
if {![botisop $channel]} {
putserv "PRIVMSG $channel :I'm not op'd. Muppet."
return 1
}
if {[isvoice $channel]} {
putserv "PRIVMSG $channel :YOU are ALREADY voice'd in $channel you dumbass."
return 1
}
putserv "MODE $channel +v $nick"
return 1
}
if {![botisop $channel]} {
putserv "PRIVMSG $channel :I'm not op'd. Muppet."
return 1
}

if {[isvoice $who $channel]} {
putserv "PRIVMSG $channel :$who is ALREADY voice'd in $channel you dumbass."
return 1
}

putserv "MODE $channel +vvvvv $who "
putserv "PRIVMSG $channel :Voice'd $who on $channel."
putlog "$nick made me op $who in $channel."
}
#End of pub_do_voice

#----------------------------------------------------------------

#Devoice someone
proc pub_do_devoice {nick host handle channel testes} {
global botnick
set who [lindex $testes 0]
if {$who == ""} {
putserv "PRIVMSG $channel :Usage: !devoice <Nick to Devoice>"
return 1
}
if {[string tolower $who] == [string tolower $botnick]} {
putserv "MODE $channel -v $nick"
putserv "PRIVMSG $channel :This is not fair, Think that's funny? Trying to make me devoice myself?"
return 1
}
if {[string tolower $who] == [string tolower $nick]} {
putserv "PRIVMSG $channel :You really wanna devoice yourself $nick, well ok, here goes. as your wish"
putserv "MODE $channel -v $nick"
return 1
}
if {[matchattr $who +n]} {
putserv "MODE $channel -v $nick"
putserv "PRIVMSG $channel :Im not gonna devoice my owner! You think im a stupid bot?"
return 1
}
if {![isvoice $who $channel]} {
putserv "PRIVMSG $channel :That user is already devoice'd."
return 1
}
putserv "MODE $channel -v $who"
return 1
}
#end of pub_do_devoice

#----------------------------------------------------------------

#Change topic on channel
proc pub_do_topic {user host handle channel testes} {
set what [lrange $testes 0 end]
if {$what == ""} {
putserv "PRIVMSG $channel :Usage: !topic <Topic you want.>"
return 1
}
if {![botisop $channel]} {
putserv "PRIVMSG $channel : I need to be op'd on that channel to change the topic."
return 1
}

putserv "TOPIC $channel :$what"
return 1
}
#end of pub_do_topic

#----------------------------------------------------------------

#Permban someone
proc pub_do_perm {nick host handle channel testes} {
global botnick
set why [lrange $testes 1 end]
set who [lindex $testes 0]
set ban [maskhost [getchanhost $who $channel]]
if {$who == ""} {
putserv "PRIVMSG $channel :Usage: !perm <Nick to shitlist>"
set ban [maskhost [getchanhost $channel]]
return 1
}
if {![onchan $who $channel]} {
putserv "PRIVMSG $channel :$who aint on $channel."
return 1
}
if {[string tolower $who] == [string tolower $botnick]} {
putserv "KICK $channel $nick :Dumbass. I aint bannin' myself!"
return 1
}
if {[matchattr $who +n]} {
putserv "NOTICE $who :$nick tried to permban you. Better have a talk with him."
putserv "PRIVMSG $channel :You tried to permban $who, He's my OWNER! I'm tellin' him now..."
return 1
}
newchanban $channel $ban $nick $why
stick $ban $channel
putserv "KICK $channel $who :$why "
putlog "$nick made me permban $who who was $ban and the reason was $why."
putserv "PRIVMSG $channel :PermBanned $who on $channel with reason: $why."
return 1
}
#end of pub_do_perm
#ban 

proc ban:pub {nick uhost hand chan arg} {
 set ban [lindex $arg 0]
 if {[string match *!*@* $ban]} {pushmode $chan +b $ban} {pushmode $chan +b *!*@[lindex [split [getchanhost $ban] @] 1]}
}

#end
#kban 

proc kban:pub {nick uhost hand chan arg} {ban:pub $nick $uhost $hand $chan $arg;pub_do_kick $nick $uhost $hand $chan $arg} 

#----------------------------------------------------------------

#Kick someone
proc pub_do_kick {nick uhost hand chan arg} {
global botnick
set who [lindex $arg 0]
set why [lrange $arg 1 end]
if {![onchan $who $chan]} {
putserv "PRIVMSG $channel :$who isnt on $chan."
return 1
}
if {[string tolower $who] == [string tolower $botnick]} {
putserv "KICK $chan $nick :hah. not funny."
return 1
}
if {$who == ""} {
putserv "PRIVMSG $chan :Useage: !k <nick to kick>"
return 1
}
if {$who == $nick} {
putserv "PRIVMSG $chan :Why the hell do you want to kick yourself $nick?"
return 1
}
if {[matchattr $who +n]} {
putserv "KICK $chan $nick :Trying to kick my owner eh? ;Þ"
return 1
}
putserv "KICK $chan $who :$why "
putserv "PRIVMSG $chan :Kicked $who from $channel with this saying: $why. :)"
return 1
}
#End of pub_do_kick

#----------------------------------------------------------------

#Delete a host from the banlist.
proc pub_do_unban {nick host handle channel testes} {
set who [lindex $testes 0]
if {$who == ""} {
putserv "NOTICE $nick :Usage: <Host to unban>"
return 1
}
putserv "MODE $channel -b $who"
putlog "$nick made me Delete $who from banlist."
return 1
}
#end of pub_do_unban

#----------------------------------------------------------------

#Remove user from shitlist
proc pub_do_unperm {nick host handle channel testes} {
set who [lindex $testes 0]
if {$who == ""} {
putserv "NOTICE $nick :Usage: <Shit to remove>"
return 1
}
killchanban $channel $who
putlog "$nick made me Delete $who from shitlist."
return 1
}
#end of pub_do_unperm

#----------------------------------------------------------------

#banlist
proc pub_do_bans {nick uhost hand chan text} {  
     puthelp "NOTICE $nick :- \037\002Ban List for\002\037 ($chan.)"  
foreach {a b c d} [banlist $chan] {  
     puthelp "NOTICE $nick :- [format %-12s%-12s%-12s%-12s $a $b $c $d]" 
     } 
     puthelp "NOTICE $nick :- \037\002Ban List for\002\037 ($chan Completed.)" 
}
#end of banlist

#----------------------------------------------------------------

#Set the bot away.
proc pub_do_away {nick host handle channel testes} {
set why [lrange $testes 0 end]
if {$why == ""} {
putserv "NOTICE $nick :!away <The away msg you want me to use.>"
return 1
}
putserv "AWAY :$why"
putserv "NOTICE $nick :Away MSG set to $why."
return 1
}
#end of pub_do_away

#----------------------------------------------------------------

#Set the bot back.
proc pub_do_back {nick host handle channel testes} {
putserv "AWAY :"
putserv "NOTICE $nick :I'm back."
}
#end of pub_do_back

#----------------------------------------------------------------

#Change the mode in the channel
proc pub_do_mode {nick host handle channel testes} {
set who [lindex $testes 0]
if {![botisop $channel]} {
putserv "NOTICE $nick :I'm not op'd in $channel you LAMER!"
return 1
}
if {$who == ""} {
putserv "NOTICE $nick :Usage: !mode <Channel mode you want to set>"
return 1
}
putserv "MODE $channel $who"
return 1
}
#end of pub_do_mode


#Set the rehash
proc pub_do_rehash  {nick host handle channel testes} {
  global botnick 
 set who [lindex $testes 0] 
 if {$who == ""} {
 rehash 
 putquick "NOTICE $nick : Rehashing TCL script(s) and variables"
 return 1
}
}

#Set the restart
proc pub_do_restart  {nick host handle channel testes} {
  global botnick
 set who [lindex $testes 0]
 if {$who == ""} {
 restart
 putquick "NOTICE $nick : Restarting Bot  TCL script(s) and variables"
 return 1
}
}

#Set the jump
proc pub_do_jump  {nick host handle channel testes} {
  global botnick
 set who [lindex $testes 0]
 if {$who == ""} {
 jump
 putquick "NOTICE $nick : Changing Servers"
 return 1
}
}

#Set the save
proc pub_do_save  {nick host handle channel testes} {
  global botnick
 set who [lindex $testes 0]
 if {$who == ""} {
 save
 putquick "NOTICE $nick :Saving user file"
 putquick "NOTICE $nick :Saving Channel File"
 return 1
}
}

#Hop the bot!

# Set this to 1 if the bot should hop upon getting deopped, 0 if it should ignore it.
 set hopondeop 1

# Set this to 1 if the bot should kick those who deop it upon returning, 0 if not.
# NOTE: The bot owner will be immune to this kick even if it is enabled.
 set kickondeop 0

#Don't Edit anything below!

bind pub m "!hop" hop:pub
bind pub m "!cycle" hop:pub
bind msg m "hop" hop:msg
bind mode - * hop:mode

proc hop:pub { nick uhost hand chan text } {
 putlog "Hopping channel $chan at $nick's Request"
 putserv "PRIVMSG $chan :Cycle Command used by $nick , Cycling "
 putserv "PART :$chan"
 putserv "JOIN :$chan"
 putserv "PRIVMSG $chan :"
}

proc hop:msg { nick uhost hand text } {
 putlog "Hopping channel $text at $nick's Request"
 putserv "PART :$text"
 putserv "JOIN :$text"
 putserv "PRIVMSG $text :Cycle Command was used by $nick "
}

proc hop:mode { nick uhost hand chan mc vict } {
global hopondeop kickondeop botnick owner
if {$mc == "-o" && $vict == $botnick && $hopondeop == 1} {
 putlog "Hopping channel $chan due to deop"
 putserv "PRIVMSG $chan :"
 putserv "PART :$chan"
 putserv "JOIN :$chan"
 putserv "PRIVMSG $chan :"
  if {$nick != $owner && $kickondeop == 1} {
   putserv "KICK $chan $nick"
}
}
}
#join/part section, newly added 

bind pub m "!join" join:pub 

proc join:pub { nick uhost hand chan text } {
 putlog "Joining channel $text by $nick's Request"
 putserv "PRIVMSG $chan :Joining channel $text by $nick's Request"
 putserv "JOIN :$text"
 channel add $text
 putserv "PRIVMSG $chan :"
}

bind pub m "!part" part:pub 

proc part:pub { nick uhost hand chan text } {
  set chan [lindex $text 0]
  if {![isdynamic $chan]} {
  puthelp "privmsg $chan :$nick: That channel isn't dynamic!"
  return 0
 }
  if {![validchan $chan]} {
  puthelp "privmsg $chan :$nick: That channel doesn't exist!"
  return 0
 }

 putlog "Parting $chan by $nick's Request"
 putserv "PRIVMSG $chan :Leaving $chan by $nick's Request"
 putserv "PART :$chan"
 channel remove $chan
 }

# End - join/part 
# botnick - small routine to bot to change nicks.

bind pub m "!botnick" botnick:pub

proc botnick:pub { mynick uhost hand chan text  } {
global nick password
putlog "Changing botnick "
putserv "PRIVMSG $chan :Changing my name?? to $text "
set nick $text 
putquick "PRIVMSG nickserv@services.dal.net :identify $text $password" 
putserv "PRIVMSG $chan :Identifying to NickServ@services.dal.net..."
}
# end botnick

#identifing Botnick 

proc do_identify {nick host handle chan text} { 
global password
putquick "PRIVMSG nickserv@services.dal.net :identify $password" 
putserv "NOTICE $nick :Identifying to NickServ@services.dal.net..."
}

#end
#uptime 

bind pub m "!uptime" uptime:pub

proc uptime:pub {nick host handle chan arg} {
 global uptime
 set uu [unixtime]
 set tt [incr uu -$uptime]
 puthelp "privmsg $chan :$nick: My uptime is [duration $tt]."
}

#End of uptime

#addchattr with flags


proc chattr:pub {nick uhost handle chan arg} {
 set handle [lindex $arg 0]
 set flags [lindex $arg 1]
 if {![validuser $handle]} {
  puthelp "privmsg $chan :$nick: That handle doesn't exist!"
  return 0
 }
 if {$flags == ""} {
  puthelp "privmsg $chan :$nick: Syntax: .chattr <handle> <+|-><flags>"
  return 0
 }
 chattr $handle $flags
 puthelp "privmsg $chan :Added that! $nick."
}
#adduser 
bind pub m "!adduser" adduser:pub

proc adduser:pub {nick uhost handle chan arg} {
 set handle [lindex $arg 0]
 set hostmask [lindex $arg 1]
 if {[validuser $handle]} {
  puthelp "privmsg $chan :$nick: That user already exists!"
  return 0
 }
 if {$hostmask == ""} {
  set host [getchanhost $handle]
  if {$host == ""} {
   puthelp "privmsg $chan :$nick: I can't get $handle's host."
   puthelp "privmsg $chan :$nick: Syntax: !adduser <handle> <hostmask (nick!user@host) wildcard acceptable>" 
   return 0
 }
  if {![validuser $handle]}  {
   adduser $handle *!$host
   puthelp "privmsg $chan :Added that! $nick."
  }
 }
  if {![validuser $handle]}  {
  adduser $handle $hostmask
  puthelp "privmsg $chan :Added that! $nick."

  }
 }
#end
#deluser 
bind pub m "!deluser" deluser:pub

proc deluser:pub {nick uhost handle chan arg} {
 set handle [lindex $arg 0]
 set hostmask [lindex $arg 1]
 if {[validuser $handle]} {
  deluser $handle 
  puthelp "privmsg $chan :$nick: User has been deleted from my database !"
  return 0
 }
 if {![validuser $handle]} {
  puthelp "privmsg $chan :$nick: User does not exisit on  my database !"
  return 0
 }
}

#access
proc pub_access {nick uhost handle chan arg} {

 if {![validuser [lindex $arg 0]]} {puthelp "privmsg $chan :[lindex $arg 0] does not exist";return}
 if {[matchattr [lindex $arg 0] n]} {puthelp "privmsg $chan :[lindex $arg 0] is an \002Owner";return}
 if {[matchattr [lindex $arg 0] m]} {puthelp "privmsg $chan :[lindex $arg 0] is a \002Master";return}
 if {[matchattr [lindex $arg 0] o]} {puthelp "privmsg $chan :[lindex $arg 0] is an \002Operator";return}
 puthelp "privmsg $chan :[lindex $arg 0] is Basic"
}

#info
proc pub_info {nick uhost handle chan arg} {
 if {$arg == "none"} {
  setuser $handle info ""
  puthelp "privmsg $chan :Added that! $nick."
 }
 if {$arg != "none" && $arg != ""} {
  setuser $handle info $arg
  puthelp "privmsg $chan :Added that! $nick."
 }
 if {$arg == ""} {
  if {[getuser $handle info] == ""} {
   puthelp "privmsg $chan :$nick: You don't have an info."
   return 0 
  }
  puthelp "privmsg $chan :$nick: Your info is: [getuser $handle info]"
 }
}


#end
#say & act 

proc pub:say {nick uhost handle chan arg} {puthelp "privmsg $chan :$arg"}
proc pub:global {nick uhost handle chan arg} {
 foreach chan [channels] {
  puthelp "privmsg $chan :\002 $arg \002 This Message Broadcasted by request of $nick "
 }
}
proc pub:act {nick uhost handle chan arg} {puthelp "privmsg $chan :\001ACTION $arg\001"}

putlog "Channel Public Commands Script 3.0 redone by ArNz|8o8 "

