import React, { Component, useState } from 'react';
import { Text, Box, Button, StatelessTextInput } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { fetchGangMembers } from '../../utils';

// TODO whole thing
const GangMembers = (props) => {
	return(
		<Box border={1}>
		{/* <Text>Gang Members</Text> */}
		{/* <Text>Select default ships to which you’re willing to send your Status. Clicking Pause will temporarily stop sending your Status to a ship, but you will still receive theirs.  </Text> */}
  	{/* <StatelessTextInput/> */}
		{/* <Button onClick={() => pShareStatus(_gangMember)}>Add</Button> */}
		{/* 	{ gangMembers.map(gangMember => { */}
		{/* 		return ( */}
		{/* 		<Box> */}
		{/* 			<Text>{gangMember._ship}</Text> */}
		{/* 			{/1* <Button onClick={() => pauseGangMember(_gangMember)}>Pause</Button> *1/} */}
		{/* 			{/1* <Button onClick={() => removeGangMember(_gangMember)}>Remove</Button> *1/} */}
		{/* 		</Box> */}
		{/* 		) */}
		{/* 	})} */}
		</Box>
	 );
}

export default GangMembers;
