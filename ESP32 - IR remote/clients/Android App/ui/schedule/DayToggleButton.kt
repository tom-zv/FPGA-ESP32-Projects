package com.example.acremote.ui.schedule

import androidx.compose.foundation.border
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.acremote.ui.theme.BlueAccent
import com.example.acremote.ui.theme.Primary
import com.example.acremote.ui.theme.SurfaceDark

@Composable
fun DayToggleButton(day: String, isSelected: Boolean, onToggle: (Boolean) -> Unit) {
    Button(
        onClick = { onToggle(!isSelected) },
        colors = ButtonDefaults.buttonColors(
            containerColor = if (isSelected) Primary else SurfaceDark,
            contentColor = if (isSelected) Color.White else BlueAccent
        ),
        modifier = Modifier.padding(4.dp).width(52.dp).height(52.dp).border(width = 1.dp, Color.LightGray, shape = CircleShape ),
        contentPadding = PaddingValues(0.dp)

    ) {
        Text(
            day,
            fontSize = 14.sp,
            color = Color.White,
            modifier = Modifier.padding(5.dp)
                .align(Alignment.CenterVertically)
        )

    }
}
