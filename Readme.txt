Aby zbudować obraz Docker:
docker build -t kali-ssh .

Aby uruchomić kontener Docker z uprawnieniami --privileged i przekierowaniem portu 22 na port 2222 hosta:
docker run --privileged -d -p 2222:22 kali-ssh

Po uruchomieniu, możesz połączyć się z kontenerem przez SSH:
ssh ${SSH_USERNAME:-your_ssh_username_from_env}@localhost -p 2222
hasło: ${SSH_PASSWORD:-your_ssh_password_from_env}
