import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button, StatelessTextInput } from "@tlon/indigo-react";
import { useStore } from '../../data/store';

const Radius = () => {
	const radius = useStore(state => state.settings.radius);
	const [_radius, _setRadius] = useState(radius);
	const pRadius = useStore(state => state.pRadius);

	return(
		<Box borderBottom={1}>
		<Text display="block">Radius</Text>
		<Text display="block">
		Distance within which you’re willing to receive Statuses. 
	  Shared with Gang members when Status is turned on.
		</Text>
		<Text >Miles:</Text>
		{/* TODO make sure the input is a number */}
		<StatelessTextInput
			display="block"
			value={_radius}
			onChange={(e) => _setRadius(e.currentTarget.value)}>
			</StatelessTextInput>
		<Button onClick={() => pRadius(String(_radius))}>Set</Button>
		</Box>
	 );
}

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

const CustomCollections = (props) => {
	return(
		<Box border={1}>
		{/* <Text>Gang Members</Text> */}
		{/* <Text>Select default ships to which you’re willing to send your Status. Clicking Pause will temporarily stop sending your Status to a ship, but you will still receive theirs.  </Text> */}
  	{/* <StatelessTextInput/> */}
		{/* <Button onClick={() => pShareStatus(_gangMember)}>Add</Button> */}
		{/* 	{ gangMembers.map(gangMember => { */}
		{/* 		return ( */}
		{/* 		<Box> */}
		{/* 			<Text>{gangMember._ship}</Text> */}
		{/* 			{/1* <Button onClick={() => pauseGangMember(_gangMember)}>Pause</Button> *1/} */}
		{/* 			{/1* <Button onClick={() => removeGangMember(_gangMember)}>Remove</Button> *1/} */}
		{/* 		</Box> */}
		{/* 		) */}
		{/* 	})} */}
		</Box>
	 );
}

const Settings = () => {
	return(
		<Box>
				<Location/>
				<Radius/>
		</Box>
	 );
}

export default Settings;
