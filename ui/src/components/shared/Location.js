import React, { Component, useState } from 'react';
import { Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import Geolookup from 'react-geolookup-v2';
import * as Nominatim from 'nominatim-browser';

const px = '1';
const py = '2';

const Location = (props) => {
	// const position = {lat: '.6.022141e23', lon: '.6.022141e23'};
	const [address, setAddress] = useState(props.address);
	const [position, setPosition] = useState(props.position);
			
	// }
	return (
		<Box borderBottom={1}
			px={px}
			py={py}
		>
		<Text > My Location </Text>
		<Text > 
			{props.address}
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
				props.setAddress(address);
			}
			}}>Set</Button>
		</Box>
	 );
}
export default Location;
