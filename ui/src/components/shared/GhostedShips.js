import React, { Component, useState } from 'react';
import { Text, Box, Button, StatelessTextInput } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import GhostedShip from './GhostedShip';

const GhostedShips = () => {
	const ghostedShips = useStore(state => state.ships.filter(x => x.weGhosted === true));
	const pGhostShip = useStore(state => state.pGhostShip);
	const unGhostShip = useStore(state => state.unGhostShip);
	const [_ghostedShip, _setGhostedShip] = useState("");

	return(
		<Box borderBottom={1}>
		<Text display="block">Ghosted Ships</Text>
		<Text display="block">
			Statuses or Invites will not 
			be sent to or received from these ships.
		</Text>
		<StatelessTextInput
			display="block"
			value={_ghostedShip}
			onChange={(e) => _setGhostedShip(e.currentTarget.value)}>
		</StatelessTextInput>
		<Button onClick={() => pGhostShip(_ghostedShip)}>Ghost</Button>
			{ghostedShips.map((ghostedShip) => <GhostedShip ghostedShip={ghostedShip}/>)}
		</Box>
	 );
}

export default GhostedShips;
