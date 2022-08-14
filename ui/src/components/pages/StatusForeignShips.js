import React, { Component } from 'react';
import { Text, Box } from "@tlon/indigo-react";
import StatusForeignShip from "../shared/StatusForeignShip";

const StatusForeignShips = (props) => {
	return(
		<Box>
		<Text> Foreign Ships </Text>
		<StatusForeignShip/>
		</Box>
	);
}

export default StatusForeignShips;
