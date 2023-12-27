package com.example.acremote.ui.acControl

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material.icons.filled.KeyboardArrowUp
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.example.acremote.R
import com.example.acremote.ui.theme.SurfaceDark

@Composable
fun FanSpeedControl(fanSpeed: Int, onFanDown: () -> Unit, onFanUp: () -> Unit) {
    val fanSpeedIcon = when (fanSpeed) {
        0 -> painterResource(id = R.drawable.baseline_signal_cellular_alt_1_bar_48)
        1 -> painterResource(id = R.drawable.baseline_signal_cellular_alt_2_bar_48)
        2 -> painterResource(id = R.drawable.baseline_signal_cellular_alt_48)
        3 -> painterResource(id = R.drawable.baseline_hdr_auto_48)
        else -> painterResource(id = R.drawable.ic_launcher_foreground) // Fallback icon (placeholder)
    }

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier
            .clip(RoundedCornerShape(12.dp))
            .background(SurfaceDark)
            .padding(12.dp)
            .fillMaxWidth(0.6f)
    ) {

        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier.fillMaxWidth()
        ) {
            PlusMinusButton(
                imageVector = Icons.Default.KeyboardArrowDown,
                contentDescription = "Decrease Fan Speed",
                onClick = onFanDown
            )
            Icon(
                painter = fanSpeedIcon,
                contentDescription = "Fan Speed",
                tint = Color.White,
                modifier = Modifier.size(32.dp)
            )
            PlusMinusButton(
                imageVector = Icons.Default.KeyboardArrowUp,
                contentDescription = "Decrease Fan Speed",
                onClick = onFanUp
            )
        }
    }
}