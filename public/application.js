var formSubmits = function(el) {
  var submits = new Bacon.Bus();
  el.submit(function(ev, data) {
    ev.preventDefault();
    submits.plug(Bacon.fromPromise($.ajax({
      type: "GET",
      url: "/episodes/search",
      dataType: "json",
      data: $('#episode_input').serialize(),
    })));
  });

  return submits;
};

$(document).ready(function() {
  var submits = formSubmits($('#episode_form'));
  var responses = submits.map(function(data) { return "Skip to: " + data['next'] });
  var keydowns = $('#episode_input').asEventStream('keydown');
  responses.merge(keydowns.map("")).assign($("#next_episode"), "text");

  $('#episode_input').focus();
});
