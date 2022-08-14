import React, { Component } from 'react';
import { Text, Box } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import PendingInvite from './PendingInvite';
import { fetchPendingInvites, fetchAcceptedInvites } from '../../utils';

const PendingInvites = (state) => {
	const pendingInvites = useStore(state => fetchPendingInvites(state.invites));
	return(
		<Box>
		<Text> Pending Invites </Text>
		<Box>
			{ pendingInvites.map(invite => <PendingInvite {...invite}/>)}
		</Box>
		</Box>
	 );
}

export default PendingInvites;
