import React, { Component, useState } from "react";
import { useStore } from "../data/store";
import { useAlert } from "react-alert";
import { getBaseURL } from "../utils";
import Location from "./Location";
import moment from "moment";

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
		"access-link": invite.accessLink,
		"rsvp-limit": invite.rsvpLimit,
		radius: invite.radius,
		image: invite.image,
		date: invite.date,
		"earth-link": invite.earthLink,
		"excise-comets": invite.exciseComets,
		"enable-chat": invite.enableChat,
	});
	const alert = useAlert();
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
						value={eInvite.title}
						onChange={(e) => {
							setEditedInvite({ ...eInvite, title: e.currentTarget.value });
						}}
					/>
				</div>
				<div className="edit-desc flexcol">
					<span>Description</span>
					<textarea
						type="text"
						value={eInvite.desc}
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
						value={eInvite["access-link"]}
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
						<span display="inline">Delivery radius (km)</span>
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
						value={eInvite.image}
						onChange={(e) =>
							setEditedInvite({ ...eInvite, image: e.currentTarget.value })
						}
					/>
				</div>
				<div className="edit-date flexrow">
					<div className="edit-datebegin flexcol flexgrow">
						<span> Date Begin </span>
						<input
							type="datetime-local"
							value={
								eInvite.date.begin === null
									? null
									: moment(eInvite.date.begin * 1000).format("YYYY-MM-DDTHH:mm")
							}
							onChange={(e) =>
								setEditedInvite({
									...eInvite,
									date: {
										begin: moment(new Date(e.currentTarget.value)).unix(),
										end: eInvite.date.end,
									},
								})
							}
						/>
					</div>
					<div className="edit-dateend flexcol flexgrow">
						<span> Date End </span>
						<input
							type="datetime-local"
							value={
								eInvite.date.end === null
									? null
									: moment(eInvite.date.end * 1000).format("YYYY-MM-DDTHH:mm")
							}
							onChange={(e) => {
								const end = new Date(e.currentTarget.value).toISOString();
								setEditedInvite({
									...eInvite,
									date: {
										begin: eInvite.date.begin,
										end: moment(new Date(e.currentTarget.value)).unix(),
									},
								});
							}}
						/>
					</div>
				</div>
				{/* <div className="edit-excisecomets radio"> */}
				{/* 	<span> Excise Comets </span> */}
				{/* 	<div> */}
				{/* 		<input */}
				{/* 			type="radio" */}
				{/* 			name="advanced-excisecomets" */}
				{/* 			checked={eInvite["excise-comets"] === true} */}
				{/* 			onChange={() => { */}
				{/* 				setEditedInvite({ */}
				{/* 					...eInvite, */}
				{/* 					"excise-comets": true, */}
				{/* 				}); */}
				{/* 			}} */}
				{/* 		/> */}
				{/* 		<span>Yes</span> */}
				{/* 	</div> */}
				{/* 	<div> */}
				{/* 		<input */}
				{/* 			type="radio" */}
				{/* 			name="advanced-excisecomets" */}
				{/* 			checked={eInvite["excise-comets"] === false} */}
				{/* 			onChange={() => { */}
				{/* 				setEditedInvite({ */}
				{/* 					...eInvite, */}
				{/* 					"excise-comets": false, */}
				{/* 				}); */}
				{/* 			}} */}
				{/* 		/> */}
				{/* 		<span>No</span> */}
				{/* 	</div> */}
				{/* </div> */}
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
				{invite.access === "public" && (
					<div className="draft-public">
						<div className="draft-public-earthlink flexcol">
							<span className="label">Earth Link</span>
							<input
								type="text"
								value={
									getBaseURL() +
									eInvite["earth-link"]
								}
								onChange={(e) => {
									const re = /^[a-zA-Z0-9_-]*$/;
									const baseUrl = getBaseURL();
										setEditedInvite({
											...eInvite,
											"earth-link": e.currentTarget.value.slice(baseUrl.length),
										});
									// if (re.test(e.currentTarget.value.slice(baseUrl.length)))
								}}
							/>
						</div>
					</div>
				)}
			</div>
			<button
				className="edit-save send"
				onClick={() => {
					const begin = eInvite.date.begin === null ? null : new Date(eInvite.date.begin * 1000).toUTCString().slice(0, -4);
					const end = eInvite.date.end === null ? null : (new Date(eInvite.date.end * 1000).toUTCString()).slice(0, -4);
					const date = { begin, end };
					pEditInvite({...eInvite, date});
					alert.show(<div style={{ color: "green" }}>Edit Saved</div>);
				}}
			>
				Save
			</button>
		</div>
	);
};

export default Edit;
