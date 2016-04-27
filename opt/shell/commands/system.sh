
__kits_disk_status() {
    local dev=$1
    local tmp="$KITS_TMP/smartctl-$(md5 -q -s $dev).txt"
    # 不保存到文件会失去分行
    smartctl -s on -a $dev >$tmp
    [[ "$?" -ne 0 ]] && {
        cat <<EOF
$dev
    $(_kits_red_text $(cat $tmp | grep failed))

EOF
        return 1
    }
    local model=$(cat $tmp | grep "Device Model" | awk -F ":" '{print $2}' | sed 's/^[ ]*//g')
    local capacity=$(cat $tmp | grep "User Capacity" | awk -F "[" '{print $2}' | awk -F "]" '{print $1}')
    local sar=$(cat $tmp | grep "self-assessment test result" | awk -F ":" '{print $2}' | sed 's/^[ ]*//g')
    local sar_output=$([[ "$sar" == "PASSED" ]] && _kits_green_text "$sar" || _kits_red_text "$sar")
    local power_on=$(cat $tmp | grep "Power_On_Hours" | awk '{print $10}')
    if [[ "$(cat $tmp | grep "Rotation Rate" | grep -c "Solid State Device")" -gt 0 ]]; then
        # 固态硬盘
        # 开始使用年份 预估可使用寿命
        local start_year="2011"
        local model=$(cat $tmp | grep "Device Model" | awk -F ":" '{print $2}' | sed 's/^[ ]*//g')
        local reads=$(cat $tmp | grep Host_Reads_32MiB | awk '{print $10}')
        local writes=$(cat $tmp | grep -m 1 Host_Writes_32MiB | awk '{print $10}')
        local wearout=$(cat $tmp | grep -m 1 Media_Wearout_Indicator | awk '{print $4}' | sed 's/^[0]*//g')
        local reservd_space=$(cat $tmp | grep -m 1 Available_Reservd_Space | awk '{print $4}')
        writes=$(echo "$writes * 65536 * 512" | bc)
        reads=$(echo "$reads * 65536 * 512" | bc)
        local can_write=$(echo "$writes / (100 - $wearout) * 100 - $writes" | bc)
        cat <<EOF
$dev
　　　　型号: $model [$capacity]
   SMART自检: $sar_output
累计工作时间: $power_on Hours
　　健康指示: $wearout%
　　累计写入: $(_kits_hr_size $writes)
　　累计读取: $(_kits_hr_size $reads)
有效保留空间: $reservd_space%
理论可写数据: $(_kits_hr_size $can_write)

EOF
    else

        cat <<EOF
$dev
　　　　型号: $model [$capacity]
   SMART自检: $sar_output
累计工作时间: $power_on Hours
　重定位计数: $(cat $tmp | grep "Reallocated_Event_Count" | awk '{print $10}')
等候重定扇区: $(cat $tmp | grep "Current_Pending_Sector" | awk '{print $10}')
无法校正扇区: $(cat $tmp | grep "Offline_Uncorrectable" | awk '{print $10}')

EOF
    fi
}

kits_disk_status() {
    local device="/dev/disk0"
    _kits_cmd_exists smartctl || {
        _kits_red_text 'smartctl missing. INSTALL: brew install smartmontools'
        return 1
    }
    local devs=$(diskutil list | grep ^/dev | awk '{print $1}')
    for d in $devs; do
        __kits_disk_status $d
    done
}