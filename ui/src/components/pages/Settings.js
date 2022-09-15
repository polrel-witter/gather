import React, { Component, useState } from 'react';
import {StatelessRadioButtonField, Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button, StatelessTextInput } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import Location from '../shared/Location';
import { patpValidate } from '../../utils';
import { useAlert } from 'react-alert'

const px = '1';
const py = '2';

const MyRadius = () => {
	const radius = useStore(state => state.settings.radius);
	const [_radius, _setRadius] = useState(radius);
	const pRadius = useStore(state => state.pRadius);

	return(
		<Box 
			borderBottom={1}
			px={px}
			py={py}
		>
			<Text display="block">My Radius:</Text>
			<Box display='flex'>
		{/* TODO make sure the input is a number */}
		<StatelessTextInput
			display="block"
			value={_radius}
			onChange={(e) =>
				{
					const re = /^[0-9\b]+$/;
					if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
						_setRadius(Number(e.currentTarget.value));
				}}
		>
			</StatelessTextInput>
		<Button onClick={() => pRadius(String(_radius))}>Set</Button>
			</Box>
		</Box>
	 );
}

const Radius = () => {
	const radius = useStore(state => state.settings.radius);
	const [_radius, _setRadius] = useState(radius);
	const pRadius = useStore(state => state.pRadius);

	return(
		<Box borderBottom={1}
			px={px}
			py={py}
			display='flex'
		>
		<Text display="block">Radius</Text>
		<Text display="block">
		Distance within which you’re willing to receive Statuses.
	  Shared with Gang members when Status is turned on.
		</Text>
		<Text >Miles:</Text>
		{/* TODO make sure the input is a number */}
		<StatelessTextInput
			display="block"
			value={_radius}
			onChange={(e) => _setRadius(e.currentTarget.value)}>
			</StatelessTextInput>
		<Button onClick={() => pRadius(String(_radius))}>Set</Button>
		</Box>
	 );
}

const Banned = () => {
		const banned = useStore(state => state.settings.banned);
		const collections = useStore(state => state.settings.collections);
		// const banned = [];
		const pUnban = useStore(state => state.pUnban);
		const pBan = useStore(state => state.pBan);
		const [banSearch, setBanSearch] = useState("");
		const alert = useAlert();
		return (
		<Box
			borderBottom={1}
			px={px}
			py={py}
		>
			<Text> Banned Ships: </Text>
		<Box 
			display='flex'
		>
				<StatelessTextInput
				display="block"
				value={banSearch}
				onChange={(e) =>
					{
						setBanSearch(e.currentTarget.value);
					}}
				/>
			<Button onClick={()=>{
				if(patpValidate(banSearch))
					pBan(banSearch)
					alert.show('You will no longer send or receive invites to/from this ship');
			}}>Ban</Button>
			</Box>
			{ banned.length !== 0 &&
					banned.map(ship => 
					<Box 
						border={1}
						display='flex'
						alignItems='center'
						my={2}
					>
						<Box
							width='100%'
							px={2}
						>
						{ship}
						</Box>
						<Button onClick={()=>{
							pUnban(ship)
							alert.show('You are now open to sending and receiving invites to/from this ship');
						}}>Unban</Button>
					</Box>
			)}
		</Box>
	)
}

const Settings = () => {
	const settings = useStore(state => state.settings);
	const pAddress = useStore(state => state.pAddress);
	const pPosition = useStore(state => state.pPosition);
	const pReceiveInvite = useStore(state => state.pReceiveInvite);
	return(
		<Box>
				<Location 
					address={settings.address} 
					position={settings.position} 
					setAddress={pAddress} 
					setPosition={pPosition}
			/>
				<MyRadius/>
				<Banned/>
		<Box borderBottom={1}
			px={px}
			py={py}
		>
			<Box 
				display='flex'
				justifyContent='center'
			>
			<Text
				px={5}
			>Set onlyinvite/anyone: </Text>
				<StatelessRadioButtonField
					px={5}
					selected={settings.receiveInvite === 'anyone'}
          onChange={() => { pReceiveInvite('anyone') }}
				> Anyone </StatelessRadioButtonField>
				<StatelessRadioButtonField
					px={5}
					selected={settings.receiveInvite === 'only-in-radius'}
          onChange={() => { pReceiveInvite('only-in-radius') }}
				> Only in radius </StatelessRadioButtonField>
			</Box>
		</Box>
		</Box>
	 );
}

export default Settings;
