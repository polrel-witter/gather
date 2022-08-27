import React, {useState, useEffect, Component} from "react";
import Urbit from "@urbit/http-api";
import "./App.css";
import Topbar from "./components/pages/Topbar"
import Invites from "./components/pages/Invites"
import Draft from "./components/pages/Draft"
import Settings from "./components/pages/Settings"
import patpValidate from "./patpValidate";
import { Box } from "@tlon/indigo-react";
import { useStore } from './data/store';

const AppSwitch = () => {
	const route = useStore(state => state.route);
	const sAll = useStore(state => state.sAll);
	
  useEffect(() => {
		sAll();
  }, []);

	switch(route) {
		case "invites":
			return (
			<Invites/>
			);
		break;
		case "draft":
			return (
			<Draft />
			);
		break;
		case "settings":
			return (
			<Settings/>
			);
		break;
	}
}

class App extends Component {
	  constructor(props) {
    super(props);
		window.urbit = new Urbit("http://localhost:8080","","lidlut-tabwed-pillex-ridrup");
		window.urbit.ship = 'zod';
			
		// window.urbit = new Urbit("");
		// window.urbit.ship = window.ship;

		window.urbit.onOpen = () => this.setState({conn: "ok"});
    window.urbit.onRetry = () => this.setState({conn: "try"});
    window.urbit.onError = () => this.setState({conn: "err"});
		}
	render() {
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
}

export default App;
