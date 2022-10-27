::
::  Gather: host and attend subterranean gatherings. Official distro moon:
::  ~pontus-fadpun-polrel-witter
:: 
/-  *gather, group, res-sur=resource, hark=hark-store
/+  *gather, res-lib=resource, default-agent, dbug, agentio
|%
::
+$  versioned-state
  $%  state-1
      state-0
  ==
::
::
:: Latest state structure
+$  state-1  [%1 =invites =settings]
::
::
:: Old state structures
+$  state-0        [%0 =invites-0 =settings-0] 
+$  ship-invite-0  ship-invite:zero
+$  invite-0       invite:zero
+$  invites-0      invites:zero
+$  settings-0     settings:zero
::
::
:: Random aliases 
+$  card  card:agent:gall
::
::
:: Alterable settings
+$  wht
  $?
    %address
    %position
    %radius
    %receive-invite
    %excise-comets
    %notifications
    %catalog
    %enable-chat
  ==
::
::
:: Invite pieces alterable by host 
+$  wut
  $?
    %description    %location-type
    %position       %address
    %access-link    %radius
    %max-accepted   %host-status
    %title          %image
    %date           %access
    %earth-link     %excise-comets  
    %enable-chat
  ==
::
--
::
%-  agent:dbug
=|  state-1
=*  state  -
^-  agent:gall
=<
|_  bol=bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bol)
    io    ~(. agentio bol)
    hc    ~(. +> bol)
++  on-init
  ^-  (quip card _this)
  :-  :~  (~(poke pass:io /(scot %p our.bol)/[%settings]) [our.bol %gather] gather-action+!>(`action`[%refresh-groups ~]))   
      ==
  %=  this
    settings  :*
                 [.500 .500] 
                 *radius
                 *address
                 *(map id collection)
                 *banned
                 %anyone
                 *reminders
                 *notifications
                 `%.n
                 `[%host-only %rsvp-only %host-only %host-only %rsvp-only %host-only]
                 %.y
  ==          ==
:: 
++  on-save  !>(state)
::
++  on-load  
  |=  old-state=vase
  |^  ^-  (quip card _this)
  =/  old=versioned-state  !<(versioned-state old-state)
  ?-  -.old
    %1  `this(state old)
    %0  `this(state (from-0-to-1 old))     
  ==
  ++  from-0-to-1
    |=  old=state-0
    ^-  state-1
    =/  old-invites=invites-0    +<:old
    =/  old-settings=settings-0  +>:old 
    =/  new-invites=_invites 
      %-  ~(run by old-invites)
      |=  i=invite-0
      ^-  invite
      =/  rs=(map @p ship-invite)          
        %-  ~(run by receive-ships.i)
        |=  si=ship-invite-0
        ^-  =ship-invite
        `[si [~]]
      :*
         init-ship.i                 desc.i
         rs                          location-type.i
         position.i                  address.i
         `access-link.i              radius.i
         `max-accepted.i             `accepted-count.i
         host-status.i               [~] 
         *image                      *date
         [~]                         *access           
         *mars-link                  *earth-link
         `%.n                        [~] 
         `[%anyone %anyone %anyone %anyone %anyone %anyone]
         %.n
      == 
    =/  new-settings=_settings 
      :* 
         position.old-settings 
         radius.old-settings
         address.old-settings
         collections.old-settings
         banned.old-settings
         receive-invite.old-settings
         *reminders
         *notifications
         `%.n
         `[%host-only %rsvp-only %host-only %host-only %rsvp-only %host-only]
         %.y
      ==       
    [%1 new-invites new-settings]
  --
