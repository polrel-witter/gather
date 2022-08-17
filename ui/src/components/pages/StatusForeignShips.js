import React, { Component } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { fetchForeignShips } from '../../utils';

const StatusForeignShips = (props) => {
	const foreignShips = useStore(state => fetchForeignShips(state.ships));
	const pShareStatus = useStore(state => state.pShareStatus);
	const messageShip = useStore(state => state.messageShip);
	const ignoreShip = useStore(state => state.ignoreShip);
	const pGhost = useStore(state => state.pGhost);
	return(
		<Box>
		{ foreignShips.map(foreignShip => {
			return(
		<Box border={1}>
		<Text> {foreignShip._ship} </Text>
		<Text display="block"> {foreignShip.statusNote} </Text>
		<Button onClick={() => pShareStatus(props._ship)}>Add to Gang</Button>
		<Button onClick={() => messageShip(props._ship)}>Message</Button>
		<Button onClick={() => ignoreShip(props._ship)}>Ignore</Button>
		<Button onClick={() => pGhost(props._ship)}>Ghost</Button>
		</Box>
			)})}

		</Box>
	 );
}

export default StatusForeignShips;
