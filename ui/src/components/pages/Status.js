import React, { Component } from 'react';
import StatusGang from "./StatusGang"
import StatusForeignShips from "./StatusForeignShips"
import { useStore } from '../../data/store';
import { fetchPendingInvites, fetchAcceptedInvites } from '../../utils';

const Status = () => {
	const route = useStore(state => state.route);
	switch(route) {
		case "status-gang":
			return (
			<StatusGang/>
			);
		break;
		case "status-foreign":
			return (
			<StatusForeignShips/>
			);
		break;
	}
}

export default Status;
