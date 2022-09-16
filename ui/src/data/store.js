import create from 'zustand';
import { doPoke, subscribe, dedup, properPosition } from '../utils';
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
	pAddress: (address) => {doPoke({'address': { address: address}}, () => console.log('onSucc'), ()=>{})},
	pPosition: (position) => {doPoke({'position': position}, () => console.log('onSucc'), ()=>{})},
	pRadius: (radius) => {doPoke({'radius': {'radius': '.' + radius}}, () => console.log('onSucc'), ()=>{})},
	pCreateCollection: (collection) => {doPoke({'create-collection': collection}, () => console.log('onSucc'), ()=>{})},
	pEditCollection: (collection) => {doPoke({'edit-collection': collection}, () => console.log('onSucc'), ()=>{})},
	pDeleteCollection: (id) => {doPoke({'del-collection': {id: id}}, () => console.log('onSucc'), ()=>{})},
	pEditCollectionTitle: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})},
	pAddToCollection: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})},
	pDelFromCollection: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})},
	pDelCollection: (radius) => {doPoke({'radius': radius}, () => console.log('onSucc'), ()=>{})},
	pReceiveInvite: (receiveInvite) => {doPoke({'receive-invite': {'receive-invite': receiveInvite}}, () => console.log('onSucc'), ()=>{})}, //?
	pDelReceiveShip: (id, ship) => {doPoke({'del-receive-ship': {'id': id, 'del-ships': [ship]}}, () => console.log('onSucc'), ()=>{})},
	pAddReceiveShip: (id, ship) => {doPoke({'add-receive-ship': {'id': id, 'add-ships': [ship]}}, () => console.log('onSucc'), ()=>{})},
	pEditMaxAccepted: (id, maxAccepted) => {doPoke({'edit-max-accepted': {'id': id, 'qty': maxAccepted}}, () => console.log('onSucc'), ()=>{})},
	pEditDesc: (id, desc) => {doPoke({'edit-desc': {'id': id, 'desc': desc}}, () => console.log('onSucc'), ()=>{})},
	pEditInviteLocation: (id, locationType) => {doPoke({'edit-invite-location': {'id': id, 'location-type': locationType}}, () => console.log('onSucc'), ()=>{})},
	pEditInvitePosition: (id, position) => {doPoke({'edit-invite-position': {'id': id, 'position': position}}, () => console.log('onSucc'), ()=>{})},
	pEditInviteAddress: (id, address) => {doPoke({'edit-invite-address': {'id': id, 'address': address}}, () => console.log('onSucc'), ()=>{})},
	pEditInviteAccessLink: (id, accessLink) => {doPoke({'edit-invite-access-link': {'id': id, 'access-link': '~.' + accessLink}}, () => console.log('onSucc'), ()=>{})},
	// pEditInviteAccessLink: (id, accessLink) => {doPoke({'edit-invite-access-link': {'id': id, 'access-link': accessLink}}, () => console.log('onSucc'), ()=>{})},
	pEditInviteRadius: (id, radius) => {doPoke({'edit-invite-radius': {'id': id, 'radius': '.' + radius}}, () => console.log('onSucc'), ()=>{})},
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
			console.log('all--------')
			console.log(all)
		if(Object.keys(all)[0] === 'initAll') {
			const settings = all.initAll.settings;
			console.log('settings--------x');
			console.log(settings);
			set(state => ({
				invites: all.initAll.invites.map(
				item => ({ 
				'id' : item.id,
				'invite': {
					initShip: item.invite.initShip,
					title: '',
					desc: item.invite.desc,
					radius: item.invite.inviteRadius.slice(1), 
					maxAccepted: item.invite.maxAccepted,
					position: properPosition(item.invite.invitePosition),
					address: item.invite.inviteAddress,
					locationType: item.invite.locationType, 
					accessLink: item.invite.accessLink.slice(2),
					receiveShips: item.invite.receiveShips.map(x => ({ship: x.ship, shipInvite: x.shipInvite})),
					hostStatus: item.invite.hostStatus
				}})),
				settings: {
					position: properPosition(settings.position),
					radius: settings.radius.slice(1),
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
			set(state => ({ invites: dedup('id', state.invites.concat({
				'id' : item.id,
				'invite': 
				{ hostStatus: item.invite.hostStatus,
					initShip: item.invite.initShip,
					desc: item.invite.desc, 
					radius: item.invite.inviteRadius.slice(1), 
					maxAccepted: item.invite.maxAccepted,
					locationType: item.invite.locationType,
					accessLink: item.invite.accessLink.slice(2),
					position: properPosition(item.invite.invitePosition),
					address: item.invite.inviteAddress,
					receiveShips: item.invite.receiveShips.map(x => ({ship: x.ship, shipInvite: x.shipInvite}))}}
			))}));
		}
		else if(Object.keys(all)[0] === 'updateSettings') {
			const settings = all.updateSettings.settings;
			set(state => ({
				settings: {
					position: properPosition(settings.position),
					radius: settings.radius.slice(1),
					address: settings.address,
					collections: settings.collections,
					banned: settings.banned.banned,
					receiveInvite: settings.receiveInvite,
				}
				}));
		}
	}),
}));
