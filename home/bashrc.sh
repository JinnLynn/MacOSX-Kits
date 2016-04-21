# Kits
KITS_PATH=~/.kits_path
[[ -f $KITS_PATH ]] && . $KITS_PATH && . $KITS/home/profile.sh
[[ ! -f $KITS_PATH ]] && echo "kits error: $KITS_CONFIG not found, please run 'setup' first."