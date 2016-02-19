# Project "Kalich" (C) 2001 by L3ECH.
# AI module.

# An advanced talk script with teaching via public commands.
# for Eggdrop v1.6.x or higher.
# Especially designed for Undernet and DALnet bots.
# Ideologically based on 8-ball script by hell knows whom.
# If you encounter any bad English in this script - live with it.


##### GLOBAL CONFIGURATION (CHANGE THESE OR ELSE!) #####

## Owner: Set this to the _handle_ of the permanent owner of the bot (usually it's YOU!)
## This is _VERY_ important!
	set The_Owner "ArNz|8o8"

## Command prefix: Set this to the desired command prefix
## ALL the commands will start with that, default is: !
	set cmdpfix "!"


## Log files: Set those to whatever you want.
## First one logs all private conversations with the bot
## Second one logs the conversations with the bot on public channels
	set priv_log_file "priv_msg_log.txt"
	set chan_log_file "chan_msg_log.txt"

## AI Database directory: A directory where all the database is stored.
## Note that the directory MUST EXIST and the user running the bot MUST have WRITE permission to it.
	set ai_db_directory "/home/8o8networkz/frisheid/scripts/"

## Random Talk value.
## The value of 160 means that the chance of random talk of the bot is 1:160
## 160 is just fine, but feel free to adjust.
## A value below 7 disables random talk.
	set Random_Talk 160
	
## Extra bot names
## Here you specify the extra names you want your bot to recognize as his name
## Useful if let's say your bot's nick is "Lamer32587" and you want it to respont to "Lamer" -
## Just put the names here, space separated.
	set extra_names	"Fresh"
	
##################### END OF CONFIG #######################





       



################# TEACHING SECTION #################


##### Variables and binds ######

set valid_types "question nonquest"
set ai_types_db "${ai_db_directory}AI-type.dat"
set logfile "${ai_db_directory}learn.log"

bind pub - ${cmdpfix}learn pub:learn
bind pub - ${cmdpfix}forget pub:forget
bind pub - ${cmdpfix}aitest pub:aitest
bind pub - ${cmdpfix}listall pub:listall
bind pub n ${cmdpfix}deletedb pub:deletedb

bind pub - ${cmdpfix}addtype pub:addtype
bind pub - ${cmdpfix}deltype pub:deltype
bind pub - ${cmdpfix}addkeyword pub:addkeyword
bind pub - ${cmdpfix}delkeyword pub:delkeyword
bind pub - ${cmdpfix}showkeywords pub:showkeywords

bind pub - ${cmdpfix}searchdb pub:searchdb


##### Interface database procs ######


proc pub:learn {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 
	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set args [lindex $args 0]
	set args [split $args]
	if { [llength $args] < 1 } {
		notice $nick "Usage: ${cmdpfix}learn <type> <phrase>"
		notice $nick "Valid type entries are: \002$valid_types $custom_types"
		notice $nick "To add new type entries use the \002${cmdpfix}addtype\002 command."
		return 0
	}

	set work_file [lindex $args 0]
	set work_file [string tolower $work_file]
	set work_phrase [lrange $args 1 end]

	if { ![regexp $work_file "$valid_types $custom_types"] } {
		 putserv "NOTICE $nick : Entry type \002$work_file\002 is invalid."
		 putserv "NOTICE $nick : Valid type entries are: \002$valid_types $custom_types"
		 return 0
	}

	if { [ai_addphrase "$ai_db_directory$work_file.ai" $work_phrase] != 1 } {
		 putserv "NOTICE $nick : Error writing to file (check permissions?)"
		 return 0
	}

	putlog "$nick !$hand! LEARN: type: \002$work_file\002, phrase: \002$work_phrase\002"
	putserv "PRIVMSG $chan :$nick: Added to \002$work_file\002 database: [join $work_phrase]"

	set f [open $logfile a]
	puts $f "LEARN: \[[realtime date], [realtime]\], (!$hand! $nick!$host) (DB:$work_file) PHR: $work_phrase"
	close $f
}

proc pub:forget {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 
	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set args [lindex $args 0]
	set args [split $args]
	if { [llength $args] < 1 } {
		notice $nick "Usage: ${cmdpfix}forget <type> <phrase>"
		notice $nick "Valid type entries are: \002$valid_types $custom_types"
		notice $nick "To remove type entries use the \002${cmdpfix}deltype\002 command."
		return 0
	}

	set work_file [lindex $args 0]
	set work_file [string tolower $work_file]
	set work_phrase [lrange $args 1 end]

	if { [ai_delphrase "$ai_db_directory$work_file.ai" $work_phrase] == 0} {
		 putserv "NOTICE $nick : Phrase \002$work_phrase\002 not found in \002$work_file\002, or type is invalid."
		 putserv "NOTICE $nick : Valid type entries are: \002$valid_types $custom_types"
		 return 0
	}
	putlog "$nick |$hand| FORGET: type: \002$work_file\002, phrase: \002$work_phrase\002"
	putserv "PRIVMSG $chan :$nick: Removed from \002$work_file\002 database: $work_phrase"

	set f [open $logfile a]
	puts $f "FORGET: \[[realtime date], [realtime]\], (!$hand! $nick!$host) (DB:$work_file) PHR: $work_phrase"
	close $f
}


proc pub:aitest {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 
	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set args [lindex $args 0]
	set args [split $args]
	if { [lindex $args 0] == "" } {
		notice $nick "Usage: ${cmdpfix}aitest <type>"
		notice $nick "Valid type entries are: \002$valid_types $custom_types"
		return 0
	}

	set work_file [lindex $args 0]
	set work_file [string tolower $work_file]

	set work_phrase [ai_getphrase "$ai_db_directory$work_file.ai"]
	if { $work_phrase == "" } {
		putserv "NOTICE $nick : Entry type \002$work_file\002 is invalid."
		putserv "NOTICE $nick : Valid type entries are: \002$valid_types $custom_types"
		return 0
	}

	putlog "$nick !$hand! AI-TEST: type: \002$work_file\002"
	putserv "PRIVMSG $chan :$nick: Random line from \002$work_file\002 database: $work_phrase"
}


