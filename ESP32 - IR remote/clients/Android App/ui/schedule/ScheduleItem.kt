package com.example.acremote.ui.schedule

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.acremote.R
import com.example.acremote.Schedule
import com.example.acremote.ScheduleViewModel
import com.example.acremote.ui.theme.*
import java.util.Locale

@Composable
fun ScheduleItem(schedule: Schedule, index: Int, viewModel: ScheduleViewModel, onClick: (Schedule) -> Unit) {
    val daysOfWeek = listOf("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .clickable { onClick(schedule) },
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
        colors = CardDefaults.cardColors(containerColor = SurfaceDark)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier
                    .fillMaxWidth()
            ) {
                Text(
                        text = "${String.format(Locale.US, "%02d:%02d", schedule.hourOn, schedule.minuteOn)} - ${String.format(Locale.US, "%02d:%02d", schedule.hourOff, schedule.minuteOff)}",
                        style = MaterialTheme.typography.bodyLarge.copy(fontSize = 24.sp),
                        color = Color.White
                )
                Switch(
                    checked = schedule.isOn,
                    onCheckedChange = { isChecked ->
                        viewModel.toggleSchedule(index)
                    },
                    colors = SwitchDefaults.colors(
                        checkedThumbColor = Primary,
                        uncheckedThumbColor = Color.LightGray,
                        checkedTrackColor = Primary.copy(alpha = 0.5f),
                        uncheckedTrackColor = Color.LightGray.copy(alpha = 0.5f)
                    )
                )
            }
            Spacer(modifier = Modifier.height(16.dp))
            Row(verticalAlignment = Alignment.CenterVertically) {
                //Icon(Icons.Default.CalendarToday, contentDescription = "Days", tint = BlueAccent)
                Spacer(modifier = Modifier.width(4.dp))
                Row {
                    daysOfWeek.forEachIndexed { index, day ->
                        val isActive = (schedule.dayBitmask shr index) and 1 == 1
                        Text(
                            text = day,
                            style = MaterialTheme.typography.bodyLarge,
                            color = if (isActive) Primary else Color.Gray,
                            fontSize = if (isActive) 18.sp else 16.sp,
                            modifier = Modifier.padding(horizontal = 4.dp)
                        )
                    }

                    IconButton(onClick = { viewModel.deleteSchedule(schedule.index) }) {
                        Icon(
                            painter = painterResource(id = R.drawable.baseline_delete_forever_48),
                            contentDescription = "Page",
                            modifier = Modifier.size(28.dp)
                        )
                    }
                }
            }
        }
    }
}