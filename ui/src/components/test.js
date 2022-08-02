import React, { Component } from 'react';
import { redStyle } from '../styles/test';

const Test = (props) => 
	<h1 style={redStyle}>
	{props.color}
	{console.log(props)}
	</h1>;

export default Test;
