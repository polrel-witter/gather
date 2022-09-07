import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';

const Collection = () => {
	const focusedInvite = useStore(state => state.focusedInvite);
	const focusInvite = useStore(state => state.focusInvite);
			
	return (
		<Box>
			{focusedInvite.radius}
			<Button onClick={focusInvite({})}>Return</Button>
		</Box>
	 );
}
export default Collection;
