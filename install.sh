
echo "=== Install TMUX ==="
sudo apt-get install tmux

echo "=== Installing latest java ==="
sh install_java.sh

echo "=== Getting the server jar ==="
sh download_paper.sh
