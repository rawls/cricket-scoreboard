//= require NoSleep

// A function which updates the scoreboard data
function refreshScore(match_id) {
  $.post("/scoreboard", { match_id: match_id },
    function(result) { $("#scoreboard").html(result); }
  );
};
