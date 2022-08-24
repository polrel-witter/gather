const myShip = "pontus-fadpun";
export const fetchMyInvites = (invites) => {
	// return invites.filter(x => x.initShip === window.urbit.ship)[0];
	return invites.filter(x => x.initShip === window.urbit.ship);
}

export const fetchReceivedShips = (invites) => {
	return invites.filter(x => {
		const myInviteInReceivedShips = x.receivedShips.filter(y => y._ship === myShip)[0];
		console.log(myInviteInReceivedShips);
		if(myInviteInReceivedShips !== undefined)
			return true;
		return false;
	})
};

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

export const doPoke = (jon, succ, err) => {
	console.log(jon);
	console.log(succ);
    window.urbit.poke({
      app: "gather",
      mark: "gather-action",
      json: jon,
      onSuccess: succ,
      onError: err,
    })
}

export const subscribe = (path, handler) => {
  window.urbit.subscribe({
    app: "gather",
    path: path,
    event: handler
  });
}
