import React, { Component } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { fetchPendingInvites, fetchAcceptedInvites } from '../../utils';

const PendingInvites = (props) => {
	const pendingInvites = useStore(state => fetchPendingInvites(state.invites));
	return(
		<Box border={1}>
			<Box>	<Text>{props.initShip}</Text> </Box>
			<Box> <Text>{props.inviteNote}</Text>	</Box>
			<Box>
				<Text>x/y Accepted</Text>
				<Button>Message</Button>
				<Button>Accept</Button>
				<Button>Decline</Button>
				<Button>Ignore</Button>
				<Button>Ghost</Button>
			</Box>
		</Box>
	 );
}

export default PendingInvites;
