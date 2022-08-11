import React, { Component } from 'react';
import { Text, Box, Button, StatelessTextInput, Menu, MenuButton, MenuList, MenuItem , Icon} from "@tlon/indigo-react";

const InviteLimit = (state) => {
	return(
		<Box borderBottom={1}>
		<Text> Limit </Text>
		<Box>
  	<StatelessTextInput/>
		<Text> Invitees can accept </Text>
		</Box>
		</Box>
	 );
}

export default InviteLimit;
