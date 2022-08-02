import React, { Component } from "react";
import { Calendar, momentLocalizer } from "react-big-calendar";
import moment from "moment";
import withDragAndDrop from "react-big-calendar/lib/addons/dragAndDrop";

/* import "./App.css"; */
import "react-big-calendar/lib/addons/dragAndDrop/styles.css";
import "react-big-calendar/lib/css/react-big-calendar.css";

const localizer = momentLocalizer(moment);
const DnDCalendar = withDragAndDrop(Calendar);

export const CustomCalendar = (props : any) => {
  /* state = { */
  /*   events: [ */
  /*     { */
  /*       start: moment().toDate(), */
  /*       end: moment().add(1, "days").toDate(), */
  /*       title: "Some title", */
  /*     }, */
  /*   ], */
  /* }; */

  /* const onEventResize = (data) => { */
  /*   const { start, end } = data; */

  /*   this.setState((state) => { */
  /*     state.events[0].start = start; */
  /*     state.events[0].end = end; */
  /*     return { events: [...state.events] }; */
  /*   }); */
  /* }; */

  const onEventDrop = (data : any) => {
    console.log(data);
  };

    return (
      <div className="App">
        <DnDCalendar
          defaultDate={moment().toDate()}
          defaultView="month"
          events={props.events}
          localizer={localizer}
          /* onEventDrop={props.onEventDrop} */
          /* onEventResize={props.onEventResize} */
          resizable
          style={{ height: "100vh" }}
        />
      </div>
    );
}

export default CustomCalendar;
