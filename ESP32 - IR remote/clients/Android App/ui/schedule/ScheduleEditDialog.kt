package com.example.acremote.ui.schedule

import android.util.Log
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Alignment.Companion.BottomCenter
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import com.example.acremote.Schedule
import com.example.acremote.ui.theme.BlueAccent
import com.example.acremote.ui.theme.SurfaceDark
import kotlinx.coroutines.launch


@Composable
fun ScheduleEditDialog(schedule: Schedule, index: Int, onDismiss: () -> Unit, onSave: (Schedule, Int) -> Unit) {
    var hourOn by remember { mutableIntStateOf(schedule.hourOn) }
    var minuteOn by remember { mutableIntStateOf(schedule.minuteOn) }
    var hourOff by remember { mutableIntStateOf(schedule.hourOff) }
    var minuteOff by remember { mutableIntStateOf(schedule.minuteOff) }
    val daysOfWeek = listOf("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
    val daySelection = remember { mutableStateListOf(*Array(7) { (schedule.dayBitmask shr it) and 1 == 1 }) }

    val coroutineScope = rememberCoroutineScope()
    val snackbarHostState = remember { SnackbarHostState() }
    Box(
        modifier = Modifier.fillMaxSize()
    ) {
        Dialog(onDismissRequest = onDismiss) {
            Surface(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(8.dp)
                    .size(width = 400.dp, height = 500.dp),
                shape = RoundedCornerShape(8.dp),
                color = SurfaceDark.copy(alpha = 0.9f)
            ) {
                Column(
                    modifier = Modifier.padding(8.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        "Edit Schedule",
                        style = MaterialTheme.typography.headlineSmall,
                        color = Color.White,
                        modifier = Modifier.padding(bottom = 16.dp),
                        fontSize = 16.sp
                    )

                    Row {
                        TimePicker(
                            initialHour = hourOn,
                            initialMinute = minuteOn,
                            onTimeChange = { h, m ->
                                hourOn = h
                                minuteOn = m
                            }
                        )
                        Spacer(modifier = Modifier.width(38.dp))
                        TimePicker(
                            initialHour = hourOff,
                            initialMinute = minuteOff,
                            onTimeChange = { h, m ->
                                hourOff = h
                                minuteOff = m
                            }
                        )
                    }

                    Spacer(modifier = Modifier.height(32.dp))

                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Row(
                            horizontalArrangement = Arrangement.SpaceEvenly,
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.width(270.dp)
                        ) {
                            daysOfWeek.subList(0, 4).forEachIndexed { dayIndex, day ->
                                DayToggleButton(day, daySelection[dayIndex]) { selected ->
                                    daySelection[dayIndex] = selected
                                }
                            }
                        }
                        Spacer(modifier = Modifier.height(8.dp)) // Space between the two rows
                        Row(
                            horizontalArrangement = Arrangement.SpaceEvenly,
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.width(200.dp)
                        ) {
                            daysOfWeek.subList(4, 7).forEachIndexed { dayIndex, day ->
                                DayToggleButton(day, daySelection[dayIndex + 4]) { selected ->
                                    daySelection[dayIndex + 4] = selected
                                }
                            }
                        }
                    }
                    Spacer(modifier = Modifier.height(32.dp))

                    Row(
                        horizontalArrangement = Arrangement.Center,
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Button(
                            onClick = onDismiss,
                            colors = ButtonDefaults.buttonColors(containerColor = BlueAccent)
                        ) {
                            Text("Cancel")
                        }

                        Spacer(modifier = Modifier.width(24.dp))

                        Button(onClick = {
                            val updatedSchedule = schedule.copy(
                                hourOn = hourOn,
                                minuteOn = minuteOn,
                                hourOff = hourOff,
                                minuteOff = minuteOff,
                                dayBitmask = daySelection.fold(0) { acc, selected -> (acc shl 1) + if (selected) 1 else 0 },
                                isOn = schedule.isOn
                            )

                            Log.d(
                                "ScheduleEditDialog",
                                "Day bitmask - ${updatedSchedule.dayBitmask}"
                            )
                            if (updatedSchedule.dayBitmask == 0) {
                                Log.d("ScheduleEditDialog", "showing err snack bar")
                                coroutineScope.launch {
                                    snackbarHostState.showSnackbar(
                                        "Select at least one day",
                                        duration = SnackbarDuration.Short,
                                    )
                                }
                            } else {
                                Log.d("ScheduleEditDialog", "saving schedule - $updatedSchedule")
                                onSave(updatedSchedule, index)
                            }


                        }, colors = ButtonDefaults.buttonColors(containerColor = BlueAccent)) {
                            Text("Save")
                        }


                    }

                }

            }

        }
        SnackbarHost(
            hostState = snackbarHostState,
            snackbar = { data ->
                Snackbar(
                    snackbarData = data,
                    containerColor = Color.Red,
                    contentColor = Color.White
                )
            },
            modifier = Modifier
                .align(BottomCenter)
                .padding(vertical = 92.dp)
                .width(200.dp),
        )
    }
}
