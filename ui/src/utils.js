import haversine from 'haversine-distance';

const myShip = "pontus-fadpun";
export const fetchMyInvites = (invites) => {
	// return invites.filter(x => x.initShip === window.urbit.ship)[0];
	return invites.filter(x => x.invite.initShip === window.urbit.ship);
}

export const properPosition = (position) => {
	if(position !== null)
		return { lat: position.lat.slice(1), lon: position.lon.slice(1) }
	return null;
}

export const filterDistantInvites = (invites, settings) => {
	console.log('============')
	return invites.filter( invite => {
		if( invite.invite.locationType === 'virtual' ||
				settings.receiveInvite === 'anyone'      ||
			  invite.invite.initShip === '~' + window.urbit.ship
		)
			return true;
		const inviteNA = (invite.invite.radius === '0' || invite.invite.position.lon === '500');
		const inviteeNA = (settings.radius === '0' || settings.position.lon === '500');
		const insideInvite = haversine(
		{ latitude: invite.invite.position.lat, longitude: invite.invite.position.lon },
		{ latitude: settings.position.lat, longitude: settings.position.lon }
		) <= settings.radius * 1000;
		const insideInvitee = haversine(
							{ latitude: invite.invite.position.lat, longitude: invite.invite.position.lon },
							{ latitude: settings.position.lat, longitude: settings.position.lon }
		) <= invite.invite.radius * 1000;
		console.log('--------------')
		console.log(invite.invite.desc);
		console.log(haversine(
		{ latitude: invite.invite.position.lat, longitude: invite.invite.position.lon },
		{ latitude: settings.position.lat, longitude: settings.position.lon }
		));
		console.log(settings.radius * 1000);
		console.log(insideInvite)
		console.log(inviteNA)
		console.log(insideInvitee)
		console.log(inviteeNA)
		console.log(settings.position.lon);
		console.log(settings.radius);
		console.log('--------------')
		if(inviteeNA || inviteNA)
			return true;
		if(insideInvite && insideInvitee)
			return true;
		return false;
	})
}

export const fetchReceivedShips = (invites) => {
	return invites.filter(x => x.invite.initShip !== window.urbit.ship);
};

export const fetchMyReceivedShip = (invite) => {
	console.log(window.urbit.ship);
	console.log(invite.receiveShips.filter(x => x.ship === ('~' + window.urbit.ship))[0]);
	return invite.receiveShips.filter(x => x.ship === ('~' + window.urbit.ship))[0];
};

// XX
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

export const dedup = (attr, arr) => {
	return [...new Map(arr.map(a => [a[attr], a])).values()];
	}

export const isGroup = (str) => {
	const pos = str.search('/');
	if(pos === -1)
		return false;
	const ship = str.split('/')[0];
	const group = str.split('/')[1];
	if(!patpValidate(ship))
		return false;
	return true;
}

export const createGroup = (str, collections) => {

	if(str[0] === '~' && patpValidate(str) && (collections.filter(collection => collection.collection.members[0] === str).length === 0) && str !== '~' + window.urbit.ship) {
		return ({title: str, members: [str], selected: true, resource: ''});
	}
	else if(isGroup(str)) {
		const result = scryGroup(str);
		return ({title: str, members: [], selected: true, resource: {ship: str.split('/')[0], name: str.split('/')[1]}});
	}
	else if(str !== '' && collections.filter(x => x.collection.selected).length !== 0) {
		return ({title: str, members: collections.filter(x => x.collection.selected).reduce((prev, curr) => prev.concat(curr.collection.members), []), 
			selected: true, resource: ''});
	}
	else
		return null;
}

export const toggleSelect = (id, groups) => {
	const editedCollection = groups.filter(group => {
		if (group.id === id) return true;
		else return false;
	})[0].collection;
	return { id: id, title: editedCollection.title, members: editedCollection.members, selected: !editedCollection.selected, resource : editedCollection.resource};
}

