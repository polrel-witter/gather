import React, { Component, useState } from 'react';
import { Icon, Text, Box, ManagedTextAreaField, StatelessTextArea, ManagedTextInputField, Button, StatelessTextInput, StatelessRadioButtonField} from "@tlon/indigo-react";
import { useStore } from '../../data/store';
import { patpValidate } from '../../utils';
import Location from '../shared/Location';

const FocusedInvite = (props) => {
	const id = props.invite.id;
	const invite = useStore(state => state.invites.filter(x => x.id === id)[0].invite);
	const focusInvite = props.focusInvite;
	const pAddReceiveShip = useStore(state => state.pAddReceiveShip);
	const pDelReceiveShip = useStore(state => state.pDelReceiveShip);
	const [search, setSearch] = useState("");
	//
	const [maxAccepted, setMaxAccepted] = useState(invite.maxAccepted);
	const [desc, setDesc] = useState(invite.desc);
	const [locationType, setLocationType] = useState(invite.locationType);
	const [accessLink, setAccessLink] = useState(invite.accessLink);
	const [radius, setRadius] = useState(invite.radius);
	const pEditMaxAccepted = useStore(state => state.pEditMaxAccepted);
	const pEditDesc = useStore(state => state.pEditDesc);
	const pEditInviteLocation = useStore(state => state.pEditInviteLocation);
	const pEditInvitePosition = useStore(state => state.pEditInvitePosition);
	const pEditInviteAddress = useStore(state => state.pEditInviteAddress);
	const pEditInviteAccessLink = useStore(state => state.pEditInviteAccessLink);
	const pEditInviteRadius = useStore(state => state.pEditInviteRadius);

	const px = '1';
	const py = '2';
	if(invite.initShip === '~' + window.urbit.ship && invite.hostStatus === 'sent')	
		return (
		<Box>
			<Box 
				borderBottom={1}
				px={px}
				py={py}
				display='flex'
			>
				<StatelessTextArea 
					flexGrow='2'
				value={desc} onChange={(e) => setDesc(e.currentTarget.value)}/>
				<Button 
					height='auto'
					width={250}
				onClick={ () => pEditDesc(id, desc)}>Edit Description</Button>
			</Box>
			<Box
				px={px}
				py={py}
				display='flex'
				borderBottom={1}
			>
				<StatelessTextInput value={maxAccepted} onChange={(e) => 
					{
						const re = /^[0-9\b]+$/;
						if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
							setMaxAccepted(Number(e.currentTarget.value));
					}}/>
				<Button 
					width={250}
				onClick={ () => pEditMaxAccepted(id, maxAccepted)}>Edit Max Accepted</Button>
			</Box>
			<Box 
				borderBottom={1}
				px={px}
				py={py}
				display='flex'
				justifyContent='center'
				alignItems='center'
			>
				<Text 
					pr={5}
					mr='auto'
				>Happening in: </Text>
				<StatelessRadioButtonField
					px={2}
					selected={locationType === 'virtual'}
          onChange={() => { 
					setLocationType('virtual') 
					pEditInviteLocation(id, 'virtual');
					}}
				> Virtual Space </StatelessRadioButtonField>
				<StatelessRadioButtonField
					px={2}
					selected={locationType === 'meatspace'}
          onChange={() => { 
						setLocationType('meatspace') 
						pEditInviteLocation(id, 'meatspace');
					}}
				> Meat Space </StatelessRadioButtonField>
			</Box> 
			<Box>
				<Location 
					address={invite.address} 
					position={invite.position} 
					setAddress={(address) => pEditInviteAddress(id, address)} 
					setPosition={(position) => pEditInvitePosition(id, position)} 
				/>
			</Box>
			<Box
				px={px}
				py={py}
				display='flex'
				borderBottom={1}
			>
				<StatelessTextInput value={accessLink} onChange={(e) => setAccessLink(e.currentTarget.value)}/>
				<Button 
					width={250}
				onClick={ () => pEditInviteAccessLink(id, accessLink)}>Edit Access link</Button>
			</Box>
			<Box
				px={px}
				py={py}
				display='flex'
				borderBottom={1}
			>
				<StatelessTextInput
				display="block"
				value={radius}
				onChange={(e) => 
					{
						const re = /^[0-9\b]+$/;
						if(e.currentTarget.value === '' || re.test(e.currentTarget.value))
							setRadius(Number(e.currentTarget.value));
					}}
				/>
				<Button 
					width={250}
				onClick={ () => pEditInviteRadius(id, radius)}>Edit Radius</Button>
			</Box>
			<Box 
				borderBottom={1}
				px={px}
				py={py}
				display='flex'
			>
				<StatelessTextInput onChange={(e) => setSearch(e.currentTarget.value)}/>
				<Button 
					width={250}
					onClick={() => {
					if(patpValidate(search))
						pAddReceiveShip(id, search);
				}}>Add new ship</Button>
			</Box>
			{ invite.receiveShips.map(receiveShip => {
				return (
				<Box 
					border={1}
					//px={px}
					//py={py}
					m={1}
					display='flex'
					// justifyContent='center'
					alignItems='center'
				>
					<Box pl={1} width='100%'><Text>{receiveShip.ship}</Text></Box>
					{/* <Box><Text>{receiveShip.shipInvite}</Text></Box> */}
					{ receiveShip.shipInvite === 'pending' &&
						<Icon position='center' icon="WestCarat" height='30' data-tip='location tooltip'/>
					}
					{ receiveShip.shipInvite === 'accepted' &&
						<Icon position='center' icon="Checkmark" size={200} data-tip='location tooltip'/>
					}
					<Button width={200} onClick={() => {pDelReceiveShip(id, receiveShip.ship)}}>Uninvite Ship</Button>
				</Box>
				)
			})}
			<Button 
				px={px}
				py={py}
				my={5}
				// mx={2}
				width={200}
				border={1}
			onClick={() => focusInvite({})}>Return</Button>
		</Box>
	 );
		else if(invite.initShip === '~' + window.urbit.ship)
		return (
			<Box>
			{ invite.receiveShips.map(receiveShip => {
				return (
				<Box border={1}>
					<Box><Text>{receiveShip.ship}</Text></Box>
					<Box><Text>{receiveShip.shipInvite}</Text></Box>
				</Box>
				)
			})}
			<Button 
				px={px}
				py={py}
				width={200}
				border={1}
				onClick={() => focusInvite({})}>Return</Button>
			</Box>
		)
	else
		return (
			<Box>
				<Box>
					<Text>{invite.desc}</Text>
				</Box>
				<Box>
					<Text>{invite.locationType}</Text>
				</Box>
				<Box>
					<Text>{invite.accessLink}</Text>
				</Box>
				<Box>
					<Text>{invite.address}</Text>
				</Box>
				<Box>
					<Text>{invite.radius}</Text>
				</Box>
				<Box>
					<Text>{invite.maxAccepted}</Text>
				</Box>
			{ invite.receiveShips.map(receiveShip => {
				return (
				<Box 
					display='flex'
					border={1}
					px={2}
					py={2}
					m={2}
					justifyContent='space-between'
				>
					{ receiveShip.shipInvite === 'pending' &&
					<Box
							><Text color='blue'>Pending</Text></Box>
					}
					{ receiveShip.shipInvite === 'accepted' &&
					<Box
						marginRight='auto'
							><Text color='green'>Accepted</Text></Box>
					}
					<Box
						marginLeft='auto'
					><Text>{receiveShip.ship}</Text></Box>
				</Box>
				)
			})}
			<Button onClick={() => focusInvite({})}>Return</Button>
			</Box>
		)
}
export default FocusedInvite;
