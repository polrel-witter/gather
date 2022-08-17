import React, { Component, useState} from 'react';
import { Text, Box, Button, StatelessTextInput, Menu, MenuButton, MenuList, MenuItem , Icon} from "@tlon/indigo-react";

const InviteSearch = (state) => {
	const [_inviteSearch, _setInviteSearch] = useState("sampel-palnet");
	return(
		<Box borderBottom={1}>
		<Text> Search </Text>
  	<StatelessTextInput
			/>
		<Button>Add</Button>
		</Box>
	 );
}

export default InviteSearch;
