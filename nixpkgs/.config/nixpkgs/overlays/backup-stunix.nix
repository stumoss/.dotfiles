self: super: {
  userPackages = super.userPackages or { } // {
    backup-stunix = super.writeScriptBin "backup-stunix" ''
      #!${super.bash}/bin/bash

      REPOSITORY=/var/run/media/stu/backup/backup

      read -rsp "Password for backup: " BORG_PASSPHRASE

      export BORG_PASSPHRASE

      printf "\\nCreating backup %s\\n" "$REPOSITORY::$(hostname)-$(date '+%F-%H:%M')"

      ${super.borgbackup}/bin/borg create                       \
          --stats                                               \
          --show-rc                                             \
          --exclude '*/RECYCLE.BIN'                             \
          --exclude '*/System Volume Information'               \
          --exclude '*/.sync'                                   \
          --exclude '*/.localized'                              \
          --exclude '*/.DS_Store'                               \
          --exclude '*/secrets.nix'                             \
          --compression lzma                                    \
          $REPOSITORY::'{hostname}-{now:%Y-%m-%d %H:%M}'        \
          /home/stu/AudioBooks                                  \
          /home/stu/Code                                        \
          /home/stu/Documents                                   \
          /home/stu/eBooks                                      \
          /home/stu/Movies                                      \
          /home/stu/Music                                       \
          /home/stu/Pictures                                    \
          /home/stu/TV\ Shows                                   \
          /etc/nixos

      # Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
      # archives of THIS machine. The '{hostname}-' prefix is very important to
      # limit prune's operation to this machine's archives and not apply to
      # other machine's archives also.
      ${super.borgbackup}/bin/borg prune  \
          --stats                         \
          --show-rc                       \
          --keep-within=2d                \
          --keep-daily=7                  \
          --keep-weekly=4                 \
          --keep-monthly=6                \
          --prefix '{hostname}-'          \
          $REPOSITORY

      unset BORG_PASSPHRASE
    '';
  };
}
