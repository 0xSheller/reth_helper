#!/bin/bash

current_directory="$(dirname "$(readlink -f "$0")")"
IFS="/" read -ra dir_array <<< "${current_directory#/}"  # Remove leading slash
if [ ${#dir_array[@]} -eq 3 ] && [ "${dir_array[2]}" != "scripts" ]; then
    parsed_dir="/${dir_array[0]}/${dir_array[1]}/${dir_array[2]}"
else
    parsed_dir="/${dir_array[0]}/${dir_array[1]}"
fi
source "${parsed_dir}/scripts/load_variables.sh"
source "${parsed_dir}/scripts/get_os_arch.sh"

# We need to get the current server's IPv4 address
public_ip=$(curl -s https://ipinfo.io/ip)

# Run some commands here to wrap up the setup
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server
sudo /bin/systemctl start grafana-server

output_file="${parsed_dir}/setup_summary.txt"

# Start capturing the output in the file
exec > >(tee -i "$output_file")

# Format the messages
header="Thanks for using 0xSheller setup script https://github.com/0xSheller/reth_helper! If you would like to support the public repos, please consider donating to 0x4286a468f267343f611Ee5057059522Dc922eAAD (you don't need to all, this is just if you would like to help pay for the wasabi server bill), otherwise enjoy your new node!"
echo "$header"

echo -e "\nMonitoring URLs:"
echo "------------------"
echo "Grafana is accessible at http://$public_ip:6008 (admin:admin)"
echo "Prometheus is accessible at http://$public_ip:6006"
echo "reth metrics accessible at http://$public_ip:6007"
echo "Siren is accessible at http://$public_ip:6009"
echo "rETH HTTP is accessible at http://$public_ip:69"
echo "rETH WS is accessible at http://$public_ip:96"
echo "Siren is accessible at http://$public_ip:6009"

echo -e "\n"
echo -e "\n"
echo -e "Services:"
echo "------------------"
echo "Run the following commands to monitor reth & lighthouse:"
echo "sudo systemctl status lighthouse.service"
echo "sudo systemctl status reth.service"

echo "and to get logs..."

echo "sudo journalctl -u lighthouse -f"
echo "sudo journalctl -u reth -f"

echo -e "\n"
echo -e "\n"
echo -e "Notes:"
echo "------------------"

echo "It is recommended to visit the grafana endpoint ASAP, as it will prompt you to change the default password."
echo -e "\n"
echo "Remember, all endpoints except for Grafana are protected by basic auth ($NGINX_USER:$NGINX_PASS)"

echo -e "\n$header"

# Echo the location of the output file
echo "Setup summary has been saved to: $output_file"
