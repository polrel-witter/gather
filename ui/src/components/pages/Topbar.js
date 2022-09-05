import React, { Component } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import TopButtons from '../shared/TopButtons';
import { useStore } from '../../data/store';

const Topbar = () => {
	const route = useStore(state => state.route);
	const setRoute = useStore(state => state.setRoute);
	return (
		<Box>
			{ route === 'draft' ? <Button color="red">Draft</Button> : 
			<Button onClick={() => setRoute("draft")}> Draft </Button>}
			{ route === 'invites' ? <Button color="red">Invites</Button> : 
			  <Button onClick={() => setRoute("invites")}>Invites</Button>}
			{/* { route === 'settings' ? <Button color="red">Settings</Button> : */} 
			{/* 	<Button onClick={() => setRoute("settings")}>Settings</Button>} */}
		</Box>
	)
}

export default Topbar;
