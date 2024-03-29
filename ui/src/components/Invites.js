import React, { Component, useState } from "react";
import { useStore } from "../data/store";
import { Text, div, Button } from "@tlon/indigo-react";
import Edit from "./Edit";
import Chat from "./Chat";
import Invite from "./Invite";
import {
	filterInvites,
	filterDistantInvites,
	fetchMyInvites,
	fetchReceivedShips,
	fetchMyReceivedShip,
	sortSelected,
} from "../utils";
import InviteDetails from "./InviteDetails";
import { getDistance } from "geolib";
import haversine from "haversine-distance";
import { useAlert } from "react-alert";

const topbarSelected = (invitesMode, button) => {
	if (invitesMode === button)
		return { fontWeight: "bold", borderBottom: "1px solid" };
	return {};
};

export const Invites = (props) => {
	const route = useStore((state) => state.route);
	const invitesMode = useStore((state) => state.invitesMode);
	const settings = useStore((state) => state.settings);
	const inviteMode = useStore((state) => state.inviteMode);
	const invites = useStore((state) =>
		filterInvites(invitesMode, state.invites, settings)
	);
	const inviteDetails = useStore((state) => state.inviteDetails);
	const setInvitesMode = useStore((state) => state.setInvitesMode);
	const pAdd = useStore((state) => state.pAdd);
	const [marsLink, setMarsLink] = useState("");
	const totalInvites = useStore((state) => state.invites);

	if (inviteDetails === "")
		return (
			<div className="invites">
				<div className="invites-topbar flexrow">
					<select
						className="invites-topbar-type select"
						name="inbox-hosting"
						onChange={(e) => setInvitesMode(e.target.value)}
					>
						<option
							value="hosting-open"
							selected={invitesMode.slice(0, 7) === "hosting" ? "selected" : ""}
						>
							Hosting
						</option>
						<option
							value="inbox-rsvpd"
							selected={invitesMode.slice(0, 5) === "inbox" ? "selected" : ""}
						>
							Inbox
						</option>
					</select>
					{invitesMode.slice(0, 7) === "hosting" && (
						<div className="invites-topbar-hosting">
							<button
								style={topbarSelected(invitesMode, "hosting-open")}
								onClick={() => setInvitesMode("hosting-open")}
							>
								Open
							</button>
							<button
								style={topbarSelected(invitesMode, "hosting-closed")}
								onClick={() => setInvitesMode("hosting-closed")}
							>
								Closed
							</button>
							<button
								style={topbarSelected(invitesMode, "hosting-completed")}
								onClick={() => setInvitesMode("hosting-completed")}
							>
								Completed
							</button>
							<button
								style={topbarSelected(invitesMode, "hosting-cancelled")}
								onClick={() => setInvitesMode("hosting-cancelled")}
							>
								Cancelled
							</button>
						</div>
					)}
					{invitesMode.slice(0, 5) === "inbox" && (
						<div className="invites-topbar-inbox">
							<button
								style={topbarSelected(invitesMode, "inbox-rsvpd")}
								onClick={() => setInvitesMode("inbox-rsvpd")}
							>
								RSVPd
							</button>
							<button
								style={topbarSelected(invitesMode, "inbox-pending")}
								onClick={() => setInvitesMode("inbox-pending")}
							>
								Pending
							</button>
							<button
								style={topbarSelected(invitesMode, "inbox-outofrange")}
								onClick={() => setInvitesMode("inbox-outofrange")}
							>
								Out-of-range
							</button>
						</div>
					)}
				</div>
				{invitesMode === "inbox-pending" && (
					<div className="invites-search flexrow">
						<input
							className="flexgrow"
							type="text"
							placeholder="~sampel-palnet/gather/0v6.1nmgo.hecph.32thg"
							onChange={(e) => setMarsLink(e.currentTarget.value)}
						/>
						<button
							className="button"
							onClick={() => {
								pAdd({ "mars-link": marsLink });
							}}
						>
							Add Public Invite
						</button>
					</div>
				)}
				{invites.map((invite) => (
					<Invite invite={invite} />
				))}
			</div>
		);
	else {
	if (inviteMode === "view" && totalInvites.filter((x) => x.id === inviteDetails)[0] !== undefined) return <InviteDetails />;
	
	if (inviteMode === "edit") return <Edit />;
	if (inviteMode === "chat") return <Chat />;
	}
};

export default Invites;
