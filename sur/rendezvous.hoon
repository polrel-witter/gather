:: 
:: Name TBD: meet up with nearby %pals
|%
::
:: Location status to know when to show tile
+$  status
  $?  %inactive             :: received an %off response to a %wave                            
      %local                :: ship is %in-range
      %not-local            :: ship is %out-of-range
      %pending              :: waiting for coordinates after confirming we're %in-range
  ==
::
:: Ship record types 
+$  ghosted-us      ?       :: 
+$  ghosted-them    ?       :: 
+$  distance        @ud     :: 
+$  note            @t      :: brief sharable note
+$  share-location  ?       :: willing to share location with a specific ship?
+$  lat             @rs     :: latitude
+$  lon             @rs     :: longitude 
+$  pal             ?       :: did they come from %pals?
+$  group           ?       :: did they come from %landscape?
+$  group-name      @t      :: display group name, if they're from %landscape
::
:: Ship statuses for records
+$  gang-info 
  $:  =share-location       :: are we willing to share our location with this ship?
      =status               :: determines whether to show tile on our dashboard or not
      =lat                  :: their latitude
      =lon                  :: their longitude
      =distance             :: their distance from us
      =note                 :: their note
      =ghosted-us           :: they ghosted us; don't send a %wave to these ships; can only be switched to %.n if we receive a new %wave from them
      =ghosted-them         :: we ghosted them
      =pal                  ::
      =group                ::
      =group-name           :: 
  ==
+$  mutual-info
  $:  =ghosted-us           :: 
      =ghosted-them         :: 
      =pal                  ::
      =group                ::
      =group-name           :: 
  ==
::
:: Structure and states
+$  records      
  $%  gang=(map @p gang-info)                       :: selected mutual %pals and/or group members  
      mutual=(map @p mutual-info)                  :: ships not in our gang, pulled in from %pals and Groups
  ==
+$  tile         [who=@p =note =distance =status]   :: tile structure
+$  locals       (set tile)                         :: tile collection to display
::
:: Our ship config settings
+$  config
  $:  on=?                   :: toggle on; send a %wave to gang with share-location=%.y
      =note                  :: our note
      address=@t             :: our address, used to get coordinates
      =lat                   :: our latitude
      =lon                   :: our longitude
      radius=@ud             :: radius we're willing to extend to
      timer=(unit @da)       :: optional; whether we want to auto-switch =on:config to %.n
  ==
:: 
:: Gall actions (++on-poke) e.g. request handler
+$  act
  $%  
    $:  %toggle             :: change local settings
        =on:config
        =note:config
        =address:config
        =radius:config
        =timer:config
    ==
    $:  %proximity-check    :: calculate distance between our ship and theirs
        who=@p
        their=lat
        their=lon
        our=lat
        our=lon
        our=radius:config
    ==
      [%set-share-location who=@p =share-location]   :: change a ship's share-location status; select ships from %pals or group lists
      [%set-status who=@p =status]                   :: change a ship's status; used based on responses
      [%set-note who=@p =note]                       :: initial note received
      [%set-distance who=@p =distance]               :: changed after %proximity-check completes
      [%ghost who=@p]                                :: ghost a ship
      [%wave who=@p =lat =lon]                       :: begins process of determining %local ships; sent to ships in gang when =on:config is %.y
      [%wave-queue who=@p]                           :: unsolicited %waves (i.e. non-gang ships we receive a %wave from) are put into a waving queue, which can then either be ghosted or added to the gang list and sent a %wave with our =lat and =lon
      [%off who=@p]                                  :: if =on:config is %.n, send this in response to a %wave
      [%get-lat-lon =address:config]                 :: external map API call to gather our lat and lon
  ==
:: 
:: Possible updates our agent can send to subscribers (++on-agent) e.g. response handler
+$  upd
  $%  [%in-range who=@p =lat =lon]                   :: sent if after %proximity-check the distance is <= our radius
      [%out-of-range who=@p]                         :: sent if after %proximity-check the distance is > our radius
      [%off who=@p]                                  :: received in response to our initial %wave, indicating they're %inactive
      [%ghost who=@p]                                :: received in response to our %wave, indicating they ghosted-us
      [%new-note who=@p]                             :: an updated note from them has come in
  ==
--

