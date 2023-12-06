import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QGroundControl.Controls 1.0

Popup {
    id: settingsPopup
    property int buttonIndex: -1
    width: parent.width * 0.8
    height: parent.height * 1
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    GridLayout {
        rows: 4
        columns: 4
        anchors.fill: parent
        anchors.margins: 5

        Label {
            text: "Button " + buttonIndex + " Settings"
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            Layout.columnSpan: 4
            Layout.row: 0
        }

        Label { text: "Servo Number"; Layout.column: 0; Layout.row: 1 }
        Label { text: "PWM Value"; Layout.column: 1; Layout.row: 1 }
        Label { text: "Repeat Time"; Layout.column: 2; Layout.row: 1 }
        Label { text: "Delay"; Layout.column: 3; Layout.row: 1 }

        TextField {
            id: servoNumberField
            placeholderText: "Enter Servo Number"
            validator: IntValidator {}
            Layout.column: 0
            Layout.row: 2
            Layout.fillWidth: true
        }
        TextField {
            id: pwmValueField
            placeholderText: "Enter PWM Value"
            validator: IntValidator {}
            Layout.column: 1
            Layout.row: 2
            Layout.fillWidth: true
        }
        TextField {
            id: repTimeField
            placeholderText: "Enter Repeat Time"
            validator: IntValidator {}
            Layout.column: 2
            Layout.row: 2
            Layout.fillWidth: true
        }
        TextField {
            id: delayField
            placeholderText: "Enter Delay"
            validator: IntValidator {}
            Layout.column: 3
            Layout.row: 2
            Layout.fillWidth: true
        }


        Item { Layout.column: 0; Layout.row: 3; Layout.columnSpan: 3 }
        RowLayout {
            Layout.column: 3
            Layout.row: 3
            Layout.alignment: Qt.AlignRight
            spacing: 3

            QGCButton {
                id: saveButton
                text: "Save"
                primary: true
                onClicked: {
                    // Validation
                    var servoNumber = parseInt(servoNumberField.text);
                    var pwmValue = parseInt(pwmValueField.text);
                    var repTime = parseInt(repTimeField.text);
                    var delay = parseInt(delayField.text);

                    var isValid = true;
                    var errorMessage = "";

                    if (isNaN(servoNumber) || servoNumber < 1 || servoNumber > 16) {
                        isValid = false;
                        errorMessage += "Servo number must be between 1 and 16.\n";
                    }

                    if (isNaN(pwmValue) || pwmValue < 800 || pwmValue > 2000) {
                        isValid = false;
                        errorMessage += "PWM value must be between 800 and 2000.\n";
                    }

                    if (isValid) {
                        var settings = {
                            servoNumber: servoNumber,
                            pwmValue: pwmValue,
                            repTime: repTime,
                            delay: delay
                        };

//                        _activeJoystick.setButtonSettings(settingsPopup.buttonIndex, settings);
                        _activeJoystick.setButtonSettings(buttonIndex, settings)

                        settingsPopup.close();
                    } else {
                        // Handle validation error
                        console.log("Validation Error: " + errorMessage);
                    }
                }
            }


            QGCButton {
                id: cancelButton
                text: "Cancel"
                primary: false
                onClicked: settingsPopup.close()
            }
        }
    }

    onOpened: {
        var settings = _activeJoystick.getButtonSettings(buttonIndex);
        servoNumberField.text = settings.servoNumber.toString();
        pwmValueField.text = settings.pwmValue.toString();
        repTimeField.text = settings.repTime.toString();
        delayField.text = settings.delay.toString();
    }
}
