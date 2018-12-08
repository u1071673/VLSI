echo "cleaning up files in HDL/RTL"
rm /home/jasonj/vlsi_project/HDL/RTL/*.v
rm /home/jasonj/vlsi_project/HDL/RTL/*.sv
rm /home/jasonj/vlsi_project/HDL/RTL/*.bak
echo "moving verilog files"
cp -r /home/jasonj/Documents/ece6710/VLSI/*.v /home/jasonj/vlsi_project/HDL/RTL
echo "deleting tb files"
rm /home/jasonj/vlsi_project/HDL/RTL/*_tb.v
rm /home/jasonj/vlsi_project/HDL/RTL/main_mapped_pads.v
