{ homeDirectory }:

{
  megaman = {
    passphraseSecret = ../secrets/borg-passphrase.age;
    path = "ssh://k054fh3a@k054fh3a.repo.borgbase.com/./repo";
    sshKey = "${homeDirectory}/.ssh/id_ed25519";
  };

  pop-robot = {
    passphraseSecret = ../secrets/borg-passphrase_pop-robot.age;
    path = "ssh://s680zldc@s680zldc.repo.borgbase.com/./repo";
    sshKey = "${homeDirectory}/.ssh/id_ed25519";
  };
}
