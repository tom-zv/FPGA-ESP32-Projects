package com.example.acremote.ui.acControl

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.KeyboardArrowDown
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.acremote.ui.theme.SurfaceDark

@Composable
fun TemperatureControl(temp: Int, onTempDown: () -> Unit, onTempUp: () -> Unit) {
    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
        modifier = Modifier
            .clip(RoundedCornerShape(12.dp))
            .background(SurfaceDark)
            .padding(12.dp)
            .fillMaxWidth(0.55f)
    ) {


        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier.fillMaxWidth()
        ) {
            PlusMinusButton(
                imageVector = Icons.Default.KeyboardArrowDown,
                contentDescription = "Decrease Fan Speed",
                onClick = onTempDown
            )
            Text(
                text = "$temp°C",
                color = Color.White,
                fontSize = 18.sp
            )
            PlusMinusButton(
                imageVector = Icons.Default.KeyboardArrowDown,
                contentDescription = "Decrease Fan Speed",
                onClick = onTempUp
            )
        }
    }
}