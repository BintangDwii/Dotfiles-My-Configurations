# Polybar

This configuration provides a two-monitor i3 status bar with live system telemetry. The launcher starts one bar on each connected display and assigns the system tray to the primary display only, because an X11 tray can have one owner.

## Layout

- Left: i3 workspaces.
- Center: date and time.
- Right: Wi-Fi, running Docker container count, NVIDIA GPU status, CPU temperature, root filesystem usage, audio, RAM, CPU usage, pending Arch updates, battery, and the system tray.

## Click Actions

| Module | Left click |
| --- | --- |
| Wi-Fi | Opens NetworkManager connection settings. |
| Docker | Opens a terminal showing running containers. |
| GPU | Switches to the battery display profile. |
| CPU temperature | Switches to the battery display profile. |
| Root filesystem | Opens a terminal storage summary. |
| Audio | Opens `pavucontrol`. |
| Updates | Opens a terminal listing pending Arch packages. |

## Display Profiles

The GPU and CPU-temperature actions call `~/.config/i3/scripts/display-profile.sh`.

- Performance: `Alt+Shift+F1` sets the laptop display to 240 Hz and the external 4K display to 144 Hz.
- Battery: `Alt+Shift+F2` sets the laptop display to 60 Hz and the external 4K display to 119.88 Hz.

Use the battery profile when heat or battery life matters. The external HDMI display keeps the NVIDIA GPU active while connected.

## Telemetry Scripts

| Script | Data | Refresh |
| --- | --- | --- |
| `gpu-status.sh` | NVIDIA temperature, power, and utilization | 5 seconds |
| `cpu-temperature.sh` | AMD CPU control temperature | 5 seconds |
| `docker-status.sh` | Running container count | 30 seconds |
| `updates-status.sh` | Pending official Arch updates | 60 minutes |

GPU temperature is cyan below 80 C, amber from 80 C, and red from 90 C. CPU temperature is green below 80 C, amber from 80 C, and red from 90 C.

## Dependencies

Install the required packages:

```bash
sudo pacman -S polybar i3-wm networkmanager network-manager-applet pavucontrol docker lm_sensors jq nvidia-utils
```

The update module reads the local pacman database. It does not install updates or refresh package databases.

## Restart And Validate

Reload all bars after editing:

```bash
i3-msg 'exec --no-startup-id ~/.config/polybar/launch.sh'
```

Verify the configuration and both bars:

```bash
polybar --dump=modules-right -c ~/.config/polybar/config.ini main
pgrep -af 'polybar main'
```

## Tracking

This directory is tracked in `~/Dotfiles/.config/polybar`. After editing the live configuration, synchronize the matching files into the Dotfiles repository before committing. Do not run `stow .` over an existing live configuration without first resolving file conflicts or backing it up.
