import create from 'zustand'
import { subTodo } from './subscribe';
import { addTodo, removeTodo, checkTodo } from './poke';
import { handleTodo } from './handle';

export const useStore = create(set => ({
	/* todo */
	todos: [],
	addTodo,
	removeTodo,
	checkTodo,
	handleTodo: (state) => set(handleTodo(state))
	/* calendar */
	/* notes */
}));

export const subscribe = async (state) => {
	await subTodo(state.handleTodo);
}
