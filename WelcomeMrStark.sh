(
    display_time_in_timezones() {
        # Provide a list of mainstream timezones and corresponding country or region flag Emoji
        declare -A major_timezones
        major_timezones=(
            ["America/New_York"]="🇺🇸" ["Asia/Shanghai"]="🇨🇳" ["Europe/London"]="🇬🇧" ["Australia/Sydney"]="🇦🇺"
            ["America/Los_Angeles"]="🇺🇸" ["Asia/Tokyo"]="🇯🇵" ["Asia/Kolkata"]="🇮🇳" ["America/Sao_Paulo"]="🇧🇷"
            ["Africa/Johannesburg"]="🇿🇦" ["Pacific/Auckland"]="🇳🇿"
            ["Europe/Paris"]="🇫🇷" ["Asia/Dubai"]="🇦🇪" ["Asia/Singapore"]="🇸🇬" ["Europe/Moscow"]="🇷🇺"
            ["America/Toronto"]="🇨🇦" ["Europe/Berlin"]="🇩🇪" ["America/Mexico_City"]="🇲🇽" ["Asia/Jakarta"]="🇮🇩"
            ["Asia/Seoul"]="🇰🇷" ["Europe/Madrid"]="🇪🇸" ["America/Chicago"]="🇺🇸" ["Asia/Manila"]="🇵🇭"
        )

        # Provide a list of timezones to display, which is a subset of the mainstream timezone list
        declare -a display_timezones=("America/New_York" "Asia/Tokyo" "Asia/Shanghai" "Europe/London" "Australia/Sydney")

        local_time=$(date '+%Y-%m-%d %H:%M:%S')
        local_tz=$(date +%Z)

        local_matched=false
        for tz in "${display_timezones[@]}"; do
            tz_time=$(TZ=$tz date '+%Y-%m-%d %H:%M:%S')
            if [[ "$tz_time" == "$local_time" ]]; then
                # Use printf function for aligned output
                printf "%s Time in %-30s: %s\n" "${major_timezones[$tz]}" "$tz(Local)" "$tz_time"
                local_matched=true
                break
            fi
        done

        for tz in "${display_timezones[@]}"; do
            if [[ "$tz" != "$local_tz" ]]; then
                tz_time=$(TZ=$tz date '+%Y-%m-%d %H:%M:%S')
                # Use printf function for aligned output
                printf "%s Time in %-30s: %s\n" "${major_timezones[$tz]}" "$tz" "$tz_time"
            fi
        done

        if [[ "$local_matched" == "false" ]]; then
            # Add a `🌈` symbol before the output text
            echo "🌈Time: $local_time"
        fi
    }

    suggest_figlet_installation() {
        # Detect the operating system and provide the corresponding installation guide
        case "$OSTYPE" in
        "linux-gnu"*)
            if [ -f /etc/lsb-release ]; then
                echo "Your system is Ubuntu or Debian based. For a better experience, you can install figlet with: sudo apt install figlet"
            elif [ -f /etc/redhat-release ]; then
                echo "Your system is Red Hat based. For a better experience, you can install figlet with: sudo yum install figlet"
            elif [ -f /etc/os-release ]; then
                . /etc/os-release
                if [[ "$ID" == "deepin" ]]; then
                    echo "Your system is Deepin. For a better experience, you can install figlet with: sudo apt-get install figlet"
                fi
            else
                echo "Your system type is not recognized. For a better experience, please check how to install figlet on your system."
            fi
            ;;
        "darwin"*)
            echo "Your system is macOS. For a better experience, you can install figlet with: brew install figlet"
            ;;
        *)
            echo "Your system type is not recognized. For a better experience, please check how to install figlet on your system."
            ;;
        esac
    }

    # Determine the greeting based on the hour
    message=$(date +%H | awk '{if ($1 >= 0 && $1 < 5) print "Deep night"; else if ($1 >= 5 && $1 < 7) print "Early morning"; else if ($1 >= 7 && $1 < 10) print "Morning"; else if ($1 >= 10 && $1 < 12) print "Late morning"; else if ($1 >= 12 && $1 < 14) print "Noon"; else if ($1 >= 14 && $1 < 18) print "Afternoon"; else if ($1 >= 18 && $1 < 20) print "Early evening"; else if ($1 >= 20 && $1 < 22) print "Evening"; else print "Late night";}')

    # Use figlet to output the greeting, if figlet is not available, use echo to output
    if command -v figlet >/dev/null 2>&1; then
        figlet "WELCOME"
        figlet "$message, $USER"
    else
        echo "WELCOME, $message, $USER"
        suggest_figlet_installation
    fi

    # Call the function to display timezone times
    display_time_in_timezones
)
