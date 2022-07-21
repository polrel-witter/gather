|%
+$  address  @p
+$  id  @
+$  active  ?
+$  radius  @ud  :: should not be @ud...
+$  position  [lon=@ud lat=@ud]
+$  status
  $?  
      %pending              :: waiting for coordinates after confirming we're %in-range
      %denied            :: ship is %out-of-range
      %accepted                :: ship is %in-range
  ==
+$  ship-info
  $:  
    =active
    =position
    =radius
    =status
  ==
+$  wave
  $:
    init-ship=[address ship-info]
    ships=(map address ship-info)
    location=position
    max-people=@ud
    time=@da
    note=tape
    :: votes?
  ==

+$  settings
  $:
    =active
    =position
    =radius
    default-ships=(map address ship-info)
    ghosted-us=(set address)
    ghosted-them=(set address)
  ==
:: 
+$  state
  init=wave
  receive=(list wave)
  =settings
--
