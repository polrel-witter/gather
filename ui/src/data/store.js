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
	pAddress: (address) => console.log(address),
	pPosition: (position) => console.log(position),
	pRadius: (radius) => {doPoke({'radius': {'radius': radius}}, () => console.log('onSucc'), ()=>{})},
	pCreateCollection: (title, members) => {doPoke({'create-collection': {'title': title, 'members': members}}, () => console.log('onSucc'), ()=>{})},
	pEditCollectionTitle: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})},
	pAddToCollection: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})},
	pDelFromCollection: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})},
	pDelCollection: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})},
	pReceiveInvite: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})}, //?
	pDelReceiveShip: (id) => {doPoke({'del-receive-ship': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pAddReceiveShip: (id) => {doPoke({'add-receive-ship': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pEditMaxAccepted: (id) => {doPoke({'edit-max-accepted': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pEditDesc: (id, desc) => {doPoke({'edit-desc': {'id': id, 'desc': desc}}, () => console.log('onSucc'), ()=>{})},
	pEditInviteLocation: (id, desc) => {doPoke({'edit-desc': {'id': id, 'desc': desc}}, () => console.log('onSucc'), ()=>{})},
	pEditInvitePosition: (id, desc) => {doPoke({'edit-desc': {'id': id, 'desc': desc}}, () => console.log('onSucc'), ()=>{})},
	pEditInviteAddress: (id, desc) => {doPoke({'edit-desc': {'id': id, 'desc': desc}}, () => console.log('onSucc'), ()=>{})},
	pEditInviteAccessLink: (id, desc) => {doPoke({'edit-desc': {'id': id, 'desc': desc}}, () => console.log('onSucc'), ()=>{})},
	pEditInviteRadius: (id, desc) => {doPoke({'edit-desc': {'id': id, 'desc': desc}}, () => console.log('onSucc'), ()=>{})},
	pCancel: (id) => {doPoke({'cancel': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pComplete: (id) => {doPoke({'complete': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pClose: (id) => {doPoke({'close': {'id': id}}, () => console.log('onSucc'), ()=>{})},
	pReopen: (id) => {doPoke({'reopen': {'id': id}}, () => console.log('onSucc'), ()=>{})},
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
			console.log(all.initAll.invites[0].invite.receiveShips.map(x => ({ship: x.ship, shipInvite: x.shipInvite})));
			set(state => ({ invites: all.initAll.invites.map(
				item => ({ id: item.id, initShip: item.invite.initShip, title: '', 
				desc: item.invite.desc, radius: 0, maxAccepted: item.invite.maxAccepted, 
				receiveShips: item.invite.receiveShips.map(x => ({ship: x.ship, shipInvite: x.shipInvite})),
				settings: {},
				hostStatus: item.invite.hostStatus
				}))}))
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