proc pub:listall {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 
	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set args [lindex $args 0]
	set args [split $args]
	if { [lindex $args 0] == "" } {
		notice $nick "Usage: ${cmdpfix}listall <type> \[starting line number\]"
		notice $nick "Valid type entries are: \002$valid_types $custom_types"
		return 0
	}

	set work_file [lindex $args 0]
	set start_from [lindex $args 1]

	if { $work_file == "log" } { set work_file $logfile } { set work_file "$ai_db_directory$work_file.ai" }

	if { [ai_getall $work_file $nick $start_from] == 0 } {
		 putserv "NOTICE $nick : Entry type \002$work_file\002 is probably invalid."
		 putserv "NOTICE $nick : Valid type entries are: \002$valid_types $custom_types"
		 return 0
	}
	putlog "$nick !$hand! AI-LIST-ALL: file: \002$work_file\002"
}

proc pub:deletedb {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 
	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set args [lindex $args 0]
	set args [split $args]
	if { [lindex $args 0] == "" } {
		notice $nick "Usage: ${cmdpfix}deletedb <type>"
		notice $nick "Valid type entries are: \002$valid_types $custom_types"
		return 0
	}

	set work_file [lindex $args 0]
	set work_file [string tolower $work_file]

	if { $work_file == "log" } { set work_file $logfile } { set work_file "$ai_db_directory$work_file.ai" }

	if { [ai_delfile $work_file] == 0} {
		 putserv "NOTICE $nick : Entry type \002$work_file\002 is invalid or there was an error deleting the file."
		 putserv "NOTICE $nick : Valid type entries are: \002$valid_types $custom_types"
		 return 0
	}

	putlog "$nick !$hand! DELETE DATABASE FILE: file: \002$work_file\002"
	putserv "PRIVMSG $chan :$nick: Deleted the \002$work_file\002 database."

	set f [open $logfile a]
	puts $f "DELETE DATABASE: \[[realtime date], [realtime]\], (!$hand! $nick!$host) DB: $work_file"
	close $f
}


proc pub:searchdb {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"
	set existing_types "$valid_types $custom_types"

	set args [lindex $args 0]
	set args [join $args]
	if { [lindex $args 0] == "" } {
		notice $nick "Usage: ${cmdpfix}searchdb <search substring>"
		return 0
	}

	set phrase $args

	putserv "PRIVMSG $nick :Searching for \002$phrase\002..."
	set total 0
	foreach ty [split $existing_types] {
		set temp [ai_searchdb $ai_db_directory$ty.ai $phrase $nick]
		if { $temp != "" } { incr total $temp }
	}
	putserv "PRIVMSG $nick :\002$total\002 matches for \002$phrase\002 found."

	putlog "$nick !$hand! SEARCH DATABASE: \002$phrase\002"
}


###### Interface type procs #######


proc pub:addtype {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set args [lindex $args 0]
	set args [split $args]
	if { [llength $args] < 3 } {
		notice $nick "Usage: ${cmdpfix}addtype <new type> <orientation: \002question\002/\002nonquest\002/\002react\002> <initial keyword>"
		notice $nick "To add new keywords to existing type entries use the \002${cmdpfix}addkeyword\002 command."
		return 0
	}

	set custom_types "[get_type_list 1] [get_type_list 2] "
	set existing_types "$valid_types $custom_types"

	set work_file [lindex $args 0]
	set work_file [string tolower $work_file]
	set work_phrase [lrange $args 2 end]
	set work_phrase [string tolower $work_phrase]

	set work_type [lindex $args 1]
	set work_type [string tolower $work_type]
	set the_type 0
	if { $work_type == "question" } { set the_type 1 }
	if { $work_type == "nonquest" } { set the_type 2 }
	if { $work_type == "react" } { set the_type 3 }
	if { $the_type == 0 } { 
		notice $nick "Invalid orientation (2nd argument). Must be \002question\002, \002nonquest\002 or \002react\002."
		return 0
	}
	if { [regexp " $work_file " $existing_types] } { 
		notice $nick "Type entry \002$work_file\002 ia already in use."
		if { [regexp " $work_file " " $custom_types "] } {
			notice $nick "Please choose a different type name, or use the \002${cmdpfix}addkeyword\002 command to add new keywords to \002$work_file\002 type."
		} {
			notice $nick "Please choose a different type name."
		}
		return 0
	}

	if { $work_phrase == "" } { 
		notice $nick "Initial keyword not specified."
		return 0
	}

	add_type $work_file $the_type $work_phrase

	putlog "$nick !$hand! ADD-NEW-TYPE: type: \002$work_file\002, orien: \002$the_type\002, kwds: \002$work_phrase\002"
	putserv "PRIVMSG $chan :$nick: Added new type \002$work_file\002 with \002$work_type\002 orientation and keywords: \002[join $work_phrase]"

	set f [open $logfile a]
	puts $f "ADD-TYPE: \[[realtime date], [realtime]\], (!$hand! $nick!$host) - TYPE:$work_file ORN:$the_type KWD:$work_phrase"
	close $f
}

proc pub:deltype {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 
	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}
	set args [lindex $args 0]
	set args [split $args]
	if { [lindex $args 0] == "" } {
		notice $nick "Usage: ${cmdpfix}deltype <type>"
		notice $nick "Valid type entries are: \002$custom_types"
		return 0
	}

	set work_file [lindex $args 0]
	set work_file [string tolower $work_file]

	if { [del_type $work_file] == 0} {
		putserv "NOTICE $nick : Entry type \002$work_file\002 is invalid."
		putserv "NOTICE $nick : Valid type entries are: \002$custom_types"
		return 0
	}
	putlog "$nick |$hand| DEL-TYPE: type: \002$work_file\002"
	putserv "PRIVMSG $chan :$nick: Removed the \002$work_file\002 type and all the keywords for it."

	set f [open $logfile a]
	puts $f "DEL-TYPE: \[[realtime date], [realtime]\], (!$hand! $nick!$host) TYPE:$work_file"
	close $f
}





