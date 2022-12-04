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
			<div className="invitedetails-topbar">
				<button
					className="edit-return"
					onClick={() => {
						setInviteMode("view");
					}}
				>
					Return
				</button>
			</div>
			<div className="flexcol">
				<div className="edit-title flexcol">
					<span>Title</span>
					<input
						type="text"
						onChange={(e) => {
							setEditedInvite({ ...eInvite, title: e.currentTarget.value });
						}}
					/>
				</div>
				<div className="edit-desc flexcol">
					<span>Description</span>
					<textarea
						type="text"
						onChange={(e) => {
							setEditedInvite({ ...eInvite, desc: e.currentTarget.value });
						}}
					/>
				</div>
				<div className="edit-locationtype radio">
					<span> Location Type </span>
					<div>
						<input
							type="radio"
							name="locationtype"
							checked={eInvite["location-type"] === "meatspace"}
							// checked="checked"
							onChange={(e) => {
								setEditedInvite({ ...eInvite, "location-type": "meatspace" });
							}}
						/>
						<span> Meatspace </span>
					</div>
					<div>
						<input
							type="radio"
							name="locationtype"
							checked={eInvite["location-type"] === "virtual"}
							onChange={(e) => {
								setEditedInvite({ ...eInvite, "location-type": "virtual" });
							}}
						/>
						<span>Virtual</span>
					</div>
				</div>
				<div className="edit-accesslink flexcol">
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
				<div className="edit-rr flexrow">
					<div className="edit-rr-radius flexgrow flexcol">
						<span display="inline">Delivery radius</span>
						<input
							type="number"
							min="0"
							value={eInvite.radius?.slice(1)}
							onChange={(e) => {
								const re = /^[0-9\b]+$/;
								if (
									e.currentTarget.value === "" ||
									re.test(e.currentTarget.value)
								)
									setEditedInvite({
										...eInvite,
										radius:
											isNaN(parseInt(e.currentTarget.value)) ||
											e.currentTarget.value === null
												? null
												: "." + parseInt(e.currentTarget.value),
									});
							}}
						/>
					</div>

					<div className="edit-rr-rsvplimit flexgrow flexcol">
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
					originalState={eInvite}
					setState={setEditedInvite}
				/>
				<div className="edit-image flexcol">
					<span> Image link </span>
					<input
						type="text"
						onChange={(e) =>
							setEditedInvite({ ...eInvite, image: e.currentTarget.value })
						}
					/>
				</div>
				<div className="edit-date flexrow">
					<div className="edit-datebegin flexcol flexgrow">
						<span> Date Begin </span>
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
					<div className="edit-dateend flexcol flexgrow">
						<span> Date End </span>
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
				<div className="edit-excisecomets radio">
					<span> Excise Comets </span>
					<div>
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
						<span>Yes</span>
					</div>
					<div>
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
						<span>No</span>
					</div>
				</div>
				<div className="edit-enablechat radio">
					<span> Enable Chat </span>
					<div>
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
						<span>Yes</span>
					</div>
					<div>
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
						<span>No</span>
					</div>
				</div>
			</div>
			<button
				className="edit-save send"
				onClick={() => {
					alert.show(<div style={{ color: "green" }}>Edit Saved</div>);
					pEditInvite(eInvite);
				}}
			>
				Save
			</button>
		</div>
	);
};

export default Edit;
