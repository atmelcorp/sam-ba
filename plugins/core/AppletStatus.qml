pragma Singleton
import QtQuick 2.3

Item {
	property int success:        0x00000000
	property int unknown_device: 0x00000001
	property int write_fail:     0x00000002
	property int read_fail:      0x00000003
	property int protect_fail:   0x00000004
	property int unprotect_fail: 0x00000005
	property int erase_fail:     0x00000006
	property int no_device:      0x00000007
	property int align_error:    0x00000008
	property int bad_block:      0x00000009
	property int pmecc_config:   0x0000000a
	property int generic_fail:   0x0000000f
}