##### Interface keywords procs ######



proc pub:addkeyword {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 
	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set args [lindex $args 0]
	set args [split $args]
	if { [llength $args] < 1 } {
		notice $nick "Usage: ${cmdpfix}addkeyword <type> <keyword(s) to add>"
		notice $nick "Valid type entries are: \002$custom_types"
		return 0
	}

	set work_file [lindex $args 0]
	set work_file [string tolower $work_file]
	set work_phrase [lrange $args 1 end]

	if { [add_keyword $work_file $work_phrase] != 1 } {
		 putserv "NOTICE $nick : Entry type \002$work_file\002 is invalid."
		 putserv "NOTICE $nick : Valid type entries are: \002$custom_types"
		 return 0
	}

	putlog "$nick !$hand! ADD-KEYWORD: type: \002$work_file\002,	keywords: \002$work_phrase\002"
	putserv "PRIVMSG $chan :$nick: Keyword(s) added to \002$work_file\002 type: [join $work_phrase]"

	set f [open $logfile a]
	puts $f "ADD-KEYWORD: \[[realtime date], [realtime]\], (!$hand! $nick!$host) Type:$work_file KWD:$work_phrase"
	close $f
}

proc pub:delkeyword {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 
	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set args [lindex $args 0]
	set args [split $args]
	if { [llength $args] < 1 } {
		notice $nick "Usage: ${cmdpfix}delkeyword <type> <keyword to delete>"
		notice $nick "Valid type entries are: \002$custom_types"
		return 0
	}

	set work_file [lindex $args 0]
	set work_file [string tolower $work_file]
	set work_phrase [lindex $args 1]

	set result [del_keyword $work_file $work_phrase]
	if { $result == 0 } {
		putserv "NOTICE $nick : Entry type \002$work_file\002 is invalid or keyword \002$work_phrase\002was not found."
		putserv "NOTICE $nick : Valid type entries are: \002$custom_types"
		return 0
	}
	if { $result == 2 } {
		putserv "NOTICE $nick : You can't delete the only keyword for \002$work_file\002 type."
		return 0
	}

	putlog "$nick !$hand! DEL-KEYWORD: type: \002$work_file\002,	keywords: \002$work_phrase\002"
	putserv "PRIVMSG $chan :$nick: Deleted keyword \002$work_phrase\002 from \002$work_file\002 type."

	set f [open $logfile a]
	puts $f "DEL-KEYWORD: \[[realtime date], [realtime]\], (!$hand! $nick!$host) Type:$work_file KWD:$work_phrase"
	close $f
}

proc pub:showkeywords {nick host hand chan args} {
	global ai_types_db logfile valid_types The_Owner ai_db_directory cmdpfix 
	set custom_types "[get_type_list 1] [get_type_list 2] [get_type_list 3]"

	if { ![matchattr $hand "W"] } {
		notice $nick "A special teaching flag (\002+W\002) is required to use this command."
		notice $nick "To recieve this flag, please contact \002$The_Owner\002."
		return 0
	}

	set args [lindex $args 0]
	set args [split $args]
	if { [lindex $args 0] == "" } {
		notice $nick "Usage: ${cmdpfix}showkeywords <type>"
		notice $nick "Valid type entries are: \002$custom_types"
		return 0
	}

	set work_file [lindex $args 0]
	set work_file [string tolower $work_file]

	set the_keywords [get_keyword_list $work_file]
	if { $the_keywords == 0 } {
		putserv "NOTICE $nick : Entry type \002$work_file\002 is invalid."
		putserv "NOTICE $nick : Valid type entries are: \002$custom_types"
		return 0
	}

	putlog "$nick !$hand! SHOW-KEYWORDS: type: \002$work_file\002"
	putserv "PRIVMSG $chan :$nick: Keywords for \002$work_file\002 type are: \002$the_keywords"
}


###### Now the core database procs ########


proc ai_getphrase { ai_file } {
	set phrases ""
	if { ![file exists $ai_file] } { return "" }
	set fd [open $ai_file r]
	while {![eof $fd]} { 
		gets $fd text
		if {$text != ""} {
			lappend phrases $text
		}
	}
	close $fd
	return [lindex $phrases [rand [llength $phrases]]]
}

proc ai_getall { ai_file nick number } {
	if { $number == ""} { set nummber 0 }
	if { ![file exists $ai_file] } { return 0 }
	putserv "PRIVMSG $nick : Listing database, file: \002$ai_file\002, starting from line \002$number\002"
	set line_num 0
	set fd [open $ai_file r]
	while {![eof $fd]} {
		incr line_num
		gets $fd text
		if {$text != ""} {
			if { $line_num >= $number } { putserv "PRIVMSG $nick : \002$line_num\002 $text" }
		}
	}
	close $fd
	putserv "PRIVMSG $nick : End of list."
	return 1
}


proc ai_addphrase { ai_file phrase } {

	set phrase [join $phrase]
	putlog "WRITING TO FILE $ai_file: \002$phrase"
	
	if {[catch {open $ai_file a} fd]} {
		return 0
	} else {
		puts $fd $phrase
		close $fd
		return 1
	}
}

proc ai_delphrase { ai_file phrase } {
	set what ""
	set phraserem 0
	set phrase [join $phrase]

	if {[catch {open $ai_file r} fd]} {
		return 0
	} else {
		while {![eof $fd]} { 
			gets $fd text
			if {[string tolower $text] != [string tolower $phrase]} { 
				append what "$text\n"
			} else { 
				set phraserem 1
			} 
		}
		close $fd
		if {[catch {open $ai_file w} fd]} {
			return 0
		} else {
			puts $fd $what
			close $fd
			return $phraserem
		}
	}
}

