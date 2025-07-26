DGPU=0000:03:00
GPU=${DGPU}.0
AUDIO=${DGPU}.1
GPU_VD="$(cat /sys/bus/pci/devices/${GPU}/vendor) $(cat /sys/bus/pci/devices/${GPU}/device)"
AUDIO_VD="$(cat /sys/bus/pci/devices/${AUDIO}/vendor) $(cat /sys/bus/pci/devices/${AUDIO}/device)"

function List {
    sudo lspci -nnk | rg -A 3 ${DGPU#*:}
}

function Switch {

  # amdgpu gets corrupted if you just remove it
  # removing and rescanning the device seems
  # to get around the problem
  echo "removing and re-attaching dgpu"
  echo 1 | sudo tee -a /sys/bus/pci/devices/${GPU}/remove
  echo 1 | sudo tee -a /sys/bus/pci/devices/${AUDIO}/remove
  echo 1 | sudo tee -a /sys/bus/pci/rescan

  echo "updating gpu driver"
  echo ${GPU} | sudo tee -a /sys/bus/pci/devices/${GPU}/driver/unbind
  echo ${AUDIO} | sudo tee -a /sys/bus/pci/devices/${AUDIO}/driver/unbind
  
  echo ${_gpu_driver} | sudo tee -a /sys/bus/pci/devices/${GPU}/driver_override
  echo ${_audio_driver} | sudo tee -a /sys/bus/pci/devices/${AUDIO}/driver_override

  echo ${GPU} | sudo tee -a /sys/bus/pci/drivers_probe
  echo ${AUDIO} | sudo tee -a /sys/bus/pci/drivers_probe

  echo "${_gpu_driver} now in use"

}

case $1 in
amd)
  _gpu_driver=amdgpu _audio_driver=snd_hda_intel Switch
  ;;
vfio)
  _gpu_driver=vfio-pci _audio_driver=vfio-pci Switch
  ;;
*)
  echo "$1 == (amd || vfio)"
  ;;
esac

