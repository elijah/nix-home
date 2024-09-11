{ ... }:
{

#alfred.includeOverlay
  
#  nixpkgs.overlays = [ alfred.overlays.default ];
#  environment.systemPackages = with pkgs; [
#    alfredGallery.spotify-mini-player
#   alfredGallery.emoji-search
#    unzip
#  ];

#alfred.darwinModules.activateWorkflows

}
