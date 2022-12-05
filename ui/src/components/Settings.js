import React, { useState, useEffect } from "react";
import { Icon } from "@tlon/indigo-react";
import { useStore } from "../data/store";
import Location from "./Location";
import { patpValidate } from "../utils";
import { useAlert } from "react-alert";
import Alert from "./Alert";

const Banned = () => {
	const banned = useStore((state) => state.settings.banned);
	// const banned = [];
	const pUnban = useStore((state) => state.pUnban);
	const pBan = useStore((state) => state.pBan);
	const [banSearch, setBanSearch] = useState("");
	const _alert = useAlert();
	const redAlert = (str) => _alert.show(<Alert str={str} color={"red"} />);
	const greenAlert = (str) => _alert.show(<Alert str={str} color={"green"} />);
	return (
		<div className="settings-banned">
			<span>Banned Ships</span>
			<div className="flexrow">
				<input
					className="flexgrow"
					type="text"
					value={banSearch}
					placeholder={'~{ship}'}
					onChange={(e) => {
						setBanSearch(e.currentTarget.value);
					}}
				/>
				<button
					className="button"
					onClick={() => {
						if (banSearch === ('~' + window.urbit.ship)) {
							redAlert("You can't ban yourself!");
						}
						else if(!patpValidate(banSearch))
							redAlert("Invalid @p!");
						else {
							pBan(banSearch);
							greenAlert(
								"You will no longer send or receive invites to/from this ship"
							);
						}
					}}
				>
					Ban
				</button>
			</div>
			<div className="list">
				{banned.length !== 0 &&
					banned.map((ship) => (
						<div className="onetoleft">
							<div>{ship}</div>
							<button
								className="button"
								onClick={() => {
									pUnban(ship);
									greenAlert(
										"You are now open to sending and receiving invites to/from this ship"
									);
								}}
							>
								Unban
							</button>
						</div>
					))}
			</div>
		</div>
	);
};

const Settings = () => {
	const settings = useStore((state) => state.settings);
	const pEditSettings = useStore((state) => state.pEditSettings);
	const _alert = useAlert();
	const redAlert = (str) => _alert.show(<Alert str={str} color={"red"} />);
	const greenAlert = (str) => _alert.show(<Alert str={str} color={"green"} />);
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
		setNewSettings({
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
			},
		});
	}, [settings]);

	const catalog = newSettings.catalog;
	return (
		<div>
			<div className="settings-radius flexcol">
				<span>My Radius (km)</span>
				<input
					type="number"
					min="0"
					value={newSettings.radius?.slice(1)}
					onChange={(e) => {
						setNewSettings({
							...newSettings,
							radius:
								isNaN(parseInt(e.currentTarget.value)) ||
								e.currentTarget.value === null
									? null
									: "." + parseInt(e.currentTarget.value),
						});
					}}
				/>
			</div>
			<Location
				address={settings.address}
				position={settings.position}
				originalState={newSettings}
				setState={setNewSettings}
			/>
			<Banned />
			<div className="divider">Location filtering</div>
			<div className="settings-receiveinvite radio">
				<span>Receive invites from</span>
				<div>
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
					<span>Anyone</span>
				</div>
				<div>
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
					<span>Only In Radius</span>
				</div>
			</div>
			<div className="divider"> Notifications</div>
			<div className="settings-notifications">
				<div className="radio">
					<span>Notify me when I receive new invites</span>
					<div>
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
						<span>Yes</span>
					</div>
					<div>
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
						<span>No</span>
					</div>
				</div>
				<div className="radio">
					<span>
						Notify me when a host updates an invite to which I'm RSVPd
					</span>
					<div>
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
						<span>Yes</span>
					</div>
					<div>
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
						<span>No</span>
					</div>
				</div>
			</div>
			<div className="divider">Advanced host options</div>
			<div className="settings-advanced">
				<div className="radio">
					<span>Excise Comets</span>
					<div>
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
						<span>Yes</span>
					</div>
					<div>
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
						<span>No</span>
					</div>
				</div>
				<div className="radio">
					<span>Enable Chat</span>
					<div>
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
						<span>Yes</span>
					</div>
					<div>
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
						<span>No</span>
					</div>
				</div>
				<div className="radio">
					<span>RSVP limit can be seen by</span>
					<div>
						<input
							type="radio"
							name="advanced-rsvplimit"
							checked={newSettings.catalog["rsvp-limit"] === "host-only"}
							onChange={() => {
								setNewSettings({
									...newSettings,
									catalog: {
										...newSettings.catalog,
										"rsvp-limit": "host-only",
									},
								});
							}}
						/>
						<span>Host Only</span>
					</div>
					<div>
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
						<span>Anyone</span>
					</div>
				</div>
				<div className="radio">
					<span>RSVP count can be seen by</span>
					<div>
						<input
							type="radio"
							name="advanced-rsvpcount"
							checked={newSettings.catalog["rsvp-count"] === "host-only"}
							onChange={() => {
								setNewSettings({
									...newSettings,
									catalog: {
										...newSettings.catalog,
										"rsvp-count": "host-only",
									},
								});
							}}
						/>
						<span>Host Only</span>
					</div>
					<div>
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
						<span>Anyone</span>
					</div>
				</div>
				<div className="radio">
					<span>Access link can be seen by</span>
					<div>
						<input
							type="radio"
							name="advanced-accesslink"
							checked={newSettings.catalog["access-link"] === "rsvp-only"}
							onChange={() => {
								setNewSettings({
									...newSettings,
									catalog: {
										...newSettings.catalog,
										"access-link": "rsvp-only",
									},
								});
							}}
						/>
						<span>RSVP Only</span>
					</div>
					<div>
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
						<span>Anyone</span>
					</div>
				</div>
				<div className="radio">
					<span>Chat Access can be seen by</span>
					<div>
						<input
							type="radio"
							name="advanced-chataccess"
							checked={newSettings.catalog["chat-access"] === "rsvp-only"}
							onChange={() => {
								setNewSettings({
									...newSettings,
									catalog: {
										...newSettings.catalog,
										"chat-access": "rsvp-only",
									},
								});
							}}
						/>
						<span>RSVP Only</span>
					</div>
					<div>
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
						<span>Anyone</span>
					</div>
				</div>
				<div className="radio">
					<span>Invite list can be seen by</span>
					<div>
						<input
							type="radio"
							name="advanced-invitelist"
							checked={newSettings.catalog["invite-list"] === "host-only"}
							onChange={() => {
								setNewSettings({
									...newSettings,
									catalog: {
										...newSettings.catalog,
										"invite-list": "host-only",
									},
								});
							}}
						/>
						<span>Host Only</span>
					</div>
					<div>
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
						<span>Anyone</span>
					</div>
				</div>
				<div className="radio">
					<span>RSVP list can be seen by</span>
					<div>
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
						<span>Host Only</span>
					</div>
					<div>
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
						<span>RSVP Only</span>
					</div>
					<div>
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
						<span>Anyone</span>
					</div>
				</div>
			</div>
			<div className="settings-save">
				<button
					className="send"
					onClick={() => {
						console.log(newSettings);
						pEditSettings(newSettings);
						greenAlert("Settings Saved");
					}}
				>
					Save
				</button>
			</div>
		</div>
	);
};

export default Settings;
