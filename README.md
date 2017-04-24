
* Copy to `CLOVER/kexts/Other`:
    * `FakePCIID.kext` from [RehabMan-FakePCIID-2017-0109.zip](https://bitbucket.org/RehabMan/os-x-fake-pci-id/downloads/RehabMan-FakePCIID-2017-0109.zip) ([source code](https://github.com/RehabMan/OS-X-Fake-PCI-ID))

# USB

Set up USB 2.0 and USB 3.0 ports

* Copy to `CLOVER/kexts/Other`:
    * `FakePCIID_XHCIMux.kext` from [RehabMan-FakePCIID-2017-0109.zip](https://bitbucket.org/RehabMan/os-x-fake-pci-id/downloads/RehabMan-FakePCIID-2017-0109.zip) ([source code](https://github.com/RehabMan/OS-X-Fake-PCI-ID))
        * Routes devices on XHC port USB 2.0 pins to EHC1, helping with port limit.
    * `USBInjectAll.kext` from [RehabMan-USBInjectAll-2017-0112.zip](https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/RehabMan-USBInjectAll-2017-0112.zip) ([source code](https://github.com/RehabMan/OS-X-USB-Inject-All))
* [Custom SSDT for `USBInjectAll.kext`](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/)
    * Compile [`SSDT-UIAC.dsl`](ACPI_patches/SSDT-UIAC.dsl) with MaciASL from [RehabMan-MaciASL-2017-0117.zip](https://bitbucket.org/RehabMan/os-x-maciasl-patchmatic/downloads/RehabMan-MaciASL-2017-0117.zip)
    * Save result [`SSDT-UIAC.aml`](CLOVER/ACPI/patched/SSDT-UIAC.aml) to `CLOVER/ACPI/patched`.
* EHC1->EH01 rename in [`config.plist`](CLOVER/config.plist)
* Disabled: EHC2->EH02 rename in [`config.plist`](CLOVER/config.plist)
* Disabled: XHCI->XHC rename in [`config.plist`](CLOVER/config.plist)
* Disabled: XHC1->XHC rename in [`config.plist`](CLOVER/config.plist)

Note the USB 3.1 ports are separate and apparently worked natively in 10.12, but an addon card (dodocool DC26 SuperSpeed USB 3.1 PCI-E, ASM1142 chipset) did not automatically work despite a review stating it worked on a Mac Pro.
