import React, { Component, useState } from 'react';
import { StatelessTextInput, Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button } from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import Geolookup from 'react-geolookup-v2';
import * as Nominatim from 'nominatim-browser';

const px = '1';
const py = '2';

const Location = (props) => {
	// const position = {lat: '.6.022141e23', lon: '.6.022141e23'};
	const [address, setAddress] = useState('');
			
	// }
	return (
		<Box borderBottom={1}
			px={px}
			py={py}
			display='flex'
		>
			<Text > My Location: </Text>
			<StatelessTextInput
					display="block"
					value={address}
					onChange={(e) => {setAddress(String(e.currentTarget.value));}}
				/>
			<Text>
			    <Geolookup
          inputClassName="geolookup__input--nominatim"
          disableAutoLookup={true}
					initialValue=" "
					onSuggestsLookup={(userInput)=>{
						console.log(address);
						return Nominatim.geocode({
      				q: address,
      				addressdetails: true
    				});
					}}
					onGeocodeSuggest={(suggest)=>{
						let geocoded = {};
						console.log(suggest);
						console.log(props);
    				if (suggest) {
    				  geocoded.nominatim = suggest.raw || {};
    				  geocoded.location = {
    				    lat: suggest.raw ? suggest.raw.lat : '',
    				    lon: suggest.raw ? suggest.raw.lon : ''
    				  };
    				  geocoded.placeId = suggest.placeId;
    				  geocoded.isFixture = suggest.isFixture;
    				  geocoded.label = suggest.raw ? suggest.raw.display_name : '';
							props.setPosition({ lon: '.' + geocoded.location.lon, lat: '.' + geocoded.location.lat});
							props.setAddress(geocoded.label);
							setAddress(geocoded.label);
    				}
    				return geocoded;
					}}
					getSuggestLabel={(suggest)=>{return suggest.display_name;}}
          radius="20" />
			</Text>
		</Box>
	 );
}
export default Location;
