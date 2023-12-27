package com.example.acremote.ui.schedule

import android.view.LayoutInflater
import android.widget.TimePicker
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import com.example.acremote.R

@Composable
fun AndroidTimePicker(
    initialHour: Int,
    initialMinute: Int,
    onTimeChange: (hour: Int, minute: Int) -> Unit
) {
    var hour by remember { mutableStateOf(initialHour) }
    var minute by remember { mutableStateOf(initialMinute) }

    AndroidView(
        factory = { ctx ->
            val view = LayoutInflater.from(ctx).inflate(R.layout.time_picker_spinner, null, false)
            val timePicker: TimePicker = view.findViewById(R.id.timePicker)
            timePicker.setIs24HourView(true)
            timePicker.hour = initialHour
            timePicker.minute = initialMinute

            timePicker.setOnTimeChangedListener { _, h, m ->
                onTimeChange(h, m)
            }

            view
        },
        update = { view ->
            val timePicker: TimePicker = view.findViewById(R.id.timePicker)
            timePicker.hour = hour
            timePicker.minute = minute
        },
        modifier = Modifier.padding(8.dp)
    )
}