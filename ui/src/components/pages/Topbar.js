import React, { Component } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import TopButtons from '../shared/TopButtons';
import { useStore } from '../../data/store';

const Topbar = () => {
	const route = useStore(state => state.route);
	const setRoute = useStore(state => state.setRoute);
	return (
		<Box display='flex' justifyContent='center'>
			{ route === 'draft' ? <Button color="blue">Draft</Button> :
			<Button onClick={() => setRoute("draft")}> Draft </Button>}
			{ route === 'invites' ? <Button color="blue">Invites</Button> :
			  <Button onClick={() => setRoute("invites")}>Invites</Button>}
			{ route === 'settings' ? <Button color="blue">Settings</Button> :
				<Button onClick={() => setRoute("settings")}>Settings</Button>}
		</Box>
	)
}

export default Topbar;
