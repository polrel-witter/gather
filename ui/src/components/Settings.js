import React, { useState, useEffect } from "react";
import { Icon } from "@tlon/indigo-react";
import { useStore } from "../data/store";
import Location from "./Location";
import { patpValidate } from "../utils";
import { useAlert } from "react-alert";

const Banned = () => {
	const banned = useStore((state) => state.settings.banned);
	// const banned = [];
	const pUnban = useStore((state) => state.pUnban);
	const pBan = useStore((state) => state.pBan);
	const [banSearch, setBanSearch] = useState("");
	const alert = useAlert();
	return (
		<div className="settings-banned">
			<span>
				Banned Ships
			</span>
			<div>
				<input
					type="text"
					value={banSearch}
					onChange={(e) => {
						setBanSearch(e.currentTarget.value);
					}}
				/>
				<button
					onClick={() => {
						if (patpValidate(banSearch)) pBan(banSearch);
						alert.show(
							"You will no longer send or receive invites to/from this ship"
						);
					}}
				>
					Ban
				</button>
			</div>
			{banned.length !== 0 &&
				banned.map((ship) => (
					<div>
						<div>{ship}</div>
						<button
							onClick={() => {
								pUnban(ship);
								alert.show(
									"You are now open to sending and receiving invites to/from this ship"
								);
							}}
						>
							Unban
						</button>
					</div>
				))}
		</div>
	);
};

