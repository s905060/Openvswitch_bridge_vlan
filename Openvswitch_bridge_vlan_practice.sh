#!/bin/bash
#
#  Created by s905060 on 2013.
#

function create_bond {
  for vlan in $*
  do
    vconfig add bond0 $vlan
    ovs-vsctl set port bond0 tag=$vlan
    ifconfig bond0.$vlan up
  done
}

function add_bridge_if {

  brdg=$1
  bond=$2

  echo "Creating $bond on $brdg"
  ovs-vsctl add-br $brdg
  ifconfig $brdg up
  ovs-vsctl add-port $brdg $bond

}

create_bond 12
add_bridge_if Net-CS6823 bond0.12

function openvswitch_bridge_vlan {
  bridge=$1
  vlan=$2
  echo "Creating Bridge: $bridge, Vlan tag: $vlan"
  ovs-vsctl add-br ovsbr0
  ovs-vsctl add-port ovsbr0 bond0
  ovs-vsctl add-br $bridge ovsbr0 $vlan
  ovs-vsctl set interface bond0 other-config:enable-vlan-splinters=true
}

ovs-vsctl set interface bond0 other-config:enable-vlan-splinters=true
openvswitch_bridge_vlan Net-CS6823 12
