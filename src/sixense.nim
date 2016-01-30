## *sixense* - Nim bindings for the Sixense Core API.
##
## This file is part of the `Nim I/O <http://nimio.us>`_ package collection.
## See the file LICENSE included in this distribution for licensing details.
## GitHub pull requests are encouraged. (c) 2015 Headcrash Industries LLC.

{.deadCodeElim: on.}


when defined(linux):
  when defined(debug):
    const dllname = "libsixensed_x64.so"
  else:
    const dllname = "libsixense_x64.so"
elif defined(mac):
  when defined(debug):
    const dllname = "libsixensed_x64.dylib"
  else:
    const dllname = "libsixense_x64.dylib"
elif defined(windows):
  when defined(win64):
    when defined(debug):
      const dllname = "sixensed_x64.dll"
    else:
      const dllname = "sixense_x64.dll"
  else:
    when defined(debug):
      const dllname = "sixensed.dll"
    else:
      const dllname = "sixense.dll"
else:
  {.error: "Platform does not support sixense".}


const
  SIXENSE_BUTTON_BUMPER* = (0x00000001 shl 7)
    ## Bit mask for the bumper button.
  SIXENSE_BUTTON_JOYSTICK* = (0x00000001 shl 8)
    ## Bit mask for the joystick.
  SIXENSE_BUTTON_1* = (0x00000001 shl 5)
    ## Bit mask for button 1.
  SIXENSE_BUTTON_2* = (0x00000001 shl 6)
    ## Bit mask for button 3.
  SIXENSE_BUTTON_3* = (0x00000001 shl 3)
    ## Bit mask for button 3.
  SIXENSE_BUTTON_4* = (0x00000001 shl 4)
    ## Bit mask for button 4.
  SIXENSE_BUTTON_START* = (0x00000001 shl 0)
    ## Bit mask for the Start button.
  SIXENSE_SUCCESS* = 0
    ## Function call completed successfully.
  SIXENSE_FAILURE* = - 1
    ## An Error occurred during function call.
  SIXENSE_MAX_CONTROLLERS* = 4
    ## Maximum number of controllers that can be connected.


type
  SixenseControllerData* = object
    ## Controller data retrieval structure.
    ##
    ## See also:
    ## - `sixenseGetAllData <#sixenseGetAllData>`_
    ## - `sixenseGetAllNewestData <#sixenseGetAllNewestData>`_
    ## - `sixenseGetData <#sixenseGetData>`_
    ## - `sixenseGetNewestData <#sixenseGetNewestData>`_
    pos*: array[3, cfloat]
    rotMat*: array[3, array[3, cfloat]]
    joystickX*: cfloat
    joystickY*: cfloat
    trigger*: cfloat
    buttons*: cuint
    sequenceNumber*: cuchar
    rotQuat*: array[4, cfloat]
    firmwareRevision*: cushort
    hardwareRevision*: cushort
    packetType*: cushort
    magneticFrequency*: cushort
    enabled*: cint
    controllerIndex*: cint
    isDocked*: cuchar
    whichHand*: cuchar
    hemiTrackingEnabled*: cuchar


  SixenseAllControllerData* = object
    ## A convenience structure for querying all controllers at once.
    ##
    ## See also:
    ## - `sixenseGetAllData <#sixenseGetAllData>`_
    ## - `sixenseGetAllNewestData <#sixenseGetAllNewestData>`_
    controllers*: array[4, SixenseControllerData]


proc sixenseInit*(): cint {.cdecl, dynlib: dllname, importc.}
  ## Initialize the Sixense library.
  ##
  ## result
  ##   - `SIXENSE_SUCCESS` if the library is successfully initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## See also:
  ## - `sixenseExit <#sixenseExit>`_


proc sixenseExit*(): cint {.cdecl, dynlib: dllname, importc.}
  ## Shut down the Sixense library.
  ##
  ## result
  ##   - `SIXENSE_SUCCESS` if the library was successfully shut down,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## See also:
  ## - `sixenseInit <#sixenseInit >`_


proc sixenseGetMaxBases*(): cint {.cdecl, dynlib: dllname, importc.}
  ## Return the maximum number of base units that can be connected to the
  ## computer at once.
  ##
  ## result
  ##   The maximum number of base units supported by the Sixense control system.
  ##   Currently, this number is `4` for all platforms.


proc sixenseSetActiveBase*(baseNum: cint): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Designate which base subsequent API calls are to be directed to.
  ##
  ## baseNum
  ##   An integer from `0` to `sixenseGetMaxBases() <#sixenseGetMaxBases>`_ - 1`.
  ## result
  ##   - `SIXENSE_SUCCESS` if the the designated base is active and valid,
  ##   - `SIXENSE_FAILURE` otherwise.


