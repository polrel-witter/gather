// external dependencies
import React, { useState } from 'react';
import {useStore} from '../../data/store';
import IconButton from '@mui/material/IconButton';
import Snackbar from '@mui/material/Snackbar';
import FormatListBulletedIcon from '@mui/icons-material/FormatListBulleted';
import Paper from '@mui/material/Paper';

//internal dependecies
import AddTodo from './AddTodo';
import TodoList from './TodoList';

const Main = () => {
		const [open, setOpen] = useState(false);
		const todos = useStore(state => state.todos);
		const addTodo = useStore(state => state.addTodo);
		const removeTodo = useStore(state => state.removeTodo);
		const checkTodo = useStore(state => state.checkTodo);

    return (
       <Paper 
          style={{paddingBottom: '20px', marginTop: 100, marginBottom: 100, marginRight: 20, marginLeft: 40}}>
          <div 
          style={{
            display: 'flex',
          }}
          >
            <div style={{marginLeft: '44%'}}>
              <h1 style={{ textAlign: 'center'}}>
                Todo List 
              </h1>
            </div>
            <div style={{ marginRight:'10%', marginTop: 13}}>
            </div>
          </div>
              <h1 style={{ textAlign: 'center', color: '#ffffff'}}/>
          <TodoList 
            todos={todos}
            handleRemove={removeTodo} 
            handleCheck={checkTodo} 
          />
          <br />
          <div style={{marginLeft: '5%'}}>
           <AddTodo/>
          </div>
          <Snackbar
          open={open}
          message="Todo Item deleted"
          autoHideDuration={2000}
          /* onRequestClose={() => setOpen(false)} */
        />
        </Paper>
    );
}

export default Main;
