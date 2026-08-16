{ config, pkgs, ... }:

let
  csv = "/Users/tseeley/speedtest.csv";

  speedlog = pkgs.writeShellApplication {
    name = "speedlog";
    runtimeInputs = [
      pkgs.speedtest-cli
      pkgs.gawk
    ];
    text = ''
      if [ ! -f "${csv}" ]; then
        echo "timestamp,ping_ms,download_mbps,upload_mbps" > "${csv}"
      fi
      speedtest-cli --csv --csv-delimiter '|' | awk -F'|' '{
        printf "%s,%.1f,%.2f,%.2f\n", strftime("%Y-%m-%d %H:%M"), $6, $7/1000000, $8/1000000
      }' >> "${csv}"
    '';
  };
in
{
  launchd.user.agents.speedlog = {
    command = "${speedlog}/bin/speedlog";
    serviceConfig = {
      StartCalendarInterval = [
        {
          Hour = 8;
          Minute = 0;
        }
        {
          Hour = 12;
          Minute = 0;
        }
        {
          Hour = 18;
          Minute = 0;
        }
        {
          Hour = 22;
          Minute = 0;
        }
      ];
      StandardErrorPath = "/Users/tseeley/speedlog.err.log";
      StandardOutPath = "/Users/tseeley/speedlog.out.log";
    };
  };
}
