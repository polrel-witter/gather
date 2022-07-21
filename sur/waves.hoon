|%
+$  address  @p
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
  ==
--
