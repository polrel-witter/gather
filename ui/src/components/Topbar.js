import React, { Component } from 'react';
import { Text, Box } from "@tlon/indigo-react";
import { useStore } from '../data/store';

const Topbar = () => {
	const route = useStore(state => state.route);
	const setRoute = useStore(state => state.setRoute);
	return (
		<div className='topbar'>
			{ route === 'draft' ? <button className='topbar-buttonselected'>Draft</button> : 
			<button className='topbar-button' onClick={() => setRoute("draft")}> Draft </button>}
			{ route === 'invites' ? <button className='topbar-buttonselected'>Invites</button> : 
			  <button className='topbar-button' onClick={() => setRoute("invites")}>Invites</button>}
			{ route === 'settings' ? <button className='topbar-buttonselected'>Settings</button> : 
				<button className='topbar-button' onClick={() => setRoute("settings")}>Settings</button>}
		</div>
	)
}

export default Topbar;
