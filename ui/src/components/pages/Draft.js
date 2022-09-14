import React, { Component, useState } from 'react';
import StatusGang from "./StatusGang"
import StatusForeignShips from "./StatusForeignShips"
import Location from '../shared/Location';
import Collection from "./Collection"
import { useStore } from '../../data/store';
import { DisclosureButton, DisclosureBox, Row, Text, Box, Button, StatelessTextArea, StatelessTextInput, StatelessRadioButtonField, RadioButton, Menu, MenuButton, Icon, MenuList, MenuItem} from "@tlon/indigo-react";
import { fetchPendingInvites, fetchAcceptedInvites, dedup, createGroup, toggleSelect, deleteGroup} from '../../utils';
import * as Nominatim from 'nominatim-browser';
// import {Geolookup} from 'react-geolookup';

const px = '1';
const py = '2';

const Draft = () => {
	const route = useStore(state => state.route);
	const pSendInvite = useStore(state => state.pSendInvite);
	const pDeny = useStore(state => state.pDeny);
	const pCreateCollection = useStore(state => state.pCreateCollection);
	const pEditCollection = useStore(state => state.pEditCollection);
	const pDeleteCollection = useStore(state => state.pDeleteCollection);
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
				if (collections.filter(i => i.collection.selected).length !== 0) {
					console.log('collections----');
					console.log(collections.filter(i => i.collection.selected).reduce((prev, curr) => prev.concat(curr.collection.members), []));
					pSendInvite(
				{ 
					//TODO reduce
					"send-to": collections.filter(i => i.collection.selected).reduce((prev, curr) => prev.concat(curr.collection.members), []),
					"location-type": locationType,
					"position": position,
					"address": address,
					"access-link": '~.' + accessLink,
					"radius": '.' + radius,
					"max-accepted": maxAccepted, 
					"desc": desc,
				})}}}>Send</Button>
			<Box borderBottom={1}
				px={px}
				py={py}
			>
				<Text>Description</Text>
				<StatelessTextArea onChange={(e) => setDesc(e.currentTarget.value)}/>
			</Box>
			<Box 
				borderBottom={1}
				px={px}
				py={py}
				display='flex'
				justifyContent='center'
				alignItems='center'
			>
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
			{/* <Box borderBottom={1}> */}
			{/* 	<Button>Select Date</Button> */}
			{/* 	<Button>Select Time</Button> */}
			{/* </Box> */}
			<Box 
				borderBottom={1}
				px={px}
				py={py}
			>
				<Text> Access link to event: </Text>
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
			<Box borderBottom={1}
				px={px}
				py={py}
				display='flex'
				// flexDirection='row'
			>
				{/* <Text mr={90}>Delivery radius (in km): </Text> */}
				<Text 
					display='inline'
				>Delivery radius: </Text>
				<StatelessTextInput
				value={radius}
				onChange={(e) => 
					{
						const re = /^[0-9\b]+$/;
						if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
							setRadius(Number(e.currentTarget.value));
					}}
				/>
				<Text> Number of participants:
				</Text>
				<StatelessTextInput value={maxAccepted} onChange={(e) => 
					{
						const re = /^[0-9\b]+$/;
						if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
							setMaxAccepted(Number(e.currentTarget.value));
					}}/>
			</Box>
			<Box borderBottom={1}
				px={px}
				py={py}
			>
				{/* <Text display='block'>Create New Collection from ship: ~[patp]</Text> */}
				{/* <Text display='block'>Create New Collection from group: ~[patp]/[groupid]</Text> */}
				{/* <Text display='block'>Create Custom Collection: kkk</Text> */}
				<Text>Ships/Groups/Collections to invite:</Text>
				<Box display='flex'>
			<StatelessTextInput onChange={(e) => setGroupSearch(e.currentTarget.value)}/>
			<Button 
				px={7}
				py={1}
				onClick={() => {
					console.log('collec-------');
					console.log(collections);
				if(createGroup(groupSearch, collections) !== null)
					pCreateCollection(createGroup(groupSearch, collections));
				}}>Add</Button>
				</Box>
				<Box
					py={2}
				>
					<Text>Invite List:</Text>
			{ collections !== undefined && collections.length !== 0 && collections.map(collection =>
				<Box 
					display='flex'
					alignItems='center'
					justifyContent='center'
					border={1}
					px={px}
					py={py}
					m={1}
				>
					<Box display='block'>
				<Text>{collection.collection.title}</Text>
					</Box>
					{ collection.collection.selected &&
						<Button onClick={() => pEditCollection(toggleSelect(collection.id, collections))}>Select</Button>
					}
					{ !collection.collection.selected &&
						<Button onClick={() => pEditCollection(toggleSelect(collection.id, collections))}>Unselect</Button>
					}
						<Button onClick={() => pDeleteCollection(collection.id)}>Delete</Button>
				</Box>
				)
			}
				</Box>
			</Box>
		</Box>
	)
}

export default Draft;
