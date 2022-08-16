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
	route: "status-foreign",
	/* default, started, finalized */
	inviteState: "default",
	statusState: "on",
	/* STATE
	 *
	 */
	ships: [
		{
			_ship: "polrel-witter",
			position: { lat: 111, lon: 123 },
			radius: 50,
			address: "Just a string for now",
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
			initShip: "pontus-fadpun",
			receivedShips: [
				{ _ship: "polrel-witter", inviteStatus: "pending", group: "" },
				{ _ship: "sampel-palnet", inviteStatus: "pending", group: "zod/testgroup" },
			],
			maxAccepted: 10,
			inviteNote: "Having a Huge party tonight!",
			finalized: false
		},
		{
			initShip: "polrel-witter",
			receivedShips: [
				{ _ship: "pontus-fadpun", inviteStatus: "pending", group: "" },
			],
			maxAccepted: 10,
			inviteNote: "Having a Huge party tonight!",
			finalized: false
		},
		{
			initShip: "sampel-palnet",
			receivedShips: [
				{ _ship: "pontus-fadpun", inviteStatus: "accepted", group: "" },
			],
			maxAccepted: 10,
			inviteNote: "Having a Huge party tonight!",
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
	// why send-to, aren't all invites in =invite ?
	pSendInvite: (id, sendTo, invite) => console.log(invite),
	pAccept: (id) => console.log(id),
	pDeny: (id) => console.log(id),
	/*  STATUS  */
	// maybe it should be one @p for sharing status
	pShareStatus: (sendTo) => console.log(sendTo),
}));
