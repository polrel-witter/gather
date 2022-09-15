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
import { useAlert } from 'react-alert'

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
	const alert = useAlert()
	return (
		<Box>
			<Button onClick={() => {
				if (collections.filter(i => i.collection.selected).length !== 0) {
					console.log('collections----');
					console.log(collections.filter(i => i.collection.selected).reduce((prev, curr) => prev.concat(curr.collection.members), []));
					alert.show(<div style={{ color: 'green' }}>Invite Sent</div>);
					// alert.show('hello');
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
				<Text 
					pr={5}
					mr='auto'
				>Happening in: </Text>
				<StatelessRadioButtonField
					px={2}
					selected={locationType === 'meatspace'}
          onChange={() => { setLocationType('meatspace') }}
				> Meat Space </StatelessRadioButtonField>
				<StatelessRadioButtonField
					px={2}
					selected={locationType === 'virtual'}
          onChange={() => { setLocationType('virtual') }}
				> Virtual Space</StatelessRadioButtonField>
			</Box>
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
				<Box
					width='100%'
				>
				<Text 
					display='inline'
					px={px}
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
				</Box>
				<Box
					width='100%'
				>
				<Text px={px}> Number of participants:
				</Text>
				<StatelessTextInput value={maxAccepted} onChange={(e) => 
					{
						const re = /^[0-9\b]+$/;
						if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
							setMaxAccepted(Number(e.currentTarget.value));
					}}/>
				</Box>
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
			//		px={px}
			//		py={py}
					m={1}
				>
				<Text
					pr={5}
					mr='auto'
				>
					{collection.collection.title
					}</Text>
					{ collection.collection.selected &&
						<Button 
							// px={2}

							onClick={() => pEditCollection(toggleSelect(collection.id, collections))}>Unselect</Button>
					}
					{ !collection.collection.selected &&
						<Button 
							// px={2}
						onClick={() => pEditCollection(toggleSelect(collection.id, collections))}>Select</Button>
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
