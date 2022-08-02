import Urbit from '@urbit/http-api';
const api = new Urbit('', '', window.desk);
api.ship = window.ship;

export const subTodo = async (handle : any) => await api.subscribe({app: 'org', path:'/updates', err: handle, event:handle, quit:handle});