proc ai_delfile { file } {
	if {[file exists $file]} {
		file delete -force $file
		if {[file exists $file]} {
			return 0
		} else {
			return 1
		}
	} else {
		return 0
	}
}


proc ai_searchdb { ai_file phrase nick } {
	set phrase [join $phrase]
	set line 0
	set found 0
	set retstr ""
	if { ![file exists $ai_file] } { return "" }
	if { $phrase == "" } { return "" }
	set fd [open $ai_file r]
	while {![eof $fd]} {
		incr line
		gets $fd text
		if {$text != ""} {
			if { [regexp $phrase $text] } {
				putserv "PRIVMSG $nick : \002$ai_file: $line\002 $text"
				incr found
				set retstr "$found"
			}
		}
	}
	close $fd
	return "$retstr"
}


###### Now the core type procs ########


proc add_type { ai_type type_type keywords } {
global ai_types_db ai_db_directory 

	set fh [open $ai_types_db a]
	if { $type_type == 1} { puts $fh "$ai_type => $keywords" }
	if { $type_type == 2} { puts $fh "$ai_type -> $keywords" }
	if { $type_type == 3} { puts $fh "$ai_type _> $keywords" }
	close $fh
}

proc del_type { ai_type } {
global ai_types_db ai_db_directory 
set what ""
set phraserem 0

	if {[catch {open $ai_types_db r} fd]} {
		return 0
	} else {
		while {![eof $fd]} { 
			gets $fd text
							set first_word [lindex [split $text] 0]
			if {[string tolower $first_word] == [string tolower $ai_type]} {
				set phraserem 1
			} else { 
				append what "$text\n"
			} 
		}
		close $fd
		if {[catch {open $ai_types_db w} fd]} {
			return 0
		} else {
			puts $fd $what
			close $fd
			return $phraserem
		}
	}
}

proc get_type_list { type_type } {
	global ai_types_db ai_db_directory 
	set result ""

	if { $type_type == 1} { set requested_type "=>" }
	if { $type_type == 2} { set requested_type "->" }
	if { $type_type == 3} { set requested_type "_>" }

	if {[catch {open $ai_types_db r} fd]} {
		return ""
	} else {
		while {![eof $fd]} { 
			gets $fd text
			set first_word [lindex [split $text] 0]
			set current_type [lindex [split $text] 1]
			if { $current_type == $requested_type } {
				append result " $first_word"
			}
		}
		close $fd
	}

	set result [join $result]
	set result [split $result]
	return "$result"
}




###### And now, finally, the core keyword procs ########


proc add_keyword { ai_type keyword } {
global ai_types_db ai_db_directory 
set what ""
set result 0

	if {[catch {open $ai_types_db r} fd]} {
		return 0
	} else {
		while {![eof $fd]} { 
			gets $fd text
							set first_word [lindex [split $text] 0]
			if {[string tolower $first_word] == [string tolower $ai_type]} {
								append text " [string tolower $keyword]"
				append what "$text\n"
				set result 1
			} else { 
				append what "$text\n"
			} 
		}
		close $fd
		if {[catch {open $ai_types_db w} fd]} {
			return 0
		} else {
			puts $fd $what
			close $fd
			return $result
		}
	}
}

proc del_keyword { ai_type keyword } {
global ai_types_db ai_db_directory 
set what ""
set result 0

	if {[catch {open $ai_types_db r} fd]} {
		return 0
	} else {
		while {![eof $fd]} { 
			gets $fd text
			set temp [split $text]
			set first_word [lindex $temp 0]
			set second_word [lindex $temp 1]
			set all_keywords [lrange $temp 2 end]

			if {[string tolower $first_word] == [string tolower $ai_type]} {
				if { [regsub -all -nocase -- " $keyword" $all_keywords "" all_keywords] == 0 } {
					if { [regsub -all -nocase -- "$keyword " $all_keywords "" all_keywords] == 0 } { return 2 }
				}
				append what "$first_word $second_word $all_keywords\n"
				set result 1
			} else { 
				append what "$text\n"
			} 
		}
		close $fd
		if {[catch {open $ai_types_db w} fd]} {
			return 0
		} else {
			puts $fd $what
			close $fd
			return $result
		}
	}
}

proc get_keyword_list { ai_type } {
global ai_types_db ai_db_directory 
set result ""

	if {[catch {open $ai_types_db r} fd]} {
		return ""
	} else {
		while {![eof $fd]} { 
			gets $fd text
			set temp [split $text]
			set first_word [lindex $temp 0]
			set all_keywords [lrange $temp 2 end]
			set all_keywords [join $all_keywords]
			if { $first_word == $ai_type } {
				set result "$all_keywords"
			}
		}
		close $fd
	}

set result [split $result]
return "$result"
}




####### COUNTRY LIST (for "asl" and stuff :)) ######

