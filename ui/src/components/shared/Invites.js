import React, { Component, useState} from 'react';
import { useStore } from '../../data/store';
import { Text, Box, Button, StatelessTextInput, Menu, MenuButton, MenuList, MenuItem , Icon} from "@tlon/indigo-react";
import { fetchMyInvite } from '../../utils';
import Invitee from './Invitee';

const Invites = (state) => {
	const inviteState = useStore(state => state.inviteState);
	const myInvite = useStore(state => fetchMyInvite(state.invites));
	return(
		<Box borderBottom={1}>
		<Text> Invites </Text>
		<Box>
			{myInvite.receiveShips.map(invitee => <Invitee {...invitee}/>)}
		</Box>
		</Box>
	 );
}

export default Invites;
