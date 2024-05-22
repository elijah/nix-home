{ ... }:

let
  elijah = {
    name = "Elijah Wright";
    email = "elw@stderr.org";
    signingKey = "DDA464DF734AD996C0C9C371A30CF61339FA6421";
  };
in
{
  programs = {
    git = {
      enable = true;
      userName = elijah.name;
      userEmail = elijah.email;

      signing = {
        key = elijah.signingKey;
        signByDefault = true;
        gpgPath = "gpg";
      };

      ignores = [
        "*~"
        ".DS_Store"
        "*.swp"
      ];

      aliases = {
        st = "status";
        co = "checkout";
        cb = "checkout -b";
        rb = "rebase";
        rba = "rebase --abort";
        rbc = "rebase --continue";
        rbi = "rebase -i";
        pf = "push --force-with-lease";
      };

      diff-so-fancy.enable = true;
    };
  };
}
