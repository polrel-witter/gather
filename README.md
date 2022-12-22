# Gather
A meetup app for Urbit. Host and attend gatherings. 

## Install
In Grid: `~pontus-fadpun-polrel-witter/gather`

In Dojo: `|install ~pontus-fadpun-polrel-witter %gather`

## Usage

### Host a Gathering

New invites can be created under the Draft page. Before creating, you'll want to decide whether you want the invite to be public or private, and make sure your Advanced Host Options (in Settings) are set to your preferences for this invite. The invite will function differently based on your choices.

**Private Invites**

To send a private invite, you'll need to build an invitee list at the bottom of the Draft page. There are three methods to do so, and you can use a combination of all three: add ships individually, pull in fellow members of groups you're a part of, or select a collection that you've previously made. If you have any collections, they'll already appear in the list; you'll just need to select them to include the ships they contain. You can create a collection by selecting ships, groups, or other collections, entering a name in the collection field and clicking "Create Collection".

Once your list is made, you can click "Send" which will pass the invite to each ship.

**Public Invites**

Since public invites don't have invitee lists, a mars-link is generated upon creation which can be shared so others can view your invite. The mars-link is created by appending the invite's `@uv` ID to your ship's `@p` + gather, so it looks like: `~sampel-palnet/gather/0v6.yrj9.89y6.lah0`. The backend does this automatically for all public invites, and can be found in the invite details, post-creation. 

Additionally, if your ship has a domain, you can publish your public invites to the clearweb so that anyone can view them. To do this, you just need to append an invite-specific name to the URL you use to access your ship. A field for this is shown at the bottom of the Draft page if you have "public" selected. It would look something like `https://sampel-palnet.com/gather/gathering-title`

### Attend a Gathering

Not much to note here other than a few highlights:
- With a mars-link, you can search for its invite details under Invites > Inbox > Pending
- There's a button to RSVP and unRSVP
- If the host enabled chat, you'll see a button to join at the top-right of an invite. 

### Settings
If you prefer to filter meatspace invites happening far away, you can set a location and radius to create a bubble for yourself. The filter will apply to invites with a venue location, in which case they'll appear in your "Out-of-range" tab under Invites > Inbox. The location feature uses [Nominatim's API](https://nominatim.org/release-docs/develop/api/Search/) to pull coordinates which are stored locally and not shared with other ships. 

You can also ban ships, toggle notifications, and further permission your invite info with Advanced Host Options. 

## Deploy

1. Boot a fake ship
2. Merge and mount a desk:
```
|merge %work our %base
|mount %work
```
3. Run the install script to put the desk files into the new %work folder mounted on your OS filesystem (i.e. where your fake ship's pier folder is). You can hit `ctl+z` once the files copy over.
4. Then, `cd` into the `ui` directory and run `npm run build` to bundle the frontend code. If you don't have npm installed, you'll first need to run `npm install`.
5. Still in the `ui` directory, run `rsync -avL --delete dist/ ~/zod/work/gather` where `~zod` is your fake ship's pier.
5. After this, return to the dojo and run `|commit %work` so your fake ship recognizes the changes.
6. Switch dojo's working directory with `=dir /=garden`
7. Make the glob: `-make-glob %work /gather` 
8. The glob file (appended with `.glob`) can be found in `~zod/.urb/put` 
9. You can now upload the glob to a publicly available HTTP endpoint that can serve files. 
10. After uploading the glob, you'll want to update the docket file at `desk/desk.docket-0`. The URL and hash should be updated to match the glob we created.
11. In the dojo, run `|commit %work` one more time so your ship recognizes the change. 

## Gather Agents

`%gather` handles all operations excluding clearweb beaming, which is `%odyssey`'s job. `%terraform` builds the clearweb page using [rudder](https://github.com/Fang-/suite/blob/master/lib/rudder.hoon).

## Qs & Feedback

Drop us a line in `~polrel-witter/proposal-gather`.

Or DM us at `~polrel-witter` or `~pontus-fadpun`.