proc sixenseIsBaseConnected*(baseNum: cint): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Determine if a base is currently connected to the system.
  ##
  ## baseNum
  ##   An integer from `0` to `sixenseGetMaxBases() <#sixenseGetMaxBases>`_ - 1`.
  ## result
  ##   `1` if the base is currently plugged in, and `0` otherwise


proc sixenseGetMaxControllers*(): cint {.cdecl, dynlib: dllname, importc.}
  ## Return the maximum number of controllers supported by the Sixense control
  ## system.
  ##
  ## result
  ##   The maximum number of controllers supported by the Sixense control
  ##   system. Currently, this number is `4` for all platforms.


proc sixenseIsControllerEnabled*(which: cint): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Check if a referenced controller is currently connected to the Base Unit.
  ##
  ## which
  ##   The ID of the controller to check.
  ## result
  ##   `1` if the controller is enabled, `0` if it is disabled.
  ##
  ## See also:
  ## - `sixenseGetMaxControllers <#sixenseGetMaxControllers>`_


proc sixenseGetNumActiveControllers*(): cint {.cdecl, dynlib: dllname, importc.}
  ## Report the number of active controllers.
  ##
  ## result
  ##   The number of controllers currently linked to the base station.
  ##
  ## See also:
  ## - `sixenseGetMaxControllers <#sixenseGetMaxControllers>`_
  ## - `sixenseIsControllerEnabled <#sixenseIsControllerEnabled>`_


proc sixenseGetHistorySize*(): cint {.cdecl, dynlib: dllname, importc.}
  ## Get the size of the history buffer.
  ##
  ## result
  ##   The size of the history buffer is returned. For 3.2 hardware this value
  ##   is always `10`.
  ##
  ## See also:
  ## - `sixenseGetData <#sixenseGetData>`_
  ## - `sixenseGetAllData <#sixenseGetAllData>`_
  ## - `SixenseControllerData <#SixenseControllerData>`_


proc sixenseGetData*(which: cint; indexBack: cint;
  a4: ptr SixenseControllerData): cint {.cdecl, dynlib: dllname, importc.}
  ## Get state of one of the controllers, selecting how far back into a history
  ## of the last 10 updates.
  ##
  ## which
  ##   The ID of the desired controller. Valid values are from `0` to `3`. If
  ##   the desired controller is not connected, an empty data packet is
  ##   returned. Empty data packets are initialized to a zero position and the
  ##   identity rotation matrix.
  ## indexBack
  ##   How far back in the history buffer to retrieve data. `0` returns the most
  ##   recent data, `9` returns the oldest data. Any of the last 10 positions
  ##   may be queried.
  ## data
  ##   Pointer to user-allocated memory for returning the desired controller
  ##   information.
  ## result
  ##   - `SIXENSE_SUCCESS` if the data was successfully retrieved
  ##   - `SIXENSE_FAILURE` on failure, or if the desired controller is not
  ##   currently connected.


proc sixenseGetAllData*(indexBack: cint; allData: ptr SixenseAllControllerData):
  cint {.cdecl, dynlib: dllname, importc.}
  ## Get state of all of the controllers, selecting how far back into a history
  ## of the last 10 updates.
  ##
  ## indexBack
  ##   How far back in the history buffer to retrieve data. `0` returns the most
  ##   recent data, `9` returns the oldest data. Any of the last 10 positions
  ##   may be queried.
  ## allData
  ##   Pointer to user-allocated memory for returning the desired controller
  ##   information.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.


proc sixenseGetNewestData*(which: cint; data: ptr SixenseControllerData): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Get the most recent state of one of the controllers.
  ##
  ## which
  ##   The ID of the desired controller. Valid values are from `0` to `3`. If
  ##   the desired controller is not connected, an empty data packet is
  ##   returned. Empty data packets are initialized to a zero position and the
  ##   identity rotation matrix.
  ## data
  ##   Pointer to user-allocated memory for returning the desired controller
  ##   information.
  ## result
  ##   - `SIXENSE_SUCCESS` if the data was successfully retrieved
  ##   - `SIXENSE_FAILURE` on failure, or if the desired controller is not
  ##   currently connected.


proc sixenseGetAllNewestData*(allData: ptr SixenseAllControllerData): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Get the most recent state of all of the controllers.
  ##
  ## allData
  ##   Pointer to user-allocated memory for returning the controller information.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.


proc sixenseSetHemisphereTrackingMode*(whichController: cint; state: cint):
  cint {.cdecl, dynlib: dllname, importc.}


proc sixenseGetHemisphereTrackingMode*(whichController: cint; state: ptr cint):
  cint {.cdecl, dynlib: dllname, importc.}


proc sixenseAutoEnableHemisphereTracking*(whichController: cint): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Enable Hemisphere Tracking when the controller is aiming at the base.
  ##
  ## whichController
  ##   The `0` based index of the desired controller.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## This call is deprecated, as hemisphere tracking is automatically enabled
  ## when the controllers are in the dock, or by the controller manager. See the
  ## Sixense API Overivew for more information.


