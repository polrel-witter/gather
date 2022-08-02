import React from 'react';
import Checkbox from '@mui/material/Checkbox'
import DeleteIcon from '@mui/icons-material/Delete';
import IconButton from '@mui/material/IconButton';
import Divider from '@mui/material/Divider';
import ListItem from '@mui/material/ListItem';

const listElementStyles = {
	color: '#123456',
	fontSize: 18,
	lineHeight: '24px',
}

const listElementCheckedStyles = {
	...listElementStyles,
	textDecoration: 'line-through',
}

export const Todo = (props) => {

		const listStyles = !props.checked ? listElementStyles: listElementCheckedStyles;
		return(
			<ListItem>
			<Divider />
		</ListItem>
		)
}


export default Todo;
