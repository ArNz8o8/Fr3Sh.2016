#----------------------------------------------------------------------------------------------------------------------#
#                                             AUTO WELCOME SCRIPT BY RANA USMAN                                        #
#----------------------------------------------------------------------------------------------------------------------#
### AUTHOR : RANA USMAN
### VERSION : 2
### EMAIL : coolguy_rusman@yahoo.com , usmanrana33@hotmail.com
### URL : www.ranausman.tk
### Catch me @ UNDERNET my nick is : ^Rana^Usman

###############
# DESCRIPTION #
###############
#Assalam O Aleikum n Hello,so you want to know something about this script hmm ok here we go.the purpose of this script
#is to welcome the users who enter the specific channel you put in configuration.You can set customized welcome messages 
#in a text file known as welcome.txt, Just Open it n Start entering the welcome messages you want ur bot to say.you can set
#Welcome messages in your own language too :) it is usefull to attract peoples of your country :).

#############
# WHATS NEW #
#############
# Idea was taken from Azeems greet script to expand this script - A new feature of noticing the nick is added.
# Feature of enabling nick in greet is added

###########################
#= CONFIGURATION SECTION =#
###########################
## SET THE WAY IN WHICH YOU WANT USER TO BE GREETED ##
## SET 1 : FOR CHANNEL MSG GREET - BOT WILL MSG THE CHANNEL ##
## SET 2 : BOT WILL NOTICE THE NICK ON JOIN ##

set greetway 1

## THIS FEATURE IS TO ENABLE THE NICK IN GREET MSG OR NOT ##
## SET 1: IN CASE YOU DONT WANT TO USE NICK IN GREET MSG  (<BOTNICK> Welcome) ##
## SET 2: IN CASE YOU WANT TO USE NICK IN GREET LIKE THIS (<BOTNICK> usernick : Welcome) ##

set nickstyle 1

## PUT THE CHANNEL HERE IN WHICH YOU WANT THIS SCRIPT TO WORK ##
## YOU CAN NOW USE THIS SCRIPT ONLY IN ONE CHANNEL , USING MORE THAN ONE CHANNEL IN COFIG CAN CAUSE TROUBLE ##

set urchan "#Holland"

## ENTER THE PATH OF THE FILE CONTAINING WELCOME MESSAGES ##
## IF YOU WILL LEAVE IT AS IT IS YOU HAVE TO PUT THE "welcome.txt" FILE INTO SCRIPTS FOLDER ##

set txtfile "scripts/welcome.txt"


###########################
# CONFIGURATION ENDS HERE #
###########################


#--------------------------------------------------------------------------------------------------------------------#
#  SCRIPT STARTS FROM HERE.YOU CAN MAKE MODIFICATIONS AT UR OWN RISK, I DONT RESTRICT YOU TO NOT TO TOUCH THE CODE!  #
#--------------------------------------------------------------------------------------------------------------------#

bind join - * RanaUsman:wjoin

proc RanaUsman:wjoin {nick host handle chan} {
global urchan txtfile greetway nickstyle
      set aire $urchan
      set ranadil [open $txtfile r]
      set readvar [split [read $ranadil] \n]
      close $ranadil

if {(([lsearch -exact [string tolower $aire] [string tolower $chan]] != -1)  || ($aire == ""))} {
if {$nickstyle == "1"} {
  if {$greetway == "1"} { putserv "PRIVMSG $aire :[lindex $readvar [rand [llength $readvar]]]"}
  if {$greetway == "2"} { putserv "NOTICE $nick :[lindex $readvar [rand [llength $readvar]]]" }
  }
if {$nickstyle == "2"} {
 if {$greetway == "1"} { putserv "PRIVMSG $aire :$nick : [lindex $readvar [rand [llength $readvar]]]"}
  if {$greetway == "2"} { putserv "NOTICE $nick :$nick : [lindex $readvar [rand [llength $readvar]]]" }
  }
 } 
}
#Ever Seen such simple coding ??? eh

##################################################################################################
putlog "\002*Auto Welcome Script* has been successfully LOADED"
##################################################################################################