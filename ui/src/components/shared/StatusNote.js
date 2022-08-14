import React, { Component, useState } from 'react';
import { Text, Box, StatelessTextArea, Button} from "@tlon/indigo-react";
import { useStore } from '../../data/store';

const StatusNote = (state) => {
	// TODO shouldn't be pontus-fadpun but the actual ship
	const statusNote = useStore(state => state.ships.filter(x => x.initShip === "pontus-fadpun"))[0];
	const setStatusNote = useStore(state => state.setStatusNote);
	const [_statusNote, _setStatusNote] = useState(statusNote);
	return(
		<Box>
		<Text> StatusNote </Text>
  	<StatelessTextArea rows={1} value={_statusNote}
			onChange={(e) => _setStatusNote(e.currentTarget.value)}>
		>
  	</StatelessTextArea>
		<Button onClick={() => setStatusNote(_statusNote)}>Edit</Button>
		</Box>
	 );
}

export default StatusNote;