set country_r {
 "AFGHANISTAN" "ALBANIA" "ALGERIA" "AMERICAN SAMOA"
 "ANDORRA" "ANGOLA" "ANGUILLA" "ANTARCTICA"
 "ARGENTINA" "ARMENIA" "ARUBA"
 "AUSTRALIA" "AUSTRIA" "AZERBAIJAN" "BAHAMAS"
 "BAHRAIN" "BANGLADESH" "BARBADOS" "BELARUS"
 "BELGIUM" "BELIZE" "BENIN" "BERMUDA"
 "BHUTAN" "BOLIVIA" "BOSNIA" "BOTSWANA"
 "BOUVET ISLAND" "BRAZIL" "BRUNEI DARUSSALAM"
 "BULGARIA" "BURKINA FASO" "BURUNDI" 
 "CAMBODIA" "CAMEROON" "CANADA" "CAP VERDE"
 "CAYMAN ISLANDS" "CENTRAL AFRICAN REPUBLIC" "CHAD" "CHILE"
 "CHINA" "CHRISTMAS ISLAND" "COLOMBIA"
 "COMOROS" "CONGO" "COOK ISLANDS" "COSTA RICA"
 "COTE D'IVOIRE" "CROATIA" "HRVATSKA" "CUBA"
 "CYPRUS" "CZECHOSLOVAKIA" "DENMARK" "DJIBOUTI"
 "DOMINICA" "DOMINICAN REPUBLIC" "EAST TIMOR" "ECUADOR"
 "EGYPT" "EL SALVADOR" "EQUATORIAL GUINEA" "ESTONIA"
 "ETHIOPIA" "FALKLAND ISLANDS" "MALVINAS" "FAROE ISLANDS"
 "FIJI" "FINLAND" "FRANCE" "FRENCH GUIANA"
 "FRENCH POLYNESIA" "GABON" "GAMBIA"
 "GEORGIA" "GERMANY" "DEUTSCHLAND" "GHANA"
 "GIBRALTAR" "GREECE" "GREENLAND" "GRENADA"
 "GUADELOUPE" "GUAM" "GUATEMALA" "GUINEA"
 "GUINEA BISSAU" "GYANA" "HAITI"
 "HONDURAS" "HONG KONG" "HUNGARY" "ICELAND"
 "INDIA" "INDONESIA" "IRAN" "IRAQ"
 "IRELAND" "ISRAEL" "ITALY" "JAMAICA"
 "JAPAN" "JORDAN" "KAZAKHSTAN" "KENYA"
 "KIRIBATI" "NORTH KOREA" "SOUTH KOREA" "KUWAIT"
 "KYRGYZSTAN" "LAOS" "LATVIA" "LEBANON"
 "LESOTHO" "LIBERIA" "LIECHTENSTEIN"
 "LITHUANIA" "LUXEMBOURG" "MACAU" "MACEDONIA"
 "MADAGASCAR" "MALAWI" "MALAYSIA"
 "MALI" "MALTA" "MARSHALL ISLANDS" "MARTINIQUE"
 "MAURITANIA" "MAURITIUS" "MEXICO" "MICRONESIA"
 "MOLDOVA" "MONACO" "MONGOLIA" "MONTSERRAT"
 "MOROCCO" "MOZAMBIQUE" "MYANMAR" "NAMIBIA"
 "NAURU" "NEPAL" "NETHERLANDS"
 "NEUTRAL ZONE" "NEW CALEDONIA" "NEW ZEALAND" "NICARAGUA"
 "NIGER" "NIGERIA" "NIUE" "NORFOLK ISLAND"
 "NORWAY" "OMAN" "PAKISTAN"
 "PALAU" "PANAMA" "PAPUA NEW GUINEA" "PARAGUAY"
 "PERU" "PHILIPPINES" "PITCAIRN" "POLAND"
 "PORTUGAL" "PUERTO RICO" "QATAR"
 "ROMANIA" "RUSSIA" "RWANDA"
 "SAINT LUCIA" "SAINT VINCENT AND THE GRENADINES" "SAMOA" "SAN MARINO"
 "SAO TOME AND PRINCIPE" "SAUDI ARABIA" "SENEGAL" "SEYCHELLES"
 "SIERRA LEONE" "SINGAPORE" "SLOVENIA" "SOLOMON ISLANDS"
 "SOMALIA" "SOUTH AFRICA" "SPAIN" "SRI LANKA"
 "SUDAN" "SURINAME"
 "SWAZILAND" "SWEDEN" "SWITZERLAND"
 "CANTONS OF HELVETIA" "SYRIA" "TAIWAN" "TAJIKISTAN"
 "TANZANIA" "THAILAND" "TOGO" "TOKELAU"
 "TONGA" "TRINIDAD AND TOBAGO" "TUNISIA" "TURKEY"
 "TURKMENISTAN" "TUVALU" "UGANDA"
 "UKRAINIAN SSR" "UNITED ARAB EMIRATES" "UNITED KINGDOM" "GREAT BRITAIN"
 "UNITED STATES OF AMERICA" "URUGUAY"
 "SOVIET UNION" "UZBEKISTAN" "VANUATU" "VATICAN CITY STATE" "VENEZUELA"
 "VIET NAM" 
 "WESTERN SAHARA" "YEMEN" "YUGOSLAVIA" "ZAIRE"
 "ZAMBIA" "ZIMBABWE" "KOREA"
 "LAO PEOPLES' DEMOCRATIC REPUBLIC" "RUSSIA" "SLOVAKIA" "CZECH"
}


############################ TALKING SECTION ##########################

###### Some vars #######
set its_a_mess "itsafscknmess"
set s_middle 1

#### main AI procedure binds #####
bind msgm - * do_8ball_msg_r
bind pubm - * talk_r


####### main talk procs ######
proc do_8ball_msg_r {nick uhost handle args} {
	global its_a_mess response botnick

	if {[regexp "op " "$args"] || [regexp "auth " "$args"] || [regexp "deauth" "$args"] || [regexp "pass " "$args"] || [regexp "commands" "$args"] || [regexp "help" "$args"] || [regexp "comeback " "$args"] || [regexp "addmask " "$args"] || [regexp "chat" "$args"] || [regexp "notes " "$args"]} {
		if {[regexp "auth " "$args"] || [regexp "pass " "$args"] || [regexp "addmask " "$args"]} {
			putlog "$nick msg cmd: Security."
		} {
			putlog "$nick msg cmd: $args"
		}
	}  {
		set rand_delay [rand 3000]
		after [expr ($rand_delay + 5000)]
		set the_talk [do_8ball_r $nick $args $its_a_mess $handle]
		if { $the_talk != 0 } { putserv "PRIVMSG $nick :$the_talk" }
	}
}

