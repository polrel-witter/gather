import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button, StatelessTextInput } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import Location from '../shared/Location';
import { patpValidate } from '../../utils';
import { useAlert } from 'react-alert'

const MyRadius = () => {
	const radius = useStore(state => state.settings.radius);
	const [_radius, _setRadius] = useState(radius);
	const pRadius = useStore(state => state.pRadius);

	return(
		<Box border={1}>
		<Text display="block">My Radius</Text>
		<Text display="block">
		Distance within which you’re willing to receive Statuses.
	  Shared with Gang members when Status is turned on.
		</Text>
		<Text >Miles:</Text>
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
	 );
}

const Radius = () => {
	const radius = useStore(state => state.settings.radius);
	const [_radius, _setRadius] = useState(radius);
	const pRadius = useStore(state => state.pRadius);

	return(
		<Box borderBottom={1}>
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
		// const banned = [];
		const pUnban = useStore(state => state.pUnban);
		const pBan = useStore(state => state.pBan);
		const [banSearch, setBanSearch] = useState("");
		const alert = useAlert();
		return (
		<Box border={1}>
			<Text> Banned Ships </Text>
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
			{
					banned.map(ship =>
					<Box>
					{ship}
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
	const pAddress = useStore(state => state.pAddress);
	const pPosition = useStore(state => state.pPosition);
	return(
		<Box>
				<Location setAddress={pAddress} setPosition={pPosition}/>
				<MyRadius/>
				<Banned/>
		</Box>
	 );
}

export default Settings;
