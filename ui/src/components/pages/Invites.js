import React, { Component } from 'react';
import { useStore } from '../../data/store';
import { Text, Box, Button } from "@tlon/indigo-react";
import { fetchMyInvites, fetchReceivedShips } from '../../utils';

const Actions = (props) => {
	const pBan = useStore(state => state.pBan);
	const pUnban = useStore(state => state.pUnban);
	const pCancel = useStore(state => state.pCancel);
	const pClose = useStore(state => state.pClose);
	const pEditInvite = useStore(state => state.pEditInvite);
	if(props.invite.initShip === '~' + window.urbit.ship)
		return (
			<Box>
			{ props.invite.hostStatus === "sent" && 
				<Box>
					<Button onClick={()=>{}}>Edit</Button>
					<Button onClick={()=>{pClose('close', {id: props.invite.id})}}>Close</Button>
					{/* <Button onClick={()=>{pEditInvite('cancel', {id: props.invite.id})}}>Cancel</Button> */}
					<Button onClick={()=>{pCancel(1234)}}>Cancel-test</Button>
					<Button onClick={()=>{pCancel(String(props.invite.id))}}>Cancel</Button>
				</Box>
			}
			{ props.invite.hostStatus === "closed" && 
				<Box>
				<Button>UnClose</Button>
				<Button onClick={()=>{pEditInvite('reopen', props.invite.id)}}>UnClose</Button>
				<Button>Complete</Button>
				<Button onClick={()=>{pEditInvite('cancel', props.invite.id)}}>Finalize</Button>
				</Box>
			}
			{ props.invite.hostStatus === "completed" && 
				<Box>
				<Button>Delete</Button>
				</Box>
			}
			</Box>
	)
	else {
		const inviteeStatus = 'pending';
		if (props.invite.hostStatus !== 'completed') {
			return (
				<Box>
				{ inviteeStatus === 'pending' &&
				<Box>
					<Button> RSVP </Button>
					<Button> Decline </Button>
					<Button onClick={() => {pBan(props.invite.initShip)}} > Ban </Button>
				</Box>
				}
				{ inviteeStatus === 'accepted' &&
				<Box>
					<Button> UnRSVP </Button>
				</Box>
				}
				{ inviteeStatus === 'denied' &&
				<Box>
					<Button> RSVP </Button>
					<Button> Delete </Button>
					<Button> Ban </Button>
				</Box>
				}
				</Box>
			)
		}
		else {
			return (
				<Box>
					<Button> Delete </Button>
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