proc talk_r {nick uhost handle chan args} {
	global its_a_mess response botnick The_Owner ai_db_directory cmdpfix Random_Talk extra_names

	set output8 ""
	############ Dynamic types reply ##############
	set types [get_type_list 3]
	set answerdb ""
	set answer_prio ""
	foreach ty [split $types] {
		set chk_kwd [get_keyword_list $ty]
		foreach kwd [split $chk_kwd] {
			set temp ""
			set temp1 ""
			set temp2 ""
			set s 0
			if { [stridx $kwd 0] == "!" } { set s 1 }
			for {set i $s} {$i < [string length $kwd]} {incr i} {
				set char [stridx $kwd $i]
				if { $char == "_" } { set temp "$temp " } { set temp "$temp$char" }
			}
			for {set i $s} {$i < [string length $temp]} {incr i} {
				set char [stridx $temp $i]
				set char2 [stridx $temp [expr ($i + 1)]]
				if { (($char == "&") && ($char2 == "&")) } {
					set and_kwd "[split $temp "&&"]"
					set temp1 "[lindex $and_kwd 0]"
					set temp2 "[lindex $and_kwd 2]"
					set temp1 [join $temp1]
					set temp2 [join $temp2]
				}
			}
			if { [regexp -- $temp $args] } {
				# found react reply
				set answerdb "$answerdb$ai_db_directory$ty.ai "
				if { $s == 1 } {
					set answer_prio "$ai_db_directory$ty.ai"
				}
			}
			if { ($temp1 != "") && ($temp2 != "") } {
				if { [regexp -- $temp1 $args] && [regexp -- $temp2 $args] } {
					# found react reply with "and" keyword
					set answerdb "$answerdb$ai_db_directory$ty.ai "
					if { $s == 1 } {
						set answer_prio "$ai_db_directory$ty.ai"
					}
				}
			}
		}
	}
	set $answerdb [string trimright $answerdb " "]
	if { $answerdb != "" } {
		set output8 [ai_getphrase [lindex $answerdb [rand [llength $answerdb]]]]
	}
	if { $answer_prio != "" } {
		set output8 [ai_getphrase $answer_prio]
	}
	set temp ""
	foreach w [split $output8] {
		if { $w == "%r" } {
			append temp "[get_rnd_nick $nick $chan] "
		} {
			append temp "$w "
		}
	}
	if { $temp != "" } { set output8 $temp }



	if { $output8 != "" } {
		set rand_delay [rand 3000]
		after [expr ($rand_delay + 5000)]
		set flg_chk [chattr $handle $chan]
		if { [regexp "I" $flg_chk] } { return 0 }
		set tzc "TZ[string tolower $chan]"
		if { [getuser $The_Owner XTRA $tzc] == "1" } { return 0 }
		if { [onchan $nick $chan] } { putserv "PRIVMSG $chan :$nick: $output8" }
		return 0
	}

	set fucktor [rand $Random_Talk]
	set a_bld [string tolower $args]

	set talking_to_me 0
	foreach n [split $extra_names] {
		if { [regexp [string tolower $n] $a_bld] } {
			set talking_to_me 1
		}
	}
	if { ([regexp [string tolower $botnick] $a_bld] || $talking_to_me == 1) } {
		set rand_delay [rand 3000]
		after [expr ($rand_delay + 5000)]
		set the_talk [do_8ball_r $nick $args $chan $handle]
		if { $the_talk != 0 } {
			set flg_chk [chattr $handle $chan]
			if { [regexp "I" $flg_chk] } { return 0 }
			set tzc "TZ[string tolower $chan]"
			if { [getuser $The_Owner XTRA $tzc] == "1" } { return 0 }
			if { [onchan $nick $chan] } { putserv "PRIVMSG $chan :$the_talk" }
		}
		return 0
	}

	if { ($fucktor == 7) && ("$chan" != "") } {
		set rand_delay [rand 3000]
		after [expr ($rand_delay + 5000)]
		set the_talk [do_8ball_r $nick $args $chan $handle]
		if { $the_talk != 0 } {
			set flg_chk [chattr $handle $chan]
			if { [regexp "I" $flg_chk] } { return 0 }
			set tzc "TZ[string tolower $chan]"
			if { [getuser $The_Owner XTRA $tzc] == "1" } { return 0 }
			if { [onchan $nick $chan] } { putserv "PRIVMSG $chan :$the_talk" }
		}
	}
}

proc do_8ball_chan_r {nick uhost handle chan args} {
	global s_middle
	set s_middle 2
}

proc pub_s_middle {nick uhost handle chan args} {
	global its_a_mess response botnick s_middle The_Owner

	set flg_chk [chattr $handle $chan]
	if { [regexp "I" $flg_chk] } { return 0 }
	set tzc "TZ[string tolower $chan]"
	if { [getuser $The_Owner XTRA $tzc] == "1" } { return 0 }
	
	set rand_delay [rand 3000]
	after [expr ($rand_delay + 5000)]
	set the_talk [do_8ball_r $nick $args $chan $handle]
	putserv "PRIVMSG $chan :$the_talk"
	set s_middle 1
}

