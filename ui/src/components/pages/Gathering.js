import React, { Component } from 'react';
import GatheringInitiate from "./GatheringInitiate"
import GatheringReceived from "./GatheringReceived"
import { useStore } from '../../data/store';

const Gathering = () => {
	const route = useStore(state => state.route);
	switch(route) {
		case "gather-init":
			return (
			<GatheringInitiate/>
			);
		break;
		case "gather-received":
			return (
			<GatheringReceived/>
			);
		break;
	}
}

export default Gathering;
