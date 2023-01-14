import create from "zustand";
import {
	doPoke,
	subscribe,
	dedup,
	properPosition,
	unit,
	chat,
	notifications,
	unixToDa,
	daToUnix,
	dateToDa,
	IDinInvites,
} from "../utils";
import _ from "lodash";

export const useStore = create((set) => ({
	/* FRONTEND ONLY STATE
	 *
	 */
	/* possible values for route: 
		 invites, draft, settings
	*/
	route: "draft",

	/* sorting inside invites tab */
	invitesMode: "hosting-open",
	/* view, edit, chat */
	inviteMode: "view",

	inviteDetails: "",
	setRoute: (route) =>
		set((state) => {
			if (state.inviteDetails !== '' && route === 'invites')
				window.history.replaceState(
				null,
				"New Page Title",
				"/apps/gather/" + route + '/' + state.inviteDetails
			);
			else
			window.history.replaceState(
				null,
				"New Page Title",
				"/apps/gather/" + route
			);

			return { route: route };
		}),
	focusInvite: (id) => {
		set((state) => {
		if ( id === '')
			window.history.replaceState(
				null,
				"New Page Title",
				"/apps/gather/" + state.route
			);
			else
		window.history.replaceState(
			null,
			"New Page Title",
			"/apps/gather/invite/" + id
		);
			return ({ inviteDetails: id })});
	},
	setInvitesMode: (mode) => set((state) => ({ invitesMode: mode })),
	setInviteMode: (mode) => set((state) => ({ inviteMode: mode })),
	draftInvite: {
		"send-to": [],
		"location-type": "meatspace",
		position: null,
		address: "",
		"access-link": "",
		radius: null,
		"rsvp-limit": null,
		desc: "",
		title: "",
		image: "",
		date: { begin: null, end: null },
		access: "private",
		"earth-link": "",
		// TODO fix excise-comets and enable-chat
		"excise-comets": true,
		"enable-chat": true,
	},
	setDraftInvite: (invite) => set((state) => ({ draftInvite: invite })),

	/*  STATE  */

	invites: [],
	settings: {},

	/*  ACTIONS  */

	pGatheringReminder: (data) => {
		doPoke({ "gathering-reminder": data });
	},
	pEditSettings: (data) => {
		doPoke({ "edit-settings": data });
	},
	pCreateCollection: (collection) => {
		set((state) => ({ collectionWaiting: true }));
		doPoke({ "create-collection": collection });
	},
	pEditCollection: (collection) => {
		const formattedCollection = {
			id: collection.id,
			collection: {
				members: collection.members,
				resource: collection.resource,
				selected: collection.selected,
				title: collection.title,
			},
		};
		set((state) => ({
			settings: {
				...state.settings,
				collections: state.settings.collections
					.filter((x) => x.id !== collection.id)
					.concat([formattedCollection]),
			},
		}));
		doPoke({ "edit-collection": collection });
	},
	pDeleteCollection: (id) => {
		set((state) => ({
			settings: {
				...state.settings,
				collections: state.settings.collections.filter((x) => x.id !== id),
			},
		}));
		doPoke({ "del-collection": { id: id } });
	},
	pDelInvite: (data) => {
		doPoke({ "del-invite": data });
	},
	pAltHostStatus: (data) => {
		doPoke({ "alt-host-status": data });
	},
	pInviteShips: (data) => {
		doPoke({ "invite-ships": data });
	},
	pUnInviteShips: (data) => {
		doPoke({ "uninvite-ships": data });
	},
	pEditInvite: (data) => {
		doPoke({ "edit-invite": { ...data, "earth-link": "" } });
		doPoke({ "edit-invite": data });
	},
	pNewInvite: (data) => {
		doPoke({ "new-invite": data });
	},
	pAdd: (data) => {
		doPoke({ add: data });
	},
	pRSVP: (data) => {
		doPoke({ rsvp: data });
	},
	pUnRSVP: (data) => {
		doPoke({ unrsvp: data });
	},
	// pSubRSVP: (data) => {},
	// pSubInvite: (data) => {},
	pPost: (data) => {
		doPoke({ post: data });
	},
	pBan: (ship) => {
		// set((state) => ({
		// 	settings: {
		// 		...state.settings,
		// 		banned: state.settings.banned.concat([ship]),
		// 	},
		// }));
		doPoke({ ban: { ship: ship } });
	},
	pUnban: (ship) => {
		// set((state) => ({
		// 	settings: {
		// 		...state.settings,
		// 		banned: state.settings.banned.filter((x) => x !== ship),
		// 	},
		// }));
		doPoke({ unban: { ship: ship } });
	},

	/*  SUBSCRIPTIONS  */

	sAll: (handler) => {
		subscribe("/all", (all) => {
			console.log(all);
			if (Object.keys(all)[0] === "initAll") {
				const settings = all.initAll.settings;
				set((state) => {
					const idInUrl = IDinInvites(all.initAll.invites);
					console.log(idInUrl);
					if (!idInUrl)
						window.history.replaceState(
							null,
							"New Page Title",
							"/apps/gather/draft"
						);
					else
						window.history.replaceState(
							null,
							"New Page Title",
							"/apps/gather/invites/" + idInUrl
						);

					return {
						route: idInUrl !== undefined ? 'invites' : "draft",
						inviteDetails: idInUrl !== undefined ? idInUrl : "",
						invites: all.initAll.invites.map((item) => {
							// if (idInUrl !== '') {
							// 	state.setRoute('invites');
							// 	state.focusInvite(idInUrl);
							// }
							// else {
							// 	state.setRoute('draft');
							// 	state.focusInvite('');
							// }
							return {
								id: item.id,
								guestStatus: unit(item.guestStatus),
								invite: {
									initShip: item.invite.initShip,
									desc: item.invite.desc,
									guestList: item.invite.guestList.map((x) => ({
										ship: x.ship,
										shipInvite: x.shipInvite,
									})),
									locationType: item.invite.locationType,
									position: unit(item.invite.position),
									address: item.invite.address,
									accessLink: unit(item.invite.accessLink),
									radius: unit(item.invite.radius),
									rsvpLimit: unit(item.invite.rsvpLimit),
									rsvpCount: unit(item.invite.rsvpCount),
									hostStatus: item.invite.hostStatus,
									title: item.invite.title,
									date: {
										begin: unit(item.invite.date.begin),
										end: unit(item.invite.date.end),
									},
									lastUpdated: item.invite.lastUpdated,
									access: item.invite.access,
									marsLink: unit(item.invite.marsLink),
									earthLink: unit(item.invite.earthLink),
									exciseComets: unit(item.invite.exciseComets),
									chat: unit(item.invite.chat),
									catalog: unit(item.invite.catalog),
									enableChat: item.invite.enableChat,
									image: item.invite.image,
								},
							};
						}),
						settings: {
							position: unit(settings.position),
							radius: unit(settings.radius),
							address: settings.address,
							collections: settings.collections,
							banned: settings.banned.banned,
							receiveInvite: settings.receiveInvite,
							reminders: settings.reminders,
							notifications: settings.notifications,
							exciseComets: unit(settings.exciseComets),
							catalog: unit(settings.catalog),
							enableChat: settings.enableChat,
						},
					};
				});
			} else if (Object.keys(all)[0] === "updateInvite") {
				const item = all.updateInvite.invite;
				set((state) => ({
					invites: dedup(
						"id",
						state.invites.concat({
							id: all.updateInvite.id,
							guestStatus: unit(all.updateInvite.guestStatus),
							invite: {
								initShip: item.initShip,
								desc: item.desc,
								guestList: item.guestList.map((x) => ({
									ship: x.ship,
									shipInvite: unit(x.shipInvite),
								})),
								locationType: item.locationType,
								position: unit(item.position),
								address: item.address,
								accessLink: unit(item.accessLink),
								radius: unit(item.radius),
								rsvpLimit: unit(item.rsvpLimit),
								rsvpCount: unit(item.rsvpCount),
								hostStatus: item.hostStatus,
								title: item.title,
								date: {
									begin: unit(item.date.begin),
									end: unit(item.date.end),
								},
								lastUpdated: item.lastUpdated,
								access: item.access,
								marsLink: unit(item.marsLink),
								earthLink: unit(item.earthLink),
								exciseComets: unit(item.exciseComets),
								chat: unit(item.chat),
								catalog: unit(item.catalog),
								enableChat: item.enableChat,
								image: item.image,
							},
						})
					),
				}));
			} else if (Object.keys(all)[0] === "updateSettings") {
				const settings = all.updateSettings.settings;
				set((state) => ({
					collectionWaiting: false,
					settings: {
						position: unit(settings.position),
						radius: unit(settings.radius),
						address: settings.address,
						collections: settings.collections,
						banned: settings.banned.banned,
						receiveInvite: settings.receiveInvite,
						reminders: settings.reminders,
						notifications: settings.notifications,
						exciseComets: unit(settings.exciseComets),
						catalog: unit(settings.catalog),
						enableChat: settings.enableChat,
					},
				}));
			}
		});
	},
}));
