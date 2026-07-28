{ config, lib, ... }:
{
  # Keep ~/.aws/credentials writable for SSO-enabled AWS CLI tooling. Some
  # tools (e.g. `aws sso login`, aws-vault) refresh credentials in-place and
  # fail if the file is immutable or a symlink (as it would be if it were
  # accidentally managed via home.file/xdg.configFile).
  #
  # This runs as a home-manager activation script rather than a nix-darwin
  # `system.activationScripts` entry so it works identically on both the
  # macOS (nix-darwin) and Linux (standalone home-manager) personalities -
  # home-manager activation always runs as the target user, so (unlike the
  # old nix-darwin version) no chown is needed: files created here are
  # already owned by the user.
  home.activation.awsCredentialsWritable = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.home.homeDirectory}/.aws"

    credentialsFile="${config.home.homeDirectory}/.aws/credentials"
    if [ -L "$credentialsFile" ]; then
      verboseEcho "Replacing symlinked ~/.aws/credentials with a regular file"
      run rm -f "$credentialsFile"
      run touch "$credentialsFile"
    elif [ ! -e "$credentialsFile" ]; then
      run touch "$credentialsFile"
    fi

    run chmod 600 "$credentialsFile"
  '';
}
