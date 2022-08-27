import React, { Component } from 'react';
import { Text, Box } from "@tlon/indigo-react";
import Location from "../shared/Location";
import Radius from "../shared/Radius";
import CustomGangs from "../shared/CustomGangs";
import GhostedShips from "../shared/GhostedShips";
// import { Col, Rule, Menu, MenuButton, Icon, MenuList, MenuItem} from "@tlon/indigo-react";
// import { TwoUp, Anchor, Badge, Paragraph, Action} from "@tlon/indigo-react";
const Settings = () => {
	return(
		<Box>
				<Location/>
				<Radius/>
				<CustomGangs/>
		</Box>
	 );
}

              // <Menu>
              //   <MenuButton width="100%" justifyContent="space-between">
              //     MenuButton
              //     <Icon ml="2" icon="ChevronSouth" />
              //   </MenuButton>
              //   <MenuList>
              //     <MenuItem onSelect={() => console.log("Command 1")}>
              //       Command 1
              //     </MenuItem>
              //     <MenuItem onSelect={() => console.log("Command 2")}>
              //       Command 2
              //     </MenuItem>
              //     <MenuItem onSelect={() => console.log("Command 3")}>
              //       Command 3
              //     </MenuItem>
              //   </MenuList>
              // </Menu>
export default Settings;

				{/* <Box width="50%"> */}
          {/* <Col p={p}> */}
            {/* <Rule /> */}
            {/* <Text py="2">{"<Text />"}</Text> */}

            {/* <Col> */}
              {/* <Text>Default</Text> */}
              {/* <Text */}
                {/* overflow="hidden" */}
                {/* whiteSpace="nowrap" */}
                {/* maxWidth="50px" */}
                {/* textOverflow="ellipsis" */}
              {/* > */}
                {/* asdfghjkl;qwertyuiop[zxcvbnm,.dsfgsdhsfhfg */}
              {/* </Text> */}
              {/* <Text mono>Monospace</Text> */}
              {/* <Text bold>Bold</Text> */}
              {/* <Text gray>Gray</Text> */}
              {/* <Anchor href="http://urbit.org">http://www.urbit.org</Anchor> */}
              {/* <Anchor target="_blank" href="http://urbit.org"> */}
                {/* Link to new Tab */}
              {/* </Anchor> */}
              {/* <div> */}
                {/* <Badge>Badge</Badge> */}
              {/* </div> */}
            {/* </Col> */}
            {/* <Box> */}
              {/* <Paragraph> */}
                {/* <Text>A </Text> */}
                {/* <Text color="green">bunch </Text> */}
                {/* <Text mono>of </Text> */}
                {/* <Text bold>inlined </Text> */}
                {/* <Text gray> */}
                  {/* If we haven’t seen them before, we can optionally register */}
                  {/* them for a new account. We then invalidate the token so it */}
                  {/* can’t be used again (though it was going to expire after 15 */}
                  {/* minutes, anyways). */}
                {/* </Text> */}
                {/* <Anchor href="http://urbit.org">elements</Anchor> */}
                {/* <Badge>Badge</Badge> */}
              {/* </Paragraph> */}
            {/* </Box> */}
          {/* </Col> */}

          {/* <Col p={p}> */}
            {/* <Rule /> */}
            {/* <Text py="2">{"<Action />"}</Text> */}
            {/* <Box> */}
              {/* <Badge>Badge</Badge> */}
              {/* <Action>Action</Action> */}
              {/* <Action disabled>Disabled Action</Action> */}
              {/* <Action destructive>Destructive Action</Action> */}
              {/* <Action destructive disabled> */}
                {/* Desctructive + Disabled Action */}
              {/* </Action> */}
            {/* </Box> */}
          {/* </Col> */}
