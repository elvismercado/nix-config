# Trackpad — macOS trackpad clicking, scrolling, and gesture settings
#
# Configures system.defaults.trackpad with tap-to-click, three-finger drag,
# four-finger gestures, and scrolling behavior.
#
# Usage:
#   imports = [ ../../../modules/systems/darwin/trackpad.nix ];
#   custom.sysDarTrackpad.enable = true;

{
  config,
  lib,
  ...
}:

{
  options = {
    custom.sysDarTrackpad.enable = lib.mkEnableOption "macOS trackpad clicking, scrolling, and gesture behaviour";
  };

  config = lib.mkIf config.custom.sysDarTrackpad.enable {
    system.defaults.trackpad = {
      # Clicking
      Clicking = true; # Tap to click
      FirstClickThreshold = 1; # Medium click pressure
      ForceSuppressed = true; # Disable force click
      SecondClickThreshold = 1; # Medium force-click pressure (if re-enabled)
      ActuationStrength = 1; # Normal click sound
      ActuateDetents = true; # Haptic feedback on

      # Right-click
      TrackpadRightClick = true; # Two-finger right click
      TrackpadCornerSecondaryClick = 0; # No corner click

      # Dragging — three-finger drag (mutually exclusive options)
      TrackpadThreeFingerDrag = true;
      Dragging = false;
      DragLock = false;

      # Scrolling
      TrackpadMomentumScroll = true; # Inertia scrolling

      # Two-finger gestures
      TrackpadPinch = true; # Pinch to zoom
      TrackpadTwoFingerDoubleTapGesture = true; # Smart zoom
      TrackpadRotate = true; # Rotation
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3; # Notification Center

      # Three-finger gestures — disabled (conflicts with three-finger drag)
      TrackpadThreeFingerTapGesture = 0;
      TrackpadThreeFingerHorizSwipeGesture = 0;
      TrackpadThreeFingerVertSwipeGesture = 0;

      # Four-finger gestures
      TrackpadFourFingerHorizSwipeGesture = 2; # Switch desktops / full-screen apps
      TrackpadFourFingerVertSwipeGesture = 2; # Mission Control / App Exposé
      TrackpadFourFingerPinchGesture = 2; # Launchpad (pinch) / Desktop (spread)
    };

    # Natural scrolling (content follows finger direction)
    system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = true;

    # Trackpad-specific NSGlobalDomain options
    system.defaults.NSGlobalDomain."com.apple.trackpad.forceClick" = false;
    system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 2.0;
    system.defaults.NSGlobalDomain."com.apple.trackpad.enableSecondaryClick" = true;
  };
}
