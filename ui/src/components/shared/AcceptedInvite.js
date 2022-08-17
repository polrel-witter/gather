import React, { Component } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { fetchPendingInvites, fetchAcceptedInvites } from '../../utils';

const AcceptedInvite = (props) => {
	const pDeny = useStore((state) => state.pDeny);
	return(
		<Box border={1}>
			<Box>	<Text>{props.initShip}</Text> </Box>
			<Box> <Text>{props.inviteNote}</Text>	</Box>
			<Box>
				<Text>x/y Accepted</Text>
				<Button>Message</Button>
				{/* TODO RSVP List invite.receiveShips*/}
				<Button>View RSVP List</Button>
				<Button onClick={() => pDeny(props.id)}>Unaccept</Button>
			</Box>
		</Box>
	 );
}

export default AcceptedInvite;
