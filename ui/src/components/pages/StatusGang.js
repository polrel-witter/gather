import React, { Component, useState } from 'react';
import { Text, Box } from "@tlon/indigo-react";
import StatusNote from "../shared/StatusNote";
import GangMember from "../shared/GangMember";
import { useStore } from '../../data/store';
import { fetchGangMembers } from '../../utils';

const StatusGang = (props) => {
	const statusState = useStore(state => state.statusState);
	const gangMembers = useStore(state => fetchGangMembers(state.ships));
	return(
		<Box>
			<StatusNote/>
			{
				{
					"on": <Box>	{gangMembers.map( gangMember => <GangMember {...gangMember}/>) } </Box>,
				 "off": <Text> Turn status on </Text>
				}[statusState]
			}
		</Box>
	);
}

export default StatusGang;