::
++  on-poke
  |=  [=mark =vase]
  |^  ^-  (quip card _this)      
  =^  cards  this
    ?+  mark  (on-poke:def mark vase)
      %gather-action  (handle-action !<(action vase))
    ==
  [cards this]
  ++  handle-action
    |=  act=action
    ^-  (quip card _this)
    ?-  -.act
       %edit-settings
     ~|  [%failed-to-edit-settings ~]
     ?>  =(our.bol src.bol)
     =/  alt=(list wht)  %-  alter-settings 
                           :*  settings
                               address.act
                               position.act
                               radius.act
                               receive-invite.act
                               excise-comets.act
                               notifications.act
                               catalog.act
                               enable-chat.act
                           ==
     |-
     ?~  alt
        ~&  "%gather: settings have been updated"
        :_  this
        :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])
        ==
     %=  $
        settings  ^-  _settings
                  ?-    i.alt
                      %address             settings(address address.act)
                      %position            settings(position position.act)
                      %radius              settings(radius radius.act)
                      %receive-invite      settings(receive-invite receive-invite.act)
                      %excise-comets       settings(excise-comets excise-comets.act)
                      %notifications       settings(notifications notifications.act)
                      %catalog             settings(catalog catalog.act)
                      %enable-chat         settings(enable-chat enable-chat.act)
                  ==
        alt  t.alt
     == 
  ::
       %gathering-reminder 
     ~|  [%failed-to-set-gathering-reminder ~]
     ?>  =(our.bol src.bol)
     ?<  =(alarm ~)
     =.  reminders.settings  %+  ~(put by gatherings.reminders.settings)
                               id.act
                             alarm.act
     =/  moment=@da  (need alarm.act)
     :_  this
     :~  [%pass /timers/gathering/(scot %uv id.act) %arvo %b %wait moment]
     == 
  ::
       %create-collection                                               :: TODO change mentions of $resource to group-store $resource
     ~|  [%unexpected-collection-request %create-collection ~]
     ?>  =(our.bol src.bol)
     ?.  =(~ resource.act)
       =/  old=id  (single-group-id [resource.act collections.settings]) 
       =/  r=resource:res-sur  (need resource.act) 
       =/  g=(unit group:group) 
         .^  (unit group:group)  %gx 
            ;:  welp  
               (path /(scot %p our.bol)/group-store/(scot %da now.bol))
               /groups
               (en-path:res-lib r)
               /noun
            ==
         ==
       =/  gang=members  -:(need g)
       =/  r=[@p @tas]  (need resource.act)   
       =/  name=tape  (oust [0 2] `tape`(scow %t +:r)) 
       =/  title=@t  (crip (weld (scow %p -:r) (runt [1 '/'] name))) 
       =.  collections.settings
         %+  ~(put by collections.settings)
            (scot %uv eny.bol)
            :* 
                title 
                gang
                %.y
                `r
            ==
       ::  ~&  "creating collection called {<`@t`+:r>}"
      :: =/  upd=collections.settings  (~(del by collections.settings) old)
       :_  this(collections.settings (~(del by collections.settings) old))
       :~ :: (~(poke pass:io /(scot %p our.bol)/[%settings]) [our.bol %gather] gather-action+!>(`action`[%del-collection old]))   
           (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
       == 
     =/  gang=members  (silt (remove-our [our.bol (remove-banned [(remove-dupes members.act) banned.settings])]))
     =.  collections.settings   
       %+  ~(put by collections.settings)
          (scot %uv eny.bol)
          :*
             title.act 
             gang
             selected.act
             resource.act
          ==
     ::  ~&  "creating collection called {<title.act>}"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==  
  ::
       %edit-collection
     ~|  [%unexpected-collection-request %edit-collection-title ~]
     ?>  =(our.bol src.bol)
     =/  gang=members  (silt (remove-our [our.bol (remove-banned [(remove-dupes members.act) banned.settings])]))
     =.  collections.settings  
       %+  ~(jab by collections.settings)
          id.act
       |=  =collection
       %=  collection 
          title     title.act
          members   gang
          selected  selected.act  
          resource  resource.act
       ==
     ::  ~&  "updated collection {<title.act>}"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==
  ::
       %del-collection
     ~|  [%unexpected-collection-request %del-collection ~]
     ?>  =(our.bol src.bol)
     =.  collections.settings  (~(del by collections.settings) id.act)
     ::  ~&  "deleting collection"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==
  ::
       %refresh-groups                                      :: TODO change mentions of $resource to group-store $resource
     ~|  [%bad-groups-pull ~]
     ?>  =(our.bol src.bol)
     ~&  "%gather: refreshing groups"
     =|  r=resource:res-sur
     =/  temp=(set resource:res-sur)  
       .^((set resource:res-sur) %gy /(scot %p our.bol)/group-store/(scot %da now.bol)/groups)
     =/  resources=(list resource:res-sur)  ~(tap in temp)
     =/  groups=(map resource:res-sur members)
       =|  export=(map resource:res-sur members)  
       |-
       ?~  resources  export
       =+  r=-:resources
       =/  g=(unit group:group) 
         .^  (unit group:group)  %gx 
            ;:  welp  
               (path /(scot %p our.bol)/group-store/(scot %da now.bol))
               /groups
               (en-path:res-lib r)
               /noun
            ==
         ==
       =/  gang=members  -:(need g)
       %=  $
         export  (~(put by export) r gang)
         resources  t.resources
       ==
     =.  collections.settings
       =/  group-ids=(list id)  (get-group-ids collections.settings)  
       |-
       ?~  group-ids  collections.settings
       %=  $
          collections.settings  (~(del by collections.settings) i.group-ids)
          group-ids  t.group-ids
       == 
     =+  eny=eny.bol
     =/  values=(list collection)   (make-collection-values groups)
     :-  :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])
             [%pass /timers/refresh-groups %arvo %b %wait (add now.bol `@dr`~h24)]
         ==
     %=  this
        collections.settings  |-  
                              ?~  values  collections.settings
                              %=  $
                                 collections.settings   
                                     %+  ~(put by collections.settings) 
                                        (scot %uv eny) 
                                        i.values
                               :: 
                                  values  t.values
                                  eny  +(eny)
     ==                       ==
  ::  
       %cancel
     ~|  [%failed-cancel ~]
     =/  inv=invite  (~(got by invites) id.act)
     =/  paths=[path path]  (forge [id.act init-ship.inv])
     ?.  =(our.bol src.bol)
       ?>  =(src.bol init-ship.inv)
       ::  ~&  "{<init-ship.inv>} has revoked an invite"
       :_  this(invites (~(del by invites) id.act))
       ^-  (list card)
       :*  (fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all]) 
           ?.  invite-updates.notifications.settings  ~
           =/  inscript=@t 
             (crip "has cancelled {<(need title.inv)>}") 
           ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
           =/  =bin:hark      :*  /[dap.bol] 
                                  q.byk.bol 
                                  /(scot %p src.bol)/[%invite] 
                              ==
           =/  =body:hark     :*  ~[ship+src.bol text+inscript]
                                  ~
                                  now.bol
                                  /
                                  /gather
                              == 
           =/  =action:hark   [%add-note bin body]
           =/  =cage          [%hark-action !>(action)]
           [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~ 
       ==
     ?.  =(our.bol init-ship.inv)
        ?<  =(our.bol init-ship.inv)
        :_  this(invites (~(del by invites) id.act))
        :~  [%pass -:paths %agent [init-ship.inv %gather] %leave ~]
            [%pass +:paths %agent [init-ship.inv %gather] %leave ~]
            (fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all]) 
        ==
     ?>  =(our.bol init-ship.inv)
     =/  receive-ships=(list @p)  
       ~(tap in ~(key by receive-ships.inv))
     =+  dek=*(list card)
     |-
     ?~  receive-ships
       ::  ~&  "revoking invite with id {<id.act>}"
       =.  invites  
          (~(del by invites) id.act)
       =+  kik=[%give %kick ~[-:paths +:paths /all] ~]
       =+  fak=(fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all]) 
       :_  this  
          (snoc (into dek 0 fak) kik)
     %=  $
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  -:paths
                       %agent  [i.receive-ships %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel id.act])
                     ==
                     :*
                       %pass  +:paths
                       %agent  [i.receive-ships %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel id.act])
             ==  ==  ==
        receive-ships  t.receive-ships
     ==
  ::  
       %del-receive-ship
     ~|  [%failed-to-del-receive-ship ~]
     =/  inv=invite  (~(got by invites) id.act) 
     ?.  =(our.bol src.bol)
       ?>  =(src.bol init-ship.inv)                                       
       ~&  "you've been uninvited from {<init-ship.inv>}'s invite"
       :_  this(invites (~(del by invites) id.act))
       :~  (fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all])  
       ==
     ?>  =(our.bol init-ship.inv)
     =/  paths=[path path]  (forge [id.act init-ship.inv])
     ~&  "removing {<del-ships.act>} from invite {<id.act>}"    
     =+  dek=*(list card)
     |-
     ?~  del-ships.act
       =+  upd=(~(got by invites) id.act)
       =+  rsv=(veil [%rsvp upd])
       =+  air=(veil [%invite upd])
       =/  faks=(list card)
         :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[/all])
             (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
             (fact:io gather-update+!>(`update`[%update-invite id.act air]) ~[-:paths])
         == 
       [(welp faks dek) this]                           
     %=  $
        invites  %+  ~(jab by invites)
                   id.act
                 |=  =invite
                 =/  sts=invitee-status
                   -:(need (~(got by receive-ships.invite) i.del-ships.act))
                 ::
                 %=  invite
                    accepted-count  ?:  =(%accepted sts)
                                       (some (dec (need accepted-count.invite)))
                                    accepted-count.invite
                                    ::
                    receive-ships   %-  ~(del by receive-ships.invite) 
                                      i.del-ships.act
                 ==
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  -:paths
                       %agent  [i.del-ships.act %gather]
                       %poke  %gather-action
                       !>(`action`[%del-receive-ship id.act *(list @p)])
                     ==
                     :*
                       %pass  +:paths
                       %agent  [i.del-ships.act %gather]
                       %poke  %gather-action
                       !>(`action`[%del-receive-ship id.act *(list @p)])
                     ==
                     :*
                       %give  %kick
                       ~[-:paths +:paths]
                       `i.del-ships.act
             ==  ==  ==
        del-ships.act  t.del-ships.act
     ==
  ::  
       %add-receive-ship
     ~|  [%failed-add-receive-ship ~]
     ?>  =(our.bol src.bol)
     =/  inv=invite  (~(got by invites) id.act) 
     ?>  =(our.bol init-ship.inv)
     =/  paths=[path path]  (forge [id.act init-ship.inv])
     =/  add-ships=(list @p)
       %+  remove-our  our.bol
         %-  remove-banned  
           :-  (remove-dupes add-ships.act) 
               banned.settings
           ::
     ::  ~&  "adding {<add-ships>} to invite list on invite {<id.act>}"    
     =+  dek=*(list card)
     |-
     ?~  add-ships
       =+  upd=(~(got by invites) id.act)
       =+  rsv=(veil [%rsvp upd])
       =+  air=(veil [%invite upd])
       =/  faks=(list card)
         :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[/all])
             (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
             (fact:io gather-update+!>(`update`[%update-invite id.act air]) ~[-:paths])
         ==
       [(welp faks dek) this]                            
     %=  $
        invites  %+  ~(jab by invites)
                   id.act
                 |=  =invite
                 %=  invite
                    receive-ships  %+  ~(put by receive-ships.invite) 
                                     i.add-ships  `[%pending [~]] 
                 ==
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  -:paths 
                       %agent  [i.add-ships %gather]
                       %poke  %gather-action
                       !>(`action`[%subscribe-to-invite id.act [~]])
             ==  ==  ==
        add-ships  t.add-ships
     == 
  ::
       %edit-invite
     ~|  [%failed-to-edit-invite ~]
     ?>  =(our.bol src.bol)
     =/  inv=invite  (~(got by invites) id.act)
     ?>  =(our.bol init-ship.inv)
     =/  paths=[path path]  (forge [id.act init-ship.inv])
     =/  alt=(list wut)  %-  alter-invite 
                           :*  inv                 desc.act
                               location-type.act   position.act
                               address.act         access-link.act
                               max-accepted.act    radius.act
                               host-status.act     title.act
                               image.act           date.act
                               access.act          earth-link.act     
                               excise-comets.act   enable-chat.act
                           == 
     |-
     ?~  alt
        =.  invites  %+  ~(jab by invites)
                       id.act
                     |=(=invite invite(last-updated `now.bol))
        =/  inv=invite  (~(got by invites) id.act)
        =+  rsv=(veil [%rsvp inv])
        =+  air=(veil [%invite inv])
        ~&  "{<(need title.inv)>} has been updated"
        :_  this
        :~  (fact:io gather-update+!>(`update`[%update-invite id.act inv]) ~[/all])
            (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
            (fact:io gather-update+!>(`update`[%update-invite id.act air]) ~[-:paths])
        ==
     %=  $
        invites  %+  ~(jab by invites)
                   id.act
                 |=  inv=invite
                 ^-  =invite
                 ?-    i.alt
                    %description     inv(desc desc.act)
                    %location-type   inv(location-type location-type.act)
                    %position        inv(position position.act)
                    %address         inv(address address.act)
                    %access-link     inv(access-link access-link.act)
                    %radius          inv(radius radius.act)
                    %host-status     inv(host-status host-status.act)
                    %title           inv(title title.act)
                    %image           inv(image image.act)
                    %date            inv(date date.act)
                    %access          inv(access access.act)
                    %earth-link      inv(earth-link earth-link.act)
                    %excise-comets   inv(excise-comets excise-comets.act)
                    %enable-chat     inv(enable-chat enable-chat.act)
                    %max-accepted    %=  inv
                                       max-accepted  ?.  (lte (need accepted-count.inv) (need max-accepted.act))
                                                       ?.  =(0 (need max-accepted.act))
                                                         ~&  "%gather... fail: new RSVP limit is below the number of existing RSVPs"
                                                         !!
                                                       max-accepted.act
                                                     max-accepted.act
           ==                        == 
        alt  t.alt
     ==
  :: 
       %send-invite
     ~|  [%failed-send-invite ~]
     ?>  =(our.bol src.bol)
     =/  =id  (scot %uv eny.bol)
     =/  =path  /(scot %p our.bol)/[%invite]/id
     =/  =mars-link
       ?.  ?=(%public access.act)
         [~] 
       =/  gat=tape  (weld "gather" (runt [1 '/'] (scow %uv id)))
       (some (crip (weld (scow %p our.bol) (runt [1 '/'] gat)))) 
     ::
     =/  carton=[juice=(map @p =ship-invite) sugar=(list @p)]
       ?.  ?=(%private access.act)  [*(map @p =ship-invite) *(list @p)]
       =/  pulp=(list @p)
         %+  remove-our  our.bol
           %-  remove-banned  
             :-  (remove-dupes send-to.act) 
                 banned.settings
             ::
       =/  sugar=(list @p)
         ?.  (need excise-comets.act)  pulp
         pulp
       ::::      (remove-comets pulp)                 :: TODO complete lib arm 
       [(blend sugar) sugar]
     =/  new=invite 
       :*  our.bol            desc.act
           juice.carton       location-type.act
           position.act       address.act
           access-link.act    radius.act
           max-accepted.act   `0
           %sent              title.act
           image.act          date.act
           `now.bol           access.act
           mars-link          earth-link.act
           excise-comets.act  ~
           catalog.settings   enable-chat.act 
       ==
     =.  invites  (~(put by invites) id new)
     ?.  ?=(%private access.new)
       ~&  "%gather: created new public invite"
       `this 
     ~&  "%gather: sending private invite..."
     =+  dek=*(list card)
     =+  fak=(fact:io gather-update+!>(`update`[%update-invite id new]) ~[/all])
     |-
     ?~  sugar.carton
       [(into dek 0 fak) this]         
     %=  $
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  path
                       %agent  [i.sugar.carton %gather]
                       %poke  %gather-action
                       !>(`action`[%subscribe-to-invite id [~]])
             ==  ==  ==
        sugar.carton  t.sugar.carton
     ==
  ::
       %accept        
     ~|  [%failed-accept ~]
     ?:  =(our.bol src.bol)
       ?.  =(ship.act ~)
         =/  =ship  (need ship.act)
         ?<  =(our.bol ship)
         ?<  (~(has in banned.settings) ship)
         =/  =path  /(scot %p ship)/[%invite]/(scot %uv id.act)
         :_  this
         :~  [%pass path %agent [ship %gather] %watch path]
         ==
       =/  inv=invite  (~(got by invites) id.act)
       ?<  =(our.bol init-ship.inv)
       =/  =path  /(scot %p init-ship.inv)/[%invite]/(scot %uv id.act)
       :_  this
       :~  (~(poke pass:io path) [init-ship.inv %gather] gather-action+!>(`action`[%accept id.act [~]]))   
       ==
     =/  inv=invite  (~(got by invites) id.act)
     ?>  =(our.bol init-ship.inv)
     ?>  ?=([%sent] host-status.inv)
     ?>  (~(has by receive-ships.inv) src.bol)
     ?>  ?=(%private access.inv)
     =/  paths=[path path]  (forge [id.act init-ship.inv])
     =+  rsv=(veil [%rsvp inv])
     =+  air=(veil [%invite inv])
     :-  :~  :*
               %pass  +:paths 
               %agent  [src.bol %gather] 
               %poke  %gather-action 
               !>(`action`[%subscribe-to-rsvp id.act])
             ==
             [%give %kick ~[-:paths] `src.bol]
             (fact:io gather-update+!>(`update`[%update-invite id.act inv]) ~[/all])
             (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
             (fact:io gather-update+!>(`update`[%update-invite id.act air]) ~[-:paths])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=(=invite inv)
     ==
  ::
       %deny
     ~|  [%failed-deny ~]
     =/  inv=invite  (~(got by invites) id.act) 
     =/  paths=[path path]  (forge [id.act init-ship.inv])
     ?:  =(our.bol src.bol)
       ?<  =(our.bol init-ship.inv)
       :_  this
       :~  (~(poke pass:io +:paths) [init-ship.inv %gather] gather-action+!>(`action`[%deny id.act]))   
       ==
     ?>  =(our.bol init-ship.inv)
     ?<  ?=(%completed host-status.inv)    
     =/  =invitee-status  -:(need (~(got by receive-ships.inv) src.bol))
     ?>  ?=(%accepted invitee-status)
     =+  rsv=(veil [%rsvp inv])
     =+  air=(veil [%invite inv])
     :-  :~  [%give %kick ~[+:paths] `src.bol]
             :*
               %pass  -:paths 
               %agent  [src.bol %gather] 
               %poke  %gather-action 
               !>(`action`[%subscribe-to-invite id.act [~]])
             == 
             (fact:io gather-update+!>(`update`[%update-invite id.act inv]) ~[/all])
             (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
             (fact:io gather-update+!>(`update`[%update-invite id.act air]) ~[-:paths])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=(=invite inv)
     ==
  ::
       %subscribe-to-rsvp    
     ~|  [%failed-subscribe-to-rsvp ~]
     ?<  =(our.bol src.bol)
     ?<  (~(has in banned.settings) src.bol)
     =/  =path  /(scot %p src.bol)/[%rsvp]/(scot %uv id.act)
     :_  this
     :~  [%pass path %agent [src.bol %gather] %watch path]
     == 
  ::
       %subscribe-to-invite   
     ~|  [%failed-subscribe-to-invite ~]
     ?:  =(our.bol src.bol)
       ?<  =(ship.act ~)      
       =/  =ship  (need ship.act)
       ?<  (~(has in banned.settings) ship)
       =/  =path  /(scot %p ship)/[%invite]/(scot %uv id.act)
       ~&  "%gather: sending invite subscription request to {<ship>}"
       :_  this
       :~  [%pass path %agent [ship %gather] %watch path]
       == 
     ?:  (~(has by invites) id.act) 
       =/  inv=invite  (~(got by invites) id.act) 
       ?>  =(src.bol init-ship.inv)
       =/  =path  /(scot %p init-ship.inv)/[%invite]/(scot %uv id.act)
       ~&  "%gather: successfully unrsvp'd from {<init-ship.inv>}'s invite"
       :_  this
       :~  [%pass path %agent [init-ship.inv %gather] %watch path]
       ==  
     ~&  "%gather: received invite from {<src.bol>}, subscribing..."
     =/  =path  /(scot %p src.bol)/[%invite]/(scot %uv id.act)
     :_  this
     ^-  (list card)
     :*  [%pass path %agent [src.bol %gather] %watch path]
         ?.  new-invites.notifications.settings  ~
         ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
         =/  =bin:hark      :*  /[dap.bol] 
                                q.byk.bol 
                                /(scot %p src.bol)/[%invite] 
                            ==
         =/  =body:hark     :*  ~[text+'An invite has arrived from ' ship+src.bol]
                                ~
                                now.bol
                                /
                                /gather
                            == 
         =/  =action:hark   [%add-note bin body]
         =/  =cage          [%hark-action !>(action)]
         [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~ 
     ==
  ::
       %ban
     ~|  [%failed-ban ~]
     ?>  =(our.bol src.bol)
     ?<  =(our.bol ship.act)
     ~&  "%gather: banning {<ship.act>}"
     ?:  (~(has in banned.settings) ship.act)
        `this
     =/  their-ids=(list id)      (id-comb [ship.act our.bol invites])
     =/  accepted-ids=(list id)   %-  get-accepted-ids  
                                    :*  
                                      our.bol 
                                      invites 
                                      their-ids
                                    ==
     =/  our-ids=(list id)    (id-comb [our.bol ship.act invites]) 
     =+  levs=*(list card)
     =+  poks=*(list card)
     =+  kiks=*(list card)
     =+  faks=*(list card)
     |-
     ?~  our-ids
        =:  banned.settings  (~(put in banned.settings) ship.act)
         ::
           invites  |- 
                    ?~  their-ids  invites
                    %=  $
                      invites       (~(del by invites) i.their-ids)
                      their-ids  t.their-ids  
                    ==        
         ::
           levs   |-
                  ?~  accepted-ids  levs
                  %=  $
                    levs  ;:  welp  levs
                             :~  :*
                                   %pass
                                   /(scot %p ship.act)/[%rsvp]/(scot %uv i.accepted-ids)
                                   %agent  [ship.act %gather]
                                   %leave  ~
                         ==  ==  ==
                    accepted-ids  t.accepted-ids
                  ==
         ::
           poks   |-
                  ?~  accepted-ids  poks
                  %=  $
                     poks  ;:  welp  poks
                              :~  :*
                                    %pass  
                                    /(scot %p ship.act)/[%rsvp]/(scot %uv i.accepted-ids)
                                    %agent  [ship.act %gather]
                                    %poke  %gather-action
                                    !>(`action`[%deny i.accepted-ids])
                          ==  ==  ==
                     accepted-ids  t.accepted-ids
       ==          ==
       =+  fak=~[(fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])]  
       :_  this
           :(welp fak kiks levs poks faks)  
     ::
     =/  inv=invite  (~(got by invites) i.our-ids)
     =/  =invitee-status  -:(need (~(got by receive-ships.inv) ship.act))
     =:  
         accepted-count.inv  ?:  =(%accepted invitee-status)
                               (some (dec (need accepted-count.inv)))
                             accepted-count.inv

         receive-ships.inv   %-  ~(del by receive-ships.inv) 
                               ship.act
                             ==
     =+  rsv=(veil [%rsvp inv])
     =+  air=(veil [%invite inv])
     =/  paths=[path path]  (forge [i.our-ids our.bol])
     %=  $
        poks  ;:  welp  poks
                 :~  :*
                       %pass   -:paths
                       %agent  [ship.act %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel i.our-ids])
                     ==
                     :*
                       %pass   +:paths
                       %agent  [ship.act %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel i.our-ids])
             ==  ==  ==
        kiks  ;:  welp  kiks  
                 :~  :* 
                       %give  %kick
                       ~[-:paths +:paths]
                       `ship.act
             ==  ==  ==
        invites  %+  ~(jab by invites)
                   i.our-ids
                 |=(=invite inv)
        faks  ;:  welp  faks  
                 :~  :*
                       %give
                       %fact
                       ~[/all]
                       gather-update+!>(`update`[%update-invite i.our-ids inv])
                 ==  ==
                 :~  :*
                       %give
                       %fact
                       ~[+:paths]
                       gather-update+!>(`update`[%update-invite i.our-ids rsv])
                 ==  ==
                 :~  :*
                       %give
                       %fact
                       ~[-:paths]
                       gather-update+!>(`update`[%update-invite i.our-ids air])
             ==  ==  ==
        our-ids  t.our-ids
     ==
  ::
       %unban
     ~|  [%failed-unban ~]
     ?>  =(our.bol src.bol)
     ?:  (~(has in banned.settings) ship.act)
        ~&  "%gather: unbanning {<ship.act>}"
        =.  banned.settings
           (~(del in banned.settings) ship.act)
        :_  this
        :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
        ==
     `this
    ==   
  -- 
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?.  ?=([@ @ @ ~] wire)
    ?+   `@tas`(slav %tas +<:wire)  ~&([dap.bol %strange-wire wire] [~ this])
        %hark      
      ?+    -.sign  (on-agent:def wire sign)
          %poke-ack
        ?~  p.sign  [~ this]
        ~&  "%gather: failed to notify"
        [~ this]
      == 
    ::
        %settings
      ?+    -.sign  (on-agent:def wire sign)
          %poke-ack
        [~ this]
      ==
    ==
  ?+   `@tas`(slav %tas i.t.wire)  ~&([dap.bol %strange-wire wire] [~ this])    
      %invite                                                  
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign  [~ this]
      ~&  "%gather: invite subscription to {<src.bol>} failed"
      [~ this] 
    ::
        %kick
      :_  this
      :~  (~(watch pass:io wire) [src.bol %gather] wire)
      ==
    ::
        %fact
      ?>  ?=(%gather-update p.cage.sign)
      =/  =update  !<(update q.cage.sign)
      ?+    -.update  (on-agent:def wire sign)
          %update-invite                 
        =+  upd=update
        ?.  (~(has by invites) id.upd)
          ~&  "%gather: adding new invite from {<src.bol>}"
          :_  this(invites (~(put by invites) id.upd invite.upd))
          :~  (fact:io cage.sign ~[/all])
          ==
        ::  ~&  "{<src.bol>} has updated their invite (id {<id.upd>})"
        =/  inv=invite  (~(got by invites) id.upd)
        ?>  =(src.bol init-ship.inv)
 ::   |-  ^-  (list card)
 ::   =+  hrks=(list card)
 ::   =/  alt=(list wut)  (alter-invite [inv invite.upd])
 ::   ?~  alt 
 ::     :-  :(welp hrks (fact:io cage.sign ~[/all]))
        :_  %=  this
              invites  %+  ~(jab by invites)
                         id.upd
                       |=(=invite invite.upd)
            ==
 ::   %=  $
 ::      hrks
 ::          ?-    i.alt
 ::              %description
 ::              %location-type
 ::              %address
 ::              %access-link
        ^-  (list card)
        :*  (fact:io cage.sign ~[/all])
            ?.  invite-updates.notifications.settings  ~
 ::     =/  alt=[? (unit ?(%description %location-type %address %access-link))] 
 ::       (alter-invite [inv invite.upd])
 ::     ?.  -:alt  ~
            =/  inscript=@t 
              (crip "has made a change to {<(need title.inv)>}") 
            ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
            =/  =bin:hark      :*  /[dap.bol] 
                                   q.byk.bol 
                                   /(scot %p src.bol)/[%invite] 
                               ==
            =/  =body:hark     :*  ~[ship+src.bol text+inscript]
                                   ~
                                   now.bol
                                   /
                                   /gather
                               == 
            =/  =action:hark   [%add-note bin body]
            =/  =cage          [%hark-action !>(action)]
            [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~
        ==
      ==
    ==
  ::
      %rsvp                                                  
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign  [~ this]
      ~&  "%gather: rsvp subscription to {<src.bol>} failed"
      [~ this] 
    ::
        %kick
      :_  this
      :~  (~(watch pass:io wire) [src.bol %gather] wire)
      ==
    ::
        %fact
      ?>  ?=(%gather-update p.cage.sign)
      =/  =update  !<(update q.cage.sign)
      ?+    -.update  (on-agent:def wire sign)
          %update-invite                 
        =+  upd=update
        ?.  (~(has by invites) id.upd)
          ~&  "%gather: adding rsvp details from {<src.bol>}"
          :_  this(invites (~(put by invites) id.upd invite.upd))
          :~  (fact:io cage.sign ~[/all])
          ==
        ~&  "{<src.bol>} has updated their rsvp details"
        =/  inv=invite  (~(got by invites) id.upd)
        ?>  =(src.bol init-ship.inv)
        :_  %=  this
              invites  %+  ~(jab by invites)
                         id.upd
                      |=(=invite invite.upd)
            ==
        ^-  (list card)
        :*  (fact:io cage.sign ~[/all])
            ?.  invite-updates.notifications.settings  ~
       ::     =/  alt=[? (unit ?(%description %location-type %address %access-link))]
       ::       (alter-invite [inv invite.upd])
       ::     ?.  -:alt  ~
            =/  inscript=@t 
              (crip "has made a change to {<(need title.inv)>}") 
            ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
            =/  =bin:hark      :*  /[dap.bol] 
                                   q.byk.bol 
                                   /(scot %p src.bol)/[%invite] 
                               ==
            =/  =body:hark     :*  ~[ship+src.bol text+inscript]
                                   ~
                                   now.bol
                                   /
                                   /gather
                               == 
            =/  =action:hark   [%add-note bin body]
            =/  =cage          [%hark-action !>(action)]
            [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~
        ==
      ==
    ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?:  ?=([%all ~] path)
    ?>  =(our.bol src.bol)
    :_  this
    :~  %-  fact-init:io
        gather-update+!>(`update`[%init-all invites settings])
    ==
  ?>  ?=([@ @ @ ~] path)
  ?+   i.t.path  (on-watch:def path)
      %invite                                                 
    =/  =id  `@uv`(slav %uv i.t.t.path)
    ?>  =(our.bol (slav %p i.path))
    =/  inv=invite  (~(got by invites) id)
    ?>  =(our.bol init-ship.inv)
    ?>  ?=(%sent host-status.inv)  
    ?<  (~(has in banned.settings) src.bol) 
    ?:  ?=(%private access.inv)
      =/  =invitee-status
        -:(need (~(got by receive-ships.inv) src.bol))
      ?.  ?=(%pending invitee-status)
        !! 
      =.  accepted-count.inv  (some (dec (need accepted-count.inv)))
      =/  air=invite  (veil [%invite inv])
      :-  :~  (fact:io gather-update+!>(`update`[%update-invite id air]) ~[path])
          ==
      %=  this
         invites  %+  ~(jab by invites)
                    id
                  |=(=invite inv)
      ==
    =:  accepted-count.inv  ?.  (~(has by receive-ships.inv) src.bol)
                              accepted-count.inv
                            =/  =invitee-status
                              -:(need (~(got by receive-ships.inv) src.bol))
                            ?.  ?=(%accepted invitee-status)
                              accepted-count.inv
                            (some (dec (need accepted-count.inv)))
    ::
        receive-ships.inv   ?.  (~(has by receive-ships.inv) src.bol)
                              %+  ~(put by receive-ships.inv) 
                                 src.bol  `[%pending [~]] 
                            %+  ~(jab by receive-ships.inv)
                                 src.bol
                              |=  =ship-invite 
                              ^-  _ship-invite
                              `[%pending [~]]
    ==
    =/  air=invite  (veil [%invite inv])
    :-  :~  (fact:io gather-update+!>(`update`[%update-invite id air]) ~[path])
        ==
    %=  this
       invites  %+  ~(jab by invites)
                   id
                 |=(=invite inv)
    ==           
  ::
      %rsvp  
    =/  =id  `@uv`(slav %uv i.t.t.path)
    ?>  =(our.bol (slav %p i.path))
    =/  inv=invite  (~(got by invites) id)
    ?>  =(our.bol init-ship.inv)
    ?>  ?=(%sent host-status.inv)  
    ?>  ^-   ?
        ?-   access.inv
            %public
          ?<  (~(has in banned.settings) src.bol)  %.y
        ::
            %private
          =/  =invitee-status  -:(need (~(got by receive-ships.inv) src.bol))
          ?>  ?=(%pending invitee-status)  %.y
        ==
     =.  inv 
     ?>  ?:  =(max-accepted.inv ~)  %.y
         ?.  (gth +((need accepted-count.inv)) (need max-accepted.inv))  %.y
         ~&  "%gather: max accepted count for {<(need title.inv)>} has been reached"
         !! 
     %=  inv
        accepted-count  (some +((need accepted-count.inv)))
        receive-ships   ^-  (map @p ship-invite) 
                        ?-   access.inv
                            %private
                          %+  ~(jab by receive-ships.inv)
                            src.bol
                          |=  =ship-invite 
                          ^-  _ship-invite
                          `[%accepted `now.bol] 
                        ::   
                            %public
                          ?:  (~(has by receive-ships.inv) src.bol)
                            %+  ~(jab by receive-ships.inv)
                              src.bol
                            |=  =ship-invite 
                            ^-  _ship-invite
                            `[%accepted `now.bol] 
                          (~(put by receive-ships.inv) src.bol `[%accepted `now.bol])
     ==                 ==
     =/  rsv=invite  %-  veil  [%rsvp inv]
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id rsv]) ~[path])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id
                 |=(=invite inv)
     ==
  ==
