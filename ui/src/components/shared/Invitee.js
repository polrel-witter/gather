import React, { Component, useState } from 'react';
import { useStore } from '../../data/store';
import { Text, Box, Button, StatelessTextInput, Menu, MenuButton, MenuList, MenuItem , Icon} from "@tlon/indigo-react";
import { fetchMyInvite } from '../../utils';

const Invitee = (props) => {
	// const inviteState = useStore(state => state.inviteState);
	// const myInvite = useStore(state => fetchMyInvite(state.invites));
	return(
		<Box>
		<Text>{props._ship}</Text>
		</Box>
	 );
}

export default Invitee;
