package com.example.acremote.ui.acControl

import androidx.compose.animation.animateColorAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.example.acremote.ui.theme.GreenOn
import com.example.acremote.R
import com.example.acremote.ui.theme.RedOff

@Composable
fun PowerButton(isOn: Boolean, onClick: () -> Unit) {

    val backgroundColor by animateColorAsState(if (isOn) GreenOn else RedOff)
    val iconColor by animateColorAsState(if (isOn) Color.White else Color.White)
    val borderColor by animateColorAsState(if (isOn) Color.White else Color.Transparent)

    IconButton(
        onClick = onClick, modifier = Modifier
            .clip(CircleShape)
            .background(backgroundColor)
            .border(2.dp, borderColor, shape = CircleShape)
            .padding(14.dp)
            .size(48.dp)
    ) {
        Icon(
            painter = painterResource(id = R.drawable.baseline_power_settings_new),
            contentDescription = "Power",
            tint = iconColor,
            modifier = Modifier.size(42.dp),
        )
    }
}