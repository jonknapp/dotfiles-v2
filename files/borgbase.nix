{ homeDirectory }:

{
  megaman = {
    passphraseSecret = ../secrets/borg-passphrase.age;
    path = "ssh://k054fh3a@k054fh3a.repo.borgbase.com/./repo";
    sshKey = "${homeDirectory}/.ssh/id_ed25519";
  };
}
