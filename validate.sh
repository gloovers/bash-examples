#! /bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# set variables
declare -a path_list=("/mr"
                      "/log"
                      "/appdb"
)
declare -a path_mount_list=("/tools/mtt"
                            "/tools/tools"
                            "/home"
                            "/mr"
                            "/log"
                            "/var"
                            "/perf"
                            "/server"
                            "/tmp"
)
declare -a mount_list=("serv.com:/vol/infra_nss_snap/mttlv"
                       "rs:/vol/infra_snap2/cm"
                       "/dev/mapper/rootvg-homelv"
                       "/dev/mapper/datavg-mrlv"
                       "/dev/mapper/datavg-loglv"
                       "/dev/mapper/rootvg-varlv"
                       "/dev/mapper/rootvg-perflv"
                       "/dev/mapper/datavg-appserverlv"
                       "/dev/mapper/rootvg-tmplv"
)

echo -e "\n### Server Validation\Checkout ###"
echo -e "    1. Server's dirs Validation:"
for path_chk in "${path_list[@]}"
do
  if [ -d $path_chk ];then
    if [[ "$(ls -lad $path_chk | awk '{print $1 " " $3 " " $4}')" == "drwxrwsr-x admin asadmin" ]]; then
      echo -e "    ${GREEN}OK${NC} - '$path_chk'"
    else
      echo -e "    ${RED}FAIL${NC} - '$path_chk' doesn't have owner admin or drwxrwsr-x permisions !!!"
      echo -e "         + owner:group => $(ls -lad $path_chk | awk '{print $3 ":" $4}')"
      echo -e "         + permissions => $(ls -lad $path_chk | awk '{print $1}')"
    fi
  else
    echo -e "    ${RED}FAIL${NC} -  '$path_chk' doesn't exist !!!"
  fi
done

echo -e "\n    2. Server's storage mounts Validation:"
for (( i=0; i<${#path_mount_list[@]}; i++ ));
do
  if [ -d ${path_mount_list[$i]} ];then
    if [[ "$(df -h ${path_mount_list[$i]} | awk '{print $1 }' | tail -n 1)" == "${mount_list[$i]}" ]]; then
      echo -e "    ${GREEN}OK${NC} - '${path_mount_list[$i]}' mounted as ${mount_list[$i]}"
    else
      echo -e "    ${RED}FAIL${NC} - '${path_mount_list[$i]}' doesn't have a proper point of mount !!!"
      echo "[ DEBUG ]: ${mount_list[$i]}"
    fi
  else
    echo -e "    ${RED}FAIL${NC} -  '${path_mount_list[$i]}' doesn't exist !!!"
  fi
done

echo -e "\n    3. Server's time zone Validation:"
if [[ "$(date | awk '{print $5 }')" == "CST" ]]; then
  echo -e "    ${GREEN}OK${NC} - Time Zone is CST"
else
  echo -e "    ${RED}FAIL${NC} - Time Zone is not CST !!!"
fi

echo -e "####################################\n"
