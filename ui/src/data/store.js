import { createStore } from 'zustand';
import create from 'zustand';
import { doPoke } from '../utils';

export const useStore = create((set) => ({
	/* FRONTEND ONLY STATE 
	 *
	 */
	/* possible values for route: 
		 invites, draft, settings
	*/
	route: "invites",
	/* all, hosting, received */
	inviteRoute: "all",
	/* default, started, finalized */
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
			title: "Huge Party!!4",
			receivedShips: [
				{ _ship: "polrel-witter", inviteStatus: "pending", group: "" },
				{ _ship: "sampel-palnet", inviteStatus: "pending", group: "zod/testgroup" },
			],
			maxAccepted: 10,
			radius: 0,
			note: "Having a Huge party tonight!",
			address: "244 Andrew drive",
			locationType: "meatspace",
			accessLink: "https://developers.urbit.org",
			hostStatus: "sent"
		},
		{
			id: '456',
			title: "Huge Party!!4",
			initShip: "polrel-witter",
			receivedShips: [
				{ _ship: "pontus-fadpun", inviteStatus: "pending", group: "" },
			],
			maxAccepted: 10,
			radius: 10,
			note: "Having a Huge party tonight!",
			address: "111 Mulholland Drive",
			locationType: "meatspace",
			accessLink: "https://developers.urbit.org",
			hostStatus: "finalized"
		},
		{
			id: '789',
			title: "Huge Party!!4",
			initShip: "sampel-palnet",
			receivedShips: [
				{ _ship: "pontus-fadpun", inviteStatus: "accepted", group: "" },
			],
			maxAccepted: 10,
			radius: 30,
			note: "Having a Huge party tonight!",
			locationType: "virtual",
			accessLink: "https://developers.urbit.org",
			address: "",
			hostStatus: "completed"
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
