import Urbit from '@urbit/http-api';
const api = new Urbit('', '', window.desk);
api.ship = window.ship;

const onSuccess = () => {console.log('onSuccess')};
const onError = () => {console.log('onError')};


export const addTodo = async (todo : any) => {
	const json = {action: 'add', params: todo};
	console.log(json);
	await api.poke({onSuccess, onError, app: 'org', mark:'org-action', json });
};

export const removeTodo = async (todo : any) => {};
export const checkTodo = async (todo : any) => {};
