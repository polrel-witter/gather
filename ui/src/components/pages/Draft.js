import React, { Component, useState } from 'react';
import StatusGang from "./StatusGang"
import StatusForeignShips from "./StatusForeignShips"
import Location from '../shared/Location';
import Collection from "./Collection"
import { useStore } from '../../data/store';
import { Text, Box, Button, StatelessTextArea, StatelessTextInput, StatelessRadioButtonField, RadioButton, Menu, MenuButton, Icon, MenuList, MenuItem} from "@tlon/indigo-react";
import { fetchPendingInvites, fetchAcceptedInvites, dedup, createGroup, toggleSelect, deleteGroup} from '../../utils';
import * as Nominatim from 'nominatim-browser';
// import {Geolookup} from 'react-geolookup';

const Draft = () => {
	const route = useStore(state => state.route);
	const pSendInvite = useStore(state => state.pSendInvite);
	const pDeny = useStore(state => state.pDeny);
	const pCreateCollection = useStore(state => state.pCreateCollection);
	const pModifyCollection = useStore(state => state.pCreateCollection);
	const pDeleteCollection = useStore(state => state.pCreateCollection);
	const [desc, setDesc] = useState("");
	const [locationType, setLocationType] = useState('meatspace');
	const [radius, setRadius] = useState(0);
	const [accessLink, setAccessLink] = useState('');
	const [position, setPosition] = useState({lat: '.0', lon: '.0'});
	const [address, setAddress] = useState('');
	const [maxAccepted, setMaxAccepted] = useState(0);
	const [groupSearch, setGroupSearch] = useState("");
	const collections = useStore(state => state.settings.collections);
	const [customGroupName, setCustomGroupName] = useState('');
	return (
		<Box>
			<Button onClick={() => {
				if (collections.filter(i => i.selected).length !== 0)
					console.log('collections----');
					console.log(collections);
					pSendInvite(
				{ 
					//TODO reduce
					"send-to": collections.filter(i => i.selected).map(i => i.members[0]),
					"location-type": locationType,
					"position": position,
					"address": address,
					"access-link": '~.' + accessLink,
					"radius": '.' + radius,
					"max-accepted": maxAccepted, 
					"desc": desc,
				})
			}}>Send</Button>
			<Box border={1}>
				<Text>Description</Text>
				<StatelessTextArea onChange={(e) => setDesc(e.currentTarget.value)}/>
			</Box>
			<Box border={1}>
				<Text>Happening in: </Text>
				<StatelessRadioButtonField
					selected={locationType === 'virtual'}
          onChange={() => { setLocationType('virtual') }}
				> MeatSpace </StatelessRadioButtonField>
				<StatelessRadioButtonField
					selected={locationType === 'meatspace'}
          onChange={() => { setLocationType('meatspace') }}
				> Virtual </StatelessRadioButtonField>
			</Box> 
			{/* <Box border={1}> */}
			{/* 	<Button>Select Date</Button> */}
			{/* 	<Button>Select Time</Button> */}
			{/* </Box> */}
			<Box border={1}>
				<Text> Set access link to event </Text>
				<StatelessTextInput
					display="block"
					value={accessLink}
					onChange={(e) => {setAccessLink(String(e.currentTarget.value));}}
				/>
			</Box>
			
			<Location 
				address={address} 
				position={position} 
				setAddress={setAddress} 
				setPosition={setPosition}
			/>
			<Box border={1}>
				<Text>Restrict delivery radius to 
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
					miles within location address
				</Text>
				</Box>
			<Box border={1}>
				<Text> Limit number of RSVPs you'll accept 
				<StatelessTextInput value={maxAccepted} onChange={(e) => 
					{
						const re = /^[0-9\b]+$/;
						if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
							setMaxAccepted(Number(e.currentTarget.value));
					}}/>
				</Text>
				</Box>
			========================================
			<Box border={1}>
			<Text>Search ships/groups/collections to invite </Text>
			<StatelessTextInput onChange={(e) => setGroupSearch(e.currentTarget.value)}/>
			<Button onClick={() => {
				if(createGroup(groupSearch, collections) !== null)
					pCreateCollection(createGroup(groupSearch, collections));
				}}>New Collection</Button>
			<Text>Ships/Groups/Collections to invite</Text>
			{/* { collections.length !== 0 && collections.map(collection => */}
			{/* <Box> */}
			{/* 	<Box> */}
			{/* 	<Text>{collection.members[0]}</Text> */}
			{/* 		{ collection.selected && */}
			{/* 		<Icon ml="2" icon="Smiley" onClick = {() => pModifyCollection(toggleSelect(collection.id, collections))}/> */}
			{/* 		} */}
			{/* 		{ !collection.selected && */}
			{/* 		<Icon ml="2" icon="ArrowExternal" onClick = {() => pModifyCollection(toggleSelect(collection.id, collections))}/> */}
			{/* 		} */}
			{/* 		<Icon ml="2" icon="X" onClick = {() => pDeleteCollection(collection.id)}/> */}
			{/* 	</Box> */}
			{/* </Box> */}
			{/* 	) */}
			{/* } */}
			</Box>
		</Box>
	)
}

export default Draft;
