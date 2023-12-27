package com.example.acremote

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.acremote.ui.Footer
import com.example.acremote.ui.schedule.ScheduleItem
import com.example.acremote.ui.schedule.ScheduleEditDialog
import com.example.acremote.ui.theme.BackgroundDark
import java.time.LocalTime.now

@Composable
fun SchedulePage(viewModel: ScheduleViewModel, onNavigate: (String) -> Unit) {
    var showDialog by remember { mutableStateOf(false) }
    var editingSchedule by remember { mutableStateOf<Schedule?>(null) }
    var editingIndex by remember { mutableStateOf(0) }

    val currentTime = now()

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(BackgroundDark)
    ) {
        Scaffold(
            floatingActionButton = {
                FloatingActionButton(
                    onClick = {
                        editingSchedule = Schedule(viewModel.schedules.size, currentTime.hour, currentTime.minute, currentTime.hour, currentTime.minute, 0, false)
                        editingIndex = viewModel.schedules.size
                        showDialog = true
                    },
                    modifier = Modifier
                        .padding(bottom = 70.dp)
                        .clip(CircleShape)
                ) {
                    Text("+", fontSize = 28.sp, modifier = Modifier.padding(8.dp))
                }
            },
            containerColor = Color.Transparent,
            content = { paddingValues ->
                Column(
                    modifier = Modifier
                        .padding(paddingValues)
                        .padding(bottom = 48.dp)
                ) {
                    LazyColumn(
                        modifier = Modifier.fillMaxSize(),
                        contentPadding = PaddingValues(16.dp)
                    ) {
                        itemsIndexed(viewModel.schedules) { index, schedule ->
                            ScheduleItem(schedule, index, viewModel) {
                                editingSchedule = it
                                editingIndex = index
                                showDialog = true
                            }
                            Spacer(modifier = Modifier.height(8.dp))
                        }
                    }
                }
            }
        )
        // Footer
        Footer(
            currentPage = "Schedule",
            onNavigate = onNavigate,
            modifier = Modifier.align(Alignment.BottomCenter)
        )
    }

    if (showDialog) {
        editingSchedule?.let { schedule ->
            ScheduleEditDialog(
                schedule = schedule,
                index = editingIndex,
                onDismiss = { showDialog = false },
                onSave = { updatedSchedule, index ->
                    viewModel.saveSchedule(updatedSchedule, index)
                    showDialog = false
                }
            )
        }
    }
}

