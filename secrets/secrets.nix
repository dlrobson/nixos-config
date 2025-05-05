let
  laptop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIc+tZ6XSUqF/7g4IPQXWojEYfa2VI92MrZol7UZV4jd";
  server =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7H8YJAK3gp/EcDyZKvYbuvT4xFHt8S0lgucTVWKv4W";
in {
  "restic/env.age".publicKeys = [ laptop server ];
  "restic/bucket.age".publicKeys = [ laptop server ];
  "restic/password.age".publicKeys = [ laptop server ];
}
