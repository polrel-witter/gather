import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';


const Location = () => {
	const statusNote = useStore(state => state.settings.statusNote);
	const setStatusNote = useStore(state => state.setStatusNote);
	const [_statusNote, _setStatusNote] = useState(statusNote);
	// const handleChange = (e) => {
	// 	if(e.nativeEvent.data === null)
			
	// }
	return (
		<Box borderBottom={1}>
		<Text display="block"> My Location </Text>
		<Text display="block"> 
			Used to retrieve location coordinates,
			and is shared with Gang members when Status is turned on. 
		</Text>
  <StatelessTextArea rows={1} value={_statusNote}
		onChange={(e) => _setStatusNote(e.currentTarget.value)}>
	>
  </StatelessTextArea>
		<Button onClick={() => {setStatusNote(_statusNote); console.log(statusNote)}}>Set</Button>
		</Box>
	 );
}

export default Location;
