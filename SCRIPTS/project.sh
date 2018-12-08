echo "cleaning up files in HDL/RTL"
rm /home/johny/Desktop/vlsi_project/HDL/RTL/*.v
rm /home/johny/Desktop/vlsi_project/HDL/RTL/*.sv
rm /home/johny/Desktop/vlsi_project/HDL/RTL/*.bak
echo "moving verilog files"
cp -r /home/johny/Documents/ece5710/VLSI/*.v /home/johny/Desktop/vlsi_project/HDL/RTL
echo "deleting tb files"
rm /home/johny/Desktop/vlsi_project/HDL/RTL/*_tb.v
rm /home/johny/Desktop/vlsi_project/HDL/RTL/main_mapped_pads.v
