(*
Copyright © 2011 Jeffrey Pfau

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*)

on run
	set startTime to (current date) - (30 * days)
	tell application "Mail"
		set numberOfMessages to 0
		-- Collect the rules that are mutes
		set muteRules to {}
		repeat with ruleNumber from 1 to count rules
			if name of item ruleNumber of rules starts with "Mute thread: " then
				set muteRules to muteRules & {item ruleNumber of rules}
			end if
		end repeat
		
		expression of first rule condition of first item of muteRules
		-- Find the messages that match the thread name
		set theMessages to messages of inbox
		repeat with messageNumber from 1 to count theMessages
			set numberOfMessages to numberOfMessages + 1
			set theMessage to item messageNumber of theMessages
			set livelist to {}
			repeat with ruleNumber from 1 to count muteRules
				ignoring case
					--expression of item ruleNumber of muteRules
					if date received of theMessage > startTime and subject of theMessage starts with Â
						(expression of first rule condition of item ruleNumber of muteRules) Â
							then copy ruleNumber to end of livelist
				end ignoring
			end repeat
			
			-- Remove live items from the victim list
			if (count livelist) > 0 then
				set oldMuteRules to {}
				repeat with ruleNumber from 1 to count muteRules
					if ruleNumber is not in livelist then set oldMuteRules to oldMuteRules & {item ruleNumber of muteRules}
				end repeat
				set muteRules to oldMuteRules
			end if
			
			-- Bail out if we don't have any rules left to remove
			if (count muteRules) is equal to 0 then exit repeat
		end repeat
		
		-- Anything left is ancient. Remove them.
		repeat with ruleNumber from 1 to count rules
			if {item ruleNumber of rules} is in muteRules then
				-- This is an atrociously huge hack and I don't know why I need this temporary
				set victim to item ruleNumber of rules
				delete victim
			end if
		end repeat
	end tell
end run