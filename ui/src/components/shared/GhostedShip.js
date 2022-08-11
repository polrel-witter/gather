import React, { Component, useState } from 'react';
import { Text, Box, Button, StatelessTextInput } from "@tlon/indigo-react";
import { useStore } from '../../data/store';

const GhostedShip = (props) => {
	const unGhostShip = useStore(state => state.unGhostShip);

	return(
		<Box>
		<Text> {props.ghostedShip._ship} </Text>
		<Button onClick={() => unGhostShip(props.ghostedShip._ship)}>Ghost</Button>
		</Box>
	 );
}

export default GhostedShip;
