{
  # `gpg --card-edit` then make sure key shows up with `list`
  # May need to run `fetch`.
  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        # yubikey usbc
        source = ../keys/51330F9D3F9D368E.pub;
        trust = "ultimate";
      }
    ];
  };
}
