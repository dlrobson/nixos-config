let
  laptop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIc+tZ6XSUqF/7g4IPQXWojEYfa2VI92MrZol7UZV4jd";
  server =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBE5GEja6S97XJr9QGOZkXlq5SJXB2Rx8r//hc1zcWnI";
in {
  "restic/env.age".publicKeys = [ laptop server ];
  "restic/bucket.age".publicKeys = [ laptop server ];
  "restic/password.age".publicKeys = [ laptop server ];
}
