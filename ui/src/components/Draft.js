import React, { useState, useEffect } from "react";
import Location from "./Location";
import { useStore } from "../data/store";
import { createGroup, toggleSelect, deleteGroup, sortSelected } from "../utils";
import { useAlert } from "react-alert";
import ReactTooltip from "react-tooltip";

const Draft = () => {
	const [listSelect, setListSelect] = useState("ship");
	const collectionWaiting = useStore((state) => state.collectionWaiting);
	const collections = useStore((state) => state.settings.collections);
	const settings = useStore((state) => state.settings);
	const alert = useAlert();
	const pNewInvite = useStore((state) => state.pNewInvite);
	const pCreateCollection = useStore((state) => state.pCreateCollection);
	const pEditCollection = useStore((state) => state.pEditCollection);
	const pDeleteCollection = useStore((state) => state.pDeleteCollection);
	const [newCollectionString, setNewCollectionString] = useState("");
	const [invite, setInvite] = useState({
		"send-to": [],
		"location-type": "meatspace",
		position: { lat: ".0", lon: ".0" },
		address: "",
		"access-link": "",
		radius: ".0",
		"rsvp-limit": 0,
		desc: "",
		title: "",
		image: "",
		date: { begin: "", end: "" },
		access: "private",
		"earth-link": "",
		// TODO fix excise-comets and enable-chat
		"excise-comets": true,
		"enable-chat": true,
	});

	useEffect(() => {
		console.log(settings);
		if (Object.keys(settings) !== 0) {
			setInvite({
				...invite,
				"excise-comets": settings["exciseComets"],
				"enable-chat": settings["enableChat"],
			});
		}
		if (collections !== undefined) {
			setInvite({
				...invite,
				"send-to": collections
					.filter((x) => x.collection.selected)
					.reduce((prev, curr) => prev.concat(curr.collection.members), []),
			});
		}
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
				{/* TODO fix dates */}
				<div className="draft-date-datebegin flexcol flexgrow">
					<span>Date Begin</span>
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
					<span>Date End</span>
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
				setAddress={(address) => setInvite({ ...invite, address })}
				setPosition={(position) => setInvite({ ...invite, position })}
			/>

			<div className="draft-rr flexrow">
				<div className="draft-rr-radius flexcol flexgrow">
					<span>Delivery radius</span>
					<input
						type="number"
						min="0"
						value={invite.radius.slice(1)}
						onChange={(e) => {
							// const re = /^[0-9\b]+$/;
							// if (
							// 	e.currentTarget.value === "" ||
							// 	re.test(e.currentTarget.value)
							// )
							setInvite({
								...invite,
								radius: "." + parseInt(e.currentTarget.value),
							});
						}}
					/>
				</div>

				<div className="draft-rr-rsvplimit flexcol flexgrow">
					<span>Limit # of RSVPs accepted</span>
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
								setInvite({ ...invite, "rsvp-limit": e.currentTarget.value });
						}}
					/>
				</div>
			</div>

			<div className="draft-optionstitle divider"> Options </div>
			<div className="draft-options radiobox">
				<div className="draft-options-accesstype radio">
					<span> Access Type </span>
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
					<span> Location Type </span>
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
						<span> Virtual </span>
					</div>
				</div>
			</div>

			<div className="draft-optionstitle divider"> Invitees </div>
			{invite["access"] === "public" && (
				<div className="draft-links">
					Everyone can be invited who receives the mars or earth link
				</div>
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
								type="text"
								onChange={(e) => setNewCollectionString(e.currentTarget.value)}
							/>
							<button
								className="button"
								onClick={() =>
									pCreateCollection(
										createGroup("ship", newCollectionString, collections)
									)
								}
							>
								Add Ship
							</button>
						</div>
					)}
					{listSelect === "group" && (
						<div className="draft-listselect-group flexrow">
							<input
								className="flexgrow"
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
								Create Group
							</button>
						</div>
					)}
					{listSelect === "collection" && (
						<div className="draft-listselect-collection flexrow">
							<input
								className="flexgrow"
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
							collections.sort(sortSelected).map((collection) => (
								<div className="draft-list-item onetoleft">
									<span>{collection.collection.title}</span>
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
							))}
					</div>
				</div>
			)}
			<button
				className="send"
				onClick={() => {
					if (invite["send-to"].length !== 0) {
						alert.show(<div style={{ color: "green" }}>Invite Sent</div>);
						pNewInvite(invite);
					} else
						alert.show(
							<div style={{ color: "red" }}>No collection selected!</div>
						);
				}}
			>
				Send
			</button>
		</div>
	);
};

export default Draft;