proc sixenseSetHighPriorityBindingEnabled*(onOrOff: cint): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Enable and disable High Priority RF binding mode.
  ##
  ## onOrOff
  ##   `1` enables High Priority binding, `0` disables it.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## This call is only used with the wireless Sixense devkits.


proc sixenseGetHighPriorityBindingEnabled*(onOrOff: ptr cint): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Return the current state of High Priority RF binding mode.
  ##
  ## onOrOff
  ##   Pointer to variable to store the current state of the High Priority
  ##   binding mode in. `1` means it is enabled, `0` is disabled.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## This call is only used with the wireless Sixense devkits.


proc sixenseTriggerVibration*(controllerId: cint; duration100ms: cint;
  patternId: cint): cint {.cdecl, dynlib: dllname, importc.}
  ## Enable a period of tactile feedback using the vibration motor.
  ##
  ## controllerId
  ##   The ID of the controller to vibrate. Valid values are `0` through
  ##   `sixenseGetMaxControllers <#sixenseGetMaxControllers>`_.
  ## duration100ms
  ##   The duration of the vibration, in 100 millisecond units. For example, a
  ##   value of `5` will vibrate for half a second.
  ## patternId
  ##   Future SDK’s will support different pulsing patterns for the vibration.
  ##   Currently, this argument is ignored and the vibration motor is engaged
  ##   for the full duration.
  ##
  ## Note the Razer Hydra does not support vibration.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.


proc sixenseSetFilterEnabled*(onOrOff: cint): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Turn the internal position and orientation filtering on or off.
  ##
  ## onOrOff
  ##   The desired state of the filtering. `0` is off, `1` is on.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## See also:
  ## - `sixenseGetFilterEnabled <#sixenseGetFilterEnabled>`_


proc sixenseGetFilterEnabled*(onOrOff: ptr cint): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Return the enable status of the internal position and orientation filtering.
  ##
  ## onOrOff
  ##   Pointer to variable in which to store the result.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## See also:
  ## - `sixenseSetFilterEnabled <#sixenseSetFilterEnabled>`_


proc sixenseSetFilterParams*(nearRange: cfloat; nearVal: cfloat;
  farRange: cfloat; farVal: cfloat): cint {.cdecl, dynlib: dllname, importc.}
  ## Set the parameters that control the position and orientation filtering
  ## level.
  ##
  ## nearRange
  ##   The range from the Sixense Base Unit at which to start increasing the
  ##   filtering level from the `nearVal` to `farVal`. Between `nearRange` and
  ##   `farRange`, the `nearVal` and `farVal` are linearly interpolated.
  ## nearVal
  ##   The minimum filtering value. This value is used for when the controller
  ##   is between `0` and `nearVal` millimeters from the Sixense Base Unit.
  ##   Valid values are between `0` and `1`.
  ## farRange
  ##   The range from the Sixense Base Unit after which to stop interpolating
  ##   the filter value from the `nearVal`, and after which to simply use
  ##   `farVal`.
  ## farVal
  ##   The maximum filtering value. This value is used for when the controller
  ##   is between `farVal` and infinity. Valid values are between `0` and `1`.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## See also:
  ## - `sixenseGetFilterParams <#sixenseGetFilterParams>`_


proc sixenseGetFilterParams*(nearRange: ptr cfloat; nearVal: ptr cfloat;
  farRange: ptr cfloat; farVal: ptr cfloat): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Return the current filtering parameter values.
  ##
  ## nearRange
  ##   Pointer to variable in which to store the result.
  ## nearVal
  ##   Pointer to variable in which to store the result.
  ## farRange
  ##   Pointer to variable in which to store the result.
  ## farVal
  ##   Pointer to variable in which to store the result.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## See also:
  ## - `sixenseSetFilterParams <#sixenseSetFilterParams>`_


proc sixenseSetBaseColor*(red: cuchar; green: cuchar; blue: cuchar): cint
  {.cdecl, dynlib: dllname, importc.}
  ## Sets the color of the LED on the Sixense wireless devkits.
  ##
  ## red
  ##   Red component of the led color. `0` is off and `255` is fully red.
  ## green
  ##   Green component of the led color.
  ## blue
  ##   Blue component of the led color.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## The Razer Hydra colors cannot be changed.


proc sixenseGetBaseColor*(red: ptr cuchar; green: ptr cuchar; blue: ptr cuchar):
  cint {.cdecl, dynlib: dllname, importc.}
  ## Get the color of the LED on the Sixense wireless devkits.
  ##
  ## red
  ##   Red component of the led color. `0` is off and `255` is fully red.
  ## green
  ##   Green component of the led color.
  ## blue
  ##   Blue component of the led color.
  ## result
  ##   - `SIXENSE_SUCCESS` as long as the Sixense system has been initialized,
  ##   - `SIXENSE_FAILURE` otherwise.
  ##
  ## The Razer Hydra colors cannot be changed.
