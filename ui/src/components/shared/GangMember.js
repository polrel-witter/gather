import React, { Component, useState } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { fetchGangMembers } from '../../utils';

const GangMember = (props) => {
	const messageShip = useStore(state => state.messageGangMember);
	const ignoreShip = useStore(state => state.ignoreShip);
	return(
		<Box border={1}>
		<Text> {props._ship} </Text>
		<Text> {props.statusNote} </Text>
		<Button onClick={() => messageShip(props._ship)}>Pause</Button>
		<Button onClick={() => ignoreShip(props._ship)}>Remove</Button>
		</Box>
	 );
}

export default GangMember;
