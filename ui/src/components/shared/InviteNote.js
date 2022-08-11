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
	const [_inviteNote, _setinviteNote] = useState(myInvite.inviteNote);

	return(
		<Box borderBottom={1}>
		<Box>
		<Text> InviteNote </Text>
		</Box>
		<Text> Include details such as location, date, and time </Text>
			{
				{
					"default": <Button onClick={() => sendGathering(props.invite)}>Start</Button>,
					"started": <span> 
										 	<Button>Cancel</Button>
										 	<Button>Finalize</Button>
										 </span>,
					"finalized": <Button>Cancel</Button>
				}[inviteState]
			}
	{/* TODO freezee TextArea if finalized */}
  <StatelessTextArea rows={1} value={_inviteNote}
		onChange={(e) => _setinviteNote(e.currentTarget.value)}>
	>
  </StatelessTextArea>
	{
				{
					"default": <Button onClick={() => setMyInviteNote(_inviteNote)}>Edit</Button>,
					"started": <Button onClick={() => setMyInviteNote(_inviteNote)}>Edit</Button>,
				}[inviteState]
			}	
	</Box>
	 );
}

export default InviteNote;
