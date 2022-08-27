import create from 'zustand';
import { doPoke, subscribe, dedup} from '../utils';

export const useStore = create((set) => ({
	/* FRONTEND ONLY STATE 
	 *
	 */
	/* possible values for route: 
		 invites, draft, settings
	*/
	route: "draft",
	/* all, hosting, received */
	inviteRoute: "all",
	setRoute: (route) => set(state => ({ route : route })),
	/* STATE
	 *
	 */
	invites: [
	],
	settings: {
		statusActive: true,
		gatherActive: false,
		position: { lat: 3134, lon: 12 },
		radius: 50,
		address: "I'll define this later",
		statusNote: "I'm having a great time",
		receiveInvite: "anyone",
		receiveStatus: "anyone",
	},
	/*  ACTIONS
	 *
	 */
	pSettings: (tas, data) => console.log(tas + data),
	pEditInvite: (tag, id) => {
		// const obj = {'edit-invite': {}};
		// obj['edit-invite'][tag] = action;
		// console.log(obj);
		console.log({'edit-invite': {'close': id}});
		doPoke({'edit-invite': {'close': id}}, () => console.log('onSucc'), ()=>{})
	},
	// pEditInvite: (tag, action) => console.log({tag: action}),
	pSendInvite: (myInvite) => doPoke({"send-invite": myInvite}, () => console.log('onSucc'), ()=>{}),
	pAccept: (id) => doPoke({"accept": {id}}, () => {console.log('onSucc')}, () => {}),
	pDeny: (id) => doPoke({"deny": {id}}, () => {console.log('onSucc')}, () => {}),
	pBan: (ship) => doPoke({"ban": {ship }}, () => {console.log('onSucc')}, () => {}),
	pUnban: (ship) => doPoke({"unban": {ship}}, () => {console.log('onSucc')}, () => {}),
	/*  SUBSCRIPTIONS
	 *
	 */
	sAll: (handler) => subscribe('/all', (all) => {
		if(Object.keys(all)[0] === 'initAll') {
			set(state => ({ invites: all.initAll.invites.map(
				item => ({id: item.id, initShip: item.invite.initShip, title: '', 
				desc: item.invite.desc, radius: 0, maxAccepted: item.invite.maxAccepted, receiveShips: [], 
				hostStatus: item.invite.hostStatus
				})) }))
		}
		else if(Object.keys(all)[0] === 'updateInvite') {
			const item = all.updateInvite;
			console.log(item)
			set(state => ({ invites: dedup('id', state.invites.concat(
				{ id: item.id, hostStatus: item.invite.hostStatus,
					initShip: item.invite.initShip, title: '',
					desc: item.invite.desc, radius: 0, maxAccepted:
					item.invite.maxAccepted, 
					receiveShips: item.invite.receiveShips.map(x => ({ship: x.ship, shipInvite: x.shipInvite}))})),
				settings: {
				}}));
		}
	}),
}));
