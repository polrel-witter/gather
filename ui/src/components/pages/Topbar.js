import React, { Component } from 'react';
import { Text, Box, Button } from "@tlon/indigo-react";
import TopButtons from '../shared/TopButtons';
import { useStore } from '../../data/store';

const Topbar = () => {
	const route = useStore(state => state.route);
	switch(route) {
		case "gather-init":
			return (
			<Box>
			<TopButtons/>
				<Box>
			<Button> Initiate (focused)</Button>
			<Button> Received </Button>
				</Box>
			</Box>
			);
		break;
		case "gather-received":
			return (
			<Box>
			<TopButtons/>
				<Box>
			<Button> Initiate (focused)</Button>
			<Button> Received </Button>
				</Box>
			</Box>
			);
		break;
		case "status-gang":
			return (
			<Box>
			<TopButtons/>
				<Box>
			<Button> Initiate (focused)</Button>
			<Button> Received </Button>
				</Box>
			</Box>
			);
		break;
		case "status-foreign":
			return (
			<Box>
			<TopButtons/>
				<Box>
			<Button> Initiate (focused)</Button>
			<Button> Received </Button>
				</Box>
			</Box>
			);
		break;
		case "settings":
			return (
			<Box>
			<TopButtons/>
				<Box>
			<Button> Initiate (focused)</Button>
			<Button> Received </Button>
				</Box>
			</Box>
			);
		break;
	}
}

export default Topbar;
