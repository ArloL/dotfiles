on run argv
	tell application "Terminal"
		set target_tty to "not a tty"
		set profile to "Basic"
		if (count of argv) = 2 then
			set target_tty to item 1 of argv
			set profile to item 2 of argv
		end if
		if target_tty = "not a tty" then
			return
		end if
		set window_list to every window
		repeat with the_window in window_list
			set tab_list to {}
			try
				set tab_list to every tab in the_window
			end try
			repeat with the_tab in tab_list
				set the_tty to the tty of the_tab # grab the title
				if the_tty contains (target_tty as text) then
					set current settings of the_tab to settings set profile
				end if
			end repeat
		end repeat
	end tell
end run
