import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';

const FocusedInvite = () => {
	const invite = useStore(state => state.focusedInvite);
	const focusInvite = useStore(state => state.focusInvite);
			
	return (
		<Box>
			<Box>
				{invite.desc}
				<Button onClick={focusInvite({})}>Edit Description</Button>
			</Box>
			<Box>
				{invite.radius}
			</Box>
			<Box>
				{invite.radius}
			</Box>
			<Box>
				{invite.radius}
			</Box>
			{ invite.receiveShips.map(receiveShip => {
				<Box border={1}>
					<Text>{receiveShip.ship}</Text>
					<Text>{receiveShip.shipInvite}</Text>
					<Button onClick={focusInvite({})}>Delete Ship</Button>
				</Box>
			})}
			{/* <Button onClick={focusInvite({})}>Return</Button> */}
		</Box>
	 );
}
export default FocusedInvite;
