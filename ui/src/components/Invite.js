import React, { Component } from "react";
import { useStore } from "../data/store";

const Button = (props) => {
	return <button onClick={() => props.click()}>{props.text}</button>;
};

const HostingButtons = (props) => {
	const invite = props.invite.invite;
	const id = props.invite.id;

	const focusInvite = useStore((state) => state.focusInvite);
	const pAltHostStatus = useStore((state) => state.pAltHostStatus);
	const pDelInvite = useStore((state) => state.pDelInvite);
	const pBan = useStore((state) => state.pBan);

	switch (invite.hostStatus) {
		case "open":
			return (
				<div className="invite-hosting-open cardbuttons">
					<Button text="View" click={() => focusInvite(id)} invite={invite} />
					<Button
						text="Close"
						click={() => pAltHostStatus({ id, "host-status": "closed" })}
						invite={invite}
					/>
					<Button
						text="Cancel"
						click={() => pAltHostStatus({ id, "host-status": "cancelled" })}
						invite={invite}
					/>
				</div>
			);
			break;
		case "closed":
			return (
				<div className="invite-hosting-closed cardbuttons">
					<Button text="View" click={() => focusInvite(id)} />
					<Button
						text="Open"
						click={() => pAltHostStatus({ id, "host-status": "open" })}
					/>
					<Button
						text="Complete"
						click={() => pAltHostStatus({ id, "host-status": "completed" })}
					/>
					<Button
						text="Cancel"
						click={() => pAltHostStatus({ id, "host-status": "cancelled" })}
					/>
				</div>
			);
			break;
		case "completed":
			return (
				<div className="invite-hosting-completed cardbuttons">
					<Button text="View" click={() => focusInvite(id)} />
					<Button text="Delete" click={() => pDelInvite({ id })} />
				</div>
			);
			break;
		case "cancelled":
			return (
				<div className="invite-hosting-cancelled cardbuttons">
					<Button text="View" click={() => focusInvite(id)} />
					<Button text="Delete" click={() => pDelInvite({ id })} />
				</div>
			);
			break;
	}
};

const InboxButtons = (props) => {
	// const status = props.status;
	const invite = props.invite;
	const focusInvite = useStore((state) => state.focusInvite);
	const pDelInvite = useStore((state) => state.pDelInvite);
	const pBan = useStore((state) => state.pBan);
	console.log(invite);

	return (
		<div className="invite-inbox cardbuttons">
			<Button text="View" click={() => focusInvite(invite.id)} />
			<Button text="Delete" click={() => pDelInvite(invite.id)} />
			<Button text="Ban Host" click={() => pBan(invite.invite.initShip)} />
		</div>
	);
};

const Invite = (props) => {
	const invite = props.invite.invite;
	const invitesMode = useStore((state) => state.invitesMode);
	console.log(invite);
	return (
		<div className="invite">
			<div className="invite-columns">
				<div className="invite-firstcol">
					<div className="invite-title">{invite.title}</div>
					<div className="invite-host">From <span className='bold'>{invite.initShip}</span></div>
					{ invite.date.begin !== null && <div className="invite-date">Date: {new Date(invite.date.begin*1000).toLocaleString()}</div>
					}
					<div className="invite-locationtype">Happening in {invite.locationType}</div>
				</div>
				<div className="invite-secondcol">
					<div className="invite-status">{'%'+invite.hostStatus}</div>
					<div className="invite-access">{invite.access}</div>
					<div className="invite-rsvpd">{props.guestStatus}</div>
				</div>
			</div>
			<div className="invite-desc">{invite.desc}</div>

			{invitesMode.slice(0, 7) === "hosting" && (
				<HostingButtons invite={props.invite} />
			)}
			{invitesMode.slice(0, 5) === "inbox" && (
				<InboxButtons invite={props.invite} />
			)}
		</div>
	);
};
export default Invite;