proc do_8ball_r {nick text chan handle} {
	global its_a_mess priv_log_file chan_log_file botnick ai_db_directory The_Owner
	global country_r

	if { $chan != $its_a_mess } { 
		set flg_chk [chattr $handle $chan]
	} { 
		set flg_chk [chattr $handle]
	}

	if { ([regexp "I" $flg_chk]) && ($chan != $its_a_mess) } { return 0 }
	set tzc "TZ[string tolower $chan]"
	if { [getuser $The_Owner XTRA $tzc] == "1" } { return 0 }

	set text [string tolower $text]
	set text "$text "
	set chan [string tolower $chan]
	set flg_chk [chattr $handle]

	if {[regexp "\\?" "$text"]} {

		############# Global question reply ##############
		set output8 [ai_getphrase "${ai_db_directory}question.ai"]

		########### Fixed reply types ###########

		if {[regexp " old" "$text"] || [regexp " age" "$text"]} {
			set output8 "[rand 60] years."
		}

		if { [regexp "m/f" "$text"] || [regexp "m or f" "$text"] } { if { [rand 2] == 1 } { set output8 "m" } else { set output8 "f" } }

		if {[regexp " asl\\?" "$text"] || [regexp "asl" "$text"] || [regexp "a/s/l" "$text"] } {
			set age [expr ([rand	40] + 10)]
			if {[rand 2] == 1} { set sex "male" } else { set sex "female" }
			set loc [lindex $country_r [rand [llength $country_r]]]
			set output8 "i am $sex, $age years old from $loc"
			set output8 [string tolower $output8]
		}

		############ Dynamic types reply ##############
		set types [get_type_list 1]
		set answerdb ""
		set answer_prio ""
		foreach ty [split $types] {
			set chk_kwd [get_keyword_list $ty]
			foreach kwd [split $chk_kwd] {
				set temp ""
				set temp1 ""
				set temp2 ""
				set s 0
				if { [stridx $kwd 0] == "!" } { set s 1 }
				for {set i $s} {$i < [string length $kwd]} {incr i} {
					set char [stridx $kwd $i]
					if { $char == "_" } { set temp "$temp " } { set temp "$temp$char" }
				}
				for {set i $s} {$i < [string length $temp]} {incr i} {
					set char [stridx $temp $i]
					set char2 [stridx $temp [expr ($i + 1)]]
					if { (($char == "&") && ($char2 == "&")) } {
						set and_kwd "[split $temp "&&"]"
						set temp1 "[lindex $and_kwd 0]"
						set temp2 "[lindex $and_kwd 2]"
						set temp1 [join $temp1]
						set temp2 [join $temp2]
					}
				}
				if { [regexp -- $temp $text] } {
					# found react reply
					set answerdb "$answerdb$ai_db_directory$ty.ai "
					if { $s == 1 } {
						set answer_prio "$ai_db_directory$ty.ai"
					}
				}
				if { ($temp1 != "") && ($temp2 != "") } {
					if { [regexp -- $temp1 $text] && [regexp -- $temp2 $text] } {
						# found react reply with "and" keyword
						set answerdb "$answerdb$ai_db_directory$ty.ai "
						if { $s == 1 } {
							set answer_prio "$ai_db_directory$ty.ai"
						}
					}
				}
			}
		}
		set $answerdb [string trimright $answerdb " "]
		if { $answerdb != "" } {
			set output8 [ai_getphrase [lindex $answerdb [rand [llength $answerdb]]]]
		}
		if { $answer_prio != "" } {
			set output8 [ai_getphrase $answer_prio]
		}
		set temp ""
		foreach w [split $output8] {
			if { $w == "%r" } {
				append temp "[get_rnd_nick $nick $chan] "
			} {
				append temp "$w "
			}
		}
		if { $temp != "" } { set output8 $temp }


		############# quest returns ###############
		if {"$chan" == "$its_a_mess"} {
			if {[catch {open $priv_log_file a} fd]} {
				putlog "Error in log file!"
			} else {
				puts $fd "[realtime] <$nick> $text	  <$botnick> $output8"
				close $fd
			}
			set p_t [whom 0]
			foreach n $p_t {
				set h [lindex $n 0]
				set b [lindex $n 1]
				set idx [hand2idx $h]
				if { ([matchattr $h "S"]) && ($b == $botnick) && ($idx > 0) } {
					putdcc $idx "PRIVATE: <$nick> $text	 <$botnick> $output8"
				}
			}

			return "$output8"
		} else {
			if {[catch {open $chan_log_file a} fd]} {
				putlog "Error in log file!"
			} else {
				puts $fd "[realtime] $chan: <$nick> $text    <$botnick> $output8"
				close $fd
			}

			if { ([regexp "b" $flg_chk]) && ($chan != $its_a_mess) } {
				set damn_it [rand 7]
				putlog "Bottalk: $nick, $chan, $damn_it (?)"
				if { $damn_it == 3 } {
					return "I'm so tired of talking to bots... ;)"
				} {
					if { $output8 == "" } { return 0 }
					return "$nick $output8"
				}
			} {
				if { $output8 == "" } { return 0 }
				return "$nick: $output8"
			}
		}

	} else {

		#### Global non-question response #####
		set output8 [ai_getphrase "${ai_db_directory}nonquest.ai"]


		#### Fixed non-question responses #####
		if { [regexp "m/f" "$text"] || [regexp "m or f" "$text"] } { if { [rand 2] == 1 } { set output8 "m" } else { set output8 "f" } }
		if {[regexp " asl\\?" "$text"] || [regexp "asl" "$text"] || [regexp "a/s/l" "$text"] } {
			set age [rand 50]
			if {[rand 2] == 1} { set sex "male" } else { set sex "female" }
			set loc [lindex $country_r [rand [llength $country_r]]]
			set output8 "i am $sex, $age years old from $loc"
			set output8 [string tolower $output8]
		}


		#### Dynamic types reply #####
		set types [get_type_list 2]
		set answerdb ""
		set answer_prio ""
		foreach ty [split $types] {
			set chk_kwd [get_keyword_list $ty]
			foreach kwd [split $chk_kwd] {
				set temp ""
				set temp1 ""
				set temp2 ""
				set s 0
				if { [stridx $kwd 0] == "!" } { set s 1 }
				for {set i $s} {$i < [string length $kwd]} {incr i} {
					set char [stridx $kwd $i]
					if { $char == "_" } { set temp "$temp " } { set temp "$temp$char" }
				}
				for {set i $s} {$i < [string length $temp]} {incr i} {
					set char [stridx $temp $i]
					set char2 [stridx $temp [expr ($i + 1)]]
					if { (($char == "&") && ($char2 == "&")) } {
						set and_kwd "[split $temp "&&"]"
						set temp1 "[lindex $and_kwd 0]"
						set temp2 "[lindex $and_kwd 2]"
						set temp1 [join $temp1]
						set temp2 [join $temp2]
					}
				}
				if { [regexp -- $temp $text] } {
					# found react reply
					set answerdb "$answerdb$ai_db_directory$ty.ai "
					if { $s == 1 } {
						set answer_prio "$ai_db_directory$ty.ai"
					}
				}
				if { ($temp1 != "") && ($temp2 != "") } {
					if { [regexp -- $temp1 $text] && [regexp -- $temp2 $text] } {
						# found react reply with "and" keyword
						set answerdb "$answerdb$ai_db_directory$ty.ai "
						if { $s == 1 } {
							set answer_prio "$ai_db_directory$ty.ai"
						}
					}
				}
			}
		}
		set $answerdb [string trimright $answerdb " "]
		if { $answerdb != "" } {
			set output8 [ai_getphrase [lindex $answerdb [rand [llength $answerdb]]]]
		}
		if { $answer_prio != "" } {
			set output8 [ai_getphrase $answer_prio]
		}
		set temp ""
		foreach w [split $output8] {
			if { $w == "%r" } {
				append temp "[get_rnd_nick $nick $chan] "
			} {
				append temp "$w "
			}
		}
		if { $temp != "" } { set output8 $temp }



		############# no-quest returns ###############
		if {"$chan" == "$its_a_mess"} {
			if {[catch {open $priv_log_file a} fd]} {
				putlog "Error in log file!"
			} else {
				puts $fd "[realtime] <$nick> $text    <$botnick> $output8"
				close $fd
			}
			set p_t [whom 0]
			foreach n $p_t {
				set h [lindex $n 0]
				set b [lindex $n 1]
				set idx [hand2idx $h]
				if { ([matchattr $h "S"]) && ($b == $botnick) && ($idx > 0) } {
					putdcc $idx "PRIVATE: <$nick> $text	 <$botnick> $output8"
				}
			}
			return "$output8"
		} else {
			if {[catch {open $chan_log_file a} fd]} {
				putlog "Error in log file!"
			} else {
				puts $fd "[realtime] $chan: <$nick> $text    <$botnick> $output8"
				close $fd
			}

			if { ([regexp "b" $flg_chk]) && ($chan != $its_a_mess) } {
				set damn_it [rand 7]
				putlog "Bottalk: $nick, $chan, $damn_it (.)"
				if { $damn_it == 3 } {
					return "I'm so tired of talking to bots... ;)"
				} {
					if { $output8 == "" } { return 0 }
					return "$nick $output8"
				}
			} {
				if { $output8 == "" } { return 0 }
				return "$nick: $output8"
			}
		}
	}
}


