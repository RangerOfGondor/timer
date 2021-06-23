enum actions { start, stop, pause, play, reset }

const Map<actions, String> actionToString = {
  actions.start: "start",
  actions.stop: "stop",
  actions.play: "play",
  actions.pause: "pause",
  actions.reset: "reset",
};
