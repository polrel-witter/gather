import React, { Component, useState } from 'react';
import { Text, Box, StatelessTextArea, Button} from "@tlon/indigo-react";
import { useStore } from '../../data/store';

const TopButtons = (state) => {
	// TODO shouldn't be pontus-fadpun but the actual ship
	const statusNote = useStore(state => state.ships.filter(x => x.initShip === "pontus-fadpun"))[0];
	const setStatusNote = useStore(state => state.setStatusNote);
	const [_statusNote, _setStatusNote] = useState(statusNote);
	const route = useStore(state => state.route);
		switch(route) {
			case "gather-init":
			return(
			<Box>
				<Button>Gather</Button>
				<Button>Status</Button>
				<Button>Settings</Button>
			</Box>
			)
			case "gather-received":
			return(
			<Box>
				<Button>Gather</Button>
				<Button>Status</Button>
				<Button>Settings</Button>
			</Box>
			)
			case "gather-init":
			return(
			<Box>
				<Button>Gather</Button>
				<Button>Status</Button>
				<Button>Settings</Button>
			</Box>
			)
			case "gather-init":
			return(
			<Box>
				<Button>Gather</Button>
				<Button>Status</Button>
				<Button>Settings</Button>
			</Box>
			)
			case "gather-init":
			return(
			<Box>
				<Button>Gather</Button>
				<Button>Status</Button>
				<Button>Settings</Button>
			</Box>
			)
		}
}

export default TopButtons;
