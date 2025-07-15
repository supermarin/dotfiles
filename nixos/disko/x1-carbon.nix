{
  disko.devices = {
    disk.main = {
      device = "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          swap = {
            # Need 1.5x the RAM for hybernation
            size = "48G";
            content = {
              type = "swap";
              randomEncryption = false;
            };
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted-root";
              settings.allowDiscards = true;
              content = {
                type = "filesystem";
                format = "ext4"; # Or ext4 if preferred
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
