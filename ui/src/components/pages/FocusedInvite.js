import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button, StatelessTextInput} from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { patpValidate } from '../../utils';

const FocusedInvite = (props) => {
	const invite = props.invite;
	const focusInvite = props.focusInvite;
	const pAddReceiveShip = props.pAddReceiveShip;
	const [search, setSearch] = useState("");
			
	return (
		<Box>
			<Box border={1}>
				<StatelessTextInput onChange={(e) => setSearch(e.currentTarget.value)}/>
				<Button onClick={() => {
					if( patpValidate(search))
						pAddReceiveShip(invite.id, search)
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
				<Box border={1}>
					<Text>{receiveShip.ship}</Text>
					<Text>{receiveShip.shipInvite}</Text>
					<Button onClick={() => focusInvite({})}>UnInvite</Button>
				</Box>
			})}
			{/* <Button onClick={focusInvite({})}>Return</Button> */}
		</Box>
	 );
}
export default FocusedInvite;
