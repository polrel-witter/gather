import React, { Component, useState } from 'react';
import { useStore } from '../../data/store';
import { Text, Box, Button } from "@tlon/indigo-react";
import { fetchMyInvites, fetchReceivedShips, fetchMyReceivedShip } from '../../utils';
import FocusedInvite from './FocusedInvite';

const Actions = (props) => {
	const pBan = useStore(state => state.pBan);
	const pUnban = useStore(state => state.pUnban);
	const pAccept = useStore(state => state.pAccept);
	const pDeny = useStore(state => state.pDeny);
	const pCancel = useStore(state => state.pCancel);
	const pClose = useStore(state => state.pClose);
	const pReopen = useStore(state => state.pReopen);
	const pComplete = useStore(state => state.pComplete);
	const pEditDesc = useStore(state => state.pEditDesc);
	const pEditInvite = useStore(state => state.pEditInvite);
	if(props.invite.initShip === '~' + window.urbit.ship) {
		const invite = props.invite.invite;
		return (
			<Box>
			{ props.invite.hostStatus === "sent" && 
				<Box>
					<Button onClick={()=>{pClose(props.invite.id)}}>Close</Button>
					<Button onClick={()=>{pCancel(props.invite.id)}}>Cancel</Button>
				</Box>
			}
			{ props.invite.hostStatus === "closed" && 
				<Box>
				<Button onClick={()=>{pReopen(props.invite.id)}}>Reopen</Button>
				<Button onClick={()=>{pComplete(props.invite.id)}}>Complete</Button>
				<Button onClick={()=>{pCancel(props.invite.id)}}>Delete</Button>
				</Box>
			}
			{ props.invite.hostStatus === "completed" && 
				<Box>
				<Button onClick={()=>{pCancel(props.invite.id)}}>Delete</Button>
				</Box>
			}
			</Box>
	)}
	else {
		const inviteeStatus = fetchMyReceivedShip(props.invite).shipInvite;
		// console.log(fetchMyReceivedShip(props.invite));
		// const inviteeStatus = 'pending';
		console.log(inviteeStatus);
		if (props.invite.hostStatus !== 'completed') {
			return (
				<Box>
				{ inviteeStatus === 'pending' &&
				<Box>
					<Button onClick={() => {pAccept(props.invite.id)}}> RSVP </Button>
					<Button onClick={() => {pBan(props.invite.initShip)}} > Ban </Button>
				</Box>
				}
				{ inviteeStatus === 'accepted' &&
				<Box>
					<Button onClick={() => {pDeny(props.invite.id)}}> UnRSVP </Button>
				</Box>
				}
				</Box>
			)
		}
		else {
			return (
				<Box>
					<Button onClick={()=>{pCancel(props.invite.id)}}>Delete</Button>
				</Box>
			)
		}
	}

	return (<h1></h1>);
}

const Date = (props) => {
	// invite.date
	return (
		<Box>
		<Text> Date </Text>
		<Text> Time </Text>
		</Box>
	);
}

const Status = (props) => {
		switch (props.invite.hostStatus) {
			case 'sent':
			return (
				<Text>Sent</Text>
			)
			break;
			case 'closed':
			return (
				<Text>Closed</Text>
			)
			break;
			case 'completed':
			return (
				<Text>Completed</Text>
			)
			break;
		}
}

const Invite = (props) => {
	const route = useStore(state => state.route);
	// const focusedInvite = useStore(state => state.focusedInvite);
	// const focusInvite = useStore(state => state.focusInvite);
	const [focusedInvite, focusInvite] = useState({});

	if(Object.keys(focusedInvite).length === 0)
		return (
				<Box>
					{ props.invites.map( mInvite => {
						const id = invite.id;
						const invite = mInvite.invite;
						return (
					<Box border={1}>
						<Text>{invite.title} </Text>
						<Status invite={mInvite}/>
						<Box>
						<Text>From {invite.initShip} </Text>
						</Box>
						<Box>
						<Text>{invite.desc}</Text>
						</Box>
						<Box>==================</Box>
						<Box>
							<Text>
								Happening in meatspace/virtual world on 
								{ invite.locationType === "meatspace" && 
									<Text> Location: {invite.location} </Text>
								}
							</Text>
						</Box>
						<Box>
							<Text>
								Access Link: {invite.accessLink}
							</Text>
						</Box>
						{ invite.radius !== 0 && 
						<Box>
							<Text>
								Delivery Radius: {invite.radius}
							</Text>
						</Box>
						}
						{ invite.maxAccepted !== 0 && 
						<Box>
							<Text> {invite.receiveShips.filter(x => x.shipInvite === 'accepted').length} / {invite.maxAccepted} RSVP'd </Text>
						</Box>
						}
						<Box>
							<Button onClick={() => {console.log(invite); focusInvite(invite)}}>Focus</Button>
						</Box>
					<Box>
						<Actions invite={mInvite}/>
					</Box>
					</Box>
						)})}
				</Box>
			)
	else
		return (
			<FocusedInvite invite={focusedInvite} focusInvite={focusInvite}/>
		)
};

const Invites = () => {
	const inviteRoute = useStore(state => state.inviteRoute);
	const all = useStore(state => state.invites);
	const hosting = useStore(state => fetchMyInvites(state.invites));
	const received = useStore(state => fetchReceivedShips(state.invites));
	switch(inviteRoute) {
		case "all":
			return (
				<Invite invites={all}/>
			);
		break;
		case "hosting":
			return (
				<Invite invites={hosting}/>
			);
		break;
		case "received":
			return (
				<Invite invites={received}/>
			);
		break;
	}
}

export default Invites;
