import React, { Component, useState } from "react";
import { useStore } from "../data/store";
import { useAlert } from "react-alert";
const Alert = (props) => {

	return (
		<div className="alert"
			style={{ color: props.color }}
		>
			{props.str}
		</div>
	);
};

export default Alert;
