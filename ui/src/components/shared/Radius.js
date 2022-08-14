import React, { Component, useState } from 'react';
import { Text, Box, Button, StatelessTextInput } from "@tlon/indigo-react";
import { useStore } from '../../data/store';

const Radius = () => {
	const radius = useStore(state => state.settings.radius);
	const setRadius = useStore(state => state.setRadius);
	const [_radius, _setRadius] = useState(radius);

	return(
		<Box borderBottom={1}>
		<Text display="block">Radius</Text>
		<Text display="block">
		Distance within which you’re willing to receive Statuses. 
	  Shared with Gang members when Status is turned on.
		</Text>
		<Text >Miles:</Text>
		<StatelessTextInput
			display="block"
			value={_radius}
			onChange={(e) => _setRadius(e.currentTarget.value)}>
			</StatelessTextInput>
		<Button onClick={() => setRadius(_radius)}>Set</Button>
		<Text >{radius}</Text>
		</Box>
	 );
}

export default Radius;
