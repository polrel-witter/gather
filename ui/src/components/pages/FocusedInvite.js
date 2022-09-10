import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button, StatelessTextInput} from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { patpValidate } from '../../utils';

const FocusedInvite = (props) => {
	const invite = props.invite;
	const focusInvite = props.focusInvite;
	const pAddReceiveShip = useStore(state => state.pAddReceiveShip);
	const pDelReceiveShip = useState(state => state.pAddReceiveShip);
	const [search, setSearch] = useState("");
			
	return (
		<Box>
			<Box border={1}>
				<StatelessTextInput onChange={(e) => setSearch(e.currentTarget.value)}/>
				<Button onClick={() => {
					if(patpValidate(search))
						pAddReceiveShip(invite.id, search);
				}}>Add</Button>
			</Box>
			<Box>
				{invite.desc}
				<Button onClick={ () => focusInvite({})}>Edit Description</Button>
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
				console.log('invitereceive---');
				console.log(invite);
				return (
				<Box border={1}>
					<Box><Text>{receiveShip.ship}</Text></Box>
					<Box><Text>{receiveShip.shipInvite}</Text></Box>
					<Button onClick={() => pDelReceiveShip(invite.id, receiveShip.ship)}>Uninvite Ship</Button>
				</Box>
				)
			})}
			{/* <Button onClick={focusInvite({})}>Return</Button> */}
		</Box>
	 );
}
export default FocusedInvite;
