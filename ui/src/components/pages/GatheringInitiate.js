import React, { Component } from "react";
import { Text, Box } from "@tlon/indigo-react";
import InviteNote from "../shared/InviteNote";
import InviteSearch from "../shared/InviteSearch";
import InviteLimit from "../shared/InviteLimit";
import Invites from "../shared/Invites";
import { useStore } from "../../data/store";

const GatherInitiate = (state) => {
	const inviteState = useStore((state) => state.inviteState);
	const [_inviteNote, _setinviteNote] = useState(myInvite.inviteNote);
	return (
		<Box>
			<Box borderBottom={1}>
				<Box>
					<Text> InviteNote </Text>
				</Box>
				<Text> Include details such as location, date, and time </Text>
				{
					{
						default: <Button onClick={() => pSendInvite({})}>Start</Button>,
						started: (
							<span>
								<Button>Cancel</Button>
								<Button>Finalize</Button>
							</span>
						),
						finalized: <Button>Cancel</Button>,
					}[inviteState]
				}
				{/* TODO freezee TextArea if finalized */}
				<StatelessTextArea
					rows={1}
					value={_inviteNote}
					onChange={(e) => _setinviteNote(e.currentTarget.value)}
				>
					>
				</StatelessTextArea>
				{
					{
						default: (
							<Button onClick={() => setMyInviteNote(_inviteNote)}>Edit</Button>
						),
						started: (
							<Button onClick={() => pEditInvite(_inviteNote)}>Edit</Button>
						),
					}[inviteState]
				}
			</Box>
		</Box>
	);
};

export default GatherInitiate;
{
	/* <InviteNote/> */
}
{
	/* <InviteSearch/> */
}
{
	/* <InviteLimit/> */
}
{
	/* <Invites/> */
}
{
	/* </Box> */
}
