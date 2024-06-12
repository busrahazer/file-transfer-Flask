import QtQuick.Controls 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQml 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 600

    property string consoleOutput: ""

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#f0f0f0"

        ColumnLayout {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 70
            anchors.topMargin: 20
            anchors.margins: 20
            spacing: 15
            width: parent.width - 300

            RowLayout {
                spacing: 10

                Text {
                    text: "Car URL    "
                    font.pixelSize: 15
                    color: "#ff0055"
                    font.bold: true
                    Layout.alignment: Qt.AlignLeft
                }

                TextField {
                    id: urlField
                    placeholderText: "remote_host_ip"
                    placeholderTextColor: "#C0C0C0"
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 30
                }
            }

            RowLayout {
                spacing: 10

                Text {
                    text: "Car Port    "
                    font.pixelSize: 15
                    color: "#ff0055"
                    font.bold: true
                    Layout.alignment: Qt.AlignLeft
                }

                TextField {
                    id: portField
                    placeholderText: "22"
                    placeholderTextColor: "#C0C0C0"
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 30
                }
            }

            RowLayout {
                spacing: 10

                Text {
                    text: "Username"
                    font.pixelSize: 15
                    color: "#ff0055"
                    font.bold: true
                    Layout.alignment: Qt.AlignLeft
                }

                TextField {
                    id: userNameField
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 30
                }
            }

            RowLayout {
                spacing: 10

                Text {
                    text: "Password "
                    font.pixelSize: 15
                    color: "#ff0055"
                    font.bold: true
                    Layout.alignment: Qt.AlignLeft
                }

                TextField {
                    id: passwordField
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 30
                    echoMode: TextInput.Password
                }
            }

            RowLayout {
                spacing: 10

                Text {
                    text: "Log Path   "
                    font.pixelSize: 15
                    color: "#ff0055"
                    font.bold: true
                    Layout.alignment: Qt.AlignLeft
                }

                TextField {
                    id: logPathField
                    placeholderText: "/path/to/remote/file"
                    placeholderTextColor: "#C0C0C0"
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 30
                }
            }

            Button {
                text: "Test Connection"
                font.pixelSize: 15
                Layout.preferredWidth: 150
                Layout.preferredHeight: 50
                Layout.alignment: Qt.AlignCenter

                onClicked: {
                    consoleOutput = "Username: " + userNameField.text
                }

                background: Rectangle {
                    color: "#ff0055"
                    radius: 15
                }

                contentItem: Item {
                    width: parent.width
                    height: parent.height
                    Text {
                        text: "Test Connection"
                        color: "white"
                        font.pixelSize: 15
                        anchors.centerIn: parent
                    }
                }
            }
            Button {
                text: "Download Log"
                font.pixelSize: 15
                Layout.preferredWidth: 150
                Layout.preferredHeight: 50
                Layout.alignment: Qt.AlignCenter

                onClicked: {
                    var xhr = new XMLHttpRequest();
                    xhr.open("POST", "http://localhost:5000/download_log");
                    xhr.setRequestHeader("Content-Type", "application/json");
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === XMLHttpRequest.DONE) {
                            consoleOutput = xhr.responseText;
                        }
                    }
                    var data = JSON.stringify({
                        "remote_host": urlField.text,
                        "remote_port": portField.text,
                        "username": userNameField.text,
                        "password": passwordField.text,
                        "remote_path": logPathField.text
                    });
                    xhr.send(data);
                }

                background: Rectangle {
                    color: "#ff0055"
                    radius: 15
                }

                contentItem: Item {
                    width: parent.width
                    height: parent.height
                    Text {
                        text: "Download Log"
                        color: "white"
                        font.pixelSize: 15
                        anchors.centerIn: parent
                    }
                }
            }

            Text {
                id: consoleOutputText
                text: consoleOutput
                color: "#C0C0C0"
                font.pixelSize: 15
                Layout.alignment: Qt.AlignLeft
                wrapMode: Text.Wrap
                width: parent.width - 300
                height: 200
            }
        }
    }
}
