import React, { useEffect, useState } from 'react';
import moment from "moment";
import Todo from './components/todo/Main';
import {useStore, subscribe} from './data/store';
import Calendar from './components/CustomCalendar';

/* const testEntry = { */
/* 	'action' : 'add-entry', */
/* 	'params' : { */
/* 		'id': 'testid', */
/* 	}, */
/* }; */


const events = [
      {
        start: moment().toDate(),
        end: moment().add(1, "days").toDate(),
        title: "Some title",
      },
    ];

// middle is a calendar, side is a todo app
export function App() {
	const state = useStore(state => state);

  useEffect(() => {
    const init = async () => await subscribe(state);
    init();
  }, []);

  return (
	<main>
	<Todo/>
	</main>
  );
}
