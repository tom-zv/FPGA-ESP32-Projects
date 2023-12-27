package com.example.acremote.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.unit.dp
import com.example.acremote.R
import com.example.acremote.ui.theme.BackgroundDark
import com.example.acremote.ui.theme.SurfaceDark
import com.example.acremote.ui.theme.SurfaceLight

@Composable
fun Footer(currentPage: String, onNavigate: (String) -> Unit, modifier: Modifier = Modifier){
    Box(
        modifier = modifier
            .fillMaxWidth()
            .drawBehind {
                drawLine(
                    Color.LightGray,
                    Offset(0f, 0f),
                    Offset(size.width, 0f),
                    2f
                )
            }
            .height(90.dp)
            .background(SurfaceDark)
            .padding(top = 12.dp)

    ) {
        Row(
            horizontalArrangement = Arrangement.Center,
            modifier = Modifier.fillMaxWidth()
        ) {
            FooterButton(
                text = "AC Control",
                isSelected = currentPage == "AcControl",
                onClick = { onNavigate("AcControl") },
                painterID = R.drawable.baseline_settings_remote_48,

            )
            Spacer(modifier = Modifier.width(12.dp))
            FooterButton(
                text = "Schedule",
                isSelected = currentPage == "Schedule",
                onClick = { onNavigate("Schedule") },
                painterID = R.drawable.sharp_schedule_48,

            )
        }
    }
}