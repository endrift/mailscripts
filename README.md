# Mail Scripts

A collection of AppleScripts for muting Mail.app threads.


## Installation (using built-in OS X features)

Download and put these into `~/Library/Scripts/Applications/Mail`.

Open Script Editor, open its Preferences and enable “Show Script menu in menu bar”.


## Installation (using Keyboard Maestro or similar)

Download and put these somewhere; `~/Library/Scripts/Applications/Mail` is still a great location.

Set up Keyboard Maestro or a similar tool to execute the script on a hot key.

Marking the messages as read is (partially?) broken, so make it also execute “Message → Mark → As Read” as part of the macro. (Disable stop-on-failure, because the command won't always be available.)

For a visual confirmation, you can optionally configure it to display the execution results in a notification.
