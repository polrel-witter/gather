++ on-poke
- check the src to determine whether act is local or remote

++ local
 - %settings
   - %status-active
   	- switch status-active:settings on/off                                    :: should this be a toggle, or will the %.y or %.n come with the vase?
   	- give update-status fact to subscribers 
   - %gather-active
   	- switch gather-active:settings on/off
   	- give update-gather fact to subscribers
   - %address
   	- change address:settings
   	- gather coordinates 
   	- call %position:settings to update
   - %position
   	- update position:settings
   	- give update-status fact to subscribers
   - %radius
   	- change radius:settings
   	- give update-status fact to subscribers
   - %status-note
   	- change status-note:settings
   	- give update-status fact to subscribers
   - %receive-invite
   	- change receive-invite:settings                                            :: frontend tells backend; should frontend just display based on what's set here? i.e. no backend work required?
   - %receive-status
   	- change receive-status:settings
   		- if %only-in-radius: proximity check each ship before displaying   :: maybe this happens on frontend since we don't have markers indicating whether they're in range or not?
 - %edit-invite
   - %cancel
   	- give kick to all subscribers of this invite
   - %done
   	- give kick to all subscribers of this invite
   - %finalize
   	- switch finalized:invite to %.y
   	- give a update-invite fact to all subscribers to this invite
 - %send-invite
   - check to make sure ship is not we-ghosted=%.y and/or they-ghosted=%.y
   - pass the =invite as a %poke-as (request) to the target agent's ++on-poke arm with %subscribe-to-invite act
 - %accept
   - give invite-status=%accepted fact to host ship 
 - %deny
   - give invite-status=%denied fact to host ship
 - %done
   - give kick to all subscribers to current invite
 - %share-status
   - check to make sure ship is not we-ghosted=%.y and/or they-ghosted=%.y
   - pass a %poke-as (request) to the target agent's ++on-poke arm with %subscribe-to-gang-member act
 - %ghost
   - switch ship-info:we-ghosted to %.y/%.n in ships map

++ remote
 - %subscribe-to-invite
   - check to make sure src ship is not our ship
   - check if init ship is in $ships map
      - if not, add it, set ship-info to default values, and send a positive %watch-ack
      - if yes, check if we-ghosted
         - if we-ghosted=%y, pass a %poke-as (request) to the target agent's ++on-poke arm with %ghost act
         - if we-ghosted=%.n, pass a %watch-as (request) card to subscribe to the invite
 - %subscribe-to-gang-member 
   - check to make sure src ship is not our ship
   - add init ship to $ship map and subscribe to init ship's agent
 - %ghost
   - check to make sure src ship is not our ship
   - change they-ghosted to %.y
 
++ on-watch
 - %subscribe-to-invite
 - %subscribe-to-gang-member
 

++ on-agent
  - %watch-ack
  - %poke-ack
  - %kick
  - %fact
    - %update-gather
      - change ship-info:gather-active:settings to %.y/%.n
    - %update-invite
      - check the src ship to determine host
      - if our ship is host:
        - check for ship-invite changes
        - adjust frontend and beam updates in the receive-ship map to subscribers
      - if our ship is not host:
        - check for ship-invite changes such as update to receive-ship map, or whether the invite was finalized
    - %update-status
      - update the following within ship's ship-info:
        - status-active
        - position
        - radius
        - address
        - status-note

++ on-arvo





















