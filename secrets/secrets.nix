let
  laptop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIc+tZ6XSUqF/7g4IPQXWojEYfa2VI92MrZol7UZV4jd";
in {
  "restic/env.age".publicKeys = [ laptop ];
  "restic/bucket.age".publicKeys = [ laptop ];
  "restic/password.age".publicKeys = [ laptop ];
}
