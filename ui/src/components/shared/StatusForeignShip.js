import React, { Component } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { fetchForeignShips } from '../../utils';

const StatusForeignShip = (props) => {
	const foreignShips = useStore(state => fetchForeignShips(state.ships));
	const addForeignShipToGang = useStore(state => state.addForeignShipToGang);
	const messageShip = useStore(state => state.messageShip);
	const ignoreShip = useStore(state => state.ignoreShip);
	const ghostShip = useStore(state => state.ghostShip);
	return(
		<Box>
		{ foreignShips.map(foreignShip => {
			return(
		<Box border={1}>
		<Text> {foreignShip._ship} </Text>
		<Text display="block"> {foreignShip.statusNote} </Text>
		<Button onClick={() => addForeignShipToGang(props._ship)}>Add to Gang</Button>
		<Button onClick={() => messageShip(props._ship)}>Message</Button>
		<Button onClick={() => ignoreShip(props._ship)}>Ignore</Button>
		<Button onClick={() => ghostShip(props._ship)}>Ghost</Button>
		</Box>
			)})}

		</Box>
	 );
}

export default StatusForeignShip;
