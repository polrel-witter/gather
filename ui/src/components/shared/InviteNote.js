import React, { Component, useState} from 'react';
import { Text, Box, Button, StatelessTextArea } from "@tlon/indigo-react";
import { useStore } from '../../data/store';

const InviteNote = (props) => {
	const inviteState = useStore(state => state.inviteState);
	// TODO shouldn't be pontus-fadpun but the actual ship
	const myInvite = useStore(state => state.invites.filter(x => x.initShip === "pontus-fadpun"))[0];
	const setMyInviteNote = useStore(state => state.setInviteNote);
	const sendGathering = useStore(state => state.sendGathering);
	const finalizeGathering = useStore(state => state.finalizeGathering);
	const cancelGathering = useStore(state => state.cancelGathering);

	return(
	 );
}

export default InviteNote;
