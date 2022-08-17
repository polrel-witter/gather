import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';

// TODO mapping a location to a lat/lon
const Location = () => {
	const statusNote = useStore(state => state.settings.statusNote);
	const pSettings = useStore(state => state.pSettings);
	const [_statusNote, _setStatusNote] = useState(statusNote);
	// const handleChange = (e) => {
	// 	if(e.nativeEvent.data === null)
	const address = { street: "street2", city: "Austin", state: "Texas", country: "USA2", zip: "111112" };
	const position = { lon: 43, lat: 11};
			
	// }
	return (
		<Box borderBottom={1}>
		<Text display="block"> My Location </Text>
		<Text display="block"> 
			Used to retrieve location coordinates,
			and is shared with Gang members when Status is turned on. 
		</Text>
  <StatelessTextArea rows={1} value={address.street + ' ,' + address.city + ' ,' + address.state + ' ,' + address.country + ' ,' + address.zip}
		onChange={(e) => _setStatusNote(e.currentTarget.value)}>
	>
  </StatelessTextArea>
		<Button onClick={() => {pSettings('address', address); pSettings('position', position)}}>Set</Button>
		</Box>
	 );
}

export default Location;
