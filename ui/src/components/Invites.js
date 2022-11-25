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

export const Invites = (props) => {
	const route = useStore((state) => state.route);
	const invitesMode = useStore((state) => state.invitesMode);
	const settings = useStore((state) => state.settings);
	const inviteMode = useStore((state) => state.inviteMode);
	const invites = useStore((state) =>
		filterInvites(invitesMode, state.invites)
	);
	const inviteDetails = useStore((state) => state.inviteDetails);
	const setInvitesMode = useStore((state) => state.setInvitesMode);
	console.log(invitesMode.slice(0,7) === 'hosting');

	if (inviteDetails === "")
		return (
			<div className="invites">
				<div className="invites-topbar">
					<select
						className="invites-topbar-type"
						name="inbox-hosting"
						onChange={(e) => setInvitesMode(e.target.value)}
					>
						<option value="hosting-open">Hosting</option>
						<option value="inbox-rsvp">Inbox</option>
					</select>
					{invitesMode.slice(0, 7) === "hosting" && (
						<div className="invites-topbar-hosting">
							<button onClick={() => setInvitesMode("hosting-open")}>
								Open
							</button>
							<button onClick={() => setInvitesMode("hosting-closed")}>
								Closed
							</button>
							<button onClick={() => setInvitesMode("hosting-completed")}>
								Completed
							</button>
							<button onClick={() => setInvitesMode("hosting-cancelled")}>
								Cancelled
							</button>
							<button>Search</button>
						</div>
					)}
					{invitesMode.slice(0, 5) === "inbox" && (
						<div className="invites-topbar-inbox">
							<button onClick={() => setInvitesMode("inbox-rsvp")}>
								RSVPd
							</button>
							<button onClick={() => setInvitesMode("inbox-pending")}>
								Pending
							</button>
							<button onClick={() => setInvitesMode("inbox-outofrange")}>
								Out-of-range
							</button>
							<button>Search</button>
						</div>
					)}
				</div>
				{invites.map((invite) => (
					<Invite invite={invite} />
				))}
			</div>
		);
	else if (inviteMode === "view") return <InviteDetails />;
	if (inviteMode === "edit") return <Edit />;
	if (inviteMode === "chat") return <Chat />;
};

export default Invites;
