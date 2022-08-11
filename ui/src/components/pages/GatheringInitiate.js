import React, { Component } from 'react';
import { Text, Box } from "@tlon/indigo-react";
import InviteNote from "../shared/InviteNote";
import InviteSearch from "../shared/InviteSearch";
import InviteLimit from "../shared/InviteLimit";
import Invites from "../shared/Invites";
import { useStore } from '../../data/store';

const GatherInitiate = (state) => {
	const inviteState = useStore(state => state.inviteState);
		return (
			<Box>
			<InviteNote/>
			<InviteSearch/>
			<InviteLimit/>
			<Invites/>
			</Box>
		)
}

export default GatherInitiate;
