import React, {useState, useEffect, Component} from "react";
import Urbit from "@urbit/http-api";
import "./App.css";
import Topbar from "./components/pages/Topbar"
import Invites from "./components/pages/Invites"
import Draft from "./components/pages/Draft"
import Settings from "./components/pages/Settings"
import patpValidate from "./patpValidate";
import { Box, Text } from "@tlon/indigo-react";
import { useStore } from './data/store';
import { scryGroup } from './utils';
import { useAlert } from 'react-alert'

const AppSwitch = () => {
	const route = useStore(state => state.route);
	const sAll = useStore(state => state.sAll);

	const allState = useStore(state => state);

  useEffect(() => {
		sAll();
  }, []);

	if(Object.keys(allState.settings).length === 0)
		return (
			<Text>Loading...may take a minute, your groups are being pulled in.</Text>
		)
	else
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

		window.urbit = new Urbit("http://localhost:8080","","linmer-hodtev-nidhex-worted");
		window.urbit.ship = 'difhut-mogsel-pontus-fadpun';
		// window.urbit = new Urbit("http://localhost:8080","","magsub-micsev-bacmug-moldex");
		// window.urbit.ship = 'dev';
			
		  // window.urbit = new Urbit("");
		  // window.urbit.ship = window.ship;

		window.urbit.onOpen = () => this.setState({conn: "ok"});
    window.urbit.onRetry = () => this.setState({conn: "try"});
    window.urbit.onError = () => this.setState({conn: "err"});
		// scryGroup('');
		}
	render() {
		return(
			<Box
				display="flex"
				flexDirection="column"
			  alignItems="center"
				// position='center'
        // width="39.5%"
				// height="5"
        // px="2"
				width="100%"
				// right="25%"
				//left="5%"
			>
				<div className='overbox'>
					<Topbar/>
					<AppSwitch/>
				</div>
			</Box>
	)
	}
}

export default App;
