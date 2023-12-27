package com.example.acremote.ui.acControl

import androidx.compose.animation.animateColorAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.unit.dp
import com.example.acremote.ui.theme.Primary
import com.example.acremote.ui.theme.SurfaceDark

@Composable
fun ModeIcon(painter: Painter, description: String, isSelected: Boolean, onClick: () -> Unit) {
    val backgroundColor by animateColorAsState(if (isSelected) Primary else SurfaceDark, label = "")
    val iconColor by animateColorAsState(if (isSelected) Color.White else Color.White, label = "")
    val borderColor by animateColorAsState(if (isSelected) Color.White else Color.Transparent)

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier
            .clip(CircleShape)
            .background(backgroundColor)
            .border(1.dp, borderColor, shape = CircleShape)
            .padding(12.dp)
            .clickable(onClick = onClick)
    ) {
        Icon(
            painter = painter,
            contentDescription = description,
            tint = iconColor,
            modifier = Modifier.size(32.dp)
        )

    }
}