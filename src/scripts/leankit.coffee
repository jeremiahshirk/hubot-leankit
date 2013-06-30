# Description
#   Poll a Leankit Kanban board for card changes, and announce them
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_LEANKIT_USERNAME
#   HUBOT_LEANKIT_PASSWORD
#   HUBOT_LEANKIT_ORGNAME
#   HUBOT_LEANKIT_BOARD_ID
#   HUBOT_LEANKIT_POLL_INTERVAL
#   HUBOT_LEANKIT_ROOM
#
# Commands:
#   None 
#
# Notes:
#   None
#
# Author:
#   jeremiahshirk

basic_auth = (config) ->
  'Basic ' + new Buffer(config.user + ':' + config.pass).toString('base64')

update_last_seen = (robot, config) ->
  auth = basic_auth(config)
  robot
    .http("https://#{config.org}.leankit.com/Kanban/Api/Boards/#{config.board_id}")
    .headers(Authorization: auth, Accept: 'application/json')
    .get() (err,res,body) ->
      result = JSON.parse(body)
      if result && result.ReplyData
        config.last_seen = result.ReplyData[0].Version
        robot.send(config.room, "LeanKit watcher starting...current board version is #{config.last_seen}")


check_updates = (robot, config) ->
  # robot.send(config.room, "Checking for updates after version #{config.last_seen} ")
  auth = basic_auth(config)
  robot
    .http("https://#{config.org}.leankit.com/Kanban/Api/Board/#{config.board_id}/BoardVersion/#{config.last_seen}/GetBoardHistorySince")
    .headers(Authorization: auth, Accept: 'application/json')
    .get() (err,res,body) ->
      result = JSON.parse(body)
      if result && result.ReplyData && result.ReplyData[0]
        for update in result.ReplyData[0]
          config.last_seen += 1
          robot.send(config.room, update.Message)

module.exports = (robot) ->
  config =
    user: process.env.HUBOT_LEANKIT_USERNAME
    pass: process.env.HUBOT_LEANKIT_PASSWORD
    org: process.env.HUBOT_LEANKIT_ORGNAME
    board_id: process.env.HUBOT_LEANKIT_BOARD_ID
    interval: process.env.HUBOT_LEANKIT_POLL_INTERVAL
    room: { "room": process.env.HUBOT_LEANKIT_ROOM, "type": "groupchat" }
    last_seen: 0

  setImmediate(update_last_seen, robot, config)
  setInterval(check_updates, config.interval, robot, config) 