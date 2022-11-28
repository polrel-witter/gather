import React, { Component, useState } from "react";
import {
	Icon,
	Text,
	Box,
	ManagedTextAreaField,
	StatelessTextArea,
	ManagedTextInputField,
	Button,
	StatelessTextInput,
	StatelessRadioButtonField,
} from "@tlon/indigo-react";
import { useStore } from "../data/store";
import { patpValidate } from "../utils";
import Location from "./Location";

const InviteDetails = (props) => {
	const invites = useStore((state) => state.invites);
	const inviteDetails = useStore((state) => state.inviteDetails);
	const _invite = invites.filter((x) => x.id === inviteDetails)[0];
	const invite = _invite.invite;
	const unFocusInvite = useStore((state) => state.unFocusInvite);
	const pRSVP = useStore((state) => state.pRSVP);
	const pUnRSVP = useStore((state) => state.pUnRSVP);
	const setInviteMode = useStore((state) => state.setInviteMode);
	const [reminder, setReminder] = useState(0);
	const pGatheringReminder = useStore((state) => state.pGatheringReminder);

	const isHosting = invite.initShip === ("~" + window.urbit.ship);
	console.log(invite);

	return (
		<div className="invitedetails">
			<button className="invitedetails-return" onClick={() => unFocusInvite()}>
				Return
			</button>
			{isHosting && (
				<button
					className="invitedetails-edit"
					onClick={() => setInviteMode('edit')}
				>
					Edit
				</button>
			)}
			{_invite.guestStatus === "pending" && (
				<button
					className="invitedetails-rsvp"
					onClick={() => pRSVP(_invite.id)}
				>
					RSVP
				</button>
			)}
			{_invite.guestStatus === "rsvpd" && (
				<button
					className="invitedetails-unrsvp"
					onClick={() => {
						pUnRSVP(_invite.id);
					}}
				>
					UnRSVP
				</button>
			)}
			<button className="invitedetails-chat" 
					onClick={() => setInviteMode('chat')}
				>
				Chat
			</button>
			<div className="invitedetails">
				<div className="invitedetails-host">Host {invite.initShip}</div>
				<div className="invitedetails-datebegin">
					Gather StartDate 
					{invite.date.begin}
				</div>
				<div className="invitedetails-dateend">
					Gather EndDate
					{invite.date.end}
				</div>
				<div className="invitedetails-rsvpnumber">
					{invite.rsvpCount} / {invite.rsvpLimit} RSVPd
				</div>
				<div className="invitedetails-hoststatus">{invite.hostStatus}</div>
				==================
				<div className="invitedetails-title">{invite.title}</div>
				<img className="invitedetails-image" src={invite.image} />
				<div className="invitedetails-desc">{invite.desc}</div>
				==================
				{/* TODO make reminder work */}
				<div className="invitedetails-reminder">
					<input
						type='datetime-local'
						onChange={(e) => {
								const rem = new Date(e.currentTarget.value);
								setReminder(rem.valueOf());
						}}
					/>
					<button
						onClick={() => pGatheringReminder({id: _invite.id, alarm: reminder})}
					>
						Set Reminder
					</button>
				</div>
				<div className="invitedetails-lastupdated">
					Last Updated: {invite.lastUpdated}
				</div>
				<div className="invitedetails-rsvpcount">
					Max RSVPs: {invite.rsvpCount}
				</div>
				<div className="invitedetails-radius">
					Delivery Radius: {invite.radius}
				</div>
				<div className="invitedetails-address">
					loelivery Radius: {invite.address}
				</div>
				<div className="invitedetails-radius">
					Delivery Radius: {invite.radius}
				</div>
				<div className="invitedetails-address">Address: {invite.address}</div>
				<div className="invitedetails-accesslink">
					Access Link: {invite.accessLink}
				</div>
				===================
				<div className="invitedetails-guestlist">
					Guest List
					{invite.guestList.map((guest) => (
						<div className="invitedetails-guestlist-item">
							<span>{guest.ship}</span>
							{ guest.shipInvite.guestStatus === 'pending' && 
							<span> Pending </span>
							}
							{ guest.shipInvite.guestStatus === 'rsvpd' && 
								<span> RSVPd </span>
							}
							<span>{guest.shipInvite.rsvpDate}</span>
							</div>
					))}
				</div>
			</div>
		</div>
	);
};

export default InviteDetails;
