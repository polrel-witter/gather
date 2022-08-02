// external dependencies
import React  from 'react';
import List from '@mui/material/List';
// internal dependecies
import Todo from './Todo';

export const TodoList = (props) => {

    const {
      handleRemove,
      handleCheck,
      todos,
    } = props;

    var todoNode = todos.map((todo) => {
    return (
      <Todo 
        key={ todo.id } 
        todo={ todo.task } 
        id = {todo.id}
        checked = { todo.checked }
        handleRemove={handleRemove}
        handleCheck={handleCheck}
      />
    )
  })
    return(
    <List style={{marginLeft: '5%'}}>
      <ul>{ todoNode }</ul>
    </List>
    )
}
  
export default TodoList
