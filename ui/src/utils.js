import haversine from "haversine-distance";
import bigInt, { BigInteger } from "big-integer";
import { useAlert } from "react-alert";

const myShip = "pontus-fadpun";
export const fetchMyInvites = (invites) => {
	// return invites.filter(x => x.initShip === window.urbit.ship)[0];
	return invites.filter((x) => x.invite.initShip === window.urbit.ship);
};

export const getInviteById = (id, invites) => {
	return invites.filter((x) => x.id === id)[0];
};

export const properPosition = (position) => {
	if (position !== null)
		return { lat: position.lat.slice(1), lon: position.lon.slice(1) };
	return null;
};

const opposite =
	(f) =>
	(...args) =>
		!f(...args);

export const filterDistantInvites = (invite, settings) => {
	if (
		invite.invite.locationType === "virtual" ||
		settings.receiveInvite === "anyone"
	)
		return true;

	if (invite.invite.position === null || settings.position === null)
		return true;

	const inviteNA =
		invite.invite.radius === null || invite.invite.position.lon === null;
	const inviteeNA = settings.radius === null || settings.position.lon === null;
	const isInviteInside =
		haversine(
			{
				latitude: invite.invite.position.lat,
				longitude: invite.invite.position.lon,
			},
			{ latitude: settings.position.lat, longitude: settings.position.lon }
		) <=
		settings.radius * 1000;
	const isInviteeInside =
		haversine(
			{
				latitude: invite.invite.position.lat,
				longitude: invite.invite.position.lon,
			},
			{ latitude: settings.position.lat, longitude: settings.position.lon }
		) <=
		invite.invite.radius * 1000;

	// console.log(invite.invite.desc);
	// console.log(haversine(
	// { latitude: invite.invite.position.lat, longitude: invite.invite.position.lon },
	// { latitude: settings.position.lat, longitude: settings.position.lon }
	// ));
	// console.log(settings.radius * 1000);
	// console.log(isInviteInside)
	// console.log(inviteNA)
	// console.log(isInviteeInside)
	// console.log(inviteeNA)
	// console.log(settings.position.lon);
	// console.log(settings.radius);
	// console.log('--------------')

	if (
		(!isInviteInside && settings.radius !== "0") ||
		(!isInviteeInside && invite.invite.radius !== "0")
	)
		return false;
	return true;
};

export const fetchReceivedShips = (invites) => {
	return invites.filter((x) => x.invite.initShip !== window.urbit.ship);
};

export const fetchMyReceivedShip = (invite) => {
	return invite.receiveShips.filter(
		(x) => x.ship === "~" + window.urbit.ship
	)[0];
};

// XX
export const fetchPendingInvites = (invites) => {
	return invites.filter((x) => {
		const myInviteInReceivedShips = x.receivedShips.filter(
			(y) => y._ship === myShip
		)[0];
		if (
			myInviteInReceivedShips !== undefined &&
			myInviteInReceivedShips.inviteStatus === "pending"
		)
			return true;
		return false;
	});
};

export const fetchAcceptedInvites = (invites) => {
	return invites.filter((x) => {
		const myInviteInReceivedShips = x.receivedShips.filter(
			(y) => y._ship === myShip
		)[0];
		if (
			myInviteInReceivedShips !== undefined &&
			myInviteInReceivedShips.inviteStatus === "accepted"
		)
			return true;
		return false;
	});
};

export const fetchGangMembers = (ships) => {
	return ships.filter((x) => x.ourGang === true);
};

export const fetchForeignShips = (ships) => {
	return ships.filter((x) => x.ourGang === false && x.theirGang === true);
};

export const doPoke = (jon) => {
	console.log(jon);
	window.urbit.poke({
		app: "gather",
		mark: "gather-action",
		json: jon,
		onSuccess: () => {},
		onError: () => {},
	});
};

export const subscribe = (path, handler) => {
	window.urbit.subscribe({
		app: "gather",
		path: path,
		event: handler,
	});
};

export const dedup = (attr, arr) => {
	return [...new Map(arr.map((a) => [a[attr], a])).values()];
};

export const isGroup = (str) => {
	const pos = str.search("/");
	if (pos === -1) return false;
	const ship = str.split("/")[0];
	const group = str.split("/")[1];
	if (!patpValidate(ship)) return false;
	return true;
};

