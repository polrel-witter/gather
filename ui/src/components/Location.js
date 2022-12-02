import React, { Component, useState } from 'react';
import { Icon, StatelessTextInput, Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button } from "@tlon/indigo-react";
import { useStore } from '../data/store';
import Geolookup from 'react-geolookup-v2';
import * as Nominatim from 'nominatim-browser';
import ReactTooltip from 'react-tooltip';

const Location = (props) => {
	const [address, setAddress] = useState('');
			
	return (
		<div className='location flexcol'
		>
			<span> 
				Location 
			</span>
			{/* <Box display='flex'> */}
			    <Geolookup
          inputClassName="geolookup__input--nominatim"
          disableAutoLookup={true}
					initialValue={props.address}
					onSuggestsLookup={(userInput)=>{
						// console.log(userInput);
						return Nominatim.geocode({
      				q: userInput,
      				addressdetails: true
    				});
					}}
					onGeocodeSuggest={(suggest)=>{
						let geocoded = {};
						// console.log(suggest);
						// console.log(props);
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
							setAddress(geocoded.label);
							props.setAddress(geocoded.label);
    				}
    				return geocoded;
					}}
					getSuggestLabel={(suggest)=>{return suggest.display_name;}}
          radius="20" />
		</div>
	 );
}
export default Location;