proc get_rnd_nick { nick chan } {
	global botnick

	set user_list [chanlist $chan]
	set chosen ""
	if { $user_list != "" } {
		while { $chosen == "" } {
			set selected_user [lindex $user_list [rand [llength $user_list]]]
			set host "$selected_user![getchanhost $selected_user $chan]"
			set target_user [finduser $host]
			set target_chk [chattr $target_user $chan]
			if { (![regexp "I" "$target_chk"]) && ($selected_user != $botnick) && ($selected_user != $nick) } {
				set chosen "$selected_user"
			}
		}
	}
	return $chosen
}

######################### FUNCTIONS ##########################

bind pub m|m ${cmdpfix}shudup pub:shudup
bind pub m|m ${cmdpfix}unshudup pub:unshudup


# Usage: !shudup [#channel]
# Stops all bot talk on certain channel
# If #channel not specified, defaults to current channel

proc pub:shudup {nick uhost hand chan arg} {
	global botnick The_Owner
	if {![auth:check $hand]} {
		notice $nick "Authentication is required to use public commands. Please authenticate yourself by typing: /msg $botnick auth <your password>"
		return 0
	}

	if { $arg != "" } { set chan $arg }
	if { ![validchan $chan] } {
		notice $nick "$chan is not a valid channel."
		return 0
	}

	set sec_chk [chattr $hand $chan]
	if { ![regexp "n" "$sec_chk"] } {
		notice $nick "Access denied."
		return 0
	}

	set tzc "TZ[string tolower $chan]"
	setuser $The_Owner XTRA $tzc "1"

	notice $nick "Now shutting up on \002$chan\002 :("
	putcmdlog "<<$nick>> !$hand! SHUDUP ON $chan ($arg)"

}


# Usage: !unshudup
# Starts all bot talk on certain channel (if stopped, see previous proc)
# If #channel not specified, defaults to current channel

proc pub:unshudup {nick uhost hand chan arg} {
	global botnick The_Owner
	if {![auth:check $hand]} {
		notice $nick "Authentication is required to use public commands. Please authenticate yourself by typing: /msg $botnick auth <your password>"
		return 0
	}

	if { $arg != "" } { set chan $arg }
	if { ![validchan $chan] } {
		notice $nick "$chan is not a valid channel."
		return 0
	}

	set sec_chk [chattr $hand $chan]
	if { ![regexp "n" "$sec_chk"] } {
		notice $nick "Access denied."
		return 0
	}

	set tzc "TZ[string tolower $chan]"
	setuser $The_Owner XTRA $tzc "0"

	notice $nick "No more shutting up on \002$chan\002!!! :)"
	putcmdlog "<<$nick>> !$hand! SHUDUP OFF $chan ($arg)"
}


############################ FIN ##########################


putlog "Project \"Kalich\" (C) L3ECH, 2001: Loaded AI section."
set AI "LOADED"