export const createGroup = (type, str, collections) => {
	if (type === "ship") {
		const newStr = str[0] === "~" ? str : "~" + str;
		return { title: newStr, members: [newStr], selected: true, resource: "" };
	} else if (type === "group") {
		// const result = scryGroups(str);
		return {
			title: str,
			members: [],
			selected: true,
			resource: { ship: str.split("/")[0], name: str.split("/")[1] },
		};
	} else if (type === "collection") {
		const newStr = str[0] === "~" ? str.slice(1) : str;
		return {
			title: newStr,
			members: collections
				.filter((x) => x.collection.selected)
				.reduce((prev, curr) => prev.concat(curr.collection.members), []),
			selected: true,
			resource: "",
		};
	}
};

export const toggleSelect = (id, groups) => {
	const editedCollection = groups.filter((group) => {
		if (group.id === id) return true;
		else return false;
	})[0].collection;
	return {
		id: id,
		title: editedCollection.title,
		members: editedCollection.members,
		selected: !editedCollection.selected,
		resource: editedCollection.resource,
	};
};

export const deleteGroup = (id, groups) => {
	return groups.filter((group) => {
		if (group.id === id) return false;
		return true;
	});
};
export const patpValidate = (str) => {
	const prefix = new Set([
		"doz",
		"mar",
		"bin",
		"wan",
		"sam",
		"lit",
		"sig",
		"hid",
		"fid",
		"lis",
		"sog",
		"dir",
		"wac",
		"sab",
		"wis",
		"sib",
		"rig",
		"sol",
		"dop",
		"mod",
		"fog",
		"lid",
		"hop",
		"dar",
		"dor",
		"lor",
		"hod",
		"fol",
		"rin",
		"tog",
		"sil",
		"mir",
		"hol",
		"pas",
		"lac",
		"rov",
		"liv",
		"dal",
		"sat",
		"lib",
		"tab",
		"han",
		"tic",
		"pid",
		"tor",
		"bol",
		"fos",
		"dot",
		"los",
		"dil",
		"for",
		"pil",
		"ram",
		"tir",
		"win",
		"tad",
		"bic",
		"dif",
		"roc",
		"wid",
		"bis",
		"das",
		"mid",
		"lop",
		"ril",
		"nar",
		"dap",
		"mol",
		"san",
		"loc",
		"nov",
		"sit",
		"nid",
		"tip",
		"sic",
		"rop",
		"wit",
		"nat",
		"pan",
		"min",
		"rit",
		"pod",
		"mot",
		"tam",
		"tol",
		"sav",
		"pos",
		"nap",
		"nop",
		"som",
		"fin",
		"fon",
		"ban",
		"mor",
		"wor",
		"sip",
		"ron",
		"nor",
		"bot",
		"wic",
		"soc",
		"wat",
		"dol",
		"mag",
		"pic",
		"dav",
		"bid",
		"bal",
		"tim",
		"tas",
		"mal",
		"lig",
		"siv",
		"tag",
		"pad",
		"sal",
		"div",
		"dac",
		"tan",
		"sid",
		"fab",
		"tar",
		"mon",
		"ran",
		"nis",
		"wol",
		"mis",
		"pal",
		"las",
		"dis",
		"map",
		"rab",
		"tob",
		"rol",
		"lat",
		"lon",
		"nod",
		"nav",
		"fig",
		"nom",
		"nib",
		"pag",
		"sop",
		"ral",
		"bil",
		"had",
		"doc",
		"rid",
		"moc",
		"pac",
		"rav",
		"rip",
		"fal",
		"tod",
		"til",
		"tin",
		"hap",
		"mic",
		"fan",
		"pat",
		"tac",
		"lab",
		"mog",
		"sim",
		"son",
		"pin",
		"lom",
		"ric",
		"tap",
		"fir",
		"has",
		"bos",
		"bat",
		"poc",
		"hac",
		"tid",
		"hav",
		"sap",
		"lin",
		"dib",
		"hos",
		"dab",
		"bit",
		"bar",
		"rac",
		"par",
		"lod",
		"dos",
		"bor",
		"toc",
		"hil",
		"mac",
		"tom",
		"dig",
		"fil",
		"fas",
		"mit",
		"hob",
		"har",
		"mig",
		"hin",
		"rad",
		"mas",
		"hal",
		"rag",
		"lag",
		"fad",
		"top",
		"mop",
		"hab",
		"nil",
		"nos",
		"mil",
		"fop",
		"fam",
		"dat",
		"nol",
		"din",
		"hat",
		"nac",
		"ris",
		"fot",
		"rib",
		"hoc",
		"nim",
		"lar",
		"fit",
		"wal",
		"rap",
		"sar",
		"nal",
		"mos",
		"lan",
		"don",
		"dan",
		"lad",
		"dov",
		"riv",
		"bac",
		"pol",
		"lap",
		"tal",
		"pit",
		"nam",
		"bon",
		"ros",
		"ton",
		"fod",
		"pon",
		"sov",
		"noc",
		"sor",
		"lav",
		"mat",
		"mip",
		"fip",
	]);
	const suffix = new Set([
		"zod",
		"nec",
		"bud",
		"wes",
		"sev",
		"per",
		"sut",
		"let",
		"ful",
		"pen",
		"syt",
		"dur",
		"wep",
		"ser",
		"wyl",
		"sun",
		"ryp",
		"syx",
		"dyr",
		"nup",
		"heb",
		"peg",
		"lup",
		"dep",
		"dys",
		"put",
		"lug",
		"hec",
		"ryt",
		"tyv",
		"syd",
		"nex",
		"lun",
		"mep",
		"lut",
		"sep",
		"pes",
		"del",
		"sul",
		"ped",
		"tem",
		"led",
		"tul",
		"met",
		"wen",
		"byn",
		"hex",
		"feb",
		"pyl",
		"dul",
		"het",
		"mev",
		"rut",
		"tyl",
		"wyd",
		"tep",
		"bes",
		"dex",
		"sef",
		"wyc",
		"bur",
		"der",
		"nep",
		"pur",
		"rys",
		"reb",
		"den",
		"nut",
		"sub",
		"pet",
		"rul",
		"syn",
		"reg",
		"tyd",
		"sup",
		"sem",
		"wyn",
		"rec",
		"meg",
		"net",
		"sec",
		"mul",
		"nym",
		"tev",
		"web",
		"sum",
		"mut",
		"nyx",
		"rex",
		"teb",
		"fus",
		"hep",
		"ben",
		"mus",
		"wyx",
		"sym",
		"sel",
		"ruc",
		"dec",
		"wex",
		"syr",
		"wet",
		"dyl",
		"myn",
		"mes",
		"det",
		"bet",
		"bel",
		"tux",
		"tug",
		"myr",
		"pel",
		"syp",
		"ter",
		"meb",
		"set",
		"dut",
		"deg",
		"tex",
		"sur",
		"fel",
		"tud",
		"nux",
		"rux",
		"ren",
		"wyt",
		"nub",
		"med",
		"lyt",
		"dus",
		"neb",
		"rum",
		"tyn",
		"seg",
		"lyx",
		"pun",
		"res",
		"red",
		"fun",
		"rev",
		"ref",
		"mec",
		"ted",
		"rus",
		"bex",
		"leb",
		"dux",
		"ryn",
		"num",
		"pyx",
		"ryg",
		"ryx",
		"fep",
		"tyr",
		"tus",
		"tyc",
		"leg",
		"nem",
		"fer",
		"mer",
		"ten",
		"lus",
		"nus",
		"syl",
		"tec",
		"mex",
		"pub",
		"rym",
		"tuc",
		"fyl",
		"lep",
		"deb",
		"ber",
		"mug",
		"hut",
		"tun",
		"byl",
		"sud",
		"pem",
		"dev",
		"lur",
		"def",
		"bus",
		"bep",
		"run",
		"mel",
		"pex",
		"dyt",
		"byt",
		"typ",
		"lev",
		"myl",
		"wed",
		"duc",
		"fur",
		"fex",
		"nul",
		"luc",
		"len",
		"ner",
		"lex",
		"rup",
		"ned",
		"lec",
		"ryd",
		"lyd",
		"fen",
		"wel",
		"nyd",
		"hus",
		"rel",
		"rud",
		"nes",
		"hes",
		"fet",
		"des",
		"ret",
		"dun",
		"ler",
		"nyr",
		"seb",
		"hul",
		"ryl",
		"lud",
		"rem",
		"lys",
		"fyn",
		"wer",
		"ryc",
		"sug",
		"nys",
		"nyl",
		"lyn",
		"dyn",
		"dem",
		"lux",
		"fed",
		"sed",
		"bec",
		"mun",
		"lyr",
		"tes",
		"mud",
		"nyt",
		"byr",
		"sen",
		"weg",
		"fyr",
		"mur",
		"tel",
		"rep",
		"teg",
		"pec",
		"nel",
		"nev",
		"fes",
	]);
	const checkPair = (pair) => {
		return prefix.has(pair.substring(0, 3)) && suffix.has(pair.substring(3));
	};
	if (str.charAt(0) === "~") {
		if (str.length === 4) return suffix.has(str.substring(1));
		const segments = str.substring(1).split("--");
		if (segments.length === 1) {
			const pairs = segments[0].split("-");
			return 0 < pairs.length && pairs.length < 5 && pairs.every(checkPair);
		}
		if (segments.length === 2) {
			const pairsA = segments[0].split("-");
			const pairsB = segments[1].split("-");
			return (
				0 < pairsA.length &&
				pairsA.length < 5 &&
				pairsB.length === 4 &&
				pairsA.every(checkPair) &&
				pairsB.every(checkPair)
			);
		}
	}
	return false;
};

