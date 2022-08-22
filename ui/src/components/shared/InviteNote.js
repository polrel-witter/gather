import React, { Component, useState} from 'react';
import { Text, Box, Button, StatelessTextArea } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { fetchMyInvite } from "../../utils";
import { v4 as uuidv4 } from 'uuid';

const InviteNote = (props) => {
	const inviteState = useStore((state) => state.inviteState);
	const myInvite = useStore(state => fetchMyInvite(state.invites));
	const pSendInvite = useStore((state) => state.pSendInvite);
	const pEditInvite = useStore((state) => state.pEditInvite);
	const inviteExists = myInvite === undefined ? false : true;
	console.log(uuidv4());
	return (
			<Box borderBottom={1}>
				<Box>
					<Text> InviteNote </Text>
				</Box>
				<Text> Include details such as location, date, and time </Text>
				{
					{
						default: <Button onClick={() => {pSendInvite({id: uuidv4(), note: props._inviteNote}); props._setInviteNote("")}}>Send</Button>,
						started: (
							<span>
								<Button onClick={() => pEditInvite('cancel', myInvite.id)}>Cancel</Button>
								<Button onClick={() => pEditInvite('finalize', myInvite.id)}>Finalize</Button>
							</span>
						),
						finalized: 
							<span>
							<Button onClick={() => pEditInvite('cancel', myInvite.id)}>Cancel</Button>,
							<Button onClick={() => pEditInvite('done', myInvite.id)}>Done</Button>,
							</span>
					}[inviteState]
				}
				{/* TODO freezee TextArea if finalized */}
				<StatelessTextArea
					rows={1}
					// value={inviteEmpty ? _inviteNote : myInvite.note}
					value={inviteExists ? 'hello' : props._inviteNote}
					onChange={(e) => props._setInviteNote(e.currentTarget.value)}
				>
					>
				</StatelessTextArea>
			</Box>
	)
}

export default InviteNote;
