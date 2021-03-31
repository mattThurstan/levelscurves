import QtQuick 2.0
import org.shotcut.qml 1.0

Metadata {
    type: Metadata.Filter
    name: qsTr('Levels Curves', 'Levels video filter with curves')
    mlt_service: 'frei0r.curves'
    qml: 'ui.qml'
	keyframes {
        allowAnimateIn: true
        allowAnimateOut: true
        simpleProperties: ['3', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15']
        parameters: [
            Parameter {
                name: qsTr('Curve point number')
                property: '3'
                isSimple: true
                isCurve: true
                minimum: 2
                maximum: 5
            },
            Parameter {
                name: qsTr('Point 1 input value')
                property: '6'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            },
            Parameter {
                name: qsTr('Point 1 output value')
                property: '7'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            },
            Parameter {
                name: qsTr('Point 2 input value')
                property: '8'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            },
            Parameter {
                name: qsTr('Point 2 output value')
                property: '9'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            },
            Parameter {
                name: qsTr('Point 3 input value')
                property: '10'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            },
            Parameter {
                name: qsTr('Point 3 output value')
                property: '11'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            },
            Parameter {
                name: qsTr('Point 4 input value')
                property: '12'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            },
            Parameter {
                name: qsTr('Point 4 output value')
                property: '13'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            },
            Parameter {
                name: qsTr('Point 5 input value')
                property: '14'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            },
            Parameter {
                name: qsTr('Point 5 output value')
                property: '15'
                isSimple: true
                isCurve: true
                minimum: 0
                maximum: 1
            }
        ]
    }
}