export const scryGroups = (str) => {
	// const result = {title:'testGroup', selected: true, url: 'webgraph', members: ['~dev']};
	const result = window.urbit.scry({
		app: "graph-store",
		path: "/groups",
	});
	return result;
};

export const sortSelected = (a, b) => {
	if (a.collection.selected === true && b.collection.selected === true)
		return 0;
	if (a.collection.selected === true && b.collection.selected === false)
		return -1;
	if (a.collection.selected === false && b.collection.selected === true)
		return 1;
	if (a.collection.selected === false && b.collection.selected === false)
		return 0;
};

export const filterInvites = (mode, invites, settings) => {
	switch (mode) {
		case "hosting-open":
			return invites.filter(
				(x) =>
					x.invite.initShip === "~" + window.urbit.ship &&
					x.invite.hostStatus === "open"
			);
			break;
		case "hosting-closed":
			return invites.filter(
				(x) =>
					x.invite.initShip === "~" + window.urbit.ship &&
					x.invite.hostStatus === "closed"
			);
			break;
		case "hosting-completed":
			return invites.filter(
				(x) =>
					x.invite.initShip === "~" + window.urbit.ship &&
					x.invite.hostStatus === "completed"
			);
			break;
		case "hosting-cancelled":
			return invites.filter(
				(x) =>
					x.invite.initShip === "~" + window.urbit.ship &&
					x.invite.hostStatus === "cancelled"
			);
			break;
		case "inbox-rsvpd":
			return invites
				.filter((invite) => filterDistantInvites(invite, settings))
				.filter((x) => x.guestStatus === "rsvpd");
			break;
		case "inbox-pending":
			return invites
				.filter((invite) => filterDistantInvites(invite, settings))
				.filter((x) => x.guestStatus === "pending");
			break;
		case "inbox-outofrange":
			return invites
				.filter((invite) => opposite(filterDistantInvites)(invite, settings))
				.filter((x) => x.invite.initShip !== "~" + window.urbit.ship);
			return invites;
			break;
	}
	return [];
};

