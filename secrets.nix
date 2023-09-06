let
  yubikeys = [
    "age1yubikey1qf6s46r8v8v8xhcsyu83484d0z9a02wm5alwg8n2dlwpmqscau6xzvheak2"
    "age1yubikey1qg3dqeu86gjhpmhs6ja2w24xyygcvyxq4pryna0g9dgl4pl5z9uhxgmh3p8"
    "age1yubikey1qg49cw3tx6uugyejvf34z9rydt94we04jmzt47y4fvrnna3z505276l423c"
  ];
  pn50 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICa6q9nC6Xd53qbM5/0ISbvJpFHOplLCIlw3gsj6+GCS";
  tokio = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFWJKjoSCU6G8uJrFUJYyAVKtTPhYr0PnkCOQXryFdyj";
in
{
  "secrets/nix.conf.age".publicKeys = yubikeys ++ [ pn50 tokio ];
}
