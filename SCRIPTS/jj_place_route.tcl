# place_route.tcl

set design		main_mapped_pads
set rpt_dir		./RPT
set max_route_layer		5
set pwr_net 		VDD
set gnd_net 		VSS
#To enable multi threading. Not sure if the CADE machines can allow more cores than this.
set cpu_number 		4
#Uniquify the design, otherwise, might get error during CTS
set init_design_uniquify      1


proc put_header hdr {

   puts "\n---#-----------------------------------------------------"
   puts "---# $hdr"
   puts "---#-----------------------------------------------------\n"
}

#=========================================================================================
# set_design
#
proc set_design name {
   set lname $name
   set lrpt_dir "RPT/${lname}"

   puts "Design name set to: $lname"
   uplevel #0 set design $lname

   set root [split $lname "_"]
   set root [lindex $root 0]
   puts "Design root set to: $root"
   uplevel #0 set root $root

   uplevel #0 set rpt_dir $lrpt_dir
   puts "Report directory set to: $lrpt_dir"
   # create report directory if not yet existing
   file mkdir $lrpt_dir
}

proc opt_design_prects {} {
timeDesign -preCTS
optDesign -preCTS
}

proc opt_design_postcts {} {
timeDesign -postCTS
optDesign -postCTS
optDesign -postCTS -drv
optDesign -postCTS -hold
}

proc opt_design_postroute {} {
setAnalysisMode -analysisType onChipVariation -cppr both
timeDesign -postRoute
optDesign -postRoute

}
#=========================================================================================
# free_design
#
proc free_design {} {
   put_header "Freeing design..."
   freeDesign
}

#=========================================================================================
# save_design
#
proc save_design step {
   global design

   saveDesign DBS/$design-$step.enc
}

#=========================================================================================
# restore_design
#
proc restore_design step {
   global design
   global root

   set path "./DBS/${design}-${step}.enc.dat"
   if [file exists $path] {
      restoreDesign $path $root
   } else {
      puts "-e- No design saved as $path"
   }
}

#=========================================================================================
# import_design
#     how      init | restore
#
proc import_design {{how "init"}} {
   global design

   put_header [concat "Importing " $design " " $how "..."]

   switch $how {
      "init"      {  uplevel #0 source CONF/design.globals
                     init_design
                     save_design import
                  }
      "restore"   {  restore_design import  }
   }
   setDrawView fplan
   fit
}


#=========================================================================================
# floorplan_design
#
proc floorplan_design {} {
   global design
   global root
   set init_design_uniquify 1
   put_header [concat "Floorplanning " $design "..."]

   set ASPECT_RATIO   1.0     ;# rectangle with height = 1.0*width
   set ROW_DENSITY    0.9   ;# 0.1..1.0
   set CORE_TO_LEFT   12     ;# micron
   set CORE_TO_BOTTOM 12     ;# micron
   set CORE_TO_RIGHT  12     ;# micron
   set CORE_TO_TOP    12     ;# micron

   floorPlan -site core7T -r $ASPECT_RATIO $ROW_DENSITY $CORE_TO_LEFT $CORE_TO_BOTTOM $CORE_TO_RIGHT $CORE_TO_TOP
   fit

   save_design fplan
}


#=========================================================================================
# connect_global_nets
#
proc connect_global_nets {} {
   global design
   global pwr_net
   global gnd_net

   put_header "Connecting global power nets..."


   globalNetConnect $pwr_net -type pgpin -pin VDD -all -verbose
   globalNetConnect $gnd_net  -type pgpin -pin VSS -all -verbose
   globalNetConnect $pwr_net  -type tiehi
   globalNetConnect $gnd_net -type tielo

}