::
++  on-arvo 
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%timers %refresh-groups ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
        [%behn %wake *]
      ?~  error.sign-arvo
        :_  this
        :~  (~(poke pass:io /(scot %p our.bol)/[%settings]) [our.bol %gather] gather-action+!>(`action`[%refresh-groups ~]))   
        ==
      (on-arvo:def wire sign-arvo)
    ==
      [%timers %gathering @ ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
         [%behn %wake *]
       ?~  error.sign-arvo
         =/  =id  `@uv`(slav %uv +>-:wire)
         ?>  %-  ~(has by gatherings.reminders.settings) 
               id
         =/  title=@t   
            +>+>+>+>+>+<:(~(get by gatherings.reminders.settings) id) 
         =/  inscript=@t  (crip "Reminder to check on {<title>}") 
         :_  %=  this
                gatherings.reminders.settings  %-  ~(del by gatherings.reminders.settings)
                                                 id
             ==
         ^-  (list card)
         :*
            ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
            =/  =bin:hark      :*  /[dap.bol] 
                                   q.byk.bol 
                                   /(scot %p src.bol)/[%reminder] 
                               ==
            =/  =body:hark     :*  ~[text+inscript]
                                   ~
                                   now.bol
                                   /
                                   /gather
                               == 
            =/  =action:hark   [%add-note bin body]
            =/  =cage          [%hark-action !>(action)]
            [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~
         ==
       (on-arvo:def wire sign-arvo)
    ==   
  == 
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  (on-peek:def path)
    ::
       [%x %collection %ship @ @ ~]               :: TODO change to group-store $resource
     =/  rid=(unit resource:res-sur)
        (de-path-soft:res-lib t.t.path)
     ?~  rid   ~
     =/  r=[@p @tas]  (need rid)
     ``noun+!>(`(unit collection)`(peek-collection `r))
  == 
++  on-leave  on-leave:def 
++  on-fail   on-fail:def
--
|_  bol=bowl:gall
+*  io    ~(. agentio bol)
::
::
:: Grabs a collection created from a group $resource
++  peek-collection
  |=  r=resource
  ^-  (unit collection)
  =/  cid=id  (single-group-id [r collections.settings])
  (~(get by collections.settings) cid)
::
::
:: Creates invite & rsvp paths
++  forge
  |=  [=id init-ship=@p]
  ^-  [path path]
  :_  /(scot %p init-ship)/[%rsvp]/(scot %uv id)
      /(scot %p init-ship)/[%invite]/(scot %uv id)
::
::
:: Builds list of what has changed in settings
++  alter-settings                       
  |=  $:  set=_settings 
          =address
          =position
          =radius
          =receive-invite
          excise-comets=(unit ?)
          =notifications
          =catalog
          enable-chat=?
      ==
  =|  chg=(list wht)
  =/  chk=(list wht)  
    :~  %address
        %position
        %radius
        %receive-invite
        %excise-comets
        %notifications
        %catalog
        %enable-chat
    ==
  |-  ^-  (list wht)
  ?~  chk  chg
  %=  $
     chg  ^-  (list wht) 
          ?-    i.chk
              %address          ?:(=(address.set address) chg (weld chg `(list wht)`~[i.chk]))  
              %position         ?:(=(position.set position) chg (weld chg `(list wht)`~[i.chk]))
              %radius           ?:(=(radius.set radius) chg (weld chg `(list wht)`~[i.chk]))
              %receive-invite   ?:(=(receive-invite.set receive-invite) chg (weld chg `(list wht)`~[i.chk])) 
              %excise-comets    ?:(=(excise-comets.set excise-comets) chg (weld chg `(list wht)`~[i.chk]))
              %notifications    ?:(=(notifications.set notifications) chg (weld chg `(list wht)`~[i.chk]))
              %catalog          ?:(=(catalog.set catalog) chg (weld chg `(list wht)`~[i.chk])) 
              %enable-chat      ?:(=(enable-chat.set enable-chat) chg (weld chg `(list wht)`~[i.chk])) 
          ==
     chk  
     t.chk 
  ==
::
::
:: Builds list of what has been changed by host in an invite
++  alter-invite
  |=  $:  inv=invite 
          desc=@t
          =location-type
          =position
          =address
          =access-link
          max-accepted=(unit @ud)
          =radius
          =host-status
          title=(unit @t)
          =image
          =date
          =access
          =earth-link
          excise-comets=(unit ?)
          enable-chat=?
      ==    
  =|  chg=(list wut)
  =/  chk=(list wut)  
    :~ 
       %description    %location-type
       %position       %address
       %access-link    %radius
       %max-accepted   %host-status
       %title          %image
       %date           %access
       %earth-link     %excise-comets  
       %enable-chat
    ==
  |-  ^-  (list wut)
  ?~  chk  chg
  %=  $
     chg  ^-  (list wut) 
          ?-    i.chk
              %description      ?:(=(desc.inv desc) chg (weld chg `(list wut)`~[i.chk]))  
              %location-type    ?:(=(location-type.inv location-type) chg (weld chg `(list wut)`~[i.chk]))
              %position         ?:(=(position.inv position) chg (weld chg `(list wut)`~[i.chk]))
              %address          ?:(=(address.inv address) chg (weld chg `(list wut)`~[i.chk])) 
              %access-link      ?:(=(access-link.inv access-link) chg (weld chg `(list wut)`~[i.chk]))
              %radius           ?:(=(radius.inv radius) chg (weld chg `(list wut)`~[i.chk]))
              %max-accepted     ?:(=(max-accepted.inv max-accepted) chg (weld chg `(list wut)`~[i.chk])) 
              %host-status      ?:(=(host-status.inv host-status) chg (weld chg `(list wut)`~[i.chk])) 
              %title            ?:(=(title.inv title) chg (weld chg `(list wut)`~[i.chk])) 
              %image            ?:(=(image.inv image) chg (weld chg `(list wut)`~[i.chk])) 
              %date             ?:(=(date.inv date) chg (weld chg `(list wut)`~[i.chk])) 
              %access           ?:(=(access.inv access) chg (weld chg `(list wut)`~[i.chk])) 
              %earth-link       ?:(=(earth-link.inv earth-link) chg (weld chg `(list wut)`~[i.chk])) 
              %excise-comets    ?:(=(excise-comets.inv excise-comets) chg (weld chg `(list wut)`~[i.chk])) 
              %enable-chat      ?:(=(enable-chat.inv enable-chat) chg (weld chg `(list wut)`~[i.chk])) 
         ==
     chk  
     t.chk 
  ==
::
::
:: Checks $catalog to determine hidden info 
++  veil 
  |=  [pax=?(%rsvp %invite) i=invite]
  ^-  =invite
  =/  c=catalog  catalog.i
  :*  init-ship.i        
      desc.i
      (rs-check [receive-ships.i +<:c +>+>+>:c pax]) 
      location-type.i
      position.i         
      address.i
      (al-check [access-link.i +>-:c pax])        
      radius.i
      (ma-check [max-accepted.i +>+<:c])       
      (ac-check [accepted-count.i +>+>-:c]) 
      host-status.i      
      title.i
      image.i            
      date.i
      last-updated.i     
      access.i
      mars-link.i        
      earth-link.i
      ~                  
      (ch-check [chat.i +>+>+<:c pax])
      ~                  
      enable-chat.i
  ==
  ++  al-pax-check
    |=  [=access-link pax=?(%rsvp %invite)]
    ^-  (unit @t) 
    ?-    pax
       %invite  ~
       %rsvp    access-link
    ==
  ++  ch-pax-check
    |=  [chat=(unit msgs) pax=?(%rsvp %invite)]
    ^-  (unit msgs)
    ?-   pax
       %invite  ~
       %rsvp    chat
    ==
  ++  rs-pax-check-1
    |=  [receive-ships=(map @p ship-invite) pax=?(%rsvp %invite)]
    ^-  (map @p ship-invite)
    ?-    pax
        %invite  *(map @p ship-invite)
        %rsvp    (drop-pending-ships receive-ships)
    ==
  ++  rs-pax-check-2
    |=  [receive-ships=(map @p ship-invite) pax=?(%rsvp %invite)]
    ^-  (map @p ship-invite)
    ?-    pax
        %rsvp    receive-ships 
        %invite  
      %-  ~(run by receive-ships)
      |=  =ship-invite
      ^-  ~
      ~
    ==
  ++  ma-check
    |=  [max-accepted=(unit @ud) ma=veils]
    ^-  (unit @ud)
    ?-    ma
        %host-only  ~
        %anyone     max-accepted
        %rsvp-only   ~|("invalid veil for rsvp-limit.catalog" !!)   
    ==
  ++  ac-check
    |=  [accepted-count=(unit @ud) ac=veils]
    ^-  (unit @ud)
    ?-    ac 
        %host-only  ~
        %anyone     accepted-count
        %rsvp-only  ~|("invalid veil for rsvp-count.catalog" !!) 
    ==
  ++  al-check
    |=  [=access-link al=veils pax=?(%rsvp %invite)]
    ^-  (unit @t)
    ?-    al  
        %anyone     access-link
        %rsvp-only  (al-pax-check [access-link pax])
        %host-only  ~|("invalid veil for access-link.catalog" !!) 
    ==   
  ++  ch-check
    |=  [chat=(unit msgs) ch=veils pax=?(%rsvp %invite)]
    ^-  (unit msgs)
    ?-    ch                       
        %anyone     chat  
        %rsvp-only  (ch-pax-check [chat pax]) 
        %host-only  ~|("invalid veil for chat.catalog" !!) 
    ==
  ++  rs-check
    |=  $:  receive-ships=(map @p ship-invite) 
            inv=veils 
            rsv=veils
            pax=?(%rsvp %invite)
        ==
    ^-  (map @p ship-invite)
    ?-    inv                                
        %rsvp-only    ~|("invalid veil for invite-list.catalog" !!) 
      ::
        %host-only
      ?-    rsv
          %host-only  *(map @p ship-invite)
          %anyone     (drop-pending-ships receive-ships) 
          %rsvp-only  (rs-pax-check-1 [receive-ships pax])
      ==
      :: 
        %anyone
      ?-    rsv
          %anyone     receive-ships
          %rsvp-only  (rs-pax-check-2 [receive-ships pax])
          %host-only 
        %-  ~(run by receive-ships)
        |=  =ship-invite
        ^-  ~
        ~
      ==
    ==
::
--






















