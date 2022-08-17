const myShip = "pontus-fadpun";
export const fetchMyInvite = (invites) => {
	// return invites.filter(x => x.initShip === window.urbit.ship)[0];
	return invites.filter(x => x.initShip === window.urbit.ship)[0];
}

export const fetchPendingInvites = (invites) => {
	return invites.filter(x => {
		const myInviteInReceivedShips = x.receivedShips.filter(y => y._ship === myShip)[0];
		console.log(myInviteInReceivedShips);
		if(myInviteInReceivedShips !== undefined &&
			 myInviteInReceivedShips.inviteStatus === 'pending')
			return true;
		return false;
	})
};

export const fetchAcceptedInvites = (invites) => {
	return invites.filter(x => {
		const myInviteInReceivedShips = x.receivedShips.filter(y => y._ship === myShip)[0];
		console.log(myInviteInReceivedShips);
		if(myInviteInReceivedShips !== undefined &&
			 myInviteInReceivedShips.inviteStatus === 'accepted')
			return true;
		return false;
	})
};

export const fetchGangMembers = (ships) => {
	return ships.filter(x => x.ourGang === true);
};

export const fetchForeignShips = (ships) => {
	return ships.filter(x => (x.ourGang === false && x.theirGang === true));
};

export const doPoke = (jon, succ) => {
	console.log(jon);
	console.log(succ);
    window.urbit.poke({
      app: "gather",
      mark: "hut-do",
      json: jon,
      onSuccess: succ
    })
}
