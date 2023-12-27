package com.example.acremote.ui


import androidx.compose.foundation.layout.Column

import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.acremote.ui.theme.Primary

@Composable
fun FooterButton(text: String, isSelected: Boolean, onClick: () -> Unit, painterID: Int) {
    IconButton(
        onClick = {
            if (!isSelected) {
                onClick()
            }
        },
        modifier = Modifier
            .size(80.dp)
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            Icon(
                painter = painterResource(id = painterID),
                contentDescription = "Page",
                tint = if (isSelected) Primary else Color.LightGray,
                modifier = Modifier.size(28.dp)
            )
            Text(
                text = text,
                fontSize = 10.sp,
                modifier = Modifier.padding(bottom = 24.dp),
            )
        }
    }
}