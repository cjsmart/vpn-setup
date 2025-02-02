# vpn-setup
Ansible playbook for setting up and configuring VPN and related services on a clean virtual machine.

## Usage
1. Ensure that the remote machine has access via a public key. Typically, a clean machine has the `root` user with the necessary key in `/root/.ssh/authorized_keys`.
You can also use another user with sudo privileges, as long as we have access via a public key, which is required to run Ansible playbooks.

2. Perform the initial setup by adding a vpn user, under which we will run the main playbook (in the example, we use the `root` user for connection, but another user can be used, see step 1):
   ```bash
   ansible-playbook --user root -i "<machine-ip-address>," bootstrap.yml
   ```
   The comma here is mandatory so that Ansible takes the address from the command line and not from inventories.

3. Run the main playbook:
   ```bash
   ansible-playbook -i "<machine-ip-address>," playbook.yml
   ```

Both playbooks can be executed together using a single script:
```bash
chmod +x run.sh
./run.sh -u <user> -h <machine-ip-address>
```

## What We Configure
bootstrap.yml:
1. Add a new `vpn` user and grant them sudo privileges.
2. Add local public keys from `~/.ssh/*.pub` to the `authorized_keys` file for the vpn user.

playbook.yml:
1. Install OpenVPN.
2. Install Pi-hole.
3. Configure OpenVPN to use Pi-hole as the DNS server.
4. Restrict access to Pi-hole (both DNS and HTTP) from outside the OpenVPN network.
5. Install and configure fail2ban for SSH.
6. Configure iptables to block all connections except SSH and OpenVPN.
