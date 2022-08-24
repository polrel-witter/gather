import React, { Component } from 'react';
import { useStore } from '../../data/store';
import { Text, Box, Button } from "@tlon/indigo-react";
import { fetchMyInvites, fetchReceivedShips } from '../../utils';

const Actions = (props) => {
	if(props.invite.initShip === window.urbit.ship)
		return (
			<Box>
			{ props.invite.status === "sent" && 
				<Box>
				<Button>Edit</Button>
				<Button>Finalize</Button>
				<Button>Cancel</Button>
				</Box>
			}
			{ props.invite.status === "finalized" && 
				<Box>
				<Button>Unfinalize</Button>
				<Button>Complete</Button>
				<Button>Cancel</Button>
				</Box>
			}
			{ props.invite.status === "completed" && 
				<Box>
				<Button>Delete</Button>
				</Box>
			}
			</Box>
	)
	else
		return (
			<Box>
			{ props.invite.note === '' &&
			<Box>
				<Button> RSVP </Button>
				<Button> Decline </Button>
				<Button> Ban </Button>
			</Box>
			}
			{ props.invite.note === '' &&
			<Box>
				<Button> UnRSVP </Button>
			</Box>
			}
			{ props.invite.note === '' &&
			<Box>
				<Button> RSVP </Button>
				<Button> Delete </Button>
				<Button> Ban </Button>
			</Box>
			}
			</Box>
	)

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
						<Text>From ~{invite.initShip} </Text>
						</Box>
						<Box>
						<Text>{invite.note}</Text>
						</Box>
						<Box>==================</Box>
						<Box>
							<Text>
								Happening in meatspace/virtual world on 
								<Date invite={invite}/>
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
						{ invite.initShip !== window.urbit.ship &&
						<Box>
							<Button> DM Host </Button>
						</Box>
						}
						<Box>
							<Text> 2 / {invite.maxAccepted} RSVP'd </Text>
						</Box>
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

const Hosting = (props) => {};
const Received = (props) => {};

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