const Settings = () => {
	const settings = useStore((state) => state.settings);
	const pEditSettings = useStore((state) => state.pEditSettings);
	const [newSettings, setNewSettings] = useState({
		address: settings.address,
		position: settings.position,
		radius: settings.radius,
		"receive-invite": settings.receiveInvite,
		notifications: {
			"new-invites": settings.notifications.newInvites,
			"invite-updates": settings.notifications.inviteUpdates,
		},
		"excise-comets": true,
		"enable-chat": true,
		catalog: {
			"invite-list": "anyone",
			"access-link": "anyone",
			"rsvp-limit": "anyone",
			"chat-access": "anyone",
			"rsvp-count": "anyone",
			"rsvp-list": "anyone",
		},
	});
	console.log(newSettings);
	useEffect(() => {
		setNewSettings(
		{
		address: settings.address,
		position: settings.position,
		radius: settings.radius,
		"receive-invite": settings.receiveInvite,
		notifications: {
			"new-invites": settings.notifications.newInvites,
			"invite-updates": settings.notifications.inviteUpdates,
		},
		"excise-comets": settings.exciseComets,
		"enable-chat": settings.enableChat,
		catalog: {
			"invite-list": settings.catalog.inviteList,
			"access-link": settings.catalog.accessLink,
			"rsvp-limit": settings.catalog.rsvpLimit,
			"chat-access": settings.catalog.chatAccess,
			"rsvp-count": settings.catalog.rsvpCount,
			"rsvp-list": settings.catalog.rsvpList,
		}
		}
		)
	}, [settings]);

	const catalog = newSettings.catalog;
	return (
		<div>
			<div className="settings-radius">
				My Radius
				<input
					type="number"
					value={newSettings.radius}
					onChange={(e) => {
						const re = /^[0-9\b]+$/;
						// if (e.currentTarget.value === "" || re.test(e.currentTarget.value))
							setNewSettings({
								...newSettings,
								radius: "." + parseInt(e.currentTarget.value),
							});
					}}
				/>
			</div>
			<Location
				address={settings.address}
				position={settings.position}
				setAddress={(address) => setNewSettings({ ...newSettings, address })}
				setPosition={(position) => setNewSettings({ ...newSettings, position })}
			/>
			<Banned />
			<div className="settings-receiveinvite">
				<span>
					Receive invites from
				</span>
				Anyone
				<input
					type="radio"
					checked={newSettings["receive-invite"] === "anyone"}
					name="receiveinvite"
					onChange={() => {
						setNewSettings({
							...newSettings,
							"receive-invite": "anyone",
						});
					}}
				/>
				Only In Radius
				<input
					type="radio"
					name="receiveinvite"
					checked={newSettings["receive-invite"] === "only-in-radius"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							"receive-invite": "only-in-radius",
						});
					}}
				/>
			</div>
			<div className="settings-notifications">
				<span>Notifications</span>
				Yes
				<input
					type="radio"
					name="notify-newinvites"
					checked={newSettings.notifications["new-invites"] === true}
					onChange={() => {
						setNewSettings({
							...newSettings,
							notifications: {
								...newSettings.notifications,
								"new-invites": true,
							},
						});
					}}
				/>
				No
				<input
					type="radio"
					name="notify-newinvites"
					checked={newSettings.notifications["new-invites"] === false}
					onChange={() => {
						setNewSettings({
							...newSettings,
							notifications: {
								...newSettings.notifications,
								"new-invites": false,
							},
						});
					}}
				/>
				<br />
				Yes
				<input
					type="radio"
					name="notify-inviteupdates"
					checked={newSettings.notifications["invite-updates"] === true}
					onChange={() => {
						setNewSettings({
							...newSettings,
							notifications: {
								...newSettings.notifications,
								"invite-updates": true,
							},
						});
					}}
				/>
				No
				<input
					type="radio"
					name="notify-inviteupdates"
					checked={newSettings.notifications["invite-updates"] === false}
					onChange={() => {
						setNewSettings({
							...newSettings,
							notifications: {
								...newSettings.notifications,
								"invite-updates": false,
							},
						});
					}}
				/>
			</div>
			<div className="settings-advanced">
				<span>Advanced host options</span>
				Excise Comets
				<input
					type="radio"
					name="advanced-excisecomets"
					checked={newSettings["excise-comets"] === true}
					onChange={() => {
						setNewSettings({
							...newSettings,
							"excise-comets": true,
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-excisecomets"
					checked={newSettings["excise-comets"] === false}
					onChange={() => {
						setNewSettings({
							...newSettings,
							"excise-comets": false,
						});
					}}
				/>
				Enable Chat Yes
				<input
					type="radio"
					name="advanced-enablechat"
					checked={newSettings["enable-chat"] === true}
					onChange={() => {
						setNewSettings({
							...newSettings,
							"enable-chat": true,
						});
					}}
				/>
				No
				<input
					type="radio"
					name="advanced-enablechat"
					checked={newSettings["enable-chat"] === false}
					onChange={() => {
						setNewSettings({
							...newSettings,
							"enable-chat": false,
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-rsvplimit"
					checked={newSettings.catalog["rsvp-limit"] === "host-only"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "rsvp-limit": "host-only" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-rsvplimit"
					checked={newSettings.catalog["rsvp-limit"] === "anyone"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "rsvp-limit": "anyone" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-rsvpcount"
					checked={newSettings.catalog["rsvp-count"] === "host-only"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "rsvp-count": "host-only" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-rsvpcount"
					checked={newSettings.catalog["rsvp-count"] === "anyone"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "rsvp-count": "anyone" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-accesslink"
					checked={newSettings.catalog["access-link"] === "rsvp-only"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "access-link": "rsvp-only" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-accesslink"
					checked={newSettings.catalog["access-link"] === "anyone"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "access-link": "anyone" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-chataccess"
					checked={newSettings.catalog["chat-access"] === "rsvp-only"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "chat-access": "rsvp-only" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-chataccess"
					checked={newSettings.catalog["chat-access"] === "anyone"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "chat-access": "anyone" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-invitelist"
					checked={newSettings.catalog["invite-list"] === "host-only"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "invite-list": "host-only" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-invitelist"
					checked={newSettings.catalog["invite-list"] === "anyone"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "invite-list": "anyone" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-rsvplist"
					checked={newSettings.catalog["rsvp-list"] === "host-only"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "rsvp-list": "host-only" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-rsvplist"
					checked={newSettings.catalog["rsvp-list"] === "rsvp-only"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "rsvp-list": "rsvp-only" },
						});
					}}
				/>
				<input
					type="radio"
					name="advanced-rsvplist"
					checked={newSettings.catalog["rsvp-list"] === "anyone"}
					onChange={() => {
						setNewSettings({
							...newSettings,
							catalog: { ...newSettings.catalog, "rsvp-list": "anyone" },
						});
					}}
				/>
			</div>
			<div className="settings-save">
				<button
					onClick={() => {
						console.log(newSettings);
						pEditSettings(newSettings);
					}}
				>
					Save
				</button>
			</div>
		</div>
	);
};

export default Settings;
