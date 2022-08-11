import React, { Component } from 'react';
import { Text, Box } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import AcceptedInvite from './AcceptedInvite';
import { fetchPendingInvites, fetchAcceptedInvites } from '../../utils';

const AcceptedInvites = (state) => {
	const acceptedInvites = useStore(state => fetchAcceptedInvites(state.invites));
	return(
		<Box>
		<Text> Accepted Invites </Text>
		<Box>
			{ acceptedInvites.map(invite => <AcceptedInvite {...invite}/>)}
		</Box>
		</Box>
	 );
}

export default AcceptedInvites;