#=========================================================================================
# Place the IO (by laoding the IO file) and then add the IO filler for pad ring continuity.
#
proc place_io_add_io_filler {} {
   #global design
   global rpt_dir

   put_header "Loading IO file..."
   loadIoFile SCRIPTS/place_io.io


   set iofiller_cells "pad_fill_32 pad_fill_16 pad_fill_8 pad_fill_4 pad_fill_2 pad_fill_1 pad_fill_01 pad_fill_005"
   put_header "Adding IO filler cells..."

   set prefix FILLER
   set number_io_fill [llength $iofiller_cells]
   set number_io_fill_decr [expr {$number_io_fill-1}]

   #If there is only one IO, go to the else. Generally not the case
   if {$number_io_fill>2} {
	   foreach {side} [list n s e w] {
		   for {set x 0} {$x<$number_io_fill_decr} {incr x} {
		      set io_filler [lindex $iofiller_cells $x]
		      addIoFiller -cell $io_filler -prefix $prefix -side $side
		   }
		      set io_filler_last [lindex $iofiller_cells $number_io_fill_decr]
		      addIoFiller -cell $io_filler_last -prefix $prefix -side $side -fillAnyGap

	   } } else {foreach {side} [list n s e w] {
		   for {set x 0} {$x<$number_io_fill_decr} {incr x} {
		      set io_filler [lindex $iofiller_cells $x]
		      addIoFiller -cell $iofiller_cells -prefix $prefix -side $side -fillAnyGap
		   }

	   }}

}
#=========================================================================================
# add_power_nets
#   
#
proc add_power_nets {} {
   global design
   global pwr_net
   global gnd_net

   put_header "Adding power nets..."

   set POWER_NETS    "$gnd_net $pwr_net"  ;# from core
   set CENTER_RING   1         ;# center rings between I/O and core
   set WIDTH         3.0       ;# width of ring segments
   set SPACING       2       ;# spacing of ring segments

   set LAYERS  {top METAL1 bottom METAL1 left METAL2 right METAL2}
   set EXTEND  {} ;# tl, tr, bl, bt, lt, rt, lb, rb

   deleteAllPowerPreroutes

   # add power rings

   addRing \
      -type core_rings -follow core \
      -nets $POWER_NETS \
      -center $CENTER_RING \
      -width $WIDTH -spacing $SPACING \
      -layer $LAYERS \
      -extend_corner $EXTEND -jog_distance 0 -snap_wire_center_to_grid None -threshold 0

#Connect the VDD/VSS ring to VDD/VSS pads
sroute -connect { padPin } -layerChangeRange { METAL1(1) METAL6(6) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -padPinLayerRange { METAL3(3) METAL3(3) } -allowJogging 0 -crossoverViaLayerRange { METAL1(1) METAL6(6) } -nets $POWER_NETS -allowLayerChange 0 -targetViaLayerRange { METAL1(1) METAL6(6) }

   fit
   save_design power
}

#=========================================================================================
# route_power_nets
#
proc route_power_nets {} {
   global pwr_net
   global gnd_net

   set POWER_NETS    "$gnd_net $pwr_net"  ;

   sroute -connect { blockPin corePin } \
          -layerChangeRange { METAL1(1) METAL6(6) } \
          -blockPinTarget { nearestTarget } \
          -corePinTarget { firstAfterRowEnd } \
          -crossoverViaLayerRange { METAL1(1) METAL6(6) } -nets $POWER_NETS \
          -allowJogging 1 \
          -allowLayerChange 1 \
          -blockPin useLef -targetViaLayerRange { METAL1(1) METAL6(6) }

   fit
   save_design power-routed
}

#=========================================================================================
# place_core_cells
#  
#
proc place_core_cells {} {
   global design
   global root
   global rpt_dir
   global max_route_layer
   global cpu_number

   put_header "Placing core cells..."

   setMultiCpuUsage -localCpu $cpu_number -keepLicense true -acquireLicense $cpu_number

   set PROCESS 180    ;# process technology value [micron]
   setDesignMode -process $PROCESS

   setRouteMode -earlyGlobalMaxRouteLayer $max_route_layer
   setPlaceMode -timingDriven true \
                -congEffort auto \
                -doCongOpt false -placeIOPins 1
   placeDesign -noPrePlaceOpt

   setDrawView place
   checkPlace ${rpt_dir}/place.rpt

   set name "placed"
   save_design $name
}



#=========================================================================================
# create_clock_tree
# 
#
proc create_clock_tree {{opt ""}} {
   global design
   global root
   global rpt_dir
   global max_route_layer
   global cpu_number


   setMultiCpuUsage -localCpu $cpu_number -keepLicense true -acquireLicense $cpu_number

   set cts_buffer_cells "BUFX1"
   set cts_inverter_cells "INVX1 INVX2 INVX4 INVX8 INVX16 INVX32"

   put_header "Creating clock tree..."
   create_route_type -name clkroute -top_preferred_layer $max_route_layer

   set_ccopt_property route_type_override_preferred_routing_layer_effort none
   set_ccopt_property route_type clkroute -net_type trunk
   set_ccopt_property route_type clkroute -net_type leaf

   set_ccopt_property buffer_cells $cts_buffer_cells
   set_ccopt_property inverter_cells $cts_inverter_cells

   create_ccopt_clock_tree_spec -file ccopt.spec
   source ccopt.spec

   ccopt_design -cts

   save_design cts
}


#=========================================================================================
# route_design
#
proc route_design {} {
   global design   
   global max_route_layer
   global cpu_number


   setMultiCpuUsage -localCpu $cpu_number -keepLicense true -acquireLicense $cpu_number

   put_header "Routing design..."

   set route_timing     true  ;# true | false - timing driven routing
   set route_tdr_effort 5     ;# 0..10 - 0: opt. congestion; 1: opt. timing
   set rpt_dir "RPT/$design"

   setNanoRouteMode \
      -routeWithTimingDriven $route_timing \
      -routeTopRoutingLayer $max_route_layer \
      -routeTdrEffort $route_tdr_effort
   routeDesign -globalDetail -wireOpt -viaOpt
   checkRoute

   save_design routed
}

#=========================================================================================
# 
# add_filler_cells
#
proc add_filler_cells {} {
   global design


   put_header "Adding filler cells..."

   set filler_cells \
      "FILL32 FILL16 FILL8 FILL4 FILL2 FILL1"
   set prefix FILLER

   addFiller \
      -cell $filler_cells \
      -prefix $prefix
   setDrawView place

   save_design filled
}


#=========================================================================================
# verify_design
#
proc verify_design {} {
   global rpt_dir

   put_header "Verifying design..."

   verifyConnectivity -type all -report ${rpt_dir}/connectivity.rpt

   setVerifyGeometryMode -regRoutingOnly true -error 100000
   verifyGeometry -report ${rpt_dir}/geometry.rpt

   verifyProcessAntenna -report ${rpt_dir}/antenna.rpt
   #addDiode $antenna_rpt_file $antenna_cell
}

#=========================================================================================
# generate_reports
#
proc generate_reports {} {
   global rpt_dir

   put_header "Generating reports..."

   reportNetStat > ${rpt_dir}/netlist_stats_final.rpt
   report_area > ${rpt_dir}/area_final.rpt
   report_timing > ${rpt_dir}/timing_final.rpt
   summaryReport -noHtml -outfile ${rpt_dir}/summary_report.rpt
}

#=========================================================================================
# export_design
#
proc export_design {} {
   global design
   global root
   global rpt_dir

   put_header "Exporting design..."

   set fname "${design}_pr"
   set lib [string toupper $design]
   #To be used for importing into Virtuoso
   saveNetlist -excludeLeafCell -includePowerGround "../HDL/GATE/${fname}_virtuoso.v"
   #To be used for modelsim verification (does not contain VDD/VSS ports)
   saveNetlist -excludeLeafCell "../HDL/GATE/${fname}_modelsim.v"
   streamOut "GDS/${fname}.gds" \
             -mapFile GDS/gds2.map \
             -libName $lib \
             -structureName $design \
             -units 2000 -mode ALL \
	   -merge "/research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/gds/sclib_tsmc180.gds /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/gds/padlib_tsmc180.gds"
}

#=========================================================================================
# do_steps
#
proc do_steps {start {end -1}} {

   if {$end == -1} {set end $start}
   for {set i $start} {$i <= $end} {incr i} {
      set st [format "%d" $i]
      uplevel #0 set step $st
      switch $st {
         "0"   { free_design }
         "1"   { import_design init }
         "2"   { floorplan_design }
         "3"   { connect_global_nets }
         "4"   { place_io_add_io_filler }
         "5"   { add_power_nets }
         "6"   { route_power_nets }
         "7"   { place_core_cells }
         "8"   { opt_design_prects }
         "9"   { create_clock_tree }
         "10"   { opt_design_postcts }
         "11"   { route_design }
         "12"   { opt_design_postroute }
         "13"  { add_filler_cells }
         "14"  { verify_design }
         "15"  { generate_reports }
         "16"  { export_design }
      }
   }
}

