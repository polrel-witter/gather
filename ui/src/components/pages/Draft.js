import React, { Component, useState } from 'react';
import StatusGang from "./StatusGang"
import StatusForeignShips from "./StatusForeignShips"
import { useStore } from '../../data/store';
import { Text, Box, Button, StatelessTextArea, StatelessTextInput, StatelessRadioButtonField, RadioButton, Menu, MenuButton, Icon, MenuList, MenuItem} from "@tlon/indigo-react";
import { fetchPendingInvites, fetchAcceptedInvites, dedup, createInvitee, toggleSelect, deleteInvitee} from '../../utils';

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

const MyLocation = () => {
	const pPosition = useStore(state => state.pPosition);
	const pAddress = useStore(state => state.pAddress);
	const address = { street: "street2", city: "Austin", state: "Texas", country: "USA2", zip: "111112" };
	const position = { lon: 43, lat: 11};
			
	// }
	return (
		<Box border={1}>
		<Text display="block"> My Location </Text>
		<Text display="block"> 
			Used to retrieve location coordinates,
			and is shared with Gang members when Status is turned on. 
		</Text>
  <StatelessTextArea rows={1} value={address.street + ' ,' + address.city + ' ,' + address.state + ' ,' + address.country + ' ,' + address.zip}
	>
  </StatelessTextArea>
		<Button onClick={() => {pAddress('address', address); pPosition('position', position)}}>Set</Button>
		</Box>
	 );
}

const Draft = () => {
	const route = useStore(state => state.route);
	const pSendInvite = useStore(state => state.pSendInvite);
	const pDeny = useStore(state => state.pDeny);
	const [desc, setDesc] = useState("My Super Description");
	const [locationType, setLocationType] = useState('meatspace');
	const [radius, setRadius] = useState(0);
	const [accessLink, setAccessLink] = useState('');
	const [position, setPosition] = useState({lon: 0, lat: 0});
	const [address, setAddress] = useState({ street: "street2", city: "Austin", state: "Texas", country: "USA2", zip: "111112" });
	const [maxAccepted, setMaxAccepted] = useState(0);
	const [inviteeSearch, setInviteeSearch] = useState("");
	const [invitees, setInvitees] = useState([]);
	return (
		<Box>
			<MyLocation/>
			<MyRadius/>
			<Button onClick={() => {
				if (invitees.filter(i => i.selected).length !== 0)
					pSendInvite(
				{ 
					"send-to": invitees.filter(i => i.selected).map(i => i.patp),
					"location-type": accessLink,
					"position": position,
					"address": address,
					"access-link": accessLink,
					"radius": radius,
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
			<Box border={1}>
				<Button>Select Date</Button>
				<Button>Select Time</Button>
			</Box>
			<Box border={1}>
				<Text> Set access link to event </Text>
				<StatelessTextInput
					display="block"
					value={accessLink}
					onChange={(e) => {setAccessLink(e.currentTarget.value);}}
				/>
			</Box>
			<Box border={1}>
				<Text>Invite Location:</Text>
				<StatelessTextInput/>
				<StatelessTextInput/>
				<StatelessTextInput/>
      	<Menu>
      	  <MenuButton width="100%" justifyContent="space-between">
      	    Country
      	    <Icon ml="2" icon="ChevronSouth" />
      	  </MenuButton>
      	  <MenuList>
      	    <MenuItem onSelect={() => console.log("Command 1")}>
      	      Command 1
      	    </MenuItem>
      	    <MenuItem onSelect={() => console.log("Command 2")}> Command 2
      	    </MenuItem>
      	    <MenuItem onSelect={() => console.log("Command 3")}>
      	      Command 3
      	    </MenuItem>
      	  </MenuList>
      	</Menu>
			</Box>
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
			<Box border={1}>
			<Text>Search ships to invite </Text>
			<StatelessTextInput onChange={(e) => setInviteeSearch(e.currentTarget.value)}/>
			<Button onClick={() => setInvitees(dedup('patp', createInvitee(inviteeSearch, invitees)))}>Add</Button>
			<Button onClick={() => {}}>Create Custom Group</Button>
			{/* <Text>Select groups to invite</Text> */}
			{/* <StatelessTextInput/> */}
			<Text>Invitees</Text>
			{ invitees.map(invitee =>
			<Box>
				{ invitee.type === 'ship' &&
				<Box>
				<Text>{invitee.patp}</Text>
					{ invitee.selected &&
					<Icon ml="2" icon="Smiley" onClick = {() => setInvitees(toggleSelect(invitee.patp, invitees))}/>
					}
					{ !invitee.selected &&
					<Icon ml="2" icon="ArrowExternal" onClick = {() => setInvitees(toggleSelect(invitee.patp, invitees))}/>
					}
					<Icon ml="2" icon="X" onClick = {() => setInvitees(deleteInvitee(invitee.patp, invitees))}/>
				</Box>
				}
			</Box>
				)
			}
			</Box>
		</Box>
	)
}

export default Draft;
