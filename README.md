Leankit Kanban Board Watcher
============================

hubot-leankit.coffee watches your Leankit Kanban board, announces changes in a group chat.


Configuration
--------------

All configuration is through environment variables.

	export HUBOT_LEANKIT_USERNAME='user@foo.com'
	export HUBOT_LEANKIT_PASSWORD='************'
	export HUBOT_LEANKIT_ORGNAME='foo'  # the org name, as found in your URL, i.e. foo.leankit.com
	export HUBOT_LEANKIT_BOARD_ID='12345678' # can be found the URL when viewing that board
	export HUBOT_LEANKIT_ROOM=mygroup@conference.foo.com
	export HUBOT_LEANKIT_POLL_INTERVAL=60000 # how often to poll Leankit, in ms


Installation
------------

Simply copy/link the leankit.coffee into your Hubot scripts directory, and possibly  add it to
hubot-scripts.json, depending on your configuration.


Usage
------

hubot-leankit doesn't respond to any commands, but when your board changes, it will announce that in
your group chat.


Contributing
-------------

Pull requests, issues, etc. are welcome.

