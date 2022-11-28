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

			<div className="draft-ise-image flexcol">
				<span>Image link</span>
				<input
					type="text"
					onChange={(e) =>
						setInvite({ ...invite, image: e.currentTarget.value })
					}
				/>
			</div>

			<div className="draft-ise flexcol">
				{/* TODO fix dates */}
				<div className="draft-ise-datebegin flexcol">
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
				<div className="draft-ise-dateend flexcol">
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
				<div className="draft-rr-radius flexcol">
					<span display="inline">Delivery radius</span>
					<ReactTooltip />
					<input
						type="text"
						value={invite.radius.slice(1)}
						onChange={(e) => {
							const re = /^[0-9\b]+$/;
							if (
								e.currentTarget.value === "" ||
								re.test(e.currentTarget.value)
							)
								setInvite({
									...invite,
									radius: "." + String(e.currentTarget.value),
								});
						}}
					/>
				</div>

				<div className="draft-rr-rsvplimit flexcol">
					<span>Limit # of RSVPs accepted</span>
					<ReactTooltip />
					<input
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

			<span> Options </span>
			<div className="draft-options">
				<div className="draft-options-accesstype">
					<span>Access Type </span>
					<span> Private </span>
					<input
						type="radio"
						name="accesstype"
						checked={invite["access"] === "private"}
						onChange={(e) => {
							setInvite({ ...invite, access: "private" });
						}}
					/>
					Public
					<input
						type="radio"
						name="accesstype"
						checked={invite["access"] === "public"}
						onChange={(e) => {
							setInvite({ ...invite, access: "public" });
						}}
					/>
				</div>
				<div className="draft-options-locationtype">
					<span> Location Type </span>
					<span> Meatspace </span>
					<input
						type="radio"
						name="locationtype"
						checked={invite["location-type"] === "meatspace"}
						// checked="checked"
						onChange={(e) => {
							setInvite({ ...invite, "location-type": "meatspace" });
						}}
					/>
					Virtual
					<input
						type="radio"
						name="locationtype"
						checked={invite["location-type"] === "virtual"}
						onChange={(e) => {
							setInvite({ ...invite, "location-type": "virtual" });
						}}
					/>
				</div>
			</div>

			{invite["access"] === "public" && (
				<div className="draft-links">
					Earth and Mars link will be created when clicking Create
					<button
						className="draft-links-send"
						onClick={() => {
							alert.show(<div style={{ color: "green" }}>Invite Sent</div>);
							pNewInvite({ ...invite, collections: [] });
						}}
					>
						Create
					</button>
				</div>
			)}

			{invite["access"] === "private" && (
				<div>
					<div className="draft-listselect">
						Selection type
						<select
							name="selection"
							id="cars"
							onChange={(e) => setListSelect(e.target.value)}
						>
							<option value="ship">ship</option>
							<option value="group">group</option>
							<option value="collection">collection</option>
						</select>
						<div className="draft-listselect-choose"></div>
						<div className="draft-listselect-send">
							<button
								className="draft-links-send"
								onClick={() => {
									if (invite["send-to"].length !== 0) {
										alert.show(
											<div style={{ color: "green" }}>Invite Sent</div>
										);
										pNewInvite(invite);
									} else
										alert.show(
											<div style={{ color: "red" }}>
												No collection selected!
											</div>
										);
								}}
							>
								Send
							</button>
						</div>
						{listSelect === "ship" && (
							<div className="draft-listselect-ship">
								Create ship
								<input
									type="text"
									onChange={(e) =>
										setNewCollectionString(e.currentTarget.value)
									}
								/>
								<button
									onClick={() =>
										pCreateCollection(
											createGroup("ship", newCollectionString, collections)
										)
									}
								>
									Create Ship
								</button>
							</div>
						)}
						{listSelect === "group" && (
							<div className="draft-listselect-group">
								Create group
								<input
									onChange={(e) =>
										setNewCollectionString(e.currentTarget.value)
									}
									type="text"
								/>
								<button
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
							<div className="draft-listselect-collection">
								Create collection
								<input
									type="text"
									onChange={(e) =>
										setNewCollectionString(e.currentTarget.value)
									}
								/>
								<button
									onClick={() =>
										pCreateCollection(
											createGroup(
												"collection",
												newCollectionString,
												collections
											)
										)
									}
								>
									Create Collection
								</button>
							</div>
						)}
					</div>

					<div className="draft-list">
						Collections:
						{collectionWaiting && <span> Collection Waiting </span>}
						{collections !== undefined &&
							collections.length !== 0 &&
							collections.sort(sortSelected).map((collection) => (
								<div className="draft-list-item">
									<span>{collection.collection.title}</span>
									<div>
										{collection.collection.selected && (
											<button
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
											width="100%"
											onClick={() => pDeleteCollection(collection.id)}
										>
											Delete
										</button>
									</div>
								</div>
							))}
					</div>
				</div>
			)}
		</div>
	);
};

export default Draft;
