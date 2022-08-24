import React, { Component } from 'react';
import StatusGang from "./StatusGang"
import StatusForeignShips from "./StatusForeignShips"
import { useStore } from '../../data/store';
import { Text, Box, Button, StatelessTextArea, StatelessTextInput, StatelessRadioButtonField, RadioButton, Menu, MenuButton, Icon, MenuList, MenuItem} from "@tlon/indigo-react";
  
import { fetchPendingInvites, fetchAcceptedInvites } from '../../utils';

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
	return (
		<Box>
		<Button>Cancel</Button>
		<Button>Send</Button>
		<Text>Title</Text>
			<StatelessTextInput/>
		<Text>Note</Text>
			<StatelessTextArea/>
			<Text>Happening in: </Text>
				<StatelessRadioButtonField> MeatSpace </StatelessRadioButtonField>
				<StatelessRadioButtonField> Virtual </StatelessRadioButtonField>
			<Box> 
				<DateSelector/>
			</Box>
			<Text>Location:</Text>
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
          <MenuItem onSelect={() => console.log("Command 2")}>
            Command 2
          </MenuItem>
          <MenuItem onSelect={() => console.log("Command 3")}>
            Command 3
          </MenuItem>
        </MenuList>
      </Menu>
			<StatelessTextInput/>
			<Text>Restrict delivery radius to 
      <Menu>
        <MenuButton width="100%" justifyContent="space-between">
          Country
          <Icon ml="2" icon="ChevronSouth" />
        </MenuButton>
        <MenuList>
          <MenuItem onSelect={() => console.log("Command 1")}>
            Command 1
          </MenuItem>
          <MenuItem onSelect={() => console.log("Command 2")}>
            Command 2
          </MenuItem>
          <MenuItem onSelect={() => console.log("Command 3")}>
            Command 3
          </MenuItem>
        </MenuList>
      </Menu>
				miles within location address
			</Text>
			<Box>
			<Text> Limit number of RSVPs you'll accept 
      <Menu>
        <MenuButton width="100%" justifyContent="space-between">
          Country
          <Icon ml="2" icon="ChevronSouth" />
        </MenuButton>
        <MenuList>
          <MenuItem onSelect={() => console.log("Command 1")}>
            Command 1
          </MenuItem>
          <MenuItem onSelect={() => console.log("Command 2")}>
            Command 2
          </MenuItem>
          <MenuItem onSelect={() => console.log("Command 3")}>
            Command 3
          </MenuItem>
        </MenuList>
      </Menu>
			</Text>
			</Box>
			<Text>Search ships to invite </Text>
			<StatelessTextInput/>
			<Text>Select groups to invite</Text>
			<StatelessTextInput/>
			<Text>Invitees</Text>
		</Box>
	)
}

export default Draft;
