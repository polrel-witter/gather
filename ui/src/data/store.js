import create from 'zustand';
import { doPoke, subscribe, dedup} from '../utils';
import _ from 'lodash';

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
	focusedInvite: {},
	setRoute: (route) => set(state => ({ route : route })),
	// focusInvite: (invite) => {console.log('focusInvite'); console.log(invite); set(state => ({ focusedInvite : _.cloneDeep(invite) }))},
	focusInvite: (invite) => { console.log('fInvite'); console.log(invite); set(state => ({ focusedInvite : invite }))},
	unFocusInvite: () => { console.log('unfInvite'); set(state => ({ focusedInvite : {} }))},
	/* STATE
	 *
	 */
	invites: [
	],
	settings: {},
	/*  ACTIONS
	 *
	 */
	pAddress: (address) => {doPoke({'address': address}, () => console.log('onSucc'), ()=>{})},
	pPosition: (position) => {doPoke({'position': position}, () => console.log('onSucc'), ()=>{})},
	pRadius: (radius) => {doPoke({'radius': {'radius': '.' + radius}}, () => console.log('onSucc'), ()=>{})},
	pCreateCollection: (title, members) => {console.log(members); doPoke({'create-collection': {'title': title, 'members': members}}, () => console.log('onSucc'), ()=>{})},
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
		console.log(all);
			console.log('all--------')
			console.log(all)
		if(Object.keys(all)[0] === 'initAll' && all.initAll.invites.length !== 0) {
			const settings = all.initAll.settings;
			// console.log(all.initAll.invites[0].invite.receiveShips.map(x => ({ship: x.ship, shipInvite: x.shipInvite})));
			set(state => ({
				invites: all.initAll.invites.map(
				item => ({ 
					id: item.id, 
					initShip: item.invite.initShip, 
					title: '', 
					desc: item.invite.desc, 
					radius: 0, 
					maxAccepted: item.invite.maxAccepted, 
					receiveShips: item.invite.receiveShips.map(x => ({ship: x.ship, shipInvite: x.shipInvite})),
					hostStatus: item.invite.hostStatus
				})),
				settings: {
					position: settings.position,
					radius: settings.radius,
					address: settings.address,
					collections: settings.collections,
					banned: settings.banned.banned,
					receiveInvite: settings.receiveInvite,
				}
			}))
		}
		else if(Object.keys(all)[0] === 'updateInvite') {
			const item = all.updateInvite;
			console.log('updateInvite---')
			console.log(item)
			set(state => ({ invites: dedup('id', state.invites.concat(
				{ id: item.id, hostStatus: item.invite.hostStatus,
					initShip: item.invite.initShip, title: '',
					desc: item.invite.desc, radius: 0, maxAccepted:
					item.invite.maxAccepted,
					receiveShips: item.invite.receiveShips.map(x => ({ship: x.ship, shipInvite: x.shipInvite}))})),
				}));
		}
		else if(Object.keys(all)[0] === 'updateSettings') {
			const settings = all.updateSettings.settings;
			set(state => ({
				settings: {
					position: settings.position,
					radius: settings.radius,
					address: settings.address,
					collections: settings.collections,
					banned: settings.banned.banned,
					receiveInvite: settings.receiveInvite,
				}
				}));
		}
	}),
}));
