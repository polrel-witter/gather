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
	pAddress: (tas, data) => console.log(tas + data),
	pPosition: (tas, data) => console.log(tas + data),
	pRadius: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})},
	//
	pDelReceiveShip: (id) => {doPoke({'del-receive-ship': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pAddReceiveShip: (id) => {doPoke({'add-receive-ship': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pEditMaxAccepted: (id) => {doPoke({'edit-max-accepted': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pEditDesc: (id, desc) => {doPoke({'edit-desc': {'id': id, 'desc': desc}}, () => console.log('onSucc'), ()=>{})},
	pCancel: (id) => {doPoke({'cancel': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pComplete: (id) => {doPoke({'complete': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pClose: (id) => {doPoke({'close': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pReopen: (id) => {doPoke({'reopen': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	//
	pSendInvite: (myInvite) => doPoke({"send-invite": myInvite}, () => console.log('onSucc'), ()=>{}),
	pAccept: (id) => doPoke({"accept": {'id': id}}, () => {console.log('onSucc')}, () => {}),
	pDeny: (id) => doPoke({"deny": {'id': id}}, () => {console.log('onSucc')}, () => {}),
	pBan: (ship) => doPoke({"ban": {'ship': ship}}, () => {console.log('onSucc')}, () => {}),
	pUnban: (ship) => doPoke({"unban": {'ship': ship}}, () => {console.log('onSucc')}, () => {}),
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
