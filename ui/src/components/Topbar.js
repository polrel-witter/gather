import React, { Component } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import { useStore } from '../data/store';

const Topbar = () => {
	const route = useStore(state => state.route);
	const setRoute = useStore(state => state.setRoute);
	return (
		<Box display='flex' justifyContent='center'>
			{ route === 'draft' ? <Button width='100%' color="red">Draft</Button> : 
			<Button width='100%' onClick={() => setRoute("draft")}> Draft </Button>}
			{ route === 'invites' ? <Button width='100%' color="red">Invites</Button> : 
			  <Button width='100%' onClick={() => setRoute("invites")}>Invites</Button>}
			{ route === 'settings' ? <Button width='100%' color="red">Settings</Button> : 
				<Button width='100%' onClick={() => setRoute("settings")}>Settings</Button>}
		</Box>
	)
}

export default Topbar;
