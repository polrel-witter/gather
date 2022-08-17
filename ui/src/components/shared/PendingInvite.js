import React, { Component } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { fetchPendingInvites, fetchAcceptedInvites } from '../../utils';

const PendingInvites = (props) => {
	const pendingInvites = useStore(state => fetchPendingInvites(state.invites));
	const pAccept = useStore((state) => state.pAccept);
	const pDeny = useStore((state) => state.pDeny);
	const pGhost = useStore((state) => state.pGhost);
	return(
		<Box border={1}>
			<Box>	<Text>{props.initShip}</Text> </Box>
			<Box> <Text>{props.note}</Text>	</Box>
			<Box>
				<Text>x/y Accepted</Text>
				<Button>Message</Button>
				<Button onClick={() => pAccept(props.id)}>Accept</Button>
				<Button onClick={() => pDeny(props.id)}>Decline</Button>
				<Button>Ignore</Button>
				<Button onClick={() => pGhost(props.initShip)}>Ghost</Button>
			</Box>
		</Box>
	 );
}

export default PendingInvites;
