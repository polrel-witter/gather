import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import Geolookup from 'react-geolookup-v2';
import * as Nominatim from 'nominatim-browser';



const Location = (props) => {
	// const position = {lat: '.6.022141e23', lon: '.6.022141e23'};
	const [address, setAddress] = useState("");
	const [position, setPosition] = useState({});
			
	// }
	return (
		<Box border={1}>
		<Text display="block"> My Location </Text>
		<Text display="block"> 
			Used to retrieve location coordinates,
			and is shared with Gang members when Status is turned on. 
		</Text>
			    <Geolookup
          inputClassName="geolookup__input--nominatim"
          disableAutoLookup={true}
					onSuggestsLookup={(userInput)=>{
						return Nominatim.geocode({
      				q: userInput,
      				addressdetails: true
    				});
					}}
					onGeocodeSuggest={(suggest)=>{
						let geocoded = {};
    				if (suggest) {
    				  geocoded.nominatim = suggest.raw || {};
    				  geocoded.location = {
    				    lat: suggest.raw ? suggest.raw.lat : '',
    				    lon: suggest.raw ? suggest.raw.lon : ''
    				  };
    				  geocoded.placeId = suggest.placeId;
    				  geocoded.isFixture = suggest.isFixture;
    				  geocoded.label = suggest.raw ? suggest.raw.display_name : '';
							setPosition({ lon: '.' + geocoded.location.lon, lat: '.' + geocoded.location.lat});
							setAddress(geocoded.label);
    				}
    				return geocoded;
					}}
					getSuggestLabel={(suggest)=>{return suggest.display_name;}}
          radius="20" />
		<Button onClick={() => {
			if(Object.keys(position).length !== 0) {
				props.setPosition(position);
				// props.setAddress(address);
			}
			}}>Set</Button>
		</Box>
	 );
}
export default Location;
