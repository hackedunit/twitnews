-- Follow me on Twitter: http://twitter.com/hackedunit

tell application "NetNewsWire"
	if index of selected tab = 0 then
		-- We're looking at headlines, so just get the headline URL
		set feed_url to URL of selectedHeadline
		set feed_title to title of selectedHeadline
	else
		-- We're looking at a web view tab, so we need to know which tab
		set i to index of selected tab
		set i to i + 1
		-- Get the tab's URL
		set URL_list to URLs of tabs
		set title_list to titles of tabs
		set feed_url to item i of URL_list
		set feed_title to item i of title_list
	end if
	-- Build the GET request for the is.gd API
	set feed_url to "http://is.gd/api.php?longurl=" & feed_url
	-- Submit the GET request and copy the results to clipboard
	set cmd to "curl " & feed_url
	set feed_url to (do shell script cmd)
end tell

-- change the status message to your liking here:
set tweet to feed_title & " " & feed_url

-- let the user edit
display dialog "Edit your Twitter status" with title "TwitNews" default answer tweet cancel button 1 default button 2 buttons {"Cancel", "Send"}
set tweet to (text returned of result)

-- get login from keychain
tell application "Keychain Scripting"
	set twitter_key to first Internet key of current keychain whose server is "twitter.com"
	set twitter_login to quoted form of (account of twitter_key & ":" & password of twitter_key)
end tell

-- post to twitter
set twitter_status to quoted form of ("status=" & tweet)
set results to do shell script "curl --user " & twitter_login & " --data-binary " & twitter_status & " http://twitter.com/statuses/update.json"