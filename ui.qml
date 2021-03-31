import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Shotcut.Controls 1.0 as Shotcut

Item {
    width: 350
    height: 400
    property string channelParam: '0' 		// 0 = red, 0.1 = green, 0.2 = blue, 0.3 = alpha, 0.4 = luma, 0.5 = rgb, 0.6 = hue, 0.7 = saturation
	property string showCurvesParam: '1' 	// Draw curve graph on output image (bool)
	property string graphPositionParam: '2'
	property string curvePointNumParam: '3'
	property string lumaFormulaParam: '4'	// Rec.601 (false) or Rec.709 (true)  (bool)
	property string bezierSplineParam: '5' 	// Number of points to use to build curve (/10 to fit [0,1] parameter range). Minimum 2 (0.2), Maximum 5 (0.5). Not relevant for Bézier spline.
	property string point1InputParam: '6'
	property string point1OutputParam: '7'
	property string point2InputParam: '8'
	property string point2OutputParam: '9'
	property string point3InputParam: '10'
	property string point3OutputParam: '11'
	property string point4InputParam: '12'
	property string point4OutputParam: '13'
	property string point5InputParam: '14'
	property string point5OutputParam: '15'
    property bool blockUpdate: true
    //property var startValues:  [0, 1, 0.25] // inputBlackParam, inputWhiteParam, gammaParam
    //property var middleValues: [0, 1, 0.25]
    //property var endValues:    [0, 1, 0.25]
	//handle1x;handle1y#pointx;pointy#handle2x;handle2y
	//-1;-1#0;0#.1;.1|
	//.356;.661#.406;.711#.456;.761|
	//.9;.9#1;1#2;2
	property string splinePoints: "0;0#0;0#0;0| 
									0.25;0.25#0.25;0.25#0.25;0.25|
									0.5;0.5#0.5;0.5#0.5;0.5|
									0.75;0.75#0.75;0.75#0.75;0.75|
									1;1#1;1#1;1"

    Component.onCompleted: {
        if (filter.isNew) {
            // Set default parameter values
			filter.set(channelParam, 5/10)		// 0
			//filter.set(showCurvesParam, 0)		// 1
			filter.set(graphPositionParam, 0.3)	// 2
			filter.set(curvePointNumParam, 2/10) // 3 - (/10 to fit [0,1] parameter range). Minimum 2 (0.2), Maximum 5 (0.5)
			//filter.set(lumaFormulaParam, 1)		// 4
			filter.set(bezierSplineParam, splinePoints)	 // 5 - ???
			filter.set(point1InputParam, 0)		// 6
			filter.set(point1OutputParam, 0)		// 7
			filter.set(point2InputParam, 1)		// 8
			filter.set(point2OutputParam, 1)	// 9
			filter.set(point3InputParam, 0)		// 10
			filter.set(point3OutputParam, 0)	// 11
			filter.set(point4InputParam, 0)		// 12
			filter.set(point4OutputParam, 0)	// 13
			filter.set(point5InputParam, 0)		// 14
			filter.set(point5OutputParam, 0)	// 15
			
            //filter.savePreset(preset.parameters)
        } else {
            initSimpleAnimation()
        }
        setControls()
    }

    function initSimpleAnimation() {
		middleValues = [filter.getDouble(curvePointNumParam, filter.animateIn),
                        filter.getDouble(point1InputParam, filter.animateIn),
                        filter.getDouble(point1OutputParam, filter.animateIn),
                        filter.getDouble(point2InputParam, filter.animateIn),
                        filter.getDouble(point2OutputParam, filter.animateIn),
                        filter.getDouble(point3InputParam, filter.animateIn),
                        filter.getDouble(point3OutputParam, filter.animateIn),
                        filter.getDouble(point4InputParam, filter.animateIn),
                        filter.getDouble(point4OutputParam, filter.animateIn),
                        filter.getDouble(point5InputParam, filter.animateIn),
                        filter.getDouble(point5OutputParam, filter.animateIn)]
        if (filter.animateIn > 0) {
            startValues = [filter.getDouble(curvePointNumParam, 0),
                           filter.getDouble(point1InputParam, 0),
                           filter.getDouble(point1OutputParam, 0),
                           filter.getDouble(point2InputParam, 0),
                           filter.getDouble(point2OutputParam, 0),
                           filter.getDouble(point3InputParam, 0),
                           filter.getDouble(point3OutputParam, 0),
                           filter.getDouble(point4InputParam, 0),
                           filter.getDouble(point4OutputParam, 0),
                           filter.getDouble(point5InputParam, 0),
                           filter.getDouble(point5OutputParam, 0)]
        }
        if (filter.animateOut > 0) {
            endValues = [filter.getDouble(curvePointNumParam, filter.duration - 1),
                         filter.getDouble(point1InputParam, filter.duration - 1),
                         filter.getDouble(point1OutputParam, filter.duration - 1),
                         filter.getDouble(point2InputParam, filter.duration - 1),
                         filter.getDouble(point2OutputParam, filter.duration - 1),
                         filter.getDouble(point3InputParam, filter.duration - 1),
                         filter.getDouble(point3OutputParam, filter.duration - 1),
                         filter.getDouble(point4InputParam, filter.duration - 1),
                         filter.getDouble(point4OutputParam, filter.duration - 1),
                         filter.getDouble(point5InputParam, filter.duration - 1),
                         filter.getDouble(point5OutputParam, filter.duration - 1)]
        }
    }

    function getPosition() {
        return Math.max(producer.position - (filter.in - producer.in), 0)
    }

    function setKeyframedControls() {
        var position = getPosition()
        blockUpdate = true
		
		curvePointNumberSlider.value = filter.getDouble(curvePointNumParam, position) * curvePointNumberSlider.maximumValue
		curvePointNumberKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(curvePointNumParam) > 0
		
		point1InputSlider.value = filter.getDouble(point1InputParam, position) * point1InputSlider.maximumValue
		point1InputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point1InputParam) > 0
		point1OutputSlider.value = filter.getDouble(point1OutputParam, position) * point1OutputSlider.maximumValue
		point1OutputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point1OutputParam) > 0
		
		point2InputSlider.value = filter.getDouble(point2InputParam, position) * point2InputSlider.maximumValue
		point2InputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point2InputParam) > 0
		point2OutputSlider.value = filter.getDouble(point2OutputParam, position) * point2OutputSlider.maximumValue
		point2OuputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point2OutputParam) > 0
		
		point3InputSlider.value = filter.getDouble(point3InputParam, position) * point3InputSlider.maximumValue
		point3InputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point3InputParam) > 0
		point3OutputSlider.value = filter.getDouble(point3OutputParam, position) * point3OutputSlider.maximumValue
		point3OutputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point3OutputParam) > 0
		
		point4InputSlider.value = filter.getDouble(point4InputParam, position) * point4InputSlider.maximumValue
		point4InputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point4InputParam) > 0
		point4OutputSlider.value = filter.getDouble(point4OutputParam, position) * point4OutputSlider.maximumValue
		point4OutputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point4OutputParam) > 0
		
		point5InputSlider.value = filter.getDouble(point5InputParam, position) * point5InputSlider.maximumValue
		point5InputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point5InputParam) > 0
		point5OutputSlider.value = filter.getDouble(point5OutputParam, position) * point5OutputSlider.maximumValue
		point5OutputKeyframesButton.checked = filter.animateIn <= 0 && filter.animateOut <= 0 && filter.keyframeCount(point5OutputParam) > 0
		
		blockUpdate = false
		curvePointNumberSlider.enabled = point1InputSlider.enabled = point1OutputSlider.enabled 
		    = point2InputSlider.enabled = point2OutputSlider.enabled 
		    = point3InputSlider.enabled = point3OutputSlider.enabled 
			= point4InputSlider.enabled = point4OutputSlider.enabled
			= point5InputSlider.enabled = point5OutputSlider.enabled
			= position <= 0 || (position >= (filter.animateIn - 1) && position <= (filter.duration - filter.animateOut)) || position >= (filter.duration - 1)
    }

    function setControls() {
        setKeyframedControls()
		
        channelCombo.currentIndex = Math.round(filter.getDouble(channelParam) * 10)
		showCurvesCheckbox.checked = filter.get(showCurvesParam) === '0'
        channelCombo.currentIndex = Math.round(filter.getDouble(graphPositionParam) * 10)
		
		curvePointNumberSlider.value = filter.getDouble(curvePointNumParam) * curvePointNumberSlider.maximumValue
		
		lumaFormulaCheckbox.checked = filter.get(lumaFormulaParam) === '1'
		
		point1InputSlider.value = filter.getDouble(point1InputParam) * point1InputSlider.maximumValue
		point1OutputSlider.value = filter.getDouble(point1OutputParam) * point1OutputSlider.maximumValue
		
		point2InputSlider.value = filter.getDouble(point2InputParam) * point2InputSlider.maximumValue
		point2OutputSlider.value = filter.getDouble(point2OutputParam) * point2OutputSlider.maximumValue
		
		point3InputSlider.value = filter.getDouble(point3InputParam) * point3InputSlider.maximumValue
		point3OutputSlider.value = filter.getDouble(point3OutputParam) * point3OutputSlider.maximumValue
		
		point4InputSlider.value = filter.getDouble(point4InputParam) * point4InputSlider.maximumValue
		point4OutputSlider.value = filter.getDouble(point4OutputParam) * point4OutputSlider.maximumValue
		
		point5InputSlider.value = filter.getDouble(point5InputParam) * point5InputSlider.maximumValue
		point5OutputSlider.value = filter.getDouble(point5OutputParam) * point5OutputSlider.maximumValue
		//
    }

    function updateFilter(parameter, value, position, button) {
        if (blockUpdate) return
        var index = preset.parameters.indexOf(parameter) - 1

        if (position !== null) {
            if (position <= 0 && filter.animateIn > 0)
                startValues[index] = value
            else if (position >= filter.duration - 1 && filter.animateOut > 0)
                endValues[index] = value
            else
                middleValues[index] = value
        }

        if (filter.animateIn > 0 || filter.animateOut > 0) {
            filter.resetProperty(parameter)
            button.checked = false
            if (filter.animateIn > 0) {
                filter.set(parameter, startValues[index], 0)
                filter.set(parameter, middleValues[index], filter.animateIn - 1)
            }
            if (filter.animateOut > 0) {
                filter.set(parameter, middleValues[index], filter.duration - filter.animateOut)
                filter.set(parameter, endValues[index], filter.duration - 1)
            }
        } else if (!button.checked) {
            filter.resetProperty(parameter)
            filter.set(parameter, middleValues[index])
        } else if (position !== null) {
            filter.set(parameter, value, position)
        }
    }

    function onKeyframesButtonClicked(checked, parameter, value) {
        if (checked) {
            blockUpdate = true
			curvePointNumberSlider.enabled = point1InputSlider = point1OutputSlider 
			    = point2InputSlider = point2OutputSlider 
			    = point3InputSlider = point3OutputSlider 
				= point4InputSlider = point4OutputSlider 
				= point5InputSlider = point5OutputSlider 
				= true
            if (filter.animateIn > 0 || filter.animateOut > 0) {
                filter.resetProperty(curvePointNumParam)
				
                filter.resetProperty(point1InputParam)
                filter.resetProperty(point1OutputParam)
				
                filter.resetProperty(point2InputParam)
                filter.resetProperty(point2OutputParam)
				
                filter.resetProperty(point3InputParam)
                filter.resetProperty(point3OutputParam)
				
                filter.resetProperty(point4InputParam)
                filter.resetProperty(point4OutputParam)
				
                filter.resetProperty(point5InputParam)
                filter.resetProperty(point5OutputParam)
				
                filter.animateIn = filter.animateOut = 0
            } else {
                filter.clearSimpleAnimation(parameter)
            }
            blockUpdate = false
            filter.set(parameter, value, getPosition())
        } else {
            filter.resetProperty(parameter)
            filter.set(parameter, value)
        }
    }

    GridLayout {
        columns: 4
        anchors.fill: parent
        anchors.margins: 8

// preset
		
// Channel - 0
        Label {
            text: qsTr('Channel')
            Layout.alignment: Qt.AlignRight
        }
        Shotcut.ComboBox {
            id: channelCombo
			// 0 = red, 0.1 = green, 0.2 = blue, 0.3 = alpha, 0.4 = luma, 0.5 = rgb, 0.6 = hue, 0.7 = saturation
            model: [qsTr('Red'), qsTr('Green'), qsTr('Blue'), qsTr('Alpha'), qsTr('Luma'), qsTr('RGB'), qsTr('Hue'), qsTr('Sat')]
            onActivated: filter.set(channelParam, currentIndex / 10)
        }
        Shotcut.UndoButton {
            onClicked: {
                filter.set(channelParam, 5 / 10)
                channelCombo.currentIndex = 5
            }
        }
        Item { width: 1 }

// 	Show curves	- 1
		Label {
            text: qsTr('Show curves')
            Layout.alignment: Qt.AlignRight
        }
		CheckBox {
            id: showCurvesCheckbox
            text: qsTr('Show curves')
            onCheckedChanged: filter.set(showCurvesParam, checked)
        }
		Shotcut.UndoButton {
            onClicked: showCurvesCheckbox.checked = false 
        }
        Item { width: 1 }
		
// Graph position - 2
		Label {
            text: qsTr('Graph position')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.ComboBox {
            id: graphPositionCombo
			// 0.1 = TOP,LEFT; 0.2 = TOP,RIGHT; 0.3 = BOTTOM,LEFT; 0.4 = BOTTOM, RIGHT
            model: [qsTr('Top Left'), qsTr('Top Right'), qsTr('Bottom Left'), qsTr('Bottom Right')]
            onActivated: filter.set(graphPositionParam, currentIndex / 10)
        }
        Shotcut.UndoButton {
            onClicked: {
                filter.set(graphPositionParam, 0.3)
                channelCombo.currentIndex = 3
            }
        }
        Item { width: 1 }

// Curve point number - 3
		Label {
            text: qsTr('Curve point number')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: curvePointNumberSlider
            minimumValue: 2
            maximumValue: 5
            decimals: 0
            onValueChanged: updateFilter(curvePointNumParam, value / maximumValue, getPosition(), curvePointNumberKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: curvePointNumberSlider.value = 2
        }
		Shotcut.KeyframesButton {
            id: curvePointNumberKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, curvePointNumParam, curvePointNumberSlider.value / curvePointNumberSlider.maximumValue)
        }

// Luma formula - 4
		Label {
            text: qsTr('Luma formula')
            Layout.alignment: Qt.AlignRight
        }
		CheckBox {
            id: lumaFormulaCheckbox
            text: qsTr('Rec. 601 (false) or Rec. 709 (true)')
            onCheckedChanged: filter.set(lumaFormulaParam, checked)
        }
		Shotcut.UndoButton {
            onClicked: lumaFormulaCheckbox.checked = true 
        }
        Item { width: 1 }

// Bézier spline - 5

// Point 1 input value - 6
		Label {
            text: qsTr('Point 1 input value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point1InputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point1InputParam, value / maximumValue, getPosition(), point1InputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point1InputSlider.value = 0
        }
		Shotcut.KeyframesButton {
            id: point1InputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point1InputParam, point1InputSlider.value / point1InputSlider.maximumValue)
        }

// Point 1 output value - 7
		Label {
            text: qsTr('Point 1 output value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point1OutputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point1OutputParam, value / maximumValue, getPosition(), point1OutputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point1OutputSlider.value = 0
        }
		Shotcut.KeyframesButton {
            id: point1OutputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point1OutputParam, point1OutputSlider.value / point1OutputSlider.maximumValue)
        }

// Point 2 input value - 8
		Label {
            text: qsTr('Point 2 input value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point2InputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point2InputParam, value / maximumValue, getPosition(), point2InputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point2InputSlider.value = 1
        }
		Shotcut.KeyframesButton {
            id: point2InputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point2InputParam, point2InputSlider.value / point2InputSlider.maximumValue)
        }

// Point 2 output value - 9
		Label {
            text: qsTr('Point 2 output value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point2OutputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point2OutputParam, value / maximumValue, getPosition(), point2OuputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point2OutputSlider.value = 1
        }
		Shotcut.KeyframesButton {
            id: point2OuputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point2OutputParam, point2OutputSlider.value / point2OutputSlider.maximumValue)
        }

// Point 3 input value - 10
		Label {
            text: qsTr('Point 3 input value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point3InputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point3InputParam, value / maximumValue, getPosition(), point3InputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point3InputSlider.value = 0
        }
		Shotcut.KeyframesButton {
            id: point3InputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point3InputParam, point3InputSlider.value / point3InputSlider.maximumValue)
        }

// Point 3 output value - 11
		Label {
            text: qsTr('Point 3 output value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point3OutputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point3OutputParam, value / maximumValue, getPosition(), point3OutputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point3OutputSlider.value = 0
        }
		Shotcut.KeyframesButton {
            id: point3OutputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point3OutputParam, point3OutputSlider.value / point3OutputSlider.maximumValue)
        }

// Point 4 input value - 12
		Label {
            text: qsTr('Point 4 input value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point4InputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point4InputParam, value / maximumValue, getPosition(), point4InputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point4InputSlider.value = 0
        }
		Shotcut.KeyframesButton {
            id: point4InputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point4InputParam, point4InputSlider.value / point4InputSlider.maximumValue)
        }

// Point 4 output value - 13
		Label {
            text: qsTr('Point 4 output value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point4OutputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point4OutputParam, value / maximumValue, getPosition(), point4OutputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point4OutputSlider.value = 0
        }
		Shotcut.KeyframesButton {
            id: point4OutputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point4OutputParam, point4OutputSlider.value / point4OutputSlider.maximumValue)
        }

// Point 5 input value - 14
		Label {
            text: qsTr('Point 5 input value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point5InputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point5InputParam, value / maximumValue, getPosition(), point5InputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point5InputSlider.value = 0
        }
		Shotcut.KeyframesButton {
            id: point5InputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point5InputParam, point5InputSlider.value / point5InputSlider.maximumValue)
        }

// Point 5 output value - 15
		Label {
            text: qsTr('Point 5 output value')
            Layout.alignment: Qt.AlignRight
        }
		Shotcut.SliderSpinner {
            id: point5OutputSlider
            minimumValue: 0
            maximumValue: 1
            decimals: 1
            onValueChanged: updateFilter(point5OutputParam, value / maximumValue, getPosition(), point5OutputKeyframesButton)
        }
		Shotcut.UndoButton {
            onClicked: point5OutputSlider.value = 0
        }
		Shotcut.KeyframesButton {
            id: point5OutputKeyframesButton
            onToggled: onKeyframesButtonClicked(checked, point5OutputParam, point5OutputSlider.value / point5OutputSlider.maximumValue)
        }

        Item { Layout.fillHeight: true }
    }

    function updateSimpleAnimation() {
        updateFilter(curvePointNumParam, curvePointNumberSlider.value / curvePointNumberSlider.maximumValue, getPosition(), curvePointNumberKeyframesButton)
        
		updateFilter(point1InputParam, point1InputSlider.value / point1InputSlider.maximumValue, getPosition(), point1InputKeyframesButton)
		updateFilter(point1OutputParam, point1OutputSlider.value / point1OutputSlider.maximumValue, getPosition(), point1OutputKeyframesButton)
		
		updateFilter(point2InputParam, point2InputSlider.value / point2InputSlider.maximumValue, getPosition(), point2InputKeyframesButton)
		updateFilter(point2OutputParam, point2OutputSlider.value / point2OutputSlider.maximumValue, getPosition(), point2OutputKeyframesButton)
		
		updateFilter(point3InputParam, point3InputSlider.value / point3InputSlider.maximumValue, getPosition(), point3InputKeyframesButton)
		updateFilter(point3OutputParam, point3OutputSlider.value / point3OutputSlider.maximumValue, getPosition(), point3OutputKeyframesButton)
		
		updateFilter(point4InputParam, point4InputSlider.value / point4InputSlider.maximumValue, getPosition(), point4InputKeyframesButton)
		updateFilter(point4OutputParam, point4OutputSlider.value / point4OutputSlider.maximumValue, getPosition(), point4OutputKeyframesButton)
		
		updateFilter(point5InputParam, point5InputSlider.value / point5InputSlider.maximumValue, getPosition(), point5InputKeyframesButton)
		updateFilter(point5OutputParam, point5OutputSlider.value / point5OutputSlider.maximumValue, getPosition(), point5OutputKeyframesButton)
    }

    Connections {
        target: filter
        onInChanged: updateSimpleAnimation()
        onOutChanged: updateSimpleAnimation()
        onAnimateInChanged: updateSimpleAnimation()
        onAnimateOutChanged: updateSimpleAnimation()
    }

    Connections {
        target: producer
        onPositionChanged: setKeyframedControls()
    }
}
