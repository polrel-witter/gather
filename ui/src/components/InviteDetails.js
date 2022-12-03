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
	const oldReminder = useStore(state => state.settings.reminders.gatherings.filter(x => x.id === _invite.id)[0]?.alarm);
	const [reminder, setReminder] = useState(oldReminder === undefined ? null : oldReminder);
	const pGatheringReminder = useStore((state) => state.pGatheringReminder);

	const isHosting = invite.initShip === "~" + window.urbit.ship;
	const newReminder = new Date(reminder).toISOString().substring(0,16);
	console.log(oldReminder);

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
				{_invite.guestStatus === "pending" && invite.hostStatus === 'open' && (
					<button
						className="invitedetails-rsvp"
						onClick={() => pRSVP({id: _invite.id})}
					>
						RSVP
					</button>
				)}
				{_invite.guestStatus === "rsvpd" && invite.hostStatus === 'open' && (
					<button
						className="invitedetails-unrsvp"
						onClick={() => {
							pUnRSVP({id: _invite.id});
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
						value={newReminder}
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
						<span>Access Type:</span>
						<span>{invite.access}</span>
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
						Mars Link: {invite.marsLink}
					</div>
					<div className="invitedetails-accesslink textrow">
						Earth Link: {invite.earthLink}
					</div>
				</div>
				<div className="invitedetails-guestlist">
					<div className='divider'>Guest List</div>
					{invite.guestList.map((guest) => (
						<div className="invitedetails-guestlist-item onetoleft">
							<span>{guest.ship}</span>
							{guest.shipInvite.guestStatus === "pending" && (
								<span className='guestlistitem-element'> Pending </span>
							)}
							{guest.shipInvite.guestStatus === "rsvpd" && <span className='guestlistitem-element'> RSVPd </span>}
							<span className='guestlistitem-element'>{guest.shipInvite.rsvpDate}</span>
						</div>
					))}
				</div>
			</div>
		</div>
	);
};

export default InviteDetails;
