import React, { Component, useState } from "react";
import { useStore } from "../data/store";
import { useAlert } from "react-alert";
import Location from "./Location";

const Edit = (props) => {
	const invites = useStore((state) => state.invites);
	const inviteDetails = useStore((state) => state.inviteDetails);
	const _invite = invites.filter((x) => x.id === inviteDetails)[0];
	const invite = _invite.invite;
	const pEditInvite = useStore((state) => state.pEditInvite);
	const setInviteMode = useStore((state) => state.setInviteMode);
	const [eInvite, setEditedInvite] = useState({
		id: _invite.id,
		title: invite.title,
		desc: invite.desc,
		"location-type": invite.locationType,
		position: invite.position,
		address: invite.address,
		"access-link": invite.address,
		"rsvp-limit": invite.rsvpLimit,
		radius: invite.radius,
		image: "",
		date: invite.date,
		"earth-link": invite.earthLink,
		"excise-comets": invite.exciseComets,
		"enable-chat": invite.enableChat,
	});
	const alert = useAlert();
	console.log(eInvite);
	return (
		<div className="edit">
			<button
				className="edit-return"
				onClick={() => {
					setInviteMode("view");
				}}
			>
				Return
			</button>
			<input
				className="edit-title"
				type="text"
				onChange={(e) => {
					setEditedInvite({ ...eInvite, title: e.currentTarget.value });
				}}
			/>
			<textarea
				className="edit-desc"
				type="text"
				onChange={(e) => {
					setEditedInvite({ ...eInvite, desc: e.currentTarget.value });
				}}
			/>
			<div className="edit-locationtype">
				Meatspace
				<input
					type="radio"
					name="locationtype"
					checked={eInvite["location-type"] === "meatspace"}
					// checked="checked"
					onChange={(e) => {
						setEditedInvite({ ...eInvite, "location-type": "meatspace" });
					}}
				/>
				Virtual
				<input
					type="radio"
					name="locationtype"
					checked={eInvite["location-type"] === "virtual"}
					onChange={(e) => {
						setEditedInvite({ ...eInvite, "location-type": "virtual" });
					}}
				/>
			</div>
			<div className="edit-accesslink">
				<span>Access link</span>
				<input
					type="text"
					onChange={(e) => {
						setEditedInvite({
							...eInvite,
							"access-link": String(e.currentTarget.value),
						});
					}}
				/>
			</div>
			<div className="edit-rr">
				<div className="edit-rr-radius">
					<span display="inline">Delivery radius</span>
					<input
						type="text"
						value={eInvite.radius.slice(1)}
						onChange={(e) => {
							const re = /^[0-9\b]+$/;
							if (
								e.currentTarget.value === "" ||
								re.test(e.currentTarget.value)
							)
								setEditedInvite({
									...eInvite,
									radius: "." + String(e.currentTarget.value),
								});
						}}
					/>
				</div>

				<div className="edit-rr-rsvplimit">
					<span>Limit # of RSVPs accepted</span>
					<input
						value={eInvite["rsvp-limit"]}
						onChange={(e) => {
							const re = /^[0-9\b]+$/;
							if (
								e.currentTarget.value === "" ||
								re.test(e.currentTarget.value)
							)
								setEditedInvite({
									...eInvite,
									"rsvp-limit": e.currentTarget.value,
								});
						}}
					/>
				</div>
			</div>
			<Location
				address={eInvite.address}
				position={eInvite.position}
				setAddress={(address) => setEditedInvite({ ...eInvite, address })}
				setPosition={(position) => setEditedInvite({ ...eInvite, position })}
			/>
			<div className="edit-ise">
				Image link
				<div className="edit-ise-image">
					<input
						type="text"
						onChange={(e) =>
							setEditedInvite({ ...eInvite, image: e.currentTarget.value })
						}
					/>
				</div>
				{/* TODO fix dates */}
				<div className="edit-ise-datebegin">
					<input
						type="date"
						onChange={(e) =>
							setEditedInvite({
								...eInvite,
								date: {
									begin: new Date(e.currentTarget.value).toUTCString(),
									end: eInvite.date.end,
								},
							})
						}
					/>
				</div>
				<div className="edit-ise-dateend">
					<input
						type="date"
						onChange={(e) =>
							setEditedInvite({
								...eInvite,
								date: {
									begin: eInvite.date.begin,
									end: new Date(e.currentTarget.value).toUTCString(),
								},
							})
						}
					/>
				</div>
			</div>
			Excise Comets
			<input
				type="radio"
				name="advanced-excisecomets"
				checked={eInvite["excise-comets"] === true}
				onChange={() => {
					setEditedInvite({
						...eInvite,
						"excise-comets": true,
					});
				}}
			/>
			<input
				type="radio"
				name="advanced-excisecomets"
				checked={eInvite["excise-comets"] === false}
				onChange={() => {
					setEditedInvite({
						...eInvite,
						"excise-comets": false,
					});
				}}
			/>
			Enable Chat Yes
			<input
				type="radio"
				name="advanced-enablechat"
				checked={eInvite["enable-chat"] === true}
				onChange={() => {
					setEditedInvite({
						...eInvite,
						"enable-chat": true,
					});
				}}
			/>
			No
			<input
				type="radio"
				name="advanced-enablechat"
				checked={eInvite["enable-chat"] === false}
				onChange={() => {
					setEditedInvite({
						...eInvite,
						"enable-chat": false,
					});
				}}
			/>
			<button
				className="edit-save"
				onClick={() => {
					alert.show(<div style={{ color: "green" }}>Invite Sent</div>);
					pEditInvite(eInvite);
				}}
			>
				Save
			</button>
		</div>
	);
};

export default Edit;
