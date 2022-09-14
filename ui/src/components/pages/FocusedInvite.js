import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button, StatelessTextInput, StatelessRadioButtonField} from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { patpValidate } from '../../utils';
import Location from '../shared/Location';

const FocusedInvite = (props) => {
	const id = props.invite.id;
	const invite = useStore(state => state.invites.filter(x => x.id === id)[0].invite);
	const focusInvite = props.focusInvite;
	const pAddReceiveShip = useStore(state => state.pAddReceiveShip);
	const pDelReceiveShip = useStore(state => state.pDelReceiveShip);
	const [search, setSearch] = useState("");
	//
	const [maxAccepted, setMaxAccepted] = useState(invite.maxAccepted);
	const [desc, setDesc] = useState(invite.desc);
	const [locationType, setLocationType] = useState(invite.locationType);
	const [accessLink, setAccessLink] = useState(invite.accessLink);
	const [radius, setRadius] = useState(invite.radius);
	const pEditMaxAccepted = useStore(state => state.pEditMaxAccepted);
	const pEditDesc = useStore(state => state.pEditDesc);
	const pEditInviteLocation = useStore(state => state.pEditInviteLocation);
	const pEditInvitePosition = useStore(state => state.pEditInvitePosition);
	const pEditInviteAddress = useStore(state => state.pEditInviteAddress);
	const pEditInviteAccessLink = useStore(state => state.pEditInviteAccessLink);
	const pEditInviteRadius = useStore(state => state.pEditInviteRadius);
	if(invite.initShip === '~' + window.urbit.ship && invite.hostStatus === 'sent')	
		return (
		<Box>
			<Box>
				{invite.desc}
				<StatelessTextInput value={desc} onChange={(e) => setDesc(e.currentTarget.value)}/>
				<Button onClick={ () => pEditDesc(id, desc)}>Edit Description</Button>
			</Box>
			<Box>
				{invite.maxAccepted}
				<StatelessTextInput value={maxAccepted} onChange={(e) => 
					{
						const re = /^[0-9\b]+$/;
						if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
							setMaxAccepted(Number(e.currentTarget.value));
					}}/>
				<Button onClick={ () => pEditMaxAccepted(id, maxAccepted)}>Edit Max Accepted</Button>
			</Box>
			<Box border={1}>
				<Text>Happening in: </Text>
				<StatelessRadioButtonField
					selected={locationType === 'virtual'}
          onChange={() => { 
					setLocationType('virtual') 
					pEditInviteLocation(id, 'virtual');
					}}
				> Virtual </StatelessRadioButtonField>
				<StatelessRadioButtonField
					selected={locationType === 'meatspace'}
          onChange={() => { 
						setLocationType('meatspace') 
						pEditInviteLocation(id, 'meatspace');
					}}
				> Meatspace </StatelessRadioButtonField>
			</Box> 
			<Box>
				<Location 
					address={invite.address} 
					position={invite.position} 
					setAddress={(address) => pEditInviteAddress(id, address)} 
					setPosition={(position) => pEditInvitePosition(id, position)} 
				/>
			</Box>
			<Box>
				{invite.accessLink}
				<StatelessTextInput onChange={(e) => setAccessLink(e.currentTarget.value)}/>
				<Button onClick={ () => pEditInviteAccessLink(id, accessLink)}>Edit Access link</Button>
			</Box>
			<Box>
				{invite.radius}
				<StatelessTextInput
				display="block"
				value={radius}
				onChange={(e) => 
					{
						const re = /^[0-9\b]+$/;
						if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
							setRadius(Number(e.currentTarget.value));
					}}
				/>
				<Button onClick={ () => pEditInviteRadius(id, radius)}>Edit Radius</Button>
			</Box>
			<Box border={1}>
				<StatelessTextInput onChange={(e) => setSearch(e.currentTarget.value)}/>
				<Button onClick={() => {
					if(patpValidate(search))
						pAddReceiveShip(id, search);
				}}>Add new ship</Button>
			</Box>
			{ invite.receiveShips.map(receiveShip => {
				return (
				<Box border={1}>
					<Box><Text>{receiveShip.ship}</Text></Box>
					<Box><Text>{receiveShip.shipInvite}</Text></Box>
					<Button onClick={() => {pDelReceiveShip(id, receiveShip.ship)}}>Uninvite Ship</Button>
				</Box>
				)
			})}
			<Button onClick={() => focusInvite({})}>Return</Button>
		</Box>
	 );
		else if(invite.initShip === '~' + window.urbit.ship)
		return (
			<Box>
			{ invite.receiveShips.map(receiveShip => {
				return (
				<Box border={1}>
					<Box><Text>{receiveShip.ship}</Text></Box>
					<Box><Text>{receiveShip.shipInvite}</Text></Box>
				</Box>
				)
			})}
			<Button onClick={() => focusInvite({})}>Return</Button>
			</Box>
		)
	else
		return (
			<Box>
			{ invite.receiveShips.map(receiveShip => {
				return (
				<Box border={1}>
					<Box><Text>{receiveShip.ship}</Text></Box>
					<Box><Text>{receiveShip.shipInvite}</Text></Box>
				</Box>
				)
			})}
			<Button onClick={() => focusInvite({})}>Return</Button>
			</Box>
		)
}
export default FocusedInvite;
