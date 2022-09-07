import React, { Component } from 'react';
import { useStore } from '../../data/store';
import { Text, Box, Button } from "@tlon/indigo-react";
import { fetchMyInvites, fetchReceivedShips, fetchMyReceivedShip } from '../../utils';

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
	if(props.invite.initShip === '~' + window.urbit.ship)
		return (
			<Box>
			{ props.invite.hostStatus === "sent" && 
				<Box>
					<Button onClick={()=>{}}>Edit</Button>
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
	)
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
					<Button onClick={() => {pDeny(props.invite.id)}}> Decline </Button>
					<Button onClick={() => {pBan(props.invite.initShip)}} > Ban </Button>
				</Box>
				}
				{ inviteeStatus === 'accepted' &&
				<Box>
					<Button onClick={() => {pDeny(props.invite.id)}}> UnRSVP </Button>
				</Box>
				}
				{ inviteeStatus === 'denied' &&
				<Box>
					<Button onClick={() => {pAccept(props.invite.id)}}> RSVP </Button>
					<Button onClick={() => {pCancel(props.invite.id)}}> Delete </Button>
					<Button onClick={() => {pBan(props.invite.initShip)}} > Ban </Button>
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
	return (
		<Text>Status</Text>
	);
}

const Invite = (props) => {
	return (
				<Box>
					{ props.invites.map( invite => 
					<Box border={1}>
						<Text>{invite.title} </Text>
						<Status invite={invite}/>
						<Box>
						<Text>From {invite.initShip} </Text>
						</Box>
						<Box>
						<Text>{invite.desc}</Text>
						</Box>
						<Box>==================</Box>
						{/* <Box> */}
						{/* 	<Text> */}
						{/* 		Happening in meatspace/virtual world on */} 
						{/* 		<Date invite={invite}/> */}
						{/* 		{ invite.locationType === "meatspace" && */} 
						{/* 			<Text> Location: {invite.location} </Text> */}
						{/* 		} */}
						{/* 	</Text> */}
						{/* </Box> */}
						{/* <Box> */}
						{/* 	<Text> */}
						{/* 		Access Link: {invite.accessLink} */}
						{/* 	</Text> */}
						{/* </Box> */}
						{/* { invite.radius !== 0 && */} 
						{/* <Box> */}
						{/* 	<Text> */}
						{/* 		Delivery Radius: {invite.radius} */}
						{/* 	</Text> */}
						{/* </Box> */}
						{/* } */}
						{ invite.initShip !== window.urbit.ship &&
						<Box>
							<Button> DM Host </Button>
						</Box>
						}
						{ invite.maxAccepted !== 0 && 
						<Box>
							<Text> {invite.receiveShips.filter(x => x.shipInvite === 'accepted').length} / {invite.maxAccepted} RSVP'd </Text>
						</Box>
						}
						<Box>
							<Button>View Invite List</Button>
						</Box>
					<Box>
						<Actions invite={invite}/>
					</Box>
					</Box>
					) }
				</Box>
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
