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
import { useAlert } from "react-alert";
import Alert from "./Alert";

const InviteDetails = (props) => {
	const invites = useStore((state) => state.invites);
	const inviteDetails = useStore((state) => state.inviteDetails);
	const _invite = invites.filter((x) => x.id === inviteDetails)[0];
	const invite = _invite.invite;
	const unFocusInvite = useStore((state) => state.unFocusInvite);
	const pRSVP = useStore((state) => state.pRSVP);
	const pUnRSVP = useStore((state) => state.pUnRSVP);
	const setInviteMode = useStore((state) => state.setInviteMode);
	const oldReminder = useStore(
		(state) =>
			state.settings.reminders.gatherings.filter((x) => x.id === _invite.id)[0]
				?.alarm
	);
	const [shipInvite, setShipInvite] = useState("");
	const pInviteShips = useStore((state) => state.pInviteShips);
	const pUnInviteShips = useStore((state) => state.pUnInviteShips);
	const [reminder, setReminder] = useState(
		oldReminder === undefined ? null : oldReminder
	);
	const pGatheringReminder = useStore((state) => state.pGatheringReminder);

	const isHosting = invite.initShip === "~" + window.urbit.ship;
	const newReminder =
		reminder === null
			? null
			: new Date(reminder).toISOString().substring(0, 16);

	const _alert = useAlert();
	const redAlert = (str) => _alert.show(<Alert str={str} color={"red"} />);
	const greenAlert = (str) => _alert.show(<Alert str={str} color={"green"} />);

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
				{_invite.guestStatus === "pending" && invite.hostStatus === "open" && (
					<button
						className="invitedetails-rsvp"
						onClick={() => {
							if (
								invite.rsvpCount === invite.rsvpLimit &&
								invite.rsvpLimit !== null
							)
								redAlert("RSVP limit reached!");
							else pRSVP({ id: _invite.id });
						}}
					>
						RSVP
					</button>
				)}
				{_invite.guestStatus === "rsvpd" && invite.hostStatus === "open" && (
					<button
						className="invitedetails-unrsvp"
						onClick={() => {
							pUnRSVP({ id: _invite.id });
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
							<span className="rightmargin">Start Date:</span>
							<span className="leftmargin">
								{invite.date.begin === null
									? ""
									: new Date(invite.date.begin * 1000).toLocaleString()}
							</span>
						</div>
						<div className="invitedetails-dateend">
							<span className="rightmargin">End Date:</span>
							<span className="leftmargin">
								{invite.date.end === null
									? ""
									: new Date(invite.date.end * 1000).toLocaleString()}
							</span>
						</div>
					</div>
					<div className="invitedetails-secondcol">
						<div className="invitedetails-rsvpnumber">
							{invite.rsvpLimit === null
								? "No RSVP Limit"
								: invite.rsvpCount + "/" + invite.rsvpLimit + " RSVPd"}
						</div>
						<div className="invitedetails-hoststatus">{invite.hostStatus}</div>
						{/* <span>Last Updated:</span> */}
						<div className="invitedetails-lastupdated textrow">
							{"Last Updated: " +
								new Date(invite.lastUpdated * 1000).toLocaleString()}
						</div>
					</div>
				</div>
			</div>
			<div className="flexcol invitedetails-bigchunk">
				<div className="invitedetails-title">{invite.title}</div>
				<img className="invitedetails-image" src={invite.image} />
				<div className="invitedetails-desc">{invite.desc}</div>
				<div className="invitedetails-reminder flexrow">
					<input
						type="datetime-local"
						value={newReminder === null ? null : newReminder}
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
				<div className="invitedetails-firstcol">
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
					<div className="divider">Guest List</div>
					<div className="invitedetails-guestlist-addship flexrow">
						<input
							className="flexgrow"
							placeholder="~{ship}"
							value={shipInvite}
							type="text"
							onChange={(e) => {
								setShipInvite(e.currentTarget.value);
							}}
						/>
						<button
							className="button"
							onClick={() => {
								if (patpValidate(shipInvite)) {
									pInviteShips({ id: _invite.id, "add-ships": [shipInvite] });
								} else redAlert("@p not valid!");
							}}
						>
							Add Ship
						</button>
					</div>
					{invite.guestList.map((guest) => (
						<div className="invitedetails-guestlist-item onetoleft">
							<span>{guest.ship}</span>
							{guest.shipInvite.guestStatus === "pending" && (
								<span className="guestlistitem-element"> Pending </span>
							)}
							{guest.shipInvite.guestStatus === "rsvpd" && (
								<span className="guestlistitem-element"> RSVPd </span>
							)}
							<span className="guestlistitem-element">
								{guest.shipInvite.rsvpDate === "~"
									? "~"
									: new Date(guest.shipInvite.rsvpDate * 1000).toLocaleString()}
							</span>
							<button
								className="button invitedetails-guestlist-button"
								onClick={() =>
									pUnInviteShips({ id: _invite.id, "del-ships": [guest.ship] })
								}
							>
								Uninvite
							</button>
						</div>
					))}
				</div>
			</div>
		</div>
	);
};

export default InviteDetails;