export const deleteGroup = (id, groups) => {
	return groups.filter(group => {
		if (group.id === id)
			return false;
		return true;
	})
}
export const patpValidate = str => {
  const prefix = new Set([
    'doz', 'mar', 'bin', 'wan', 'sam', 'lit', 'sig', 'hid',
    'fid', 'lis', 'sog', 'dir', 'wac', 'sab', 'wis', 'sib',
    'rig', 'sol', 'dop', 'mod', 'fog', 'lid', 'hop', 'dar',
    'dor', 'lor', 'hod', 'fol', 'rin', 'tog', 'sil', 'mir',
    'hol', 'pas', 'lac', 'rov', 'liv', 'dal', 'sat', 'lib',
    'tab', 'han', 'tic', 'pid', 'tor', 'bol', 'fos', 'dot',
    'los', 'dil', 'for', 'pil', 'ram', 'tir', 'win', 'tad',
    'bic', 'dif', 'roc', 'wid', 'bis', 'das', 'mid', 'lop',
    'ril', 'nar', 'dap', 'mol', 'san', 'loc', 'nov', 'sit',
    'nid', 'tip', 'sic', 'rop', 'wit', 'nat', 'pan', 'min',
    'rit', 'pod', 'mot', 'tam', 'tol', 'sav', 'pos', 'nap',
    'nop', 'som', 'fin', 'fon', 'ban', 'mor', 'wor', 'sip',
    'ron', 'nor', 'bot', 'wic', 'soc', 'wat', 'dol', 'mag',
    'pic', 'dav', 'bid', 'bal', 'tim', 'tas', 'mal', 'lig',
    'siv', 'tag', 'pad', 'sal', 'div', 'dac', 'tan', 'sid',
    'fab', 'tar', 'mon', 'ran', 'nis', 'wol', 'mis', 'pal',
    'las', 'dis', 'map', 'rab', 'tob', 'rol', 'lat', 'lon',
    'nod', 'nav', 'fig', 'nom', 'nib', 'pag', 'sop', 'ral',
    'bil', 'had', 'doc', 'rid', 'moc', 'pac', 'rav', 'rip',
    'fal', 'tod', 'til', 'tin', 'hap', 'mic', 'fan', 'pat',
    'tac', 'lab', 'mog', 'sim', 'son', 'pin', 'lom', 'ric',
    'tap', 'fir', 'has', 'bos', 'bat', 'poc', 'hac', 'tid',
    'hav', 'sap', 'lin', 'dib', 'hos', 'dab', 'bit', 'bar',
    'rac', 'par', 'lod', 'dos', 'bor', 'toc', 'hil', 'mac',
    'tom', 'dig', 'fil', 'fas', 'mit', 'hob', 'har', 'mig',
    'hin', 'rad', 'mas', 'hal', 'rag', 'lag', 'fad', 'top',
    'mop', 'hab', 'nil', 'nos', 'mil', 'fop', 'fam', 'dat',
    'nol', 'din', 'hat', 'nac', 'ris', 'fot', 'rib', 'hoc',
    'nim', 'lar', 'fit', 'wal', 'rap', 'sar', 'nal', 'mos',
    'lan', 'don', 'dan', 'lad', 'dov', 'riv', 'bac', 'pol',
    'lap', 'tal', 'pit', 'nam', 'bon', 'ros', 'ton', 'fod',
    'pon', 'sov', 'noc', 'sor', 'lav', 'mat', 'mip', 'fip'
  ]);
  const suffix = new Set([
    'zod', 'nec', 'bud', 'wes', 'sev', 'per', 'sut', 'let',
    'ful', 'pen', 'syt', 'dur', 'wep', 'ser', 'wyl', 'sun',
    'ryp', 'syx', 'dyr', 'nup', 'heb', 'peg', 'lup', 'dep',
    'dys', 'put', 'lug', 'hec', 'ryt', 'tyv', 'syd', 'nex',
    'lun', 'mep', 'lut', 'sep', 'pes', 'del', 'sul', 'ped',
    'tem', 'led', 'tul', 'met', 'wen', 'byn', 'hex', 'feb',
    'pyl', 'dul', 'het', 'mev', 'rut', 'tyl', 'wyd', 'tep',
    'bes', 'dex', 'sef', 'wyc', 'bur', 'der', 'nep', 'pur',
    'rys', 'reb', 'den', 'nut', 'sub', 'pet', 'rul', 'syn',
    'reg', 'tyd', 'sup', 'sem', 'wyn', 'rec', 'meg', 'net',
    'sec', 'mul', 'nym', 'tev', 'web', 'sum', 'mut', 'nyx',
    'rex', 'teb', 'fus', 'hep', 'ben', 'mus', 'wyx', 'sym',
    'sel', 'ruc', 'dec', 'wex', 'syr', 'wet', 'dyl', 'myn',
    'mes', 'det', 'bet', 'bel', 'tux', 'tug', 'myr', 'pel',
    'syp', 'ter', 'meb', 'set', 'dut', 'deg', 'tex', 'sur',
    'fel', 'tud', 'nux', 'rux', 'ren', 'wyt', 'nub', 'med',
    'lyt', 'dus', 'neb', 'rum', 'tyn', 'seg', 'lyx', 'pun',
    'res', 'red', 'fun', 'rev', 'ref', 'mec', 'ted', 'rus',
    'bex', 'leb', 'dux', 'ryn', 'num', 'pyx', 'ryg', 'ryx',
    'fep', 'tyr', 'tus', 'tyc', 'leg', 'nem', 'fer', 'mer',
    'ten', 'lus', 'nus', 'syl', 'tec', 'mex', 'pub', 'rym',
    'tuc', 'fyl', 'lep', 'deb', 'ber', 'mug', 'hut', 'tun',
    'byl', 'sud', 'pem', 'dev', 'lur', 'def', 'bus', 'bep',
    'run', 'mel', 'pex', 'dyt', 'byt', 'typ', 'lev', 'myl',
    'wed', 'duc', 'fur', 'fex', 'nul', 'luc', 'len', 'ner',
    'lex', 'rup', 'ned', 'lec', 'ryd', 'lyd', 'fen', 'wel',
    'nyd', 'hus', 'rel', 'rud', 'nes', 'hes', 'fet', 'des',
    'ret', 'dun', 'ler', 'nyr', 'seb', 'hul', 'ryl', 'lud',
    'rem', 'lys', 'fyn', 'wer', 'ryc', 'sug', 'nys', 'nyl',
    'lyn', 'dyn', 'dem', 'lux', 'fed', 'sed', 'bec', 'mun',
    'lyr', 'tes', 'mud', 'nyt', 'byr', 'sen', 'weg', 'fyr',
    'mur', 'tel', 'rep', 'teg', 'pec', 'nel', 'nev', 'fes'
  ]);
  const checkPair = pair => {
    return prefix.has(pair.substring(0,3)) &&
      suffix.has(pair.substring(3))
  };
  if (str.charAt(0) === '~') {
    if (str.length === 4) return suffix.has(str.substring(1));
    const segments = str.substring(1).split('--');
    if (segments.length === 1) {
      const pairs = segments[0].split('-');
      return (0 < pairs.length && pairs.length < 5) &&
        pairs.every(checkPair)
    };
    if (segments.length === 2) {
      const pairsA = segments[0].split('-');
      const pairsB = segments[1].split('-');
      return (
        (0 < pairsA.length && pairsA.length < 5) &&
        (pairsB.length === 4) && 
        pairsA.every(checkPair) && 
        pairsB.every(checkPair)
      );
    };
  };
  return false;
};

export const scryGroup = (str) => {
	// const result = {title:'testGroup', selected: true, url: 'webgraph', members: ['~dev']};
    const result = window.urbit.scry({
      app: "graph-store",
			// path: '/groups/ship/~martyr-sarlev-sarsen/assembly-hackers',
			// path: '/groups/ship/~difhut-mogsel-pontus-fadpun/testgroup',
			path: '/keys',
			// path: '/groups/ship/~hiddev-dannut/new-hooniverse',
			// path: '/groups/ship/~hiddev-dannut/new-hooniverse/noun'
    })
	console.log('scryGroup-----');
	console.log(result);
	return result;
}

export const sortSelected = (a,b) => {
	console.log(a);
	console.log('---------------');
	if ( a.collection.selected === true  && b.collection.selected === true)
		return 0;
	if ( a.collection.selected === true  && b.collection.selected === false)
		return -1;
	if ( a.collection.selected === false && b.collection.selected === true)
		return 1;
	if ( a.collection.selected === false && b.collection.selected === false)
		return 0;
}
