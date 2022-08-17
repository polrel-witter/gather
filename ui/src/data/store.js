import { createStore } from 'zustand';
import create from 'zustand';
import { doPoke } from '../utils';

export const useStore = create((set) => ({
	/* FRONTEND ONLY STATE 
	 *
	 */
	/* possible values for route: 
		 gather-init, gather-received,
		 status-gang, status-foreign,
		 settings */
	route: "status-gang",
	/* default, started, finalized */
	statusState: "on",
	/* STATE
	 *
	 */
	ships: [
		{
			_ship: "polrel-witter",
			position: { lat: 111, lon: 123 },
			radius: 50,
			address: { street: "street", city: "Miami", state: "Florida", country: "USA", zip: "11111" }, 
			statusActive: false,
			gatherActive: false,
			statusNote: "I'm over 9000!",
			paused: false,
			ourGang: true,
			theirGang: true,
			weGhosted: true,
			theyGhosted: false
		},
		{
			_ship: "sampel-palnet",
			position: { lat: 111, lon: 123 },
			radius: 50,
			address: "Just a string for now",
			statusActive: false,
			gatherActive: false,
			statusNote: "I'm a sample!",
			paused: false,
			ourGang: false,
			theirGang: true,
			weGhosted: true,
			theyGhosted: false
		}
	],
	invites: [
		{
			id: '123',
			initShip: "pontus-fadpun",
			receivedShips: [
				{ _ship: "polrel-witter", inviteStatus: "pending", group: "" },
				{ _ship: "sampel-palnet", inviteStatus: "pending", group: "zod/testgroup" },
			],
			maxAccepted: 10,
			note: "Having a Huge party tonight!",
			finalized: false
		},
		{
			id: '456',
			initShip: "polrel-witter",
			receivedShips: [
				{ _ship: "pontus-fadpun", inviteStatus: "pending", group: "" },
			],
			maxAccepted: 10,
			note: "Having a Huge party tonight!",
			finalized: false
		},
		{
			initShip: "sampel-palnet",
			receivedShips: [
				{ _ship: "pontus-fadpun", inviteStatus: "accepted", group: "" },
			],
			maxAccepted: 10,
			note: "Having a Huge party tonight!",
			finalized: false
		}
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
	/*  GATHERING  */
	pEditInvite: (action, id) => console.log(action, id),
	pSendInvite: (myInvite) => console.log(''),
	pAccept: (id) => console.log(id),
	pDeny: (id) => console.log(id),
	/*  STATUS  */
	pShareStatus: (sendTo) => console.log(sendTo),
	pGhost: (ship) => console.log(ship),
	//
	//
	//
	//
	// QUESTIONS
	// No marks
	// pShareStatus: send only one @p, not a list?
	// pSendInvite: why do we need sendTo?
	// pShareStatus: share exist, where is unGang? unshare gang membership needed? what 		about pausing?
	// pGhostShip: how to unGhost?
	// How can I edit an invite after sending?
	// (GangMember) pause ship? 
	// (GangMember) what should happen when kicking someone out?
	// TODO
	// proper maps/address functionality (Location)
	// unShare gang (GangMembers)
	// unGhost (GhostedShips)
	// gather-init state should depend on myInvite state
	// ability to dm the inviter from message
	// status on-off should be function of status-active setting
	// 
	// styling
}));
