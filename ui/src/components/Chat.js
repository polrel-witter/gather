import React, { Component, useState } from "react";
import { useStore } from "../data/store";
import { useAlert } from "react-alert";
import Location from "./Location";
const Chat = (props) => {
	const invites = useStore((state) => state.invites);
	const inviteDetails = useStore((state) => state.inviteDetails);
	const _invite = invites.filter((x) => x.id === inviteDetails)[0];
	const invite = _invite.invite;
	const setInviteMode = useStore((state) => state.setInviteMode);
	const pPost = useStore((state) => state.pPost);
	const [note, setNote] = useState("");

	return (
		<div className="chat">
			<button onClick={() => setInviteMode("view")}>Return</button>
			<div className="chat-messages">
				{invite.chat.map((chat) => (
					<div className='chat-message-message'>
						{chat.wat}
						<br/>
						==================
					</div>
				))}
			</div>
			<div className="chat-post">
				<textarea onChange={(e) => setNote(e.currentTarget.value)} />
				<button onClick={() => pPost({ id: _invite.id, note })}>Post</button>
			</div>
		</div>
	);
};

export default Chat;
