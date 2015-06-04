
for p in "${TUENTI_PATHS[@]}"; do
  [[ -d "${p}" ]] && PATH=${PATH}:${p}
done

export PATH
