|%
+$  address  @p
+$  status
  $?  
      %pending              :: waiting for coordinates after confirming we're %in-range
      %denied            :: ship is %out-of-range
      %accepted                :: ship is %in-range
  ==
+$  position  [lon=@ud lat=@ud]
+$  radius  @ud
+$  ship-info
  $:  
    address
    position
    radius=@ud
    active=?
    =status
  :: note ?
  ==
+$  wave
  $:
    ships=(list ship-info)
    :: votes?
  ==

+$  init
  $:
    ships=(list ship-info)
    max-people=@ud
    location=position
    time=@da
    :: note
  ==
+$  receive
  $:
    waves=(list wave)
  ==
+$  settings
  $:
  :: init and receive filters
    active=?
    =position
    =radius
    ghosted-them=(list address)
    ghosted-us=(list address)
    :: timer ?
  ==
:: 
--
