import React, { Component } from 'react';
import { Text, Box } from "@tlon/indigo-react";
import PendingInvites from "../shared/PendingInvites";
import AcceptedInvites from "../shared/AcceptedInvites";

const GatheringReceived = (props) => {
	return(
		<Box>
			<PendingInvites/>
			<AcceptedInvites/>
		</Box>
	);
}

export default GatheringReceived;
