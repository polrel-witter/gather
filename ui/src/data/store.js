import { createStore } from 'zustand';
import create from 'zustand';

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
	/*  GATHERING */
	/*  STATUS */
	/*  SETTINGS */
	setStatusNote: (statusNote) => set(state => ({ settings: {...state.settings, statusNote}})),
	// TODO enforce radius to be a number
	setRadius: (radius) => set(state => ({ settings: {...state.settings, radius}})),
	addGangMember: (radius) => set(state => ({ settings: {...state.settings, radius}})),
	pauseGangMember: (radius) => set(state => ({ settings: {...state.settings, radius}})),
	removeGangMember: (radius) => set(state => ({ settings: {...state.settings, radius}})),
	ghostShip: (radius) => set(state => ({ settings: {...state.settings, radius}})),
	unGhostShip: (radius) => set(state => ({ settings: {...state.settings, radius}})),
}));
