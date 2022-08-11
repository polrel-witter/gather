import React, {Component, useState} from "react";
import Urbit from "@urbit/http-api";
import "./App.css";
import Topbar from "./components/pages/Topbar"
import Gathering from "./components/pages/Gathering"
import Status from "./components/pages/Status"
import Settings from "./components/pages/Settings"
import patpValidate from "./patpValidate";
import { Box } from "@tlon/indigo-react";
import { useStore } from './data/store';

const AppSwitch = () => {
	const route = useStore(state => state.route);
	switch(route) {
		case "gather-init":
		case "gather-received":
			return (
			<Gathering/>
			);
		break;
		case "status-gang":
		case "status-foreign":
			return (
			<Status />
			);
		break;
		case "settings":
			return (
			<Settings/>
			);
		break;
	}
}

const App = () => {
	return(
			<Box
				display="flex"
				flexDirection="column"
			  alignItems="center"
				width="50%"
				position="absolute"
				right="25%"
				left="25%"
			>
			<Topbar/>
			<AppSwitch/>
			</Box>
	)
}

export default App;