export const unit = (str) => {
	if (str === "~") {
		return null;
	}
	return str;
};

const DA_UNIX_EPOCH = bigInt("170141184475152167957503069145530368000"); // `@ud` ~1970.1.1
const DA_SECOND = bigInt("18446744073709551616"); // `@ud` ~s1
export function daToUnix(da) {
	// ported from +time:enjs:format in hoon.hoon
	const offset = DA_SECOND.divide(bigInt(2000));
	const epochAdjusted = offset.add(da.subtract(DA_UNIX_EPOCH));

	return Math.round(
		epochAdjusted.multiply(bigInt(1000)).divide(DA_SECOND).toJSNumber()
	);
}

export function unixToDa(unix) {
	const timeSinceEpoch = bigInt(unix).multiply(DA_SECOND).divide(bigInt(1000));
	return DA_UNIX_EPOCH.add(timeSinceEpoch);
}

export function dateToDa(d: Date, mil = false) {
	const fil = function (n: number) {
		return n >= 10 ? n : "0" + n;
	};
	return (
		`~${d.getUTCFullYear()}.` +
		`${d.getUTCMonth() + 1}.` +
		`${fil(d.getUTCDate())}..` +
		`${fil(d.getUTCHours())}.` +
		`${fil(d.getUTCMinutes())}.` +
		`${fil(d.getUTCSeconds())}` +
		`${mil ? "..0000" : ""}`
	);
}

export const getColType = (col) => {
	if (col.collection.resource !== "~") return " (group)";
	if (col.collection.title[0] === "~") return " (ship)";
	return " (collection)";
};

export const getBaseURL = () => {
	const port = window.location.port === "" ? "" : ":" + window.location.port;
	return (
		window.location.protocol +
		"//" +
		window.location.hostname +
		port +
		"/gather/"
	);
};

export const IDinInvites = (invites) => {
	const href = window.location.href.split('%2F');
	console.log('IdinInvites');
	console.log(href);
	console.log(window.location.href);
	console.log(invites);
	console.log('------------');
	// console.log(invites.filter(i => i.id === pathname[4])[0]);
	if(invites.filter(i => i.id === href[2])[0] === undefined)
		return undefined;
	return href[2];
}

export const getRoute = () => {
	console.log(
		window.location.pathname.split("/")[
			window.location.pathname.split("/").length - 1
		]
	);
	return window.location.pathname.split("/")[
		window.location.pathname.split("/").length - 1
	];
};
