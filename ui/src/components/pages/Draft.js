import React, { Component, useState } from 'react';
import StatusGang from "./StatusGang"
import StatusForeignShips from "./StatusForeignShips"
import { useStore } from '../../data/store';
import { Text, Box, Button, StatelessTextArea, StatelessTextInput, StatelessRadioButtonField, RadioButton, Menu, MenuButton, Icon, MenuList, MenuItem} from "@tlon/indigo-react";
  
import { fetchPendingInvites, fetchAcceptedInvites, dedup, createInvitee, toggleSelect, deleteInvitee} from '../../utils';

const DateSelector = () => {
	return (
	<Box>
	<Button>Select Date</Button>
	<Button>Select Time</Button>
	</Box>
	)
}

const Draft = () => {
	const route = useStore(state => state.route);
	const pSendInvite = useStore(state => state.pSendInvite);
	const pDeny = useStore(state => state.pDeny);
	const [desc, setDesc] = useState("My Super Description");
	const [maxAccepted, setMaxAccepted] = useState(0);
	const [inviteeSearch, setInviteeSearch] = useState("");
	const [invitees, setInvitees] = useState([]);
	return (
		<Box>
			<Button onClick={() => {
				if (invitees.filter(i => i.selected).length !== 0)
					pSendInvite({ "max-accepted": maxAccepted, "desc": desc, 
					"send-to": invitees.filter(i => i.selected).map(i => i.patp) })
			}}>Send</Button>
		{/* <Text>Title</Text> */}
		{/* 	<StatelessTextInput/> */}
		<Text>Description</Text>
			<StatelessTextArea onChange={(e) => setDesc(e.currentTarget.value)}/>
		{/* <Text>Happening in: </Text> */}
		{/* 		<StatelessRadioButtonField> MeatSpace </StatelessRadioButtonField> */}
		{/* 		<StatelessRadioButtonField> Virtual </StatelessRadioButtonField> */}
			{/* <Box> */} 
			{/* 	<DateSelector/> */}
			{/* </Box> */}
			{/* <Text>Location:</Text> */}
			{/* <StatelessTextInput/> */}
			{/* <StatelessTextInput/> */}
			{/* <StatelessTextInput/> */}
      {/* <Menu> */}
      {/*   <MenuButton width="100%" justifyContent="space-between"> */}
      {/*     Country */}
      {/*     <Icon ml="2" icon="ChevronSouth" /> */}
      {/*   </MenuButton> */}
      {/*   <MenuList> */}
      {/*     <MenuItem onSelect={() => console.log("Command 1")}> */}
      {/*       Command 1 */}
      {/*     </MenuItem> */}
      {/*     <MenuItem onSelect={() => console.log("Command 2")}> */}
      {/*       Command 2 */}
      {/*     </MenuItem> */}
      {/*     <MenuItem onSelect={() => console.log("Command 3")}> */}
      {/*       Command 3 */}
      {/*     </MenuItem> */}
      {/*   </MenuList> */}
      {/* </Menu> */}
			{/* <StatelessTextInput/> */}
			{/* <Text>Restrict delivery radius to */} 
      {/* <Menu> */}
        {/* <MenuButton width="100%" justifyContent="space-between"> */}
          {/* Country */}
          {/* <Icon ml="2" icon="ChevronSouth" /> */}
        {/* </MenuButton> */}
        {/* <MenuList> */}
          {/* <MenuItem onSelect={() => console.log("Command 1")}> */}
            {/* Command 1 */}
          {/* </MenuItem> */}
          {/* <MenuItem onSelect={() => console.log("Command 2")}> */}
            {/* Command 2 */}
          {/* </MenuItem> */}
          {/* <MenuItem onSelect={() => console.log("Command 3")}> */}
            {/* Command 3 */}
          {/* </MenuItem> */}
        {/* </MenuList> */}
      {/* </Menu> */}
			{/* 	miles within location address */}
			{/* </Text> */}
			<Box>
			<Text> Limit number of RSVPs you'll accept 
			<StatelessTextInput value={maxAccepted} onChange={(e) => 
				{
					const re = /^[0-9\b]+$/;
					if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
						setMaxAccepted(Number(e.currentTarget.value));
				}}/>
			</Text>
			</Box>
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
	)
}

export default Draft;
