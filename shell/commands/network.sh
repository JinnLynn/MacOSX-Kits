kits_ip() {
    local ip="$1"
    if [[ -z "$ip" ]]; then
        ip=$(curl -s http://ip.3322.net)
        echo "$ip"
    fi
    local res=$(curl -s "http://ip.taobao.com/service/getIpInfo.php?ip=$ip")
    local ret=$?
    [[ "$ret" -ne 0 ]] && echo "fetch ip info fail. curl retcode: $ret" && return 1
    # echo $res
    local code=$(jsoner -k code -s "$res")
    local data=$(jsoner -k data -s "$res")
    [[ "$code" -ne 0 ]] && echo "error: $data" && return 1
    jsoner -k data.country -s "$res"
    jsoner -k data.region -s "$res"
    jsoner -k data.city -s "$res"
    jsoner -k data.isp -s "$res"
    # echo $(jsoner -k data.country -s "$res")
    # local country=$(jsoner -k data.country -s "$res")
    # local area=$(jsoner -k data.area -s "$res")
    # local region=$(jsoner -k data.region -s "$res")
    # local city=$(jsoner -k data.city -s "$res")
    # local isp=$(jsoner -k data.isp -s "$res")
    # echo "$country $region $city"
}