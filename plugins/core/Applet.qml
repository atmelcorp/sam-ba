import QtQuick 2.3

Item {
	property string name
	property string description

	property string kind
	property string fileUrl
	property int appletAddress
	property int mailboxAddress

	property int memorySize
	property int bufferAddress
	property int bufferSize

	property int initCommand
	property int readCommand
	property int writeCommand
	property int blockEraseCommand
	property int fullEraseCommand
	property int gpnvmCommand
}
