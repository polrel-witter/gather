# Gather
Gather is an [Urbit](https://urbit.org)-native meetup app that allows hosts to easily send invites to individual ships and/or members of groups they're a part of. And, from a guest's perspective, they can RSVP to invites they've received. 

Additionally, it connects to [Nominatim's API](https://nominatim.org/release-docs/develop/api/Search/) to pull in addresses which are used for location-based filtering. 

## Basic Functionality
### Draft Page
- Hosts can construct invites that contain a description, location type, location address, delivery radius, and number of RSVPs they'll accept.
- They can then build an invite list through any of the following methods:
  - Enter a ship manually and click "Add".
  - Either enter a group title containing the host ship (i.e. `~sampel-palnet/group-title`) and click "Add", or "Select" a group from the list which was pulled in upon opening the app.
  - Create a collection by selecting one or more ships and/or groups, then entering a title in the "Search ships, your groups, and create collections" field and click "Add".
- Clicking "Send" will pass the invite to all ships in the invite list.

### Invites
- This is where sent and received invites appear. 
- Invites you've sent include the following actions:
  - Inspect 
    - Make changes to your invite like adding new ships, changing the RSVP #, uninviting ships, etc.
    - See the invite list and who has RSVP'd.
  - Close
    - Stop receiving RSVPs.
  - Reopen
    - Begin receiving RSVPs again.
  - Complete
    - Essentially archives the invite; not possible to reopen once it's completed.
  - Delete
    - Deletes it locally. Others may choose to hold onto the invite.
  - Cancel
    - Ditto - deletes the invite from the host and all guests' ships.
- Invites you've received include the following actions:
  - RSVP
    - Let the host know you're planning on attending.
  - UnRSVP
    - Revoke your RSVP.
  - Delete
    - Deletes the invite locally.
  - Ban
    - Adds the host ship to your Banned Ships list in Settings (more info below).

### Settings
- Location is intended to be where you are so the Radius feature can determine which invites to filter out. For obvious privacy concerns, this field is left open-ended, and is not required. 
- "My Radius" is the distance within which you're open to receiving invites, _if_ the invite includes a location address. So for example, if your location is set to an address in downtown Austin, your radius is set to 100 Kilometers, and you have "Only in radius" selected, you won't see invites appear in your queue that contain location addresses outside that distance. This feature calculates everything in Kilometers.
- "Banned Ships" is your personal blacklist. Halt all sending and receiving invites to/from ships listed here. Adding a ship here does not notify it so your @p may be included in their future invites, but you won't actually recieve them. Additionally, a banned ship may be included in one or more collection or group of yours, however the backend will ensure it's removed from an invite before it is sent.
- "Receive invites from" is set to "Anyone" by default, which means what it says, and "Only in radius" can be toggled on, which is paired with "My Radius" and Location to filter out invites from galaxies far, far away.

## Install on Urbit
If in Grid, search: 
`~pontus-fadpun-polrel-witter/gather`

If in Dojo, run:
`|install ~pontus-fadpun-polrel-witter %gather`
