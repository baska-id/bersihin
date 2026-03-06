#!/data/data/com.termux/files/usr/bin/bash

echo "Installing bersihin..."

INSTALL_DIR="$HOME/.bersihin"

mkdir -p $INSTALL_DIR

cp bersihin.sh $INSTALL_DIR/

chmod +x $INSTALL_DIR/bersihin.sh

ln -sf $INSTALL_DIR/bersihin.sh $PREFIX/bin/bersihin

echo ""
echo "Install selesai ✅"
echo "Gunakan command:"
echo "bersihin"
