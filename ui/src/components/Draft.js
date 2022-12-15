import React, { useState, useEffect } from "react";
import Location from "./Location";
import { useStore } from "../data/store";
import {
	getBaseURL,
	createGroup,
	toggleSelect,
	deleteGroup,
	sortSelected,
	getColType,
	alert,
	patpValidate,
} from "../utils";
import { useAlert } from "react-alert";
import Alert from "./Alert";
import ReactTooltip from "react-tooltip";

const Draft = () => {
	const [listSelect, setListSelect] = useState("ship");
	const collectionWaiting = useStore((state) => state.collectionWaiting);
	const collections = useStore((state) => state.settings.collections);
	const settings = useStore((state) => state.settings);
	const _alert = useAlert();
	const alert = useAlert();
	const redAlert = (str) => _alert.show(<Alert str={str} color={"red"} />);
	const greenAlert = (str) => _alert.show(<Alert str={str} color={"green"} />);
	const pNewInvite = useStore((state) => state.pNewInvite);
	const pCreateCollection = useStore((state) => state.pCreateCollection);
	const pEditCollection = useStore((state) => state.pEditCollection);
	const pDeleteCollection = useStore((state) => state.pDeleteCollection);
	const [newCollectionString, setNewCollectionString] = useState("");
	const invite = useStore((state) => state.draftInvite);
	const setInvite = useStore((state) => state.setDraftInvite);
	// const [invite, setInvite] = useState({
	// 	"send-to": [],
	// 	"location-type": "meatspace",
	// 	position: { lat: ".0", lon: ".0" },
	// 	address: "",
	// 	"access-link": "",
	// 	radius: ".0",
	// 	"rsvp-limit": 0,
	// 	desc: "",
	// 	title: "",
	// 	image: "",
	// 	date: { begin: "", end: "" },
	// 	access: "private",
	// 	"earth-link": "",
	// 	// TODO fix excise-comets and enable-chat
	// 	"excise-comets": true,
	// 	"enable-chat": true,
	// });

	useEffect(() => {
		// if (Object.keys(settings) !== 0) {
		// 	setInvite({
		// 		...invite,
		// 		// "excise-comets": settings["exciseComets"],
		// 		// "enable-chat": settings["enableChat"],
		// 		"excise-comets": false,
		// 		"enable-chat": settings["enableChat"],
		// 	});
		// }
	}, []);

	useEffect(() => {
		const sendTo =
			collections !== undefined
				? collections
						.filter((x) => x.collection.selected)
						.reduce((prev, curr) => prev.concat(curr.collection.members), [])
				: collections;
		const exciseComets =
			Object.keys(settings) !== 0
				? settings["exciseComets"]
				: invite["excise-comets"];
		const enableChat =
			Object.keys(settings) !== 0
				? settings["enableChat"]
				: invite["enableChat"];
		const newInvite = {
			...invite,
			"send-to": sendTo,
			"excise-comets": exciseComets,
			"enable-chat": enableChat,
		};
		setInvite(newInvite);
	}, [collections, settings]);

	return (
		<div className="draft">
			<div className="draft-title flexcol">
				<span className="label">Title</span>
				<input
					type="text"
					onChange={(e) =>
						setInvite({ ...invite, title: e.currentTarget.value })
					}
				/>
			</div>

			<div className="draft-description flexcol">
				<span>Description</span>
				<textarea
					onChange={(e) =>
						setInvite({ ...invite, desc: e.currentTarget.value })
					}
				/>
			</div>

			<div className="draft-image flexcol">
				<span>Image link</span>
				<input
					type="text"
					onChange={(e) =>
						setInvite({ ...invite, image: e.currentTarget.value })
					}
				/>
			</div>

			<div className="draft-date flexrow">
				<div className="draft-date-datebegin flexcol flexgrow">
					<span>Start date</span>
					<input
						type="datetime-local"
						onChange={(e) => {
							const begin = new Date(e.currentTarget.value).toUTCString();
							setInvite({
								...invite,
								date: {
									begin: begin.substr(0, begin.length - 4),
									end: invite.date.end,
								},
							});
						}}
					/>
				</div>
				<div className="draft-date-dateend flexcol flexgrow">
					<span>End date</span>
					<input
						type="datetime-local"
						onChange={(e) => {
							const end = new Date(e.currentTarget.value).toUTCString();
							setInvite({
								...invite,
								date: {
									begin: invite.date.begin,
									end: end.substr(0, end.length - 4),
								},
							});
						}}
					/>
				</div>
			</div>

			<div className="draft-accesslink flexcol">
				<span>Access link</span>
				<ReactTooltip />
				<input
					type="text"
					onChange={(e) => {
						setInvite({
							...invite,
							"access-link": String(e.currentTarget.value),
						});
					}}
				/>
			</div>

			<Location
				address={invite.address}
				position={invite.position}
				originalState={invite}
				setState={setInvite}
			/>

			<div className="draft-rr flexrow">
				<div className="draft-rr-radius flexcol flexgrow">
					<span>Delivery radius (km)</span>
					<input
						type="number"
						min="0"
						value={invite.radius?.slice(1)}
						onChange={(e) => {
							// const re = /^[0-9\b]+$/;
							// if (
							// 	e.currentTarget.value === "" ||
							// 	re.test(e.currentTarget.value)
							// )
							setInvite({
								...invite,
								radius:
									isNaN(parseInt(e.currentTarget.value)) ||
									e.currentTarget.value === null
										? null
										: "." + parseInt(e.currentTarget.value),
							});
						}}
					/>
				</div>

				<div className="draft-rr-rsvplimit flexcol flexgrow">
					<span>RSVP limit</span>
					<input
						type="number"
						min="0"
						value={invite["rsvp-limit"]}
						onChange={(e) => {
							const re = /^[0-9\b]+$/;
							if (
								e.currentTarget.value === "" ||
								re.test(e.currentTarget.value)
							)
								setInvite({ ...invite, "rsvp-limit": parseInt(e.currentTarget.value) });
						}}
					/>
				</div>
			</div>

			<div className="draft-optionstitle divider"> Options </div>
			<div className="draft-options radiobox">
				<div className="draft-options-accesstype radio">
					<span> Access type </span>
					<div>
						<input
							type="radio"
							name="accesstype"
							id="accesstype-private"
							checked={invite["access"] === "private"}
							onChange={(e) => {
								setInvite({ ...invite, access: "private" });
							}}
						/>
						<label for="accesstype-private">Private</label>
					</div>
					<div>
						<input
							type="radio"
							name="accesstype"
							checked={invite["access"] === "public"}
							onChange={(e) => {
								setInvite({ ...invite, access: "public" });
							}}
						/>
						<span> Public </span>
					</div>
				</div>
				<div className="draft-options-locationtype radio">
					<span> Location type </span>
					<div>
						<input
							type="radio"
							name="locationtype"
							checked={invite["location-type"] === "meatspace"}
							// checked="checked"
							onChange={(e) => {
								setInvite({ ...invite, "location-type": "meatspace" });
							}}
						/>
						<span> Meatspace </span>
					</div>
					<div>
						<input
							type="radio"
							name="locationtype"
							checked={invite["location-type"] === "virtual"}
							onChange={(e) => {
								setInvite({ ...invite, "location-type": "virtual" });
							}}
						/>
						<span> Cyberspace </span>
					</div>
				</div>
			</div>

			<div className="draft-optionstitle divider"> Invitees </div>
			{invite["access"] === "public" && (
				<div className="draft-links">A mars-link will be generated upon creation, which can be shared so others can subscribe to your invite. The earth-link (modifiable below) is a url that makes your invite viewable on the clearweb. To publish a clearweb invite your ship must have a domain.</div>
			)}

			{invite["access"] === "private" && (
				<div className="draft-listselect">
					<select
						className="draft-listselect-select select"
						name="selection"
						onChange={(e) => setListSelect(e.target.value)}
					>
						<option value="ship">Ship</option>
						<option value="group">Group</option>
						<option value="collection">Collection</option>
					</select>
					<div className="draft-listselect-choose"></div>
					<div className="draft-listselect-send"></div>
					{listSelect === "ship" && (
						<div className="draft-listselect-ship flexrow">
							<input
								className="flexgrow"
								placeholder="~sampel-palnet"
								type="text"
								onChange={(e) => setNewCollectionString(e.currentTarget.value)}
							/>
							<button
								className="button"
								onClick={() => {
									if (!patpValidate(newCollectionString))
										redAlert("Invalid @p!");
									else
										pCreateCollection(
											createGroup("ship", newCollectionString, collections)
										);
								}}
							>
								Add Ship
							</button>
						</div>
					)}
					{listSelect === "group" && (
						<div className="draft-listselect-group flexrow">
							<input
								className="flexgrow"
								placeholder="~sampel-palnet/group-title"
								onChange={(e) => setNewCollectionString(e.currentTarget.value)}
								type="text"
							/>
							<button
								className="button"
								onClick={() =>
									pCreateCollection(
										createGroup("group", newCollectionString, collections)
									)
								}
							>
								Pull Group
							</button>
						</div>
					)}
					{listSelect === "collection" && (
						<div className="draft-listselect-collection flexrow">
							<input
								className="flexgrow"
								placeholder="Select ships, groups, and/or other collections below"
								type="text"
								onChange={(e) => setNewCollectionString(e.currentTarget.value)}
							/>
							<button
								className="button"
								onClick={() =>
									pCreateCollection(
										createGroup("collection", newCollectionString, collections)
									)
								}
							>
								Create Collection
							</button>
						</div>
					)}

					<div className="draft-list list">
						{/* {collectionWaiting && <span> Collection Waiting </span>} */}
						{collections !== undefined &&
							collections.length !== 0 &&
							collections.sort(sortSelected).map((collection) => {
								const colType = getColType(collection);
								return (
									<div className="draft-list-item onetoleft">
										<span>{collection.collection.title + colType}</span>
										{collection.collection.selected && (
											<button
												className="button"
												width="100%"
												onClick={() =>
													pEditCollection(
														toggleSelect(collection.id, collections)
													)
												}
											>
												Unselect
											</button>
										)}
										{!collection.collection.selected && (
											<button
												className="button"
												width="100%"
												onClick={() =>
													pEditCollection(
														toggleSelect(collection.id, collections)
													)
												}
											>
												Select
											</button>
										)}
										<button
											className="button"
											width="100%"
											onClick={() => pDeleteCollection(collection.id)}
										>
											Delete
										</button>
									</div>
								);
							})}
					</div>
				</div>
			)}
			{invite.access === "private" && (
				<button
					className="send"
					onClick={() => {
						if (invite["send-to"].length === 0) {
							// alert.show(<div style={{ color: "green" }}>Invite Sent</div>);
							redAlert("No collection selected");
						} else if (invite.title === "") {
							redAlert("No title");
							pNewInvite(invite);
						} else {
							pNewInvite(invite);
							greenAlert("Sent");
						}
					}}
				>
					Send
				</button>
			)}
			{invite.access === "public" && (
				<div className="draft-public">
					<div className="draft-public-earthlink flexcol">
						<span className="label">earth-link</span>
						<input
							type="text"
							value={
								getBaseURL() +
								invite["earth-link"]
							}
							onChange={(e) => {
								const re = /^[a-zA-Z0-9_-]*$/;
								const baseUrl = getBaseURL();
								if (re.test(e.currentTarget.value.slice(baseUrl.length)))
									setInvite({
										...invite,
										"earth-link": e.currentTarget.value.slice(baseUrl.length),
									});
							}}
						/>
					</div>
					<button
						className="send"
						onClick={() => {
							if (invite["title"] !== '') {
								alert.show(<div style={{ color: "green" }}>Created</div>);
								pNewInvite(invite);
							} else
								alert.show(
									<div style={{ color: "red" }}>No title</div>
								);
						}}
					>
						Create
					</button>
				</div>
			)}
		</div>
	);
};

export default Draft;
