import React, { Component, useState } from "react";
import { Text, Box, Button, StatelessTextArea} from "@tlon/indigo-react";
import InviteNote from "../shared/InviteNote";
import InviteSearch from "../shared/InviteSearch";
import InviteLimit from "../shared/InviteLimit";
import Invites from "../shared/Invites";
import { useStore} from "../../data/store";

const GatherInitiate = (state) => {
	const [_receiveShips, _setReceiveShips] = useState([]);
	const [_maxAccepted, _setMaxAccepted] = useState(10);
	const [_inviteNote, _setInviteNote] = useState("Default Invite");
	return (
		<Box>
			<InviteNote 
				_setInviteNote={_setInviteNote}
				_maxAccepted={_maxAccepted}
				_receiveShips={_receiveShips}
				_inviteNote={_inviteNote}
			/>
			<InviteSearch
				_setReceiveShips={_setReceiveShips}
			/>
			<InviteLimit
				_maxAccepted={_maxAccepted}
				_setMaxAccepted={_setMaxAccepted}
			/>
			<Invites
				_receiveShips={_receiveShips}
				_setReceiveShips={_setReceiveShips}
			/>
		</Box>
	);
};

export default GatherInitiate;
