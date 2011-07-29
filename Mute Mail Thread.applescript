(*
Copyright © 2011 Jeffrey Pfau

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*)

on run
	tell application "Mail"
		-- Collect the rules that already exist
		set ruleNames to {}
		repeat with ruleNumber from 1 to count rules
			copy name of item ruleNumber of rules to end of ruleNames
		end repeat
		
		-- Find the threads we want to mute
		repeat with messageNumber from 1 to count selection
			set read status of item messageNumber of (selection as list) to true
			set theSubject to the subject of item messageNumber of (selection as list)
			ignoring case
				if theSubject does not start with "Re: " then set theSubject to "Re: " & theSubject
			end ignoring
			set newRuleName to "Mute thread: " & theSubject
			
			-- Add the rule if it doesn't exist already
			if newRuleName is not in ruleNames then
				copy newRuleName to end of ruleNames
				set newRule to make new rule with properties {name:newRuleName, mark read:true, enabled:true}
				make new rule condition at end of rule conditions of newRule with properties {qualifier:ends with value, rule type:subject header, expression:theSubject}
			end if
		end repeat
	end tell
end run