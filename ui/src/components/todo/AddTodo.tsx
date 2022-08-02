import React, { useState } from 'react';
import Paper from '@mui/material/Paper';
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import {useStore} from '../../data/store';

/* const testEntry = { */
/* 		'titl': 'testtitle2', */
/* 		'text':'testdesc', */
/* }; */

const testEntry = {
		'titl': 'testtitle2',
		'text':'testdesc',
		'categories': [],
		'permissions' : [],
		'attachments' : [],
		/* 'type': { */
		/* 		note: 'note', */
		/* } */
		'type': {
		 		task: {
				due: Date.now(),
				prio: 'high',
				done: false
			}
		}
};

export const AddTodo = () => {
	const [inputValue, setInputValue] = useState('');
	const addTodo = useStore(state => state.addTodo);
	/* const onClick = () => addTodo({ */
	/* 	title:inputValue */
	/* 	}); */
	const onClick = () => addTodo(testEntry);

		return(
				<div>
					<form id="myForm">
					<Paper>
					<div class="text-blue"> Hello </div>
					<div 
						style={{marginLeft: '10px'}}
					>
						<TextField 
							className="AddText" 
							fullWidth={true}
							onChange={(e) => setInputValue(e.target.value)}
						>
						</TextField>
					</div>
					</Paper>
						<br/>
						<Button variant="text" onClick={onClick}>Add todo</Button>
					</form>
					
				</div>
		)
	}

export default AddTodo;
