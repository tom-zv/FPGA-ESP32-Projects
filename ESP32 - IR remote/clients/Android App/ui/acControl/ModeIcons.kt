package com.example.acremote.ui.acControl

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.example.acremote.R

@Composable
fun ModeIcons(mode: Int, onModeSelect: (String) -> Unit) {

    Row(
        horizontalArrangement = Arrangement.SpaceAround,
        modifier = Modifier
            .fillMaxWidth()
            .clip(CircleShape)
            .padding(horizontal = 12.dp)
            .padding(vertical = 8.dp)
    ) {
        ModeIcon(painterResource(id = R.drawable.baseline_ac_unit_48), "Cool",
            isSelected = mode == 1,
            onClick = { onModeSelect("COOL") })
        ModeIcon(
            painterResource(id = R.drawable.baseline_wb_sunny_48),
            "Heat",
            isSelected = mode == 2,
            onClick = { onModeSelect("HEAT") }) // Auto = 3
        ModeIcon(
            painterResource(id = R.drawable.baseline_water_drop_48),
            "Dry",
            isSelected = mode == 4,
            onClick = { onModeSelect("DRY") }) // unused
        ModeIcon(
            painterResource(id = R.drawable.baseline_air_48),
            "Fan",
            isSelected = mode == 5,
            onClick = { onModeSelect("FAN") })
    }
}