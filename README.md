# Hackintosh: ASUS Z97-A USB 3.1, NVMe SSD, GT 740

My original procedure from January 2016 is [documented on my blog](https://votecharlie.com/blog/2016/01/hackintosh-asus-z97-a-31.html).
I did a reinstall from scratch in April 2017 while building [my dotfiles project](https://github.com/CNG/dotfiles).
This repository tracks the hackintosh specific information.


## macOS Sierra installation

[**UEFI settings**](UEFI/index.md)

Follow [UniBeast: Install macOS Sierra on Any Supported Intel-based PC](https://www.tonymacx86.com/threads/unibeast-install-macos-sierra-on-any-supported-intel-based-pc.200564/).
Exceptions:

* **Disk Utility cannot see NVMe drive**
    * Apply the [10.12.4 NVMe patches](https://github.com/RehabMan/patch-nvme/blob/master/NVMe_patches_10_12_4.plist) to `CLOVER/config.plist` on the installation media EFI volume.
    * May also need to copy `IONVMeFamily.kext` from an existing macOS 10.12.4 `/System/Library/Extensions` folder to `CLOVER/kexts/Other` on the installation media EFI volume since it may not be included in the macOS installer.

* **Boot failure (showing prohibited sign): no root volume**

    This time I also applied the same patches to the system Clover immediately following installation due to difficulties getting Clover to inject `HackrNVMeFamily-10_12_4.kext`.
    I later found I needed a newer Clover to get the network kext injected, but did not yet return to testing whether this was the same problem.

* **MultiBeast 9.0.1 configuration**

    * Quick Start > **UEFI Boot Mode**
    * Drivers > Audio > Realtek ALCxxx > **ALC892**
    * Drivers > Audio > Realtek ALCxxx > **Optional HD 4600 HDMI Audio**
    * Drivers > Misc > **FakeSMC v6.21-311-g2958f55.1723**
    * Drivers > Misc > **FakeSMC Plugins v6.21-311-g2958f55.1723**
    * Drivers > Misc > **FakeSMC HWMonitor Application v6.21-311-g2958f55.1723**
    * Drivers > Misc > **NullCPUPowerManagement v1.0.0d2**
    * Bootloaders > **Clover v2.3k r3766 UEFI Boot Mode**
    * Customize > **System Definitions > iMac > iMac 14,2**
    * Customize > SSDT Options > **Sandy Bridge Core i5 / i7 Overclocked**

* **Ethernet fails when booting from system Clover**

    Support for the onboard Intel I218V was [reportedly added](https://www.tonymacx86.com/threads/intel-i218-v-driver.132629/) to `AppleIntelE1000e v3.3.3`, which is installable by MultiBeast.
    I saw "IntelMausi..." on the [downloads page](https://bitbucket.org/RehabMan/os-x-intel-network) for a RehabMan version, so I copied `IntelMausiEthernet.kext` manually by USB key to the system Clover, as mentioned below.
    MultiBeast 9.0.1 installed to the system Clover v2.3k r3766, but that version apparently cannot inject kexts properly or at all.
    Again using a USB key, I manually upgraded the system Clover to v2.4k r4049, after which kext injection worked.


## Post install configuration

Copy to `CLOVER/kexts/Other`:

* `FakePCIID.kext` from [RehabMan-FakePCIID-2017-0109.zip](https://bitbucket.org/RehabMan/os-x-fake-pci-id/downloads/RehabMan-FakePCIID-2017-0109.zip) ([source code](https://github.com/RehabMan/OS-X-Fake-PCI-ID))


### USB

The USB 3.1 ports are separate from USB 2.0 and USB 3.0 and work natively in 10.12.

**Configure USB 2.0 and USB 3.0 ports**

* Copy to `CLOVER/kexts/Other`:
    * `FakePCIID_XHCIMux.kext` from [RehabMan-FakePCIID-2017-0109.zip](https://bitbucket.org/RehabMan/os-x-fake-pci-id/downloads/RehabMan-FakePCIID-2017-0109.zip) ([source code](https://github.com/RehabMan/OS-X-Fake-PCI-ID))

        Routes devices on XHC port USB 2.0 pins to EHC1, helping with port limit.

    * `USBInjectAll.kext` from [RehabMan-USBInjectAll-2017-0112.zip](https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/RehabMan-USBInjectAll-2017-0112.zip) ([source code](https://github.com/RehabMan/OS-X-USB-Inject-All))
* [Custom SSDT for `USBInjectAll.kext`](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/)
    * Compile [`SSDT-UIAC.dsl`](ACPI_patches/SSDT-UIAC.dsl) with MaciASL from [RehabMan-MaciASL-2017-0117.zip](https://bitbucket.org/RehabMan/os-x-maciasl-patchmatic/downloads/RehabMan-MaciASL-2017-0117.zip)
    * Save result [`SSDT-UIAC.aml`](CLOVER/ACPI/patched/SSDT-UIAC.aml) to `CLOVER/ACPI/patched`.

**USB 3.1 PCI-E card**

My addon card ([dodocool DC26 SuperSpeed USB 3.1 PCI-E](http://amzn.to/2olbnre), ASM1142 chipset) initially did not work.
I thought it might be because I had not yet connected the card to an additional (SATA) power supply.
The [DC22 product page](http://www.dodocool.com/usb-adapters-1772/p-dc22.html) states the extra power is only required to enable higher charging current on both ports:

> **PCIe or SATA 15-pin power connector for power supply**
>
> Supply power directly from PCIe bus or from 15-pin SATA power connector. When using the 15-pin SATA power connector, it supports up to 5V 2A bus power on each USB 3.1 port.

The [DC26 product page](http://www.dodocool.com/accessories-1931/p-dc26.html) does not specifically say the SATA power is optional or required:

> **Excellent Performance**
>
> The 15-pin SATA power connector supplies power to USB-C enabled devices, and supports up to 5V 900mAh output on each USB 3.1 port.

The ports worked once I removed the EHC1->EH01 patch I had previously determined I needed.
I found the DC26 does indeed require the SATA power connector, though.
The statement "up to 5V 900mAh output" seems to be wrong: my Nexus 6P reported 1720 mA charging current.


### Intel HD graphics

I primarily use a discrete graphics card, but I want to take advantage of onchip processor features such as Intel Quick Sync Video.
I do not believe it is set up properly yet based on the Messages app crashing when first showing certain videos and on [VDADecoderCheck](https://github.com/cylonbrain/VDADecoderCheck/releases) failing.
Maybe it is a problem with macOS Sierra.
I need to review the UEFI settings related to the proressor, such as [VT-d](https://en.wikipedia.org/wiki/X86_virtualization#GVT).

Copy to `CLOVER/kexts/Other`:

* `FakePCIID_Intel_HD_Graphics.kext` from [RehabMan-FakePCIID-2017-0109.zip](https://bitbucket.org/RehabMan/os-x-fake-pci-id/downloads/RehabMan-FakePCIID-2017-0109.zip) ([source code](https://github.com/RehabMan/OS-X-Fake-PCI-ID))

    > `8086:0412` is the native device-id for HD4600 desktop. By injecting `0412`, `AppleIntelFramebufferAzul` and `AppleIntelHD5000Graphics` will load. And since, FakePCIID will also be attached to these devices, it will successfully fool both kexts that the device an Intel HD4600 Desktop IGPU (0412).


### Intel network

Copy to `CLOVER/kexts/Other`:

* `IntelMausiEthernet.kext` from [RehabMan-IntelMausiEthernet-v2-2017-0321.zip](https://bitbucket.org/RehabMan/os-x-intel-network/downloads/RehabMan-IntelMausiEthernet-v2-2017-0321.zip) ([source code](https://github.com/RehabMan/OS-X-Intel-Network))

    System information utility shows "Intel I218V2 PCI Express Gigabit Ethernet".
    [ASUS specifications](https://www.asus.com/us/Motherboards/Z97AUSB_31/specifications/) show "Intel® I218V, 1 x Gigabit LAN, Dual interconnect between the Integrated Media Access Controller (MAC) and Physical Layer (PHY) Gigabit Intel® LAN Connection- 802.3az Energy Efficient Ethernet (EEE) appliance".


### Other

I forgot what [`SSDT-SB-OC.aml`](CLOVER/ACPI/patched/SSDT-SB-OC.aml) is or where it came from.
