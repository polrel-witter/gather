import React, { useState, useEffect, Component } from "react";
import Urbit from "@urbit/http-api";
import "./App.css";
import Topbar from "./components/Topbar";
import Invites from "./components/Invites";
import Draft from "./components/Draft";
import Settings from "./components/Settings";
import patpValidate from "./patpValidate";
import { Box, Text } from "@tlon/indigo-react";
import { useStore } from "./data/store";
import { scryGroups, IDinInvites } from "./utils";
import { useAlert } from "react-alert";

const ship = 'dev';

const AppSwitch = () => {
	const route = useStore((state) => state.route);
	const sAll = useStore((state) => state.sAll);
	const setRoute = useStore(state => state.setRoute);
	const focusInvite = useStore((state) => state.focusInvite);

	const allState = useStore((state) => state);

	useEffect(() => {
		sAll();
		const id = IDinInvites(allState.invites);
		if (id !== '') {
			setRoute('invites');
			focusInvite(id);
		}
		else {
			setRoute('draft');
			focusInvite('');
		}
	}, []);

	console.log(allState);

	switch (route) {
		case "invites":
			return <Invites />;
			break;
		case "draft":
			return <Draft />;
			break;
		case "settings":
			return <Settings />;
			break;
	}
};

class App extends Component {
	constructor(props) {
		super(props);

		// window.urbit = new Urbit("http://localhost:8080","","lidlut-tabwed-pillex-ridrup");
		// window.urbit.ship = 'zod';

	//	window.urbit = new Urbit("http://localhost:8081","","ranser-masfyr-parwyd-sabdux");
	//	window.urbit.ship = 'taclev-togpub-pontus-fadpun';

	//	switch (ship) {
	//		case "fun":
	//			window.urbit = new Urbit(
	//				"http://localhost:8081",
	//				"",
	//				"dolsyt-lavref-mormyr-rissep"
	//			);
	//			window.urbit.ship = "fun";
	//			break;
	//		case "dev":
	//			window.urbit = new Urbit(
	//				"http://localhost:8080",
	//				"",
	//				"magsub-micsev-bacmug-moldex"
	//			);
	//			window.urbit.ship = "dev";
	//			break;
	//		default:
	//			break;
	//	}
		
		window.urbit = new Urbit("");
		window.urbit.ship = window.ship;

		window.urbit.onOpen = () => this.setState({ conn: "ok" });
		window.urbit.onRetry = () => this.setState({ conn: "try" });
		window.urbit.onError = () => this.setState({ conn: "err" });

	}
	render() {
		return (
			<div className="app">
				<Topbar />
				<div className="app-main">
					<AppSwitch />
				</div>
			</div>
		);
	}
}

export default App;
