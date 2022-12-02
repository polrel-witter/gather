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

	const isHosting = invite.initShip === "~" + window.urbit.ship;
	console.log(invite);

	return (
		<div className="invitedetails">
			<div className="invitedetails-topbar">
				<button
					className="invitedetails-return"
					onClick={() => unFocusInvite()}
				>
					Return
				</button>
				{isHosting && (
					<button
						className="invitedetails-edit"
						onClick={() => setInviteMode("edit")}
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
				<button
					className="invitedetails-chat"
					onClick={() => setInviteMode("chat")}
				>
					Chat
				</button>
			</div>
			<div className="invitedetails flexcol">
				<div className="invitedetails-columns">
					<div className="invitedetails-firstcol">
						<div className="invitedetails-host">
							<span className="bold">Host</span> {invite.initShip}
						</div>
						<div className="invitedetails-datebegin">
							<span className="rightmargin">Start Date</span>
							<span className="leftmargin">
								{new Date(invite.date.begin * 1000).toLocaleString()}
							</span>
						</div>
						<div className="invitedetails-dateend">
							<span className="rightmargin">End Date</span>
							<span className="leftmargin">
								{new Date(invite.date.end * 1000).toLocaleString()}
							</span>
						</div>
					</div>
					<div className="invitedetails-secondcol">
						<div className="invitedetails-rsvpnumber">
							{invite.rsvpCount} / {invite.rsvpLimit} RSVPd
						</div>
						<div className="invitedetails-hoststatus">{invite.hostStatus}</div>
					</div>
				</div>
			</div>
			<div className="flexcol invitedetails-secondcol">
				<div className="invitedetails-title">{invite.title}</div>
				<img className="invitedetails-image" src={invite.image} />
				<div className="invitedetails-desc">{invite.desc}</div>
				{/* TODO make reminder work */}
				<div className="invitedetails-reminder flexrow">
					<input
						type="datetime-local"
						onChange={(e) => {
							const rem = new Date(e.currentTarget.value);
							setReminder(rem.valueOf());
						}}
					/>
					<button
						className="button"
						onClick={() =>
							pGatheringReminder({ id: _invite.id, alarm: reminder })
						}
					>
						Set Reminder
					</button>
				</div>
				<div className="invitedetails-secondcol border">
					<div className="invitedetails-lastupdated textrow">
						Last Updated: {new Date(invite.lastUpdated * 1000).toLocaleString()}
					</div>
					<div className="invitedetails-rsvpcount textrow">
						<span>Max RSVPs:</span>
						<span>{invite.rsvpCount}</span>
					</div>
					<div className="invitedetails-radius textrow">
						<span>Delivery Radius:</span>
						<span>{invite.radius}</span>
					</div>
					<div className="invitedetails-address textrow">
						<span>Happening in:</span>
						<span>{invite.locationType}</span>
					</div>
					<div className="invitedetails-radius textrow">
						<span>Address:</span>
						<span>{invite.address}</span>
					</div>
					<div className="invitedetails-address textrow">
						<span>Access Link:</span>
						<span>{invite.accessLink}</span>
					</div>
					<div className="invitedetails-accesslink textrow">
						Access Link: {invite.accessLink}
					</div>
				</div>
				<div className="invitedetails-guestlist">
					<div className='divider'>Guest List</div>
					{invite.guestList.map((guest) => (
						<div className="invitedetails-guestlist-item onetoleft">
							<span>{guest.ship}</span>
							{guest.shipInvite.guestStatus === "pending" && (
								<span> Pending </span>
							)}
							{guest.shipInvite.guestStatus === "rsvpd" && <span> RSVPd </span>}
							<span>{guest.shipInvite.rsvpDate}</span>
						</div>
					))}
				</div>
			</div>
		</div>
	);
};

export default InviteDetails;
