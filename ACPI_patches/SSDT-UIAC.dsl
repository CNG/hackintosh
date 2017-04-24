// SSDT-UIAC.dsl

// For ASUS Z97-A/USB 3.1
// charlie@gorichanaz.com
// Template from https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/

DefinitionBlock ("", "SSDT", 2, "hack", "UIAC-ALL", 0)
{
    Device(UIAC)
    {
        Name(_HID, "UIA00000")

        Name(RMCF, Package()
        {
            "EH01", Package()
            {
                "port-count", Buffer() { 8, 0, 0, 0 },

                "ports", Package()
                {
                    "HP11", Package() // front left
                    {
                        //"UsbConnector", 0,
                        "portType", 2,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HP12", Package() // front right
                    {
                        //"UsbConnector", 0,
                        "portType", 2,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HP13", Package() // read bottom right
                    {
                        //"UsbConnector", 0,
                        "portType", 2,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HP14", Package() // read bottom left
                    {
                        //"UsbConnector", 0,
                        "portType", 2,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HP15", Package() // read middle right
                    {
                        //"UsbConnector", 0,
                        "portType", 2,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HP16", Package() // read middle left
                    {
                        //"UsbConnector", 0,
                        "portType", 2,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    // Probably the internal ones
                    // "HP17", Package()
                    // {
                    //     //"UsbConnector", 0,
                    //     "portType", 2,
                    //     "port", Buffer() { 7, 0, 0, 0 },
                    // },
                    // "HP18", Package()
                    // {
                    //     //"UsbConnector", 0,
                    //     "portType", 2,
                    //     "port", Buffer() { 8, 0, 0, 0 },
                    // },
                },
            },
            "8086_8cb1", Package()
            {
                "port-count", Buffer() { 21, 0, 0, 0 },
                // ports disappeared when changed 21 to 6

                "ports", Package()
                {
                    "SSP1", Package() // front left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 16, 0, 0, 0 },
                    },
                    "SSP2", Package() // front right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 17, 0, 0, 0 },
                    },
                    "SSP3", Package() // read bottom right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 18, 0, 0, 0 },
                    },
                    "SSP4", Package() // read bottom left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 19, 0, 0, 0 },
                    },
                    "SSP5", Package() // read middle right
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 20, 0, 0, 0 },
                    },
                    "SSP6", Package() // read middle left
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 21, 0, 0, 0 },
                    },
                },
            },
        })
    }
}
//EOF
