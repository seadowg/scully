import $ from "jquery";
import Bacon from 'baconjs';
import React from 'react';
import ReactDOM from 'react-dom';

const submissions = new Bacon.Bus();
const fieldKeydowns = new Bacon.Bus();
const fieldChanges = new Bacon.Bus();

const keyDown = (ev) => {
  fieldKeydowns.push(null);
}

const submit = (ev) => {
  ev.preventDefault();
  submissions.push(null);
};

const change = (ev) => {
  fieldChanges.push(ev.target.value);
};

const responses = (stream, url, dataFun) => {
  const bus = new Bacon.Bus();

  stream.onValue((value) => {
    bus.plug(Bacon.fromPromise($.ajax({
      type: "GET",
      url: url,
      dataType: "json",
      data: {
        "name": value
      }
    })));
  });

  return bus;
};

const Skully = (props) => {
  return (
    <div>
      The truth is out there...
      <br/>
      <br/>
      <form id="episode_form" onSubmit={submit}>
        C:\>  <input onChange={change} autoFocus={true} onKeyDown={keyDown} type="text" name="name" id="episode_input" className="episode_input" autoComplete="off"/>
      </form>
      <div>
        <span id="next_episode">{props.episode ? "Skip to: " + props.episode.next : ""}</span>
      </div>
    </div>
  )
};

const fieldValue = fieldChanges.toProperty();
const submittedValues = fieldValue.sampledBy(submissions);
const episodes = responses(submittedValues, "/episodes/search");

episodes.merge(fieldKeydowns).onValue((episode) => {
  ReactDOM.render(
    <Skully episode={episode}/>,
    document.getElementById('root')
  );
});

episodes.push(null);
